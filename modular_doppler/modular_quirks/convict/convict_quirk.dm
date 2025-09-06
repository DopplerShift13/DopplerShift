/datum/quirk/item_quirk/convict
	name = "Paroled Convict"
	desc = "In light of your previous crimes, you've been outfit with a tracking implant."
	icon = FA_ICON_CHAIN
	value = -4
	gain_text = span_notice("You've been found guilty.")
	lose_text = span_notice("You've been aquitted.")
	medical_record_text = "This patient has been convicted of a crime, and should always have a tracking implant."
	quirk_flags = QUIRK_HIDE_FROM_SCAN|QUIRK_HUMAN_ONLY
	mail_goodies = list(/obj/item/knife/shiv)
	/// A weak reference to our implant.
	var/datum/weakref/implant_ref

//Free prisoner jumpsuit
/datum/quirk/item_quirk/convict/add_unique(client/client_source)
	if(!ishuman(quirk_holder))
		return
	give_item_to_holder(/obj/item/clothing/under/rank/prisoner, list(LOCATION_BACKPACK))
	//Add Implant
	quirk_implant = new
	quirk_implant.implant(quirk_holder, null, silent=TRUE, force=TRUE)
/// Choose a crime
/datum/quirk_constant_data/convict
	associated_typepath = /datum/quirk/item_quirk/convict
	customization_options = list(
		/datum/preference/text/convict_crime,
	)

/datum/preference/text/convict_crime
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "convict_crime_name"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 32

/datum/preference/text/convict_crime/create_default_value()
	return "Larceny"

/datum/preference/text/convict_crime/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/convict_crime/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/item_quirk/convict::name in preferences.all_quirks

/datum/preference/text/convict_crime/apply_to_human(mob/living/carbon/human/target, value)
	return

//Report To Department
//Shamelessly stolen from underworld_connections_quirk.dm
//Changes made: security note differs, status is set to parole and not suspected
/datum/quirk/item_quirk/convict/post_add()
	. = ..()

	if (ishuman(quirk_holder))
		var/list/radio_channels = quirk_holder.mind?.assigned_role?.get_radio_channels()
		var/mob/living/carbon/human/human_holder = quirk_holder
		var/datum/record/crew/our_record = find_record(human_holder.name)
		var/convict_crime = quirk_holder.client?.prefs.read_preference(/datum/preference/text/convict_crime)
		if (our_record)
			our_record.wanted_status = WANTED_PAROLE
			our_record.security_note += "This paroled convict has been assigned to your station. [human_holder.name] has been convicted of [convict_crime], and should not be issued weapon permits."
		if(!length(radio_channels))
			return
		var/obj/machinery/announcement_system/aas = get_announcement_system(source = src)
		if(isnull(aas))
			return
		aas.broadcast("[human_holder.name], guilty of [convict_crime], has been assigned to your department as a convict on parole.", radio_channels)

/datum/quirk/item_quirk/convict/remove()
	if (ishuman(quirk_holder))
		QDEL_NULL(quirk_implant) // Remove Implant
		var/mob/living/carbon/human/human_holder = quirk_holder
		var/datum/record/crew/our_record = find_record(human_holder.name)
		var/convict_crime = quirk_holder.client?.prefs.read_preference(/datum/preference/text/convict_crime)
		if (isnull(our_record))
			return
		if (our_record.security_note)
			our_record.security_note = replacetext(our_record.security_note, "This paroled convict has been assigned to your station. [human_holder.name] has been convicted of [convict_crime], and should not be issued weapon permits.", "")
		if (!length(our_record.security_note)) // that was the only thing in the notes
			our_record.security_note = null
		if (isnull(our_record.security_note) && our_record.wanted_status == WANTED_PAROLE) // only clear this if the security notes contain nothing but the quirk-generated note, just to be certain we are not accidentally resetting the wanted status for an unrelated crime
			our_record.wanted_status = WANTED_NONE
