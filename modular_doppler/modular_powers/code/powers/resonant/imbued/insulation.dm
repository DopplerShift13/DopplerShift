/datum/power/imbued/insulation
	name = "Insulation"
	desc = "Your body is a poor conductor of electricity, shocks just seem to harmlessly fizzle through your body."
    security_threat = POWER_THREAT_MAJOR
	security_record_text = "Subject is naturally insulated and incapable of being electrocuted."
	value = 3

	required_powers = list(/datum/power/imbued_root/anomalous)

	menu_icon = 'icons/obj/clothing/gloves.dmi'
	menu_icon_state = "yellow"

/datum/power/imbued/insulation/add()
	ADD_TRAIT(power_holder, TRAIT_SHOCKIMMUNE, src)

/datum/power/imbued/insulation/remove()
	REMOVE_TRAIT(power_holder, TRAIT_SHOCKIMMUNE, src)
