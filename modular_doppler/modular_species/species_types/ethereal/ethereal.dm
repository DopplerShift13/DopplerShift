/datum/species/ethereal
	preview_outfit = /datum/outfit/ethereal_preview
	mutanteyes = /obj/item/organ/eyes/ethereal
	hair_alpha = 140
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	sexes = TRUE

	digitigrade_customization = DIGITIGRADE_OPTIONAL
	digi_leg_overrides = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/ethereal,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/ethereal,
	)


/datum/outfit/ethereal_preview
	name = "Ethereal (Species Preview)"
	uniform = /obj/item/clothing/under/frontier_colonist
	head = /obj/item/clothing/head/frontier_colonist

/datum/species/ethereal/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	turn_off_every_species_feature(human_for_preview)
	human_for_preview.dna.features["ethcolor"] = GLOB.color_list_ethereal["Green"]
	refresh_light_color(human_for_preview)
	human_for_preview.set_hairstyle("Lila", update = TRUE)
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)

/// Discards the legacy Ethereal color randomized by the base species so mutant color remains the canonical randomized color.
/datum/species/ethereal/randomize_features()
	var/list/features = ..()
	features -= FEATURE_ETHEREAL_COLOR
	return features

/// Hides the legacy Ethereal color preference so character creation exposes only the standard mutant color selection.
/datum/species/ethereal/get_features()
	var/list/features = ..()
	features -= "feature_ethcolor"
	return features
