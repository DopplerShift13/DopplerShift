
/datum/preference/choiced/limping_side
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "limping_side"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/limping_side/init_possible_values()
	return list("Random") + GLOB.side_choice_limping

/datum/preference/choiced/limping_side/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Limping" in preferences.all_quirks

/datum/preference/choiced/limping_side/apply_to_human(mob/living/carbon/human/target, value)
	return


/datum/preference/choiced/limping_severity
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "limping_severity"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/limping_severity/init_possible_values()
	return list("Random") + GLOB.severity_choice_limping

/datum/preference/choiced/limping_severity/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Limping" in preferences.all_quirks

/datum/preference/choiced/limping_severity/apply_to_human(mob/living/carbon/human/target, value)
	return
