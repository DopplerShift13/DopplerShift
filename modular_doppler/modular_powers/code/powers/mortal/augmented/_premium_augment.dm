// Responsible for handling most of the premium augment interactions away from the base cyberimplant.
/datum/component/premium_augment
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Host organ that owns this premium augment logic.
	var/obj/item/organ/host
	/// Current quality percentage (0..100)
	var/quality = AUGMENTED_PREMIUM_QUALITY_START
	/// How often augments should tick down their decay.
	var/decay_interval = AUGMENTED_DECAY_INTERVAL
	/// How much augments should decay when the decay tick does occur.
	var/decay_amount = AUGMENTED_DECAY_AMOUNT
	/// Round-time for when we last decayed.
	var/last_decay_time = 0
	/// Actions that render the quality bar.
	var/list/premium_actions
	/// Refurbish flow state.
	var/refurb_stage = 1
	/// Sequence of refurb steps. Override per-augment for customization.
	var/list/refurb_sequence = list(
		AUGMENTED_REFURBISH_OPEN,
		AUGMENTED_REFURBISH_PARTS,
		AUGMENTED_REFURBISH_CALIBRATE,
		AUGMENTED_REFURBISH_CLOSE,
	)
	/// Parts required during refurb. Override per-augment for customization.
	var/list/refurb_parts = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/cable_coil = 1,
	)
	/// What parts are left that need to be added to a refurbish in progress.
	var/list/refurb_parts_remaining

/datum/component/premium_augment/Initialize()
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE
	host = parent
	if(!host.premium_component)
		host.premium_component = src
	last_decay_time = world.time
	START_PROCESSING(SSfastprocess, src)

/datum/component/premium_augment/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	premium_actions = null
	if(host && host.premium_component == src) // null ref datum before destruction
		host.premium_component = null
	host = null
	return ..()

/// Whether the premium augment can function at all.
/datum/component/premium_augment/proc/can_function()
	return quality > 0

/// Returns a tier label for UI or logic.
/datum/component/premium_augment/proc/quality_tier()
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_OPTIMAL)
		return "optimal"
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_HIGH)
		return "standard"
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_MEDIUM)
		return "compromised"
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_LOW)
		return "failing"
	return "broken"

/// Performance multiplier based purely on quality tiers.
/datum/component/premium_augment/proc/perf_mult()
	return get_efficiency()

/// Returns the efficiency value based on quality tiers.
/datum/component/premium_augment/proc/get_efficiency()
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_OPTIMAL)
		return AUGMENTED_PREMIUM_EFFICIENCY_OPTIMAL
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_HIGH)
		return AUGMENTED_PREMIUM_EFFICIENCY_HIGH
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_MEDIUM)
		return AUGMENTED_PREMIUM_EFFICIENCY_MEDIUM
	if(quality > AUGMENTED_PREMIUM_THRESHOLD_LOW)
		return AUGMENTED_PREMIUM_EFFICIENCY_LOW
	return AUGMENTED_PREMIUM_EFFICIENCY_BROKEN

/// Adjust quality by amount, clamped to [0..AUGMENTED_PREMIUM_QUALITY_MAX] (or override).
/datum/component/premium_augment/proc/adjust_quality(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : AUGMENTED_PREMIUM_QUALITY_MAX
	quality = clamp(quality + amount, 0, cap_to)
	update_quality_actions()

/// Passive decay processing.
/datum/component/premium_augment/process(seconds_per_tick)
	if(decay_amount <= 0 || decay_interval <= 0)
		return
	if(world.time - last_decay_time < decay_interval)
		return
	adjust_quality(-decay_amount)
	last_decay_time = world.time

/// Register an action that should display the quality bar.
/datum/component/premium_augment/proc/register_quality_action(datum/action/item_action/organ_action/premium/action)
	if(!action)
		return
	LAZYADD(premium_actions, action)
	action.update_quality_overlay()

/// Unregister a quality bar action.
/datum/component/premium_augment/proc/unregister_quality_action(datum/action/item_action/organ_action/premium/action)
	if(!premium_actions || !action)
		return
	premium_actions -= action

/// Update all registered action quality bars.
/datum/component/premium_augment/proc/update_quality_actions()
	if(!LAZYLEN(premium_actions))
		return
	for(var/datum/action/item_action/organ_action/premium/action as anything in premium_actions)
		if(QDELETED(action))
			premium_actions -= action
			continue
		action.update_quality_overlay()

/// Premium maintenance: restores quality up to 75%.
/datum/component/premium_augment/proc/apply_premium_maintenance(amount)
	if(amount <= 0)
		return
	adjust_quality(amount, AUGMENTED_PREMIUM_QUALITY_START)

/// Refurbish: restores quality up to 100%.
/datum/component/premium_augment/proc/refurbish(amount)
	if(amount <= 0)
		return
	adjust_quality(amount, AUGMENTED_PREMIUM_QUALITY_MAX)

/// Handle refurbish interactions while the implant is out of the body.
/datum/component/premium_augment/proc/handle_refurbish_interaction(mob/user, obj/item/tool, obj/item/organ/augment)
	if(!user || !tool || !augment)
		return FALSE
	if(augment.owner) // I don't even know how you would do this; the manual says to take it out first >:C
		to_chat(user, span_warning("You need to remove [augment] before refurbishing it."))
		return TRUE
	var/step = get_refurb_step()
	if(!step)
		return FALSE

	switch(step)
		if(AUGMENTED_REFURBISH_OPEN)
			if(tool.tool_behaviour != TOOL_SCREWDRIVER)
				to_chat(user, span_warning("You need a screwdriver to open [augment]'s casing."))
				return TRUE
			to_chat(user, span_notice("You open [augment]'s casing."))
			tool.play_tool_sound(augment)
			advance_refurb_step()
			return TRUE

		if(AUGMENTED_REFURBISH_PARTS)
			ensure_refurb_parts()

			// Saves typepath, amount needed and how much was used to pass on to later in the function.
			var/typepath
			var/needed
			var/use_amount

			// Stack-specific interactions
			if(istype(tool, /obj/item/stack))
				var/obj/item/stack/stack = tool
				typepath = stack.merge_type ? stack.merge_type : stack.type
				needed = refurb_parts_remaining[typepath]

				// Wrong item, right subtype.
				if(!needed)
					to_chat(user, span_warning("[stack] doesn't fit [augment]'s parts."))
					return TRUE

				// Not enough in a stack
				var/available = stack.amount
				use_amount = min(needed, available)
				if(use_amount <= 0 || !stack.use(use_amount))
					to_chat(user, span_warning("You need more [stack] to continue."))
					return TRUE
				needed -= use_amount
			// Non-stack parts.
			else
				typepath = tool.type
				needed = refurb_parts_remaining[typepath]
				// Wrong item
				if(!needed)
					to_chat(user, span_warning("[tool] doesn't fit [augment]'s parts."))
					return TRUE
				needed -= 1
				qdel(tool)

			// Succesful use interaction
			if(needed <= 0)
				refurb_parts_remaining -= typepath
			else
				refurb_parts_remaining[typepath] = needed
			to_chat(user, span_notice("You replace worn parts inside [augment]."))
			tool.play_tool_sound(augment)
			if(!LAZYLEN(refurb_parts_remaining))
				advance_refurb_step()
			return TRUE

		if(AUGMENTED_REFURBISH_CALIBRATE)
			if(tool.tool_behaviour != TOOL_MULTITOOL)
				to_chat(user, span_warning("You need a multitool to calibrate [augment]."))
				return TRUE
			to_chat(user, span_notice("You calibrate [augment]'s diagnostics."))
			tool.play_tool_sound(augment)
			advance_refurb_step()
			return TRUE

		if(AUGMENTED_REFURBISH_CLOSE)
			if(tool.tool_behaviour != TOOL_SCREWDRIVER)
				to_chat(user, span_warning("You need a screwdriver to close [augment]'s casing."))
				return TRUE
			refurbish(AUGMENTED_PREMIUM_QUALITY_MAX)
			tool.play_tool_sound(augment)
			reset_refurb()
			to_chat(user, span_notice("You finish refurbishing [augment]. Looks about as new as it can get."))
			return TRUE

	return FALSE

/// Returns lines to show when examining a premium augment for refurbishing.
/datum/component/premium_augment/proc/get_refurb_examine_lines(obj/item/organ/augment)
	var/list/lines = list()
	if(!augment)
		return lines
	lines += span_notice("Premium quality: [round(quality)]%.")
	if(augment.owner)
		lines += span_warning("Remove [augment] before refurbishing it.")
		return lines

	var/step = get_refurb_step()
	if(!step)
		return lines

	switch(step)
		if(AUGMENTED_REFURBISH_OPEN)
			lines += span_notice("Refurbish step: Open the casing with a screwdriver.")
		if(AUGMENTED_REFURBISH_PARTS)
			ensure_refurb_parts()
			if(!LAZYLEN(refurb_parts_remaining))
				lines += span_notice("Refurbish step: Parts replaced. This isn't meant to show! Why is it not telling you to use a multitool?! PANIC!")
			else
				lines += span_notice("Refurbish step: Replace worn parts.")
				for(var/typepath in refurb_parts_remaining)
					var/amount = refurb_parts_remaining[typepath]
					var/display_name = initial(typepath:name)
					lines += span_notice(" - [display_name] x[amount]")
		if(AUGMENTED_REFURBISH_CALIBRATE)
			lines += span_notice("Refurbish step: Calibrate diagnostics with a multitool.")
		if(AUGMENTED_REFURBISH_CLOSE)
			lines += span_notice("Refurbish step: Close the casing with a screwdriver to finish.")
	return lines

/// Gets the current step we're on in the refurbish process.
/datum/component/premium_augment/proc/get_refurb_step()
	if(!LAZYLEN(refurb_sequence))
		return null
	refurb_stage = clamp(refurb_stage, 1, refurb_sequence.len)
	return refurb_sequence[refurb_stage]

/// Moves us up to the next refurbish phase.
/datum/component/premium_augment/proc/advance_refurb_step()
	refurb_stage++
	refurb_parts_remaining = null
	if(refurb_stage > refurb_sequence.len)
		refurb_stage = refurb_sequence.len

/// Resets refurbishing back to the first stage which is opening it.
/datum/component/premium_augment/proc/reset_refurb()
	refurb_stage = 1
	refurb_parts_remaining = null

/// Gets all the required refurb parts and adds them to refurb parts remaining.
/datum/component/premium_augment/proc/ensure_refurb_parts()
	if(refurb_parts_remaining)
		return
	refurb_parts_remaining = list()
	for(var/typepath in refurb_parts)
		refurb_parts_remaining[typepath] = refurb_parts[typepath]
