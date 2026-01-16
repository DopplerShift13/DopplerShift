// Pot
/obj/item/reagent_containers/cup/soup_pot/lizard
	name = "stout soup pot"
	desc = "A stout soup designed to mix and cook all kinds of Tizirian soup."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	volume = 150
	possible_transfer_amounts = list(20, 50, 100, 150)
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	) // WE were LIED TO
	max_ingredients = 18

// Rollingpinalike
/obj/item/kitchen/rollingpin/press
	name = "food press"
	desc = "A flat sheet with a handle on top, for making food that isn't flat, more flat."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	icon_state = "press"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
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

// plates n trays
/obj/item/plate/oven_tray/copper
	desc = "Time to bake... Have Tizirians invented cookies yet?"
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	fragile = FALSE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)

/obj/item/plate/copper
	desc = "Holds food, powerful. Good for morale when you're not eating your nizaya off of a desk."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	fragile = FALSE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)

// bowl
/obj/item/reagent_containers/cup/bowl/copper
	name = "bowl"
	desc = "A simple bowl, used for soups. What's a salad you ask? I couldn't tell you."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	reagent_flags = OPENCONTAINER | DUNKABLE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3,
	)
	fill_icon = 'modular_doppler/colony_fabricator/icons/items.dmi'

/obj/item/reagent_containers/cup/bowl/copper/Initialize(mapload)
	. = ..()
	// This sucks but neither of these will work with these sprites
	var/salad_component = GetComponent(/datum/component/ingredients_holder)
	var/appearance_component = GetComponent(/datum/component/takes_reagent_appearance)
	qdel(salad_component)
	qdel(appearance_component)

// Cutting board
/obj/item/cutting_board/modern
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	custom_materials = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)

/obj/item/storage/box/colony_cookware
	name = "Cookware Pack"
	desc = "A box containing the tools you need to COOK."
	icon_state = "lizard_package"
	illustration = null

/obj/item/storage/box/colony_cookware/PopulateContents()
	new /obj/item/kitchen/rollingpin/press(src)
	new /obj/item/knife/lizard_kitchen(src)
	new /obj/item/kitchen/spoon/soup_ladle/copper(src)
	new /obj/item/plate/oven_tray/copper(src)
	new /obj/item/plate/copper(src)
	new /obj/item/plate/copper(src)
	new /obj/item/reagent_containers/cup/bowl/copper(src)
