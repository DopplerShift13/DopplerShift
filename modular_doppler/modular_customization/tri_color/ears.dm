// Gotta add to the ears selector
/datum/preference/choiced/species_feature/felinid_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/lizard_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/dog_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/fox_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/bunny_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/mouse_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/bird_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/monkey_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/deer_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/fish_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/bug_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/humanoid_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/synthetic_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/alien_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/datum/preference/choiced/species_feature/teshari_ears/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/ears_color::savefile_key
	return data

/// Ears colors!
/datum/preference/tri_color/ears_color
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	savefile_key = "ears_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/tri_color/ears_color/create_default_value()
	return list(sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"))

/datum/preference/tri_color/ears_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_EARS_COLORS] = value

/datum/preference/tri_color/ears_color/is_valid(value)
	if (!..(value))
		return FALSE
	return TRUE
