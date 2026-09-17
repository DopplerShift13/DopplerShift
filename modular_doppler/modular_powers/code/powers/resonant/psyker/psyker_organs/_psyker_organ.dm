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
	/// Unmodified stress threshold inherent to this organ type.
	var/base_stress_threshold = PSYKER_ORGAN_BASE_THRESHOLD
	/// Effective stress threshold after scaling with the owner's Psyker power investment.
	/// Usually, 1x is the minor events, 1.5x are the major events, and 2x are the catastrophic events.
	var/stress_threshold
	/// The root subtype this organ is meant to work with at full efficiency.
	var/matching_root_type = /datum/power/psyker_root
	/// Base recovery per second.
	var/recovery_per_second = 0
	/// The described action taken to recover stress. Used in the stress warning to communicate HOW you would relieve stress in your current state.
	var/coping_method = "nothing"
	/// Time between repeat backlash events while above the stress threshold.
	var/stress_backlash_cooldown = 90 SECONDS

	/// Cooldown for mild stress events.
	COOLDOWN_DECLARE(mild_stress_backlash_cooldown)
	/// Cooldown for severe stress events.
	COOLDOWN_DECLARE(severe_stress_backlash_cooldown)

	///The stress warning message
	var/datum/status_effect/power/stress_warning/stress_warning

/// Call to modify stress. Don't adjust directly.
/obj/item/organ/resonant/psyker/proc/modify_stress(amount)
	if(!isnum(amount))
		return
	stress = max(stress + amount, 0)
	update_stress_warning()

/// Returns TRUE while the gland can still power psyker abilities.
/obj/item/organ/resonant/psyker/proc/is_functional()
	return damage < maxHealth && !(organ_flags & ORGAN_FAILING)

/// Creates, removes, or refreshes the stress warning to match the organ's current state.
/obj/item/organ/resonant/psyker/proc/update_stress_warning()
	if(isnull(owner) || !is_functional() || !has_compatible_root() || stress <= 0) // whenever we shouldn't display the warning. no owner, organ broke, no stress etc.
		if(owner && stress_warning)
			owner.remove_status_effect(/datum/status_effect/power/stress_warning)
		stress_warning = null
		return

	if(isnull(stress_warning)) // apply the stress warning if its not there yet.
		stress_warning = owner.apply_status_effect(/datum/status_effect/power/stress_warning)
	stress_warning?.update_stress_alert(stress, stress_threshold, coping_method)

/// Returns how much stress should naturally recover each second.
/obj/item/organ/resonant/psyker/proc/get_stress_recovery_per_second()
	if(stress >= stress_threshold)
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
		RegisterSignals(organ_owner, list(COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED), PROC_REF(on_power_list_changed))
		update_stress_threshold()
		update_medscan_flags()

/// Clears the flags on the organ before removal
/obj/item/organ/resonant/psyker/Remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	UnregisterSignal(organ_owner, list(COMSIG_LIVING_POST_FULLY_HEAL, COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED))
	if(stress_warning)
		organ_owner.remove_status_effect(/datum/status_effect/power/stress_warning)
		stress_warning = null
	update_medscan_flags(FALSE)
	return ..()

/// Recalculates the effective stress threshold from the owner's Psyker power investment.
/obj/item/organ/resonant/psyker/proc/update_stress_threshold()
	var/psyker_power_points = 0
	for(var/datum/power/power_instance as anything in owner?.powers)
		if(power_instance.path != POWER_PATH_PSYKER)
			continue
		psyker_power_points += power_instance.value

	stress_threshold = base_stress_threshold * (1 + (psyker_power_points * PSYKER_STRESS_THRESHOLD_MULTIPLIER_PER_POINT))
	update_stress_warning()

/// Keeps the effective stress threshold synchronized with changes to the owner's power list.
/obj/item/organ/resonant/psyker/proc/on_power_list_changed(mob/living/source, datum/power/changed_power)
	SIGNAL_HANDLER
	if(changed_power.path == POWER_PATH_PSYKER)
		update_stress_threshold()

/// Resets psyker stress after a full heal.
/obj/item/organ/resonant/psyker/proc/on_owner_fully_healed(datum/source, heal_flags)
	SIGNAL_HANDLER
	stress = 0
	update_stress_warning()

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
		update_stress_warning()
		return

	// If you have the associated power. read; you are a psyker.
	if(has_compatible_root())
		if(stress <= 0)
			stress = 0
			update_stress_warning()
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

		update_stress_warning()

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
			to_chat(human, span_userdanger("You lose control over your psychic powers!"))
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

/// Updates the alert's icon, name and desc to reflect stress + use the appropriate coping method per organ.
/datum/status_effect/power/stress_warning/proc/update_stress_alert(current_stress, current_stress_threshold, coping_method)
	if(isnull(linked_alert) || (current_stress_threshold <= 0))
		return

	// calculates which special icon we should based on stress
	var/stress_percentage = (current_stress / current_stress_threshold) * 100
	var/icon_percentage = clamp(FLOOR(stress_percentage, 25), 0, 100)
	var/is_extreme_stress = stress_percentage >= 100

	// dynamic desc, name and icon to describe what you need to do to fix the situation.
	linked_alert.icon_state = "psyker_stress_[icon_percentage]"
	linked_alert.name = is_extreme_stress ? "Extreme Stress" : "Stress Warning!"
	if(coping_method)
		if(is_extreme_stress)
			linked_alert.desc = "Your stress is at capacity! You will suffer periodic negative events, escalating with your excess stress, and may suffer a catastrophic breakdown if you continue to stress yourself! You must [coping_method] to recover your stress, as it no longer regenerates naturally."
		else
			linked_alert.desc = "Your stress is building. Once it reaches high enough to reach a threshold, you will suffer periodic negative events until you [coping_method], and continued use of your powers will only make things worse!"

/atom/movable/screen/alert/status_effect/stress_warning
	icon = 'modular_doppler/modular_powers/icons/powers/status_effects.dmi'
	name = "stress status (you shouldn't see this)!"
	desc = "You are meant to see something else in this description!"
	icon_state = "psyker_stress_0"
