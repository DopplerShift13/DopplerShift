/obj/effect/mob_spawn/ghost_role
	/// List of ghost role restricted species
	var/list/restricted_species = list()

/// Check that the mob being spawned matches the ghost role's species requirements, if any.
/obj/effect/mob_spawn/ghost_role/proc/validate_species(mob/target)
	if(restricted_species.len  && !(target?.client?.prefs?.read_preference(/datum/preference/choiced/species) in restricted_species))
		var/text = "Current loaded character doesn't match required species: "
		var/i = 1
		for(var/datum/species/iterated_species as anything in restricted_species)
			text += "[iterated_species.name]"
			if(i < restricted_species.len)
				text += ", "
			i++
		tgui_alert(target, text)
		return FALSE

