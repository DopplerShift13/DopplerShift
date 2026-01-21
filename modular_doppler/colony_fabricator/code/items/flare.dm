/obj/item/flashlight/flare/copper
	name = "green flare"
	desc = "A green-blue copper sulfate flare, for when you really just want to see everything green."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	lefthand_file = 'modular_doppler/colony_fabricator/icons/inhand/lefthand.dmi'
	righthand_file = 'modular_doppler/colony_fabricator/icons/inhand/righthand.dmi'
	light_range = 8
	heat = 1200
	light_color = LIGHT_COLOR_COPPER_OXIDE
	light_power = 1.5
	grind_results = list(
		/datum/reagent/sulfur = 10,
		/datum/reagent/copper = 10,
	)
	trash_type = /obj/item/trash/flare/copper

/obj/item/trash/flare/copper
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	custom_materials = list(
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.5,
	)
