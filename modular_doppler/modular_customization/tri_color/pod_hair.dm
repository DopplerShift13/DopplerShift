/datum/preference/choiced/pod_hair/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/pod_hair_color::savefile_key
	return data

/datum/preference/tri_color/pod_hair_color
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	savefile_key = "pod_hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/tri_color/pod_hair_color/create_default_value()
	return list(sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"))

/datum/preference/tri_color/pod_hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["pod_hair_color_1"] = value[1]
	target.dna.features["pod_hair_color_2"] = value[2]
	target.dna.features["pod_hair_color_3"] = value[3]
