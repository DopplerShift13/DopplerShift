// Pot
/obj/item/reagent_containers/cup/soup_pot/lizard
	name = "stout soup pot"
	desc = "A stout soup designed to mix and cook all kinds of Tizirian soup."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	volume = 150
	possible_transfer_amounts = list(20, 50, 100, 150)
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1
	) // WE were LIED TO
	max_ingredients = 18

// Rollingpinalike
/obj/item/kitchen/rollingpin/press
	name = "food press"
	desc = "A flat sheet with a handle on top, for making food that isn't flat, more flat."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	icon_state = "press"
	inhand_icon_state = null
	obj_flags = CONDUCTS_ELECTRICITY
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)

// Now that's a knife
/obj/item/knife/lizard_kitchen
	name = "\improper Tizirian kitchen knife"
	desc = "The one knife you need for cooking in the kitchens of Tiziria. They claim that all knives in the universe \
		are actually a cheap copy of this very design."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	lefthand_file = 'modular_doppler/colony_fabricator/icons/inhand/lefthand.dmi'
	righthand_file = 'modular_doppler/colony_fabricator/icons/inhand/righthand.dmi'
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)

// ladle
/obj/item/kitchen/spoon/soup_ladle/copper
	name = "ladle"
	desc = "You are safe in the knowledge that there is no such thing as a spoon of comical size."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	inhand_icon_state = null
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)
