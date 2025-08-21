GLOBAL_LIST_INIT(lung_choices, list(
	"Oxygen" = /obj/item/organ/lungs,
	"Water vapor" = /obj/item/organ/lungs/fish/mermaid,
	))

/datum/preference/choiced/fish_lungs_choice
	savefile_key = "feature_fish_lungs_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_BODYPARTS
	can_randomize = FALSE
	randomize_by_default = FALSE

/datum/preference/choiced/fish_lungs_choice/has_relevant_feature(datum/preferences/preferences)
	return current_species_has_savekey(preferences)

/datum/preference/choiced/fish_lungs_choice/apply_to_human(mob/living/carbon/human/target, value)
	if(isnull(value))
		return
	var/obj/item/organ/lungs/new_organ = SSwardrobe.provide_type(GLOB.lung_choices[value])
	new_organ.Insert(target, TRUE, DELETE_IF_REPLACED)

/datum/preference/choiced/fish_lungs_choice/init_possible_values()
	return GLOB.lung_choices

/datum/preference/choiced/fish_lungs_choice/create_default_value()
	return "Oxygen"

/datum/preference/color/fish_tail_color
	savefile_key = "feature_fish_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fish/mermaid

/datum/preference/color/fish_tail_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_TAIL_FISH_COLOR] = value

/datum/preference/color/fish_tail_color/create_default_value()
	return pick(GLOB.carp_colors - COLOR_CARP_SILVER)
