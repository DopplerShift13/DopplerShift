GLOBAL_LIST_INIT(lung_choices, list(
	"Oxygen" = /obj/item/organ/lungs,
	"Water vapor" = /obj/item/organ/lungs/fish/mermaid,
	))

/datum/preference/choiced/lungs_choice
	savefile_key = "feature_lungs_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_BODYPARTS
	can_randomize = FALSE
	randomize_by_default = FALSE

/datum/preference/choiced/lungs_choice/has_relevant_feature(datum/preferences/preferences)
	return current_species_has_savekey(preferences)

/datum/preference/choiced/lungs_choice/apply_to_human(mob/living/carbon/human/target, value)
	if(value == "None")
		return
	target.dna.species.mutantlungs = GLOB.lung_choices[value]
	var/obj/item/organ/lungs/new_organ = SSwardrobe.provide_type(GLOB.lung_choices[value])
	new_organ.Insert(target, TRUE, DELETE_IF_REPLACED)

/datum/preference/choiced/lungs_choice/init_possible_values()
	return GLOB.lung_choices

/datum/preference/choiced/lungs_choice/is_valid(value)
	if(value == "None")
		return TRUE
	return ..()

/datum/preference/choiced/lungs_choice/create_default_value()
	return "None"

/datum/preference/choiced/lungs_choice/create_informed_default_value(datum/preferences/preferences)
	if(has_relevant_feature(preferences))
		return "Oxygen"
	return ..()

/datum/preference/choiced/lungs_choice/deserialize(value, datum/preferences/preferences)
	if(!current_species_has_savekey(preferences))
		return ..(create_default_value(), preferences)
	return ..(value, preferences)

/datum/preference/color/fish_tail_color
	savefile_key = "feature_fish_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fish/mermaid

/datum/preference/color/fish_tail_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_TAIL_FISH_COLOR] = value

/datum/preference/color/fish_tail_color/create_default_value()
	return pick(GLOB.carp_colors - COLOR_CARP_SILVER)
