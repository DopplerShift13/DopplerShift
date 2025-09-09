/datum/species/lizard
	preview_outfit = /datum/outfit/lizard_preview
	damage_modifier = 15 // 15% less damage thanks to their beautiful scales

/datum/species/lizard/on_species_gain(mob/living/carbon/human/target, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	target.physiology.bleed_mod = 0.8 // Haemocyanin flows thicker

/datum/species/ramatan/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DROPLET_SLASH,
			SPECIES_PERK_NAME = "Heamocyanin",
			SPECIES_PERK_DESC = "Lizardfolk use copper based Haemocyanin as blood, which bleeds at 80% \
				the rate of humans and is regenerated using copper, instead of iron.",
		),
	)

	return to_add

/datum/outfit/lizard_preview
	name = "Lizardperson (Species Preview)"
	head = /obj/item/clothing/head/lizard_hat
	glasses = /obj/item/clothing/glasses/lizard_hud
	suit = /obj/item/clothing/suit/armor/lizard

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/lizard_for_preview)
	lizard_for_preview.dna.features[FEATURE_MUTANT_COLOR] = "#4A81A1"
	lizard_for_preview.dna.features[FEATURE_FRILLS] = "Short"
	lizard_for_preview.dna.features["frills_color_1"] = "#4a81a1"
	lizard_for_preview.dna.features["frills_color_2"] = "#c6c7d3"
	regenerate_organs(lizard_for_preview)
	lizard_for_preview.update_body(is_creating = TRUE)
