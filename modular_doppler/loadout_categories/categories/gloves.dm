/*
*	LOADOUT ITEM DATUMS FOR THE HAND SLOT
*/

/datum/loadout_category/hands
	category_name = "Hands"
	category_ui_icon = FA_ICON_HAND
	type_to_generate = /datum/loadout_item/gloves
	tab_order = /datum/loadout_category/shoes::tab_order + 1
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/hands/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/hands/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/gloves/other_loadout_items = list()
	for(var/datum/loadout_item/gloves/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/datum/loadout_item/gloves
	abstract_type = /datum/loadout_item/gloves

/datum/loadout_item/gloves/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.gloves)
			LAZYADD(outfit.backpack_contents, outfit.gloves)
		outfit.gloves = item_path
	else
		outfit.gloves = item_path

/**
 * WORK GLOVES
 */
/datum/loadout_item/gloves/work
	group = "Work Gloves"
	abstract_type = /datum/loadout_item/gloves/work

/datum/loadout_item/gloves/work/mining
	name = "Explorer Gloves"
	item_path = /obj/item/clothing/gloves/doppler_mining

/datum/loadout_item/gloves/work/frontier_gloves
	name = "Frontier Gloves"
	item_path = /obj/item/clothing/gloves/frontier_colonist

/datum/loadout_item/gloves/work/cargo
	name = "Leather Gloves (Cargo)"
	item_path = /obj/item/clothing/gloves/doppler_cargo

/datum/loadout_item/gloves/work/cargo_work
	name = "Work Gloves (Cargo)"
	item_path = /obj/item/clothing/gloves/doppler_cargo/work_gloves

/datum/loadout_item/gloves/work/aerostatic
	name = "Aerostatic Gloves"
	item_path = /obj/item/clothing/gloves/kim

/datum/loadout_item/gloves/work/latex
	name = "Latex Gloves"
	item_path = /obj/item/clothing/gloves/latex

/datum/loadout_item/gloves/work/nitrile
	name = "Nitrile Gloves"
	item_path = /obj/item/clothing/gloves/latex/nitrile

/**
 * GAUNTLETS
 */
/datum/loadout_item/gloves/gauntlets
	group = "Gauntlets"
	abstract_type = /datum/loadout_item/gloves/gauntlets

/datum/loadout_item/gloves/gauntlets/gold_gauntlets
	name = "Gold-Plate Gauntlets (Tajaran)"
	item_path = /obj/item/clothing/gloves/tajaran_gloves

/datum/loadout_item/gloves/gauntlets/alloy_gauntlets
	name = "Alloy Gauntlets (Vulpkanin)"
	item_path = /obj/item/clothing/gloves/vulp_gloves

/datum/loadout_item/gloves/gauntlets/tizirian_gauntlets
	name = "Tizirian Gauntlets"
	item_path = /obj/item/clothing/gloves/lizard_gloves

/datum/loadout_item/gloves/gauntlets/cargo_colorblock
	name = "Colorblock Gauntlets (Cargo)"
	item_path = /obj/item/clothing/gloves/doppler_cargo/colorblock_gauntlets

/datum/loadout_item/gloves/gauntlets/cargo_gauntlets
	name = "Gauntlets (Cargo)"
	item_path = /obj/item/clothing/gloves/doppler_cargo/gauntlets

/**
 * COLORED GLOVES
 */
/datum/loadout_item/gloves/color
	group = "Colored Gloves"
	abstract_type = /datum/loadout_item/gloves/color

/datum/loadout_item/gloves/color/black
	name = "Black Gloves"
	item_path = /obj/item/clothing/gloves/color/black

/datum/loadout_item/gloves/color/blue
	name = "Blue Gloves"
	item_path = /obj/item/clothing/gloves/color/blue

/datum/loadout_item/gloves/color/brown
	name = "Brown Gloves"
	item_path = /obj/item/clothing/gloves/color/brown

/datum/loadout_item/gloves/color/green
	name = "Green Gloves"
	item_path = /obj/item/clothing/gloves/color/green

/datum/loadout_item/gloves/color/grey
	name = "Grey Gloves"
	item_path = /obj/item/clothing/gloves/color/grey

/datum/loadout_item/gloves/color/light_brown
	name = "Light Brown Gloves"
	item_path = /obj/item/clothing/gloves/color/light_brown

/datum/loadout_item/gloves/color/orange
	name = "Orange Gloves"
	item_path = /obj/item/clothing/gloves/color/orange

/datum/loadout_item/gloves/color/purple
	name = "Purple Gloves"
	item_path = /obj/item/clothing/gloves/color/purple

/datum/loadout_item/gloves/color/red
	name = "Red Gloves"
	item_path = /obj/item/clothing/gloves/color/red

/datum/loadout_item/gloves/color/white
	name = "White Gloves"
	item_path = /obj/item/clothing/gloves/color/white

/datum/loadout_item/gloves/color/rainbow
	name = "Rainbow Gloves"
	item_path = /obj/item/clothing/gloves/color/rainbow

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/gloves/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/gloves/misc

/datum/loadout_item/gloves/misc/translationgloves
	name = "Translation Gloves"
	item_path = /obj/item/clothing/gloves/radio

/datum/loadout_item/gloves/misc/fingerless
	name = "Fingerless Gloves"
	item_path = /obj/item/clothing/gloves/fingerless

/datum/loadout_item/gloves/misc/cargo_fingerless
	name = "Fingerless Gloves (Cargo)"
	item_path = /obj/item/clothing/gloves/doppler_cargo/fingerless

/datum/loadout_item/gloves/misc/lalune_gloves
	name = "Elbow Gloves"
	item_path = /obj/item/clothing/gloves/lalune_long

/datum/loadout_item/gloves/misc/cloth_armwraps
	name = "Cloth Armwraps"
	item_path = /obj/item/clothing/gloves/bracer/wraps
