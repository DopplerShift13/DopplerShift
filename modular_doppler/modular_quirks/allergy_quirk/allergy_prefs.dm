/datum/quirk_constant_data/allergy_quirk
	associated_typepath = /datum/quirk/item_quirk/allergy_quirk
	customization_options = list(/datum/preference/toggle/allergy_super_lethal, /datum/preference/choiced/allergy_quirk)

/datum/preference/choiced/allergy_quirk
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "allergy_selection"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/allergy_quirk/init_possible_values()
	return assoc_to_keys(GLOB.possible_chemical_allergies)

/datum/preference/choiced/allergy_quirk/create_default_value()
	return "Psicodine"

/datum/preference/choiced/allergy_quirk/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Chemical Allergy" in preferences.all_quirks

/datum/preference/toggle/allergy_super_lethal
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "allergy_super_lethal"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = FALSE

/datum/preference/toggle/allergy_super_lethal/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Chemical Allergy" in preferences.all_quirks
