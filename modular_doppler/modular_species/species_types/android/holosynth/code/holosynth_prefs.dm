/datum/preference/color/holosynth_color
	savefile_key = "feature_holo_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/color/holosynth_color/apply_to_human(mob/living/carbon/human/target, value)
	if(isnull(value))
		return
	var/list/rbg_value = rgb2num(value)
	target.dna.features[FEATURE_HOLO_COLOR] = rgb(rbg_value[1], rbg_value[2], rbg_value[3])

/datum/preference/color/holosynth_color/create_default_value()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/datum/preference/color/holosynth_color/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	if(ispath(species, /datum/species/android/holosynth))
		return TRUE
	return FALSE
