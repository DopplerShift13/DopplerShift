/datum/loadout_category/backpack
	category_name = "Back"
	category_ui_icon = FA_ICON_ARCHIVE
	type_to_generate = /datum/loadout_item/backpack
	tab_order = /datum/loadout_category/belt::tab_order + 1


/*
*	LOADOUT ITEM DATUMS FOR THE BACK SLOT
*/
/datum/loadout_item/backpack
	abstract_type = /datum/loadout_item/backpack

/datum/loadout_item/backpack/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.back)
		LAZYADD(outfit.backpack_contents, outfit.back)
	outfit.back = item_path


/**
 * BACKPACKS
 */
/datum/loadout_item/backpack/back
	group = "Backpacks"
	abstract_type = /datum/loadout_item/backpack/back

/datum/loadout_item/backpack/back/custom_backpack
	name = "Custom Backpack"
	item_path = /obj/item/storage/backpack/custom

/datum/loadout_item/backpack/back/industrial_backpack
	name = "Custom Industrial Backpack"
	item_path = /obj/item/storage/backpack/industrial/custom

/datum/loadout_item/backpack/back/frontier_backpack
	name = "Frontier Backpack"
	item_path = /obj/item/storage/backpack/industrial/frontier_colonist

/**
 * SATCHELS
 */
/datum/loadout_item/backpack/satchel
	group = "Satchels"
	abstract_type = /datum/loadout_item/backpack/satchel

/datum/loadout_item/backpack/satchel/custom
	name = "Custom Satchel"
	item_path = /obj/item/storage/backpack/satchel/custom

/datum/loadout_item/backpack/satchel/industrial
	name = "Custom Industrial Satchel"
	item_path = /obj/item/storage/backpack/satchel/eng/custom

/datum/loadout_item/backpack/satchel/frontier_satchel
	name = "Frontier Satchel"
	item_path = /obj/item/storage/backpack/industrial/frontier_colonist/satchel

/**
 * DUFFEL BAGS
 */
/datum/loadout_item/backpack/duffel_bag
	group = "Duffel Bags"
	abstract_type = /datum/loadout_item/backpack/duffel_bag

/datum/loadout_item/backpack/duffel_bag/custom_duffel
	name = "Custom Duffelbag"
	item_path = /obj/item/storage/backpack/duffelbag/custom

/datum/loadout_item/backpack/duffel_bag/industrial_duffel
	name = "Custom Industrial Duffelbag"
	item_path = /obj/item/storage/backpack/duffelbag/engineering/custom

/**
 * MESSENGER BAGS
 */
/datum/loadout_item/backpack/messenger_bag
	group = "Messenger Bags"
	abstract_type = /datum/loadout_item/backpack/messenger_bag

/datum/loadout_item/backpack/messenger_bag/custom_messenger
	name = "Custom Messenger Bag"
	item_path = /obj/item/storage/backpack/messenger/custom

/datum/loadout_item/backpack/messenger_bag/industrial_messenger
	name = "Custom Industrial Messenger Bag"
	item_path = /obj/item/storage/backpack/messenger/eng/custom

/datum/loadout_item/backpack/messenger_bag/frontier_messenger
	name = "Frontier Messenger Bag"
	item_path = /obj/item/storage/backpack/industrial/frontier_colonist/messenger

/**
 * KITBAGS/TAILBAGS
 */
/datum/loadout_item/backpack/kit_bag
	group = "Kitbags/Tailbags"
	abstract_type = /datum/loadout_item/backpack/kit_bag

/datum/loadout_item/backpack/kit_bag/low_bag
	name = "Kitbag (Low)"
	item_path = /obj/item/storage/backpack/coalition

/datum/loadout_item/backpack/kit_bag/lizard_tan
	name = "Tizirian Kitbag (Tan)"
	item_path = /obj/item/storage/backpack/lizard

/datum/loadout_item/backpack/kit_bag/lizard_white
	name = "Tizirian Kitbag (White)"
	item_path = /obj/item/storage/backpack/lizard/white

/datum/loadout_item/backpack/kit_bag/lizard_black
	name = "Tizirian Kitbag (Black)"
	item_path = /obj/item/storage/backpack/lizard/black

/datum/loadout_item/backpack/kit_bag/tailbag_tan
	name = "Tizirian Tailbag (Tan)"
	item_path = /obj/item/storage/backpack/lizard_tailbag

/datum/loadout_item/backpack/kit_bag/tailbag_white
	name = "Tizirian Tailbag (White)"
	item_path = /obj/item/storage/backpack/lizard_tailbag/white

/datum/loadout_item/backpack/kit_bag/tailbag_black
	name = "Tizirian Tailbag (Black)"
	item_path = /obj/item/storage/backpack/lizard_tailbag/black

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/backpack/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/backpack/misc

/datum/loadout_item/backpack/misc/modsuit_civilian
	name = "Civilian Modsuit"
	item_path = /obj/item/mod/control/pre_equipped/civilian

/datum/loadout_item/backpack/misc/adventurer
	name = "Adventurer's Bandolier"
	item_path = /obj/item/storage/backpack/satchel/crusader

/datum/loadout_item/backpack/misc/gravity_harness
	name = "Gravity Harness"
	item_path = /obj/item/gravity_harness/with_cell
