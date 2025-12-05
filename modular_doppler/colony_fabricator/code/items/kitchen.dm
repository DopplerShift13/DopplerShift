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
