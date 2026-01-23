
/datum/power/psyker_power
	name = "Abstract Psyker Power"
	desc = "My claivoyance lets me see into the unseen: \
	and oh god it has shown this debug code. Please report this!"
	abstract_parent_type = /datum/power/psyker_power

	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_PSYKER
	required_powers = list(/datum/power/psyker_root)

/*
/datum/power/psyker_power/proc/add_stress(amount)
	var/obj/item/organ/resonant/psyker_organ/psyker_organ = power_owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(psyker_organ)
		psyker_organ.stress += amount
*/
