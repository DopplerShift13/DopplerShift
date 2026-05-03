/*
	Fill the sec records with a fake power. Or really anything else you want to write down.
*/

/datum/power/expert/false_power
	name = "False Power"
	desc = "A bit of misinformation about your capabilities and its immediately on record. Allows you to add a 'fake' power entry to your Security Records, tailored to your design."
	value = 1

/datum/power/expert/false_power/add(client/client_source)
	apply_false_power_prefs(client_source)

/datum/power/expert/false_power/post_add()
	apply_false_power_prefs(power_holder?.client)
	. = ..()

/datum/power/expert/false_power/get_security_record_text()
	var/custom_record = power_holder?.client?.prefs?.read_preference(/datum/preference/text/false_power_entry)
	if(isnull(custom_record))
		var/datum/preference/text/false_power_entry/pref_entry = GLOB.preference_entries[/datum/preference/text/false_power_entry]
		custom_record = pref_entry?.create_default_value() || security_record_text

	if(!istext(custom_record))
		return security_record_text

	custom_record = trim(custom_record)
	if(isnull(reject_bad_text(custom_record, 100, ascii_only = TRUE)))
		return security_record_text

	return custom_record

/// Gets the false powers settings from the user's preference.
/datum/power/expert/false_power/proc/apply_false_power_prefs(client/client_source)
	if(!client_source)
		security_threat = POWER_THREAT_MINOR
		return

	var/severity_pref = client_source.prefs?.read_preference(/datum/preference/choiced/false_power_severity)
	switch(severity_pref)
		if("Major")
			security_threat = POWER_THREAT_MAJOR
		else
			security_threat = POWER_THREAT_MINOR

// Preference choice for the fake security record entry text.
/datum/preference/text/false_power_entry
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "false_power_entry"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 100

/datum/preference/text/false_power_entry/create_default_value()
	return "Subject has been observed displaying unusual abilities."

/datum/preference/text/false_power_entry/is_valid(value)
	if(!istext(value))
		return FALSE

	var/trimmed_value = trim(value)
	if(length(trimmed_value) < 1)
		return FALSE

	return !isnull(reject_bad_text(trimmed_value, maximum_value_length, ascii_only = TRUE))

/datum/preference/text/false_power_entry/deserialize(input, datum/preferences/preferences)
	var/value = ..()
	if(!istext(value))
		return null

	value = trim(value)
	if(!is_valid(value))
		return null

	return value

/datum/preference/text/false_power_entry/apply_to_human(mob/living/carbon/human/target, value)
	return

// Preference choice for fake power severity in security records.
/datum/preference/choiced/false_power_severity
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "false_power_severity"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/false_power_severity/create_default_value()
	return "Minor"

/datum/preference/choiced/false_power_severity/init_possible_values()
	return list("Minor", "Major")

/datum/preference/choiced/false_power_severity/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/false_power
	associated_typepath = /datum/power/expert/false_power
	customization_options = list(
		/datum/preference/text/false_power_entry,
		/datum/preference/choiced/false_power_severity
	)
