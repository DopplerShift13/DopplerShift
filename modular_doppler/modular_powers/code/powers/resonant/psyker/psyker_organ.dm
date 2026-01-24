/obj/item/organ/resonant/psyker
	name = "paracausal gland"
	desc = "An intrusive organ that should not even be able to function in most bodies. Commonly found in the bodies of Psykers. Though many would try to implement these into themselves to try and awaken psychic powers, its presence in those without such powers is often life-threatening."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "demon_heart-on"
	decay_factor = 5 * STANDARD_ORGAN_DECAY //about 12mins to fully decay.
	slot = ORGAN_SLOT_PSYKER
	zone = BODY_ZONE_CHEST

	// The psyker organ handles most of the stress to do with psyker abilities. Without this organ, you can't use these abilities.
	// Stress is not correlated to organ damage, but organ damage does affect this gland.
	var/stress = 0
	// Stress threshold is how much the psyker organ can handle before the bad events start befalling the user.
	// Usually, 1x is the minor events, 1.5x are the major events, and 2x are the catastrophic events.
	var/stress_threshold = 100
	// Base recovery per second
	var/recovery_per_second = 1.1

	//Cooldowns for the stress events
	var/CDstressMild = 0
	var/CDstressSevere = 0

// Don't modify stress directly. In the future affinity has a bearing on how much stress you gain.
/obj/item/organ/resonant/psyker/proc/add_stress(amount)
	// TODO; Add clothing affinity. Wearing psychic nicknacks makes you gain less stress.
	stress += amount

/obj/item/organ/resonant/psyker/proc/remove_stress(amount)
	// TODO: Ditto on above.
	stress -= amount

/obj/item/organ/resonant/psyker/on_life(seconds_per_tick, times_fired)
	. = ..()

	// If you have the associated power read; you are a psyker.
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
		if(stress >= 200) // Catastrophic event.
			stress_backlash(3)
		else if(stress >= 150 &&  && CDstressMild <= 0) // Severe Event
			CDStresssevere = 100 // reset CD
			stress_backlash(2)
		else if (stress >= 100 && CDstressMild <= 0) // Mild Event
			CDstressMild = 100 // reset CD
			stress_backlash(1)

		if(!CDstressMild >= 0)
			CDStressMild--
		if(!CDstressSevere >= 0)
			CDStressSevere--

	// In the event that you implant this into someone else.
	// Currently placeholder til we settle on what it do on people that don't have it.
	else
		damage += 1
		owner.apply_damage(damage * 0.1, TOX)

// The psyker is exploding and probably about to summon extradimensional demons.
/obj/item/organ/resonant/psyker/proc/stress_backlash(degree)
	if(degree = 3)
