/*
	You passively heal. Wow.
*/
/datum/power/aberrant/healing_factor
	name = "Healing Factor"
	desc = "Your physical injuries heal without assistance. You heal 0.2 damage per second, randomly split between brute and burn damage while not in critical condition. Wounds such as bleeding still require medical treatment.\
	\nThe more this power heals, the hungrier you become: every 4 health healed amounts to a trivial amount of hunger."
	security_record_text = "Subject passively regenerates any injuries they sustain."
	value = 4
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES

	required_powers = list(/datum/power/aberrant_root/monstrous)

	/// how much we heal per second
	var/healing = 0.2
	/// How much healing is required to consume 1 satiety.
	var/hunger_per_healing = 2

/datum/power/aberrant/healing_factor/process(seconds_per_tick)
	// Does not work if you're in crit
	if(power_holder.stat >= SOFT_CRIT)
		return

	var/heal_amt = healing * seconds_per_tick
	if(heal_amt <= 0)
		return

	// Heal the first damaged organic limb we find.
	var/mob/living/carbon/mob = power_holder
	for(var/obj/item/bodypart/bodypart in mob.get_damaged_bodyparts(1, 1, BODYTYPE_ORGANIC))
		var/damage_before = bodypart.get_damage()
		var/updated_bodypart_state = bodypart.heal_damage(heal_amt, heal_amt, required_bodytype = BODYTYPE_ORGANIC)
		var/damage_healed = max(0, damage_before - bodypart.get_damage())
		if(damage_healed > 0)
			mob.adjust_nutrition(-(damage_healed / hunger_per_healing))
		if(updated_bodypart_state)
			mob.update_damage_overlays()
		break
