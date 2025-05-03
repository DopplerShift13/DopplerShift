/datum/quirk/item_quirk/sec_volunteer
	name = "Security volunteer"
	desc = "You're a registered volunteer with Station Security! On Red Alert, you will be expected to present to security to assist them with emergencies. You are expected to return any issued equipment and stand down when the alert is lowered. You spawn with an armband and notice in your security records to identify you."
	gain_text = span_notice("You have volunteered to aid security on red alert if needed")
	lose_text = span_notice("You are no longer volunteered to aid security on red alert")
	medical_record_text = "Patient is enrolled in the security volunteer program."
	value = 0
	mob_trait = TRAIT_SEC_VOLUNTEER
	icon = FA_ICON_SHIELD

/datum/quirk/item_quirk/sec_volunteer/post_add()
	. = ..()
	if(ishuman(quirk_holder))
		var/mob/living/carbon/human/human_holder = quirk_holder
		var/datum/record/crew/our_record = find_record(human_holder.name)
		if(our_record)
			our_record.security_note += "Subject is enlisted in the security volunteer program and will report to brig during code red to assist if needed."

/datum/quirk/item_quirk/sec_volunteer/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/armband/deputy, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/sec_volunteer/add(client/client_source)
	. = ..()
	quirk_holder.update_implanted_hud()

/datum/quirk/item_quirk/sec_volunteer/remove()
	var/mob/living/old_holder = quirk_holder
	. = ..()
	old_holder.update_implanted_hud()
	if (ishuman(quirk_holder))
		var/mob/living/carbon/human/human_holder = quirk_holder
		var/datum/record/crew/our_record = find_record(human_holder.name)
		if (our_record.security_note)
			our_record.security_note = replacetext(our_record.security_note, "Subject is enlisted in the security volunteer program and will report to brig during code red to assist if needed.", "")
		if (!length(our_record.security_note))
			our_record.security_note = null
