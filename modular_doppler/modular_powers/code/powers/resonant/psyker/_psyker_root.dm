/*
	Doesn't do much besides give you a grumpy organ. I prefer it gave a ribbon or at least some sort of positive, but I suppose the path of a psyker is to suffer.
*/
/datum/power/psyker_root
	name = "Paracausal Gland"
	desc = "An organ found only in the central nervous system of Psykers, grown by prolonged exposure to certain types of Resonance. \
	\nThe catalyst for psychic abilities; but beware overexerting it."
	security_record_text = "Subjects has a Paracausal Gland and wields psionic abilities."
	value = 1
	power_flags = POWER_HUMAN_ONLY
	mob_trait = TRAIT_ARCHETYPE_RESONANT
	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_PSYKER
	priority = POWER_PRIORITY_ROOT

	/// Reference to the psyker's paracausal gland organ.
	var/obj/item/organ/resonant/psyker/psyker_organ

/datum/power/psyker_root/add(client/client_source)
	psyker_organ = new /obj/item/organ/resonant/psyker
	psyker_organ.Insert(power_holder, special = TRUE)
	if(power_holder)
		var/has_meditate = FALSE
		for(var/datum/action/action as anything in power_holder.actions)
			if(istype(action, /datum/action/cooldown/power/resonant_meditate))
				has_meditate = TRUE
				break
		if(!has_meditate)
			grant_action(/datum/action/cooldown/power/resonant_meditate)

/datum/power/psyker_root/remove(client/client_source)
	if(psyker_organ)
		qdel(psyker_organ)
