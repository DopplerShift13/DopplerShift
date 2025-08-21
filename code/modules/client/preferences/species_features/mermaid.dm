GLOBAL_LIST_INIT(mermaid_lung_choices, list(
	/obj/item/organ/lungs = "Oxygen",
	/obj/item/organ/lungs/fish/mermaid = "Water vapor",
	))

/datum/preference/choiced/fish_lungs_choice
	savefile_key = "feature_fish_lungs_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_SPECIES
	can_randomize = FALSE
	randomize_by_default = FALSE

/datum/preference/choiced/fish_lungs_choice/has_relevant_feature(datum/preferences/preferences)
	return current_species_has_savekey(preferences)

/datum/preference/choiced/fish_lungs_choice/apply_to_human(mob/living/carbon/human/target, value)
	if(!isnull(value))
		var/obj/item/organ/lungs/lungs = new value
		lungs.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		target.dna.species.mutantlungs = lungs.type

/datum/preference/choiced/fish_lungs_choice/init_possible_values()
	return GLOB.mermaid_lung_choices

/datum/preference/choiced/fish_lungs_choice/create_default_value()
	return /obj/item/organ/lungs

/datum/preference/choiced/fish_lungs_choice/compile_constant_data()
	var/list/data = ..()
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.mermaid_lung_choices
	return data

/datum/preference/color/fish_tail_color
	savefile_key = "feature_fish_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fish/mermaid

/datum/preference/color/fish_tail_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_TAIL_FISH_COLOR] = value

/datum/preference/color/fish_tail_color/create_default_value()
	return pick(GLOB.carp_colors - COLOR_CARP_SILVER)
