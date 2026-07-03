/*
	Abstract type of the psyker organ which handles most of the stress resource as well as backlash events.
*/
/obj/item/organ/resonant/psyker
	name = "abstract psyker organ"
	desc = "how did you get this?!"
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = 5 * STANDARD_ORGAN_DECAY //about 12mins to fully decay.
	slot = ORGAN_SLOT_PSYKER
	zone = BODY_ZONE_CHEST

	/// The psyker organ handles most of the stress to do with psyker abilities; which is their central currency. Without this organ, you can't use psyker abilities.
	/// Stress is not correlated to organ damage, but organ damage does affect this gland.
	var/stress = 0
	/// Stress threshold is how much the psyker organ can handle before the bad events start befalling the user.
	/// Usually, 1x is the minor events, 1.5x are the major events, and 2x are the catastrophic events.
	var/stress_threshold = PSYKER_STRESS_STANDARD_THRESHOLD
	/// The root subtype this organ is meant to work with at full efficiency.
	var/matching_root_type = /datum/power/psyker_root
	/// Base recovery per second.
	var/recovery_per_second = 0
	/// Time between repeat backlash events while above the stress threshold.
	var/stress_backlash_cooldown = 90 SECONDS

	/// Cooldown for mild stress events.
	COOLDOWN_DECLARE(mild_stress_backlash_cooldown)
	/// Cooldown for severe stress events.
	COOLDOWN_DECLARE(severe_stress_backlash_cooldown)

	///The stress warning message
	var/datum/status_effect/power/stress_warning

/// Call to modify stress. Don't adjust directly.
/obj/item/organ/resonant/psyker/proc/modify_stress(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : PSYKER_STRESS_STANDARD_THRESHOLD * 2
	stress = clamp(stress + amount, 0, cap_to)

/// Returns TRUE while the gland can still power psyker abilities.
/obj/item/organ/resonant/psyker/proc/is_functional()
	return damage < maxHealth && !(organ_flags & ORGAN_FAILING)

/// Returns how much stress should naturally recover each second.
/obj/item/organ/resonant/psyker/proc/get_stress_recovery_per_second()
	if(stress >= PSYKER_STRESS_STANDARD_THRESHOLD)
		return 0

	var/recovery_amount = max(recovery_per_second - (damage * 0.015), 0)
	if(has_compatible_root() && !has_matching_root())
		recovery_amount *= 0.5

	return recovery_amount

/// Returns TRUE if the host has any psyker root at all.
/obj/item/organ/resonant/psyker/proc/has_compatible_root()
	if(!owner?.powers)
		return FALSE

	for(var/datum/power/power as anything in owner.powers)
		if(istype(power, /datum/power/psyker_root))
			return TRUE

	return FALSE

/// Returns TRUE if the host has the specific root subtype that belongs to this organ
/obj/item/organ/resonant/psyker/proc/has_matching_root()
	if(!owner?.powers)
		return FALSE

	for(var/datum/power/power as anything in owner.powers)
		if(istype(power, matching_root_type))
			return TRUE

	return FALSE

/// Updates medscanner visibility flags after the organ is inserted.
/obj/item/organ/resonant/psyker/Insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(.)
		RegisterSignal(organ_owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(on_owner_fully_healed))
		update_medscan_flags()

/// Clears the flags on the organ before removal
/obj/item/organ/resonant/psyker/Remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	UnregisterSignal(organ_owner, COMSIG_LIVING_POST_FULLY_HEAL)
	update_medscan_flags(FALSE)
	return ..()

/// Resets psyker stress after a full heal.
/obj/item/organ/resonant/psyker/proc/on_owner_fully_healed(datum/source, heal_flags)
	SIGNAL_HANDLER
	stress = 0

/// Updates the flags on the medscanner in the event that the person with the organ is not a psyker and when the organ is killing them.
/obj/item/organ/resonant/psyker/proc/update_medscan_flags()
	if(has_compatible_root())
		organ_flags &= ~ORGAN_HAZARDOUS
		return

	organ_flags |= ORGAN_HAZARDOUS

// If the organ is dangerous, it shows. Otherwise, you need an advanced med-scanner.
/obj/item/organ/resonant/psyker/get_status_appendix(advanced, add_tooltips)
	if(organ_flags & ORGAN_HAZARDOUS)
		return "Hazardous resonant organ detected"
	if(advanced)
		return "Unnatural resonant organ detected"

	return ..()

// Handles stress & backlash events
/obj/item/organ/resonant/psyker/on_life(seconds_per_tick, times_fired)
	. = ..()
	update_medscan_flags()

	// Organ doesn't work? Don't do anything.
	if(!is_functional())
		if(stress_warning)
			owner.remove_status_effect(/datum/status_effect/power/stress_warning)
			stress_warning = null
		return

	// If you have the associated power. read; you are a psyker.
	if(has_compatible_root())
		if(stress <= 0)
			stress = 0
			return
		stress = max(stress - (get_stress_recovery_per_second() * seconds_per_tick), 0)

		// Check if we do stress backlash after stress reduction.
		if(stress >= (stress_threshold * 2)) // Catastrophic event.
			stress_backlash(PSYKER_EVENT_TIER_CATASTROPHIC)
			owner.dispel(src) // ends most effects
			stress = 0 // No CD, just a hard reset and the consequences of your actions.
			COOLDOWN_RESET(src, mild_stress_backlash_cooldown)
			COOLDOWN_RESET(src, severe_stress_backlash_cooldown)
		// Severe event.
		else if(stress >= (stress_threshold * 1.5) && COOLDOWN_FINISHED(src, severe_stress_backlash_cooldown))
			COOLDOWN_START(src, severe_stress_backlash_cooldown, stress_backlash_cooldown)
			stress_backlash(PSYKER_EVENT_TIER_SEVERE)
		// Mild event.
		else if(stress >= stress_threshold && COOLDOWN_FINISHED(src, mild_stress_backlash_cooldown))
			COOLDOWN_START(src, mild_stress_backlash_cooldown, stress_backlash_cooldown)
			stress_backlash(PSYKER_EVENT_TIER_MILD)

		//Handle the warning status effect
		if(stress >= stress_threshold && !stress_warning)
			stress_warning = owner.apply_status_effect(/datum/status_effect/power/stress_warning)
		else if(stress < stress_threshold && stress_warning)
			owner.remove_status_effect(/datum/status_effect/power/stress_warning)
			stress_warning = null

	// In the event that you implant this into someone else.
	// Currently placeholder til we settle on what it do on people that don't have it.
	else
		damage += 1
		owner.apply_damage(damage * 0.1, TOX)

// "The psyker is exploding and probably about to summon extradimensional demons."
/// When psyker stress gets too high, it triggers bad events, this chooses said bad events.
/obj/item/organ/resonant/psyker/proc/stress_backlash(degree)
	var/mob/living/carbon/human/human = owner
	if(!istype(human))
		return FALSE

	var/base_type
	switch(degree)
		if(PSYKER_EVENT_TIER_MILD)
			base_type = /datum/psyker_event/mild
		if(PSYKER_EVENT_TIER_SEVERE)
			base_type = /datum/psyker_event/severe
		if(PSYKER_EVENT_TIER_CATASTROPHIC)
			base_type = /datum/psyker_event/catastrophic
		else
			return FALSE

	pick_psyker_event(base_type, human)
	return TRUE

/// Picks the backlash event after a stress breakdown
/obj/item/organ/resonant/psyker/proc/pick_psyker_event(base_type, mob/living/carbon/human/human)
	var/list/candidates = list()

	// We check for abstract types and assign the weights
	for(var/subtype in subtypesof(base_type))
		var/datum/psyker_event/event_type = subtype

		if(initial(event_type.abstract_type) == subtype)
			continue

		var/weight = initial(event_type.weight)
		candidates[subtype] = weight

	// We check the candidates, pick one, try it. If it returns true, we end. If it returns false, we try another.
	// In principle this should never fail because each category has one that will always return true.
	while(length(candidates))
		var/subtype = pick_weight(candidates)
		candidates -= subtype

		var/datum/psyker_event/event = new subtype

		if(!event.can_execute(human, src))
			qdel(event)
			continue

		// We check if it actually successfully executed. Qdel it under normal circumstances; if it lingers we don't.
		if(event.execute(human))
			if(!event.lingering)
				qdel(event)
			return

		// Execution failed? We retry
		qdel(event)

	return


// Warning message for high stress
/datum/status_effect/power/stress_warning
	id = "stress_warning"
	tick_interval = STATUS_EFFECT_NO_TICK // This one's just a warning
	alert_type = /atom/movable/screen/alert/status_effect/stress_warning

/atom/movable/screen/alert/status_effect/stress_warning
	icon = 'icons/mob/actions/actions_ecult.dmi'
	name = "Stress Warning!"
	desc = "Your stress is at the backlash threshold! You will suffer periodic negative events until you meditate, and continued use of your powers will only make things worse!"
	icon_state = "mansus_link" // Placeholder
