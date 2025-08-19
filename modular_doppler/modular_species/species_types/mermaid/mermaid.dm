/mob/living/carbon/human/species/mermaid
	race = /datum/species/human/mermaid

/datum/species/human/mermaid
	name = "\improper Mermaid"
	plural_form = "Mermaids"
	id = SPECIES_MERMAID
	mutant_organs = list(/obj/item/organ/tail/fish/mermaid)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest,
	)
	inherent_traits = list(
		TRAIT_WATER_ADAPTATION,
		TRAIT_MUTANT_COLORS,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_AQUATIC
	no_equip_flags = ITEM_SLOT_FEET

	species_cookie = /obj/item/food/chips/shrimp
	preview_outfit = /datum/outfit/mermaid_preview
	payday_modifier = 1.0

/datum/outfit/mermaid_preview
	name = "Mermaid (Species Preview)"

/datum/species/human/mermaid/randomize_features()
	var/list/features = ..()
	features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/tails/fish/mermaid::name //no random
	return features

/datum/species/human/mermaid/on_species_gain(mob/living/carbon/carbon_being, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(isdummy(carbon_being))
		return
	carbon_being.set_lying_down()
	carbon_being.on_fall()

/datum/species/human/mermaid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)

/datum/species/human/mermaid/get_species_description()
	return "Nothing yet."

/datum/species/human/mermaid/get_species_lore()
	return list(
		"Nothing yet.",
	)
