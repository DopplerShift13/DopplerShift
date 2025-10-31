/datum/preference/proc/species_can_access_mutant_customization(species_typepath)
	if (species_typepath in GLOB.species_blacklist_no_mutant)
		return FALSE
	return TRUE
