//DOPPLER EDIT
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
//DOPPLER EDIT END

/datum/preference/choiced/pod_hair
	savefile_key = "feature_pod_hair"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Hairstyle"
	should_generate_icons = TRUE
	relevant_external_organ = /obj/item/organ/pod_hair

/datum/preference/choiced/pod_hair/init_possible_values()
	return assoc_to_keys_features(SSaccessories.pod_hair_list)

/datum/preference/choiced/pod_hair/icon_for(value)
	var/datum/sprite_accessory/pod_hair = SSaccessories.pod_hair_list[value]

	var/datum/universal_icon/icon_with_hair = uni_icon('icons/mob/human/bodyparts_greyscale.dmi', "pod_head_m")

	if (value != "None") //DOPPLER EDIT ADDITION
		var/datum/universal_icon/icon_adj = uni_icon(pod_hair.icon, "m_pod_hair_[pod_hair.icon_state]_ADJ")
		var/datum/universal_icon/icon_front = uni_icon(pod_hair.icon, "m_pod_hair_[pod_hair.icon_state]_FRONT")
		icon_adj.blend_icon(icon_front, ICON_OVERLAY)
		icon_with_hair.blend_icon(icon_adj, ICON_OVERLAY)
		icon_with_hair.scale(64, 64)
		icon_with_hair.crop(15, 64 - 31, 15 + 31, 64)
		icon_with_hair.blend_color(COLOR_GREEN, ICON_MULTIPLY)

	return icon_with_hair

/datum/preference/choiced/pod_hair/create_default_value()
	return pick(assoc_to_keys_features(SSaccessories.pod_hair_list))

/datum/preference/choiced/pod_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_POD_HAIR] = value

//DOPPLER EDIT
/datum/preference/choiced/pod_hair/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/pod_hair_color::savefile_key

	return data
//DOPPLER EDIT END
