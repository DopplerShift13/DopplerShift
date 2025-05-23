/datum/quirk/item_quirk/prescription
	name = "Registered Prescription"
	desc = "You have a medication registered with the pharmacy. Your medical records will be updated to reflect this, and medical staff will do their best to provide you with a supply for the shift."
	/// Name of prescribed reagent.
	var/prescription_reagent_name
	/// Amount of prescribed reagent per item.
	var/prescription_reagent_amount
	/// Amount of items prescribed.
	var/prescription_item_amount
	/// What item our prescription comes in.
	var/prescription_application_method
	gain_text = span_notice("You feel like you need to take your prescribed medication...")
	lose_text = span_notice("You feel like you don't need a prescription anymore.")
	medical_record_text = ""
	value = 0
	icon = FA_ICON_PRESCRIPTION_BOTTLE_MEDICAL

/datum/quirk/item_quirk/prescription/post_add()
	var/obj/machinery/announcement_system/aas = get_announcement_system(source = src)
	if (aas)
		aas.broadcast(medical_record_text, list(RADIO_CHANNEL_MEDICAL))

/datum/quirk/item_quirk/prescription/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	prescription_reagent_name = client_source?.prefs.read_preference(/datum/preference/text/prescription_reagent_name)
	prescription_reagent_amount = client_source?.prefs.read_preference(/datum/preference/numeric/prescription_reagent_amount)
	prescription_item_amount = client_source?.prefs.read_preference(/datum/preference/numeric/prescription_item_amount)
	prescription_application_method = client_source?.prefs.read_preference(/datum/preference/choiced/prescription_application_method)
	medical_record_text = "[human_holder.name] has been prescribed [prescription_item_amount] [LOWER_TEXT(prescription_application_method)] of [prescription_reagent_name], with a dose of [prescription_reagent_amount] units per. Please produce this prescription and call them to medical when it is ready."
	give_item_to_holder(/obj/item/storage/pill_bottle, list(LOCATION_BACKPACK, LOCATION_HANDS), flavour_text = "You are prescribed [prescription_item_amount] [LOWER_TEXT(prescription_application_method)] of [prescription_reagent_name], with a dose of [prescription_reagent_amount] units per.")

/datum/quirk/item_quirk/prescription/remove()

/datum/quirk_constant_data/prescription
	associated_typepath = /datum/quirk/item_quirk/prescription
	customization_options = list(
		/datum/preference/text/prescription_reagent_name,
		/datum/preference/numeric/prescription_reagent_amount,
		/datum/preference/numeric/prescription_item_amount,
		/datum/preference/choiced/prescription_application_method,
	)

// REAGENT NAME

/datum/preference/text/prescription_reagent_name
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "prescription_reagent_name"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 32

/datum/preference/text/prescription_reagent_name/create_default_value()
	return "Psicodine"

/datum/preference/text/prescription_reagent_name/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/prescription_reagent_name/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Registered Prescription" in preferences.all_quirks

/datum/preference/text/prescription_reagent_name/apply_to_human(mob/living/carbon/human/target, value)
	return

// NUMBER OF UNITS PER ITEM

/datum/preference/numeric/prescription_reagent_amount
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "prescription_reagent_amount"
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = 1
	maximum = 50

/datum/preference/numeric/prescription_reagent_amount/create_default_value()
	return 1

/datum/preference/numeric/prescription_reagent_amount/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Registered Prescription" in preferences.all_quirks

/datum/preference/numeric/prescription_reagent_amount/apply_to_human(mob/living/carbon/human/target, value)
	return

// HOW MANY ITEMS?

/datum/preference/numeric/prescription_item_amount
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "prescription_item_amount"
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = 1
	maximum = 10

/datum/preference/numeric/prescription_item_amount/create_default_value()
	return 1

/datum/preference/numeric/prescription_item_amount/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Registered Prescription" in preferences.all_quirks

/datum/preference/numeric/prescription_item_amount/apply_to_human(mob/living/carbon/human/target, value)
	return

// APPLICATION METHOD

/datum/preference/choiced/prescription_application_method
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "prescription_application_method"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/prescription_application_method/init_possible_values()
	return assoc_to_keys(list("Pills","Patches","Bottles"))

/datum/preference/choiced/prescription_application_method/create_default_value()
	return pick(list("Pills","Patches","Bottles"))

/datum/preference/choiced/prescription_application_method/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Registered Prescription" in preferences.all_quirks

/datum/preference/choiced/prescription_application_method/apply_to_human(mob/living/carbon/human/target, value)
	return
