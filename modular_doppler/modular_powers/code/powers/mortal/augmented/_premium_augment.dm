// Package this along with cyberimps
/obj/item/organ/cyberimp
	// The datum for premium augments that handle all the quality fuckery.
	var/datum/premium_augment/premium

/// Default premium action hook. Override per implant.
/obj/item/organ/cyberimp/proc/use_action()
	return FALSE

/datum/premium_augment
	/// Host implant that owns this premium augment logic.
	var/obj/item/organ/cyberimp/host
	/// Current quality percentage (0..100)
	var/quality = AUGMENTED_PREMIUM_QUALITY_START
	/// Passive decay configuration.
	var/decay_interval = AUGMENTED_DECAY_INTERVAL
	var/decay_amount = AUGMENTED_DECAY_AMOUNT
	var/last_decay_time = 0
	/// Actions that render the quality bar.
	var/list/premium_actions

/datum/premium_augment/New(obj/item/organ/cyberimp/_host)
	host = _host
	last_decay_time = world.time
	START_PROCESSING(SSfastprocess, src)

/datum/premium_augment/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	premium_actions = null
	host = null
	return ..()

/// Whether the premium augment can function at all.
/datum/premium_augment/proc/can_function()
	return quality > 0

/// Returns a tier label for UI or logic.
/datum/premium_augment/proc/quality_tier()
	if(quality > AUGMENTED_PREMIUM_QUALITY_OPTIMAL)
		return "optimal"
	if(quality > AUGMENTED_PREMIUM_QUALITY_HIGH)
		return "standard"
	if(quality > AUGMENTED_PREMIUM_QUALITY_MEDIUM)
		return "compromised"
	if(quality > AUGMENTED_PREMIUM_QUALITY_LOW)
		return "failing"
	return "broken"

/// Performance multiplier based purely on quality tiers.
/datum/premium_augment/proc/perf_mult()
	return get_efficiency()

/// Returns the efficiency value based on quality tiers.
/datum/premium_augment/proc/get_efficiency()
	if(quality > AUGMENTED_PREMIUM_QUALITY_OPTIMAL)
		return AUGMENTED_PREMIUM_EFFICIENCY_OPTIMAL
	if(quality > AUGMENTED_PREMIUM_QUALITY_HIGH)
		return AUGMENTED_PREMIUM_EFFICIENCY_HIGH
	if(quality > AUGMENTED_PREMIUM_QUALITY_MEDIUM)
		return AUGMENTED_PREMIUM_EFFICIENCY_MEDIUM
	if(quality > AUGMENTED_PREMIUM_QUALITY_LOW)
		return AUGMENTED_PREMIUM_EFFICIENCY_LOW
	return AUGMENTED_PREMIUM_EFFICIENCY_BROKEN

/// Adjust quality by amount, clamped to [0..AUGMENTED_PREMIUM_QUALITY_MAX] (or override).
/datum/premium_augment/proc/adjust_quality(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : AUGMENTED_PREMIUM_QUALITY_MAX
	quality = clamp(quality + amount, 0, cap_to)
	update_quality_actions()

/// Passive decay processing.
/datum/premium_augment/process(seconds_per_tick)
	if(decay_amount <= 0 || decay_interval <= 0)
		return
	if(world.time - last_decay_time < decay_interval)
		return
	adjust_quality(-decay_amount)
	last_decay_time = world.time

/// Register an action that should display the quality bar.
/datum/premium_augment/proc/register_quality_action(datum/action/item_action/organ_action/premium/action)
	if(!action)
		return
	LAZYADD(premium_actions, action)
	action.update_quality_overlay()

/// Unregister a quality bar action.
/datum/premium_augment/proc/unregister_quality_action(datum/action/item_action/organ_action/premium/action)
	if(!premium_actions || !action)
		return
	premium_actions -= action

/// Update all registered action quality bars.
/datum/premium_augment/proc/update_quality_actions()
	if(!LAZYLEN(premium_actions))
		return
	for(var/datum/action/item_action/organ_action/premium/action as anything in premium_actions)
		if(QDELETED(action))
			premium_actions -= action
			continue
		action.update_quality_overlay()

/// Premium maintenance: restores quality up to 75%.
/datum/premium_augment/proc/apply_premium_maintenance(amount)
	if(amount <= 0)
		return
	adjust_quality(amount, AUGMENTED_PREMIUM_QUALITY_START)

/// Refurbish: restores quality up to 100%.
/datum/premium_augment/proc/refurbish(amount)
	if(amount <= 0)
		return
	adjust_quality(amount, AUGMENTED_PREMIUM_QUALITY_MAX)
