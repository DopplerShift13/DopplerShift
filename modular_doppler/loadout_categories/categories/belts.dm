/datum/loadout_category/belt
	category_name = "Belt"
	category_ui_icon = FA_ICON_SCREWDRIVER_WRENCH
	type_to_generate = /datum/loadout_item/belts
	tab_order = /datum/loadout_category/accessories::tab_order + 1
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/belt/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/belt/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/belts/other_loadout_items = list()
	for(var/datum/loadout_item/belts/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/*
*	LOADOUT ITEM DATUMS FOR THE BELT SLOT
*/
/datum/loadout_item/belts
	abstract_type = /datum/loadout_item/belts

/datum/loadout_item/belts/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.belt)
			LAZYADD(outfit.backpack_contents, outfit.belt)
		outfit.belt = item_path
	else
		outfit.belt = item_path

/**
 * BELTS
 */
/datum/loadout_item/belts/belt
	group = "Belts"
	abstract_type = /datum/loadout_item/belts/belt

/datum/loadout_item/belts/belt/fanny_pack_black
	name = "Fannypack (Black)"
	item_path = /obj/item/storage/belt/fannypack/black

/datum/loadout_item/belts/belt/fanny_pack_white
	name = "Fannypack (White)"
	item_path = /obj/item/storage/belt/fannypack/white

/datum/loadout_item/belts/belt/fanny_pack_custom
	name = "Fannypack (Colorable)"
	item_path = /obj/item/storage/belt/fannypack/custom

/datum/loadout_item/belts/belt/champion
	name = "Champion's Belt"
	item_path = /obj/item/storage/belt/champion

/datum/loadout_item/belts/belt/medical
	name = "Medical Belt"
	item_path = /obj/item/storage/belt/medical

/datum/loadout_item/belts/belt/medical/invisible
	name = "Medical Belt (Compact)"
	item_path = /obj/item/storage/belt/medical/invisible

/datum/loadout_item/belts/belt/security
	name = "Security Belt"
	item_path = /obj/item/storage/belt/security

/datum/loadout_item/belts/belt/utility
	name = "Utility Belt"
	item_path = /obj/item/storage/belt/utility

/datum/loadout_item/belts/belt/utility/invisible
	name = "Utility Belt (Compact)"
	item_path = /obj/item/storage/belt/utility/invisible

/**
 * UPPER BODY
 */
/datum/loadout_item/belts/upper
	group = "Upper Body"
	abstract_type = /datum/loadout_item/belts/upper

/datum/loadout_item/belts/upper/holster_shoulders
	name = "Shoulder Holster"
	item_path = /obj/item/storage/belt/holster

/datum/loadout_item/belts/upper/mining
	name = "Explorer's Webbing"
	item_path = /obj/item/storage/belt/mining

/datum/loadout_item/belts/upper/mining_alt
	name = "Explorer's Webbing (Alt)"
	item_path = /obj/item/storage/belt/mining/alt

/datum/loadout_item/belts/upper/boarding_rig
	name = "Chest Rig"
	item_path = /obj/item/storage/belt/military

/datum/loadout_item/belts/upper/pouch_rig
	name = "Chest Rig (Alt)"
	item_path = /obj/item/storage/belt/military/pouches

/datum/loadout_item/belts/upper/frontier_colonist
	name = "Chest Rig (Frontier)"
	item_path = /obj/item/storage/belt/utility/frontier_colonist

/**
 * SHEATHS
 */
/datum/loadout_item/belts/sheath
	group = "Sheaths"
	abstract_type = /datum/loadout_item/belts/sheath

/datum/loadout_item/belts/sheath/crusader_belt
	name = "Sword Belt & Sheath"
	item_path = /obj/item/storage/belt/crusader

/datum/loadout_item/belts/sheath/lizard_sword
	name = "Tizirian Chopping Sword Sheath"
	item_path = /obj/item/storage/belt/lizard_sabre

/**
 * KITS
 */
/datum/loadout_item/belts/kit
	group = "Kits"
	abstract_type = /datum/loadout_item/belts/kit

/datum/loadout_item/belts/kit/deforest_med
	name = "Satchel Med-kit"
	item_path = /obj/item/storage/backpack/duffelbag/deforest_medkit

/datum/loadout_item/belts/kit/synth_repair
	name = "Android Repair Kit"
	item_path = /obj/item/storage/medkit/robotic_repair/stocked

/datum/loadout_item/belts/kit/frontier_med
	name = "Frontier Med-kit"
	item_path = /obj/item/storage/medkit/frontier/stocked

/datum/loadout_item/belts/kit/deforest_surgical
	name = "First Responder Med-kit"
	item_path = /obj/item/storage/backpack/duffelbag/deforest_surgical

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/belts/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/belts/misc

/datum/loadout_item/belts/misc/lantern
	name = "Lantern"
	item_path = /obj/item/flashlight/lantern
