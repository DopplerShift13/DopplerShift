/obj/item/organ/resonant/psyker
	name = "paracausal gland"
	desc = "An intrusive organ that should not even be able to function in most bodies. Commonly found in the bodies of Psykers. Though many would try to implement these into themselves to try and awaken psychic powers, its presence in those without such powers is often life-threatening."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "demon_heart-on"
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = 5 * STANDARD_ORGAN_DECAY //about 12mins to fully decay.
	slot = ORGAN_SLOT_PSYKER
	zone = BODY_ZONE_CHEST

	// The psyker organ handles most of the stress to do with psyker abilities. Without this organ, you can't use these abilities.
	// Stress is not correlated to organ damage, but organ damage does affect this gland.
	var/stress = 0
	// Stress threshold is how much the psyker organ can handle before the bad events start befalling the user.
	// Usually, 1x is the minor events, 1.5x are the major events, and 2x are the catastrophic events.
	var/stress_threshold = PSYKER_STRESS_STANDARD_THRESHOLD
	// Base recovery per second
	var/recovery_per_second = PSYKER_STRESS_RECOVERY

	//Cooldowns for the stress events
	var/CDstressMild = 0
	var/CDstressSevere = 0

// Don't modify stress directly. In the future affinity has a bearing on how much stress you gain.
/obj/item/organ/resonant/psyker/proc/add_stress(amount)
	// TODO; Add clothing affinity. Wearing psychic nicknacks makes you gain less stress.
	stress += amount
	if(stress <= 0)
		stress = 0
	return

/obj/item/organ/resonant/psyker/proc/remove_stress(amount)
	// TODO: Ditto on above.
	stress -= amount
	if(stress <= 0)
		stress = 0
	return

/obj/item/organ/resonant/psyker/on_life(seconds_per_tick, times_fired)
	. = ..()

	// If you have the associated power. read; you are a psyker.
	if(owner.has_power(/datum/power/psyker_root))
		if(stress <= 0)
			stress = 0
			return
		var/stress_to_recover = recovery_per_second
		// Harder to recover at higher stress
		stress_to_recover -= (stress * 0.01)

		// Organ damage makes recovery worse
		stress_to_recover -= (damage * 0.015)

		// Don’t let recovery go negative (would increase stress)
		stress_to_recover = max(stress_to_recover, 0)

		// Apply recovery, don't let it send stress into the negatives.
		stress = max(stress - stress_to_recover * seconds_per_tick, 0)

		// Check if we do stress backlash after stress reduction.
		if(stress >= (stress_threshold * 2)) // Catastrophic event.
			stress_backlash(PSYKER_EVENT_TIER_CATASTROPHIC)
			stress = 0 // No CD, just a hard reset and the consequences of your actions.
			CDstressMild = 0
			CDstressSevere = 0
		else if(stress >= (stress_threshold * 1.5) && CDstressSevere <= 0) // Severe Event
			CDstressSevere = 60 // reset CD
			stress_backlash(PSYKER_EVENT_TIER_SEVERE)
		else if (stress >= stress_threshold && CDstressMild <= 0) // Mild Event
			CDstressMild = 60 // reset CD
			stress_backlash(PSYKER_EVENT_TIER_MILD)

		if(CDstressMild > 0)
			CDstressMild = max(CDstressMild - seconds_per_tick, 0)
		if(CDstressSevere > 0)
			CDstressSevere = max(CDstressSevere - seconds_per_tick, 0)

	// In the event that you implant this into someone else.
	// Currently placeholder til we settle on what it do on people that don't have it.
	// TODO: Appear on med scanners.
	else
		damage += 1
		owner.apply_damage(damage * 0.1, TOX)

// "The psyker is exploding and probably about to summon extradimensional demons."
// When psyker stress gets too high, it triggers bad events, this chooses said bad events.
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

// Picks the backlash event
/obj/item/organ/resonant/psyker/proc/pick_psyker_event(base_type, mob/living/carbon/human/human)
	var/list/candidates = list()

	// We check for abstract types and assign the weights
	for(var/subtype in subtypesof(base_type))
		var/datum/psyker_event/event_type = subtype

		if(initial(event_type.abstract_type) == subtype)
			continue

		var/weight = initial(event_type.weight)
		candidates[subtype] = weight

	// We check the canidates, pick one, try it. If it returns true, we ened. If it returns false, we try another.
	// In principle this should never fail because each category has one that will always return true.
	while(length(candidates))
		var/subtype = pick_weight(candidates)
		candidates -= subtype

		var/datum/psyker_event/event = new subtype

		if(!event.can_execute(human, src))
			qdel(event)
			continue

		// We check if it actually succesfully executed. Qdel it under normal circumstances; if it lingers we don't.
		if(event.execute(human))
			if(!event.lingering)
				qdel(event)
			return

		// Execution failed? We retry
		qdel(event)

	return

