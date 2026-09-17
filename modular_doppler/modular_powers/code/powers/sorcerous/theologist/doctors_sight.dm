/*
	Gives the power holder the same medical HUD used by health scanner HUD glasses.
*/

/datum/power/theologist/doctors_sight
	name = "Doctor's Sight"
	desc = "You can tell anyone's health at a glance. You can now see the health-estimates of other creatures without any assistive goggles."
	security_record_text = "Subject has a keen eye for identifying the health of others."
	mob_trait = TRAIT_MEDICAL_HUD
	value = 2

	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	menu_icon = 'icons/obj/clothing/glasses.dmi'
	menu_icon_state = "healthhud"
