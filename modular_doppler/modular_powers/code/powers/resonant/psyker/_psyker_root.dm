/*
	Doesn't do much besides give you a grumpy organ. I prefer it gave a ribbon or at least some sort of positive, but I suppose the path of a psyker is to suffer.
*/
/datum/power/psyker_root
	name = "Abstract psyker root"
	desc = "Oh god your psyker powers have gone haywire because they aren't CODED. This backlash event is not for you; its for the coders. Please report how this happened!"
	abstract_parent_type = /datum/power/psyker_root
	value = 0 // all roots should be free unless they are stronger than the defaults
	power_flags = POWER_HUMAN_ONLY
	mob_trait = TRAIT_ARCHETYPE_RESONANT
	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_PSYKER
	priority = POWER_PRIORITY_ROOT

	/// Reference to the psyker's paracausal gland organ.
	var/obj/item/organ/resonant/psyker/psyker_organ
	/// The organ subtype this root installs.
	var/organ_type = /obj/item/organ/resonant/psyker

/datum/power/psyker_root/add(client/client_source)
	psyker_organ = new organ_type
	psyker_organ.Insert(power_holder, special = TRUE)

/datum/power/psyker_root/remove(client/client_source)
	if(psyker_organ)
		qdel(psyker_organ)
