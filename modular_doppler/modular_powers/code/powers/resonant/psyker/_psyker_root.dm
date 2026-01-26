
/datum/power/psyker_root
	name = "Paracausal Gland"
	desc = "An organ found only in the central nervous system of Psykers \
	grown by prolonged exposure to certain types of Resonance. \
	The catalyst for psychic abilities; but beware overexerting it."

	value = 5
	mob_trait = TRAIT_ARCHETYPE_RESONANT
	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_PSYKER
	priority = POWER_PRIORITY_ROOT

	action_path = /datum/action/power/resonant_meditate // todo; deal with duplicates

	var/obj/item/organ/resonant/psyker/psyker_organ

/datum/power/psyker_root/add(client/client_source)
	psyker_organ = new /obj/item/organ/resonant/psyker
	psyker_organ.Insert(power_holder, special = TRUE)

