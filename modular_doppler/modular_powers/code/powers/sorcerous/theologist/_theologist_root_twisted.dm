/datum/power/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Channel chaotic energies into another creature next to you. The target is healed in wildly varying amounts every few seconds, except for one randomly chosen damage-type (which cannot be suffocation, or it's currently highest damage taken). The target is then damaged for half the healed amount with the chosen damage-type. \
	\nOnce you heal a target with A Burden Twisted, all further uses of A Burden Twisted on that target twist all damage into that type for 5 minutes. \
	\nGives Piety proportional to the net-positive amount of damage healed. Works on synthetic bodyparts."
	security_record_text = "Subject can rapidly transmute the wounds of a target into smaller, insubstantial wounds."
	action_path = /datum/action/cooldown/power/theologist/theologist_root/twisted

	value = 4

/datum/action/cooldown/power/theologist/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Channel chaotic energies into another creature next to you. The target is healed in wildly varying amounts every few seconds, except for one randomly chosen damage-type (which cannot be suffocation, or it's currently highest damage taken). The target is then damaged for half the healed amount with the chosen damage-type. \
	\nOnce you heal a target with A Burden Twisted, all further uses of A Burden Twisted on that target twist all damage into that type for 5 minutes. \
	\nGives Piety proportional to the net-positive amount of damage healed. Works on synthetic bodyparts."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "hand"
	cooldown_time = 150
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = FALSE
	unset_after_click = TRUE

	/// Minimum amount of healing per application (heal_tick_wait)
	var/heal_min = 1
	/// Maximum amount of healing per application (heal_tick_wait)
	var/heal_max = 8
	/// How much do we multiply the healing by and dish it out again as damage?
	var/heal_to_damage_ratio = 0.5
	/// How long it takes to the tick each heal
	var/heal_tick_wait = 2 SECONDS
	/// Set this to a damage type to bypass random selection and the highest-damage restriction.
	var/fixed_damage_type
	/// Tracks net-positive healing for piety.
	var/healing_done = 0

	/// How much healing is done on that tick. This is rolled each tick.
	var/healing_amount

	/// The beam effect when channeling
	var/datum/beam/current_beam

	/// The current target of the effect
	var/mob/living/current_target
	/// The non-fixed conversion type being used by the current channel.
	var/current_conversion_damage_type

/datum/action/cooldown/power/theologist/theologist_root/twisted/use_action(mob/living/user, mob/living/target)
	// We define the target just for the on_dispel listener
	current_target = target
	// Snapshot healing modifiers once for the entire channel.
	snapshot_healing_multiplier(target)
	// Because this proc channels in a loop, it won't get to the usual unset_click_ability() until after the effect resolves, so we have to run it here.
	unset_click_ability(owner, FALSE)
	owner.visible_message(span_warning("[owner.get_visible_name()] lays a hand on [target.get_visible_name()], twisting their injuries into other, smaller injuries!"), span_notice("You twist [target.get_visible_name()]'s injuries!"))
	// Listeners for dispelling.
	RegisterSignal(user, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	RegisterSignal(target, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	active = TRUE
	// I am going to shamelessly steal the red meditation spotlight for a moment.
	target.apply_status_effect(/datum/status_effect/spotlight_light/twisted, 1200)
	current_beam = owner.Beam(target, icon_state = "light_beam", time = 120 SECONDS, maxdistance = target_range, beam_type = /obj/effect/ebeam/medical, beam_color = "#cf2525")

	// Does the healing and damage
	while(active)
		// Checks if we're interupted
		if(!do_after(owner, heal_tick_wait, target = target))
			break
		// A dispel can occur while do_after is running, so check before applying another tick.
		if(!active)
			break
		// Checks if our target is in range
		if(target_range)
			var/turf/owner_turf = get_turf(owner)
			var/turf/target_turf = get_turf(target)
			if(owner_turf && target_turf && get_dist(owner_turf, target_turf) > target_range)
				owner.balloon_alert(owner, "Out of range!")
				break // we use break here instead because we don't want to heal them anymore.
		// Checks if there'sanything to heal
		if(target.health >= target.maxHealth)
			to_chat(owner, span_notice("Your target's health is full!"))
			break
		// Alright so we start checking if there's a suitable damage type to convert the healing into (usually yes)
		var/damage_type = get_damage_type(target)
		if(!damage_type)
			to_chat(owner, span_notice("Your target has no suitable damage left to twist!"))
			break
		// The healing
		healing_amount = rand(heal_min, heal_max) * healing_multiplier // rolls a random heal for that tick
		var/healed_amount = heal_other_damage_types(target, damage_type)
		if(!healed_amount)
			to_chat(owner, span_notice("Your target has no other damage left to twist!"))
			break
		// The damaging
		deal_damage_type(target, damage_type, healed_amount * get_modified_conversion_ratio())
		// effects/feedback
		new /obj/effect/temp_visual/heal(get_turf(target), "#cf2525")
		playsound(owner, 'sound/effects/magic/cosmic_expansion.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)

	// cleanup
	active = FALSE
	target.remove_status_effect(/datum/status_effect/spotlight_light/twisted)
	QDEL_NULL(current_beam)

	// unregister signal
	UnregisterSignal(current_target, COMSIG_ATOM_DISPEL)
	UnregisterSignal(owner, COMSIG_ATOM_DISPEL)

	// Handles piety gain
	var/piety_gained = max(0, floor(healing_done * THEOLOGIST_PIETY_HEALING_COEFFICIENT))
	// resets for next time
	healing_done = 0
	current_conversion_damage_type = null
	if(target.ckey)
		adjust_piety(piety_gained)
		if(piety_gained >= 1)
			to_chat(owner, span_notice("You Burden Twisted yielded [piety_gained] piety!"))
		else
			to_chat(owner, span_notice("Your Burden Twisted yielded no piety!"))
	else
		to_chat(owner, span_notice("Your Burden Twisted yielded no piety!"))
	return TRUE

/// Gets or creates the target's locked conversion type.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/get_damage_type(mob/living/target)
	// In case the mob has an upgrade or otherwise is explicitly locked to using a specific damage-type with twisted.
	if(fixed_damage_type)
		return fixed_damage_type
	// In case we already determiend our current conversion damage type.
	if(current_conversion_damage_type)
		return current_conversion_damage_type
	// In case the target has been twisted earlier and their healing is already locked.
	var/datum/status_effect/power/burden_twisted_lock/locked_effect = target.has_status_effect(/datum/status_effect/power/burden_twisted_lock)
	if(locked_effect)
		to_chat(owner, span_warning("[target.get_visible_name()]'s fate is set! All healing will be converted into [locked_effect.damage_type] damage!"))
		current_conversion_damage_type = locked_effect.damage_type
		return current_conversion_damage_type
	// Gets and sets basically all relevant damage-types
	var/brute_damage = target.getBruteLoss()
	var/burn_damage = target.getFireLoss()
	var/tox_damage = target.getToxLoss()
	var/highest_damage = max(brute_damage, burn_damage, tox_damage, target.getOxyLoss())
	var/list/damage_choices = list()
	// Iterates through all damage types besides oxyloss and takes the non-highest damage-types available as our target.
	if(brute_damage < highest_damage)
		damage_choices += "brute"
	if(burn_damage < highest_damage)
		damage_choices += "burn"
	if(tox_damage < highest_damage)
		damage_choices += "tox"
	if(!damage_choices.len)
		return
	var/damage_type = pick(damage_choices)

	// Applies the status that locks into place the chosen damage type.
	target.apply_status_effect(/datum/status_effect/power/burden_twisted_lock, damage_type)
	to_chat(owner, span_warning("You twist [target.get_visible_name()]'s burden into [damage_type] damage!"))
	current_conversion_damage_type = damage_type
	return current_conversion_damage_type

/// Heals every standard damage type except the type that the healing is being converted into.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/heal_other_damage_types(mob/living/target, conversion_damage_type)
	var/healed_amount = 0
	var/list/damage_types_to_heal = list("brute", "burn", "tox", "oxy")
	damage_types_to_heal -= conversion_damage_type // removes our current conversion damage type from the list of heal targets.
	// Randomize which damage type gets first claim on the shared healing budget each tick.
	shuffle_inplace(damage_types_to_heal)
	for(var/damage_type in damage_types_to_heal)
		var/healing_remaining = healing_amount - healed_amount
		if(healing_remaining <= 0)
			break
		switch(damage_type)
			if("brute")
				healed_amount += target.adjustBruteLoss(-min(healing_remaining, target.getBruteLoss()))
			if("burn")
				healed_amount += target.adjustFireLoss(-min(healing_remaining, target.getFireLoss()))
			if("tox")
				healed_amount += target.adjustToxLoss(-min(healing_remaining, target.getToxLoss()), forced = TRUE)
			// Oxygen loss can be healed, but can never be selected as the random conversion type.
			if("oxy")
				healed_amount += target.adjustOxyLoss(-min(healing_remaining, target.getOxyLoss()))
	healing_done += healed_amount
	return healed_amount

/// Collects additive damage conversion modifiers and applies them as a divider to the base damage ratio.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/get_modified_conversion_ratio()
	var/list/conversion_modifiers = list()
	SEND_SIGNAL(owner, COMSIG_THEOLOGIST_TWISTED_CONVERSION_MODIFIERS, conversion_modifiers)

	var/total_conversion_modifier = 1
	for(var/conversion_modifier in conversion_modifiers)
		total_conversion_modifier += conversion_modifier

	return heal_to_damage_ratio / total_conversion_modifier

/// Deals the appropriate damage back after healing.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/deal_damage_type(mob/living/target, damage_type, damage_amount)
	if(!damage_amount)
		return
	switch(damage_type)
		if("brute")
			target.adjustBruteLoss(damage_amount)
		if("burn")
			target.adjustFireLoss(damage_amount)
		if("tox")
			target.adjustToxLoss(damage_amount, forced = TRUE) // sorry slimes no free real estate 4u
		// this doesn't happen unless its forced.
		if("oxy")
			target.adjustOxyLoss(damage_amount)
	healing_done = max(0, healing_done - damage_amount)

/// Status effect that locks out burden twisted.
/datum/status_effect/power/burden_twisted_lock
	id = "burden_twisted_lock"
	duration = 5 MINUTES
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null
	/// The damage type that non-fixed Burden Twisted casts use on this target.
	var/damage_type

/datum/status_effect/power/burden_twisted_lock/on_creation(mob/living/new_owner, new_damage_type)
	. = ..()
	damage_type = new_damage_type

/// Dispel effect
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	active = FALSE
	owner.visible_message(span_warning("The resonant link between [owner.get_visible_name()] and [current_target.get_visible_name()] is broken!!"), span_notice("Your [name] is dispelled!"))
	StartCooldownSelf()
	return DISPEL_RESULT_DISPELLED

// Legacy subtype for other powers still referencing this path.
/datum/status_effect/spotlight_light/twisted
	id = "twisted_spotlight"
	spotlight_color = "#cf2525"
