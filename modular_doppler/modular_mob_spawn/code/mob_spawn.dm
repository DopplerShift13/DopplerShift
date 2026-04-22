/obj/effect/mob_spawn/ghost_role
	/// List of ghost role restricted species
	var/list/restricted_species = list()

	/// Can we use our loadout for this role?
	var/loadout_enabled = FALSE
	/// Can we use our quirks for this role?
	var/quirks_enabled = FALSE


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


/// Apply any customisation to the mob after spawning, such as loadout and quirks
/obj/effect/mob_spawn/ghost_role/proc/apply_customisation(mob/living/carbon/human/target)
	if(loadout_enabled)
		target?.equip_outfit_and_loadout(outfit, target.client?.prefs, FALSE)
	if(quirks_enabled)
		SSquirks.AssignQuirks(target, target.client)


/// Added to the end of the original create proc for ghost roles, to validate species and apply customisation.
/obj/effect/mob_spawn/ghost_role/create(mob/mob_possessor, newname)
	validate_species(mob_possessor)
	if(istype(mob_possessor, /mob/living/carbon/human))
		//var/mob/living/carbon/human/target = mob_possessor
		apply_customisation(mob_possessor)
	return ..()


/// Original proc in code/modules/mob_spawn/mob_spawn.dm ~line 39.
/obj/effect/mob_spawn/create(mob/mob_possessor, newname, is_pref_loaded)
	var/mob/living/spawned_mob = new mob_type(get_turf(src)) //living mobs only
	name_mob(spawned_mob, newname)
	special(spawned_mob, mob_possessor)
	if(!is_pref_loaded)
		equip(spawned_mob)
	return spawned_mob
