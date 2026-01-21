
/datum/preference/choiced/synthetic_charging_method
	main_feature_name = "Charging Method"
	savefile_key = "synthetic_charging_method"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/synthetic_charging_method/init_possible_values()
	return GLOB.synth_charging_method_options

/datum/preference/choiced/synthetic_charging_method/apply_to_human(mob/living/carbon/human/target, value)
	if(isnull(value))
		return
	if(isnull(GLOB.synth_charging_method_options[value]))
		return
	target.dna.features[FEATURE_SYNTHETIC_CHARGING_METHOD] = value

/datum/preference/choiced/synthetic_charging_method/create_default_value()
	return "Power Cord"

/datum/preference/choiced/synthetic_charging_method/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	if(ispath(species, /datum/species/android))
		return TRUE
	return FALSE


/datum/species/android/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	var/stomach_selection = target.dna.features[FEATURE_SYNTHETIC_CHARGING_METHOD]
	if(isnull(stomach_selection))
		return
	var/obj/item/organ/chosen_stomach_type = GLOB.synth_charging_method_options[stomach_selection]
	if(isnull(chosen_stomach_type))
		return
	var/obj/item/organ/chosen_stomach = SSwardrobe.provide_type(chosen_stomach_type)
	chosen_stomach.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
