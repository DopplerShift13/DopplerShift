/mob/living/carbon/human/species/genemod
	race = /datum/species/human/genemod

/datum/species/human/genemod
	name = "Gene-Mod"
	id = SPECIES_GENEMOD
	preview_outfit = /datum/outfit/genemod_preview
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_ANIMALISTIC,
		TRAIT_MUTANT_COLORS,
	)
	body_markings = list(/datum/bodypart_overlay/simple/body_marking/lizard = "None")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	digitigrade_customization = DIGITIGRADE_OPTIONAL
	digi_leg_overrides = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/genemod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/genemod,
	)

/datum/outfit/genemod_preview
	name = "Gene-Mod (Species Preview)"
	uniform = /obj/item/clothing/under/dress/sundress

/datum/species/human/genemod/get_physical_attributes()
	return "N/a."

/datum/species/human/genemod/get_species_description()
	return "N/a."

/datum/species/human/genemod/get_species_lore()
	return list(
		"N/a.",
	)

/datum/species/human/genemod/on_species_gain(mob/living/carbon/human/target, datum/species/old_species, pref_load, regenerate_icons)
	apply_animal_trait(target, find_animal_trait(target))
	return ..()

/datum/species/human/genemod/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.dna.ear_type = DOG
	human_for_preview.dna.features["ears"] = "Fold"
	human_for_preview.dna.features["ears_color_1"] = "#4E3E30"
	human_for_preview.dna.features["ears_color_2"] = "#F4B1C8"
	human_for_preview.set_haircolor("#3a2d22", update = FALSE)
	human_for_preview.set_hairstyle("Short twintails", update = TRUE)
	human_for_preview.dna.features["mcolor"] = skintone2hex("mixed3")
	human_for_preview.eye_color_left = "#442B12"
	human_for_preview.eye_color_right = "#442B12"
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)

/datum/action/cooldown/spell/bat_perch
	name = "Bat Perch"
	desc = "Hang out upside down!"
	button_icon_state = "negative"
	button_icon = 'icons/hud/screen_alert.dmi'
	cooldown_time = 1 SECONDS
	spell_requirements = NONE
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_LYING|AB_CHECK_INCAPACITATED
	var/hangin = FALSE

/datum/action/cooldown/spell/bat_perch/cast(mob/living/cast_on)
	. = ..()
	if(hangin)
		unflip(cast_on)
		return
	else if(check_above(cast_on))
		RegisterSignal(cast_on, COMSIG_MOVABLE_MOVED, PROC_REF(unflip))
		passtable_on(cast_on, REF(cast_on))
		cast_on.AddElement(/datum/element/forced_gravity, NEGATIVE_GRAVITY)
		hangin = TRUE


/datum/action/cooldown/spell/bat_perch/proc/unflip(mob/living/flipper)
	passtable_off(flipper, REF(flipper))
	qdel(flipper.RemoveElement(/datum/element/forced_gravity, NEGATIVE_GRAVITY))
	UnregisterSignal(flipper, COMSIG_MOVABLE_MOVED)
	hangin = FALSE

/datum/action/cooldown/spell/bat_perch/proc/check_above(mob/living/target)
	var/turf/open/current_turf = get_turf(target)
	var/turf/open/openspace/turf_above = get_step_multiz(target, UP)
	if(current_turf && istype(turf_above))
		to_chat(target, span_warning("There's only open air above you, nothing to hang from!"))
		return FALSE
	return TRUE
