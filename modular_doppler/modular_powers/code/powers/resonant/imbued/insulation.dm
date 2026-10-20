/datum/power/imbued/insulation
	name = "Insulation"
	desc = "You are immune to being shocked, such as by interacting with faulty electronics, live wires, tasers or an arcing lightning bolt emanating from the supermatter."
	security_record_text = "Subject is naturally insulated."
	value = 3

	required_powers = list(/datum/power/imbued_root/anomalous)
	mob_trait = TRAIT_SHOCKIMMUNE

	menu_icon = 'icons/obj/clothing/gloves.dmi'
	menu_icon_state = "yellow"
