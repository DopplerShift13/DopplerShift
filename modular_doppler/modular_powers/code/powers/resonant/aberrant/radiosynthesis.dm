/*
	Sunbathe under the Supermatter for healing. Doctors hate this trick! Heals every damage type except oxyloss.
*/
/datum/power/aberrant/radiosyntehsis
	name = "Radiosynthesis"
	desc = "Rather than the molecular degredation you experience from radioactivity, your body instead uses it as an energy source to rapidly heal your body. Radioactivity heals you instead of damaging you. Because this healing is anomalous, it heals synthetic and biological bodyparts."
	security_record_text = "Subject's body regenerates instead of degenerate from exposure to radiation."
	value = 3
	mob_trait = TRAIT_HALT_RADIATION_EFFECTS // we don't give radimmune cause we want to ENCOURAGE people to get irradiated.
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES

	required_powers = list(/datum/power/aberrant_root/anomalous)

	/// how much we heal per second
	var/healing = 1

/datum/power/aberrant/radiosyntehsis/process(seconds_per_tick)
	// Only heal if we're irradiated
	if(!HAS_TRAIT(power_holder, TRAIT_IRRADIATED))
		return

	var/heal_amt = healing * seconds_per_tick
	if(heal_amt <= 0)
		return

	// Get body parts, heal damage on them if there's any.
	var/mob/living/carbon/mob = power_holder
	var/list/parts = mob.get_damaged_bodyparts(1, 1)
	if(parts.len)
		for(var/obj/item/bodypart/bodypart in parts)
			if(bodypart.heal_damage(heal_amt/parts.len, heal_amt/parts.len, required_bodytype = NONE)) // Because anomalous is weird and funky we allow it to heal synthetic parts. This is deliberate. Be a radation powered robot. Beep boop.
				mob.update_damage_overlays()
				return

	// Heal toxins if we didn't heal any other damage, but never remove the last point (keeps irradiation).
	var/tox_loss = power_holder.getToxLoss()
	if(tox_loss > 1 && heal_amt < tox_loss) // We don't want to heal all of a person's radiation, just as to preserve their radioactiv
		var/tox_heal = min(heal_amt, tox_loss - 1)
		// Invert for toxins-healing sepcies
		tox_heal = HAS_TRAIT(power_holder, TRAIT_TOXINLOVER) ? -tox_heal : tox_heal
		power_holder.adjustToxLoss(-tox_heal)
