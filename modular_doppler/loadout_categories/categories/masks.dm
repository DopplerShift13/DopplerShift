/datum/loadout_category/face
	category_name = "Face"
	category_ui_icon = FA_ICON_MASK
	type_to_generate = /datum/loadout_item/mask
	tab_order = /datum/loadout_category/glasses::tab_order + 1
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/face/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/face/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/mask/other_loadout_items = list()
	for(var/datum/loadout_item/mask/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/*
*	LOADOUT ITEM DATUMS FOR THE MASK SLOT
*/
/datum/loadout_item/mask/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.mask))
		..()
		return TRUE

/datum/loadout_item/mask
	abstract_type = /datum/loadout_item/mask

/datum/loadout_item/mask/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.mask)
			LAZYADD(outfit.backpack_contents, outfit.mask)
		outfit.mask = item_path
	else
		outfit.mask = item_path

/**
 * GAS MASKS
 */
/datum/loadout_item/mask/gas
	group = "Gas Masks"
	abstract_type = /datum/loadout_item/mask/gas

/datum/loadout_item/mask/gas/gas
	name = "Gas Mask"
	item_path = /obj/item/clothing/mask/gas

/datum/loadout_item/mask/gas/gas/atmos
	name = "Atmos Gas Mask"
	item_path = /obj/item/clothing/mask/gas/atmos

/datum/loadout_item/mask/gas/gas/explorer
	name = "Explorer Gas Mask"
	item_path = /obj/item/clothing/mask/gas/explorer

/datum/loadout_item/mask/gas/frontier
	name = "Frontier Gas Mask"
	item_path = /obj/item/clothing/mask/gas/atmos/frontier_colonist

/datum/loadout_item/mask/gas/gas_cooler
	name = "Alternate Gas Mask"
	item_path = /obj/item/clothing/mask/gas/breach

/datum/loadout_item/mask/gas/mantis
	name = "Composite Gas Mask"
	item_path = /obj/item/clothing/mask/gas/mantis

/**
 * OTHER MASKS
 */
/datum/loadout_item/mask/other
	group = "Other Masks"
	abstract_type = /datum/loadout_item/mask/other

/datum/loadout_item/mask/other/respirator
	name = "Half-Mask Respirator"
	item_path = /obj/item/clothing/mask/gas/respirator

/datum/loadout_item/mask/other/nightlight
	name = "Half-Mask Rebreather"
	item_path = /obj/item/clothing/mask/gas/nightlight

/datum/loadout_item/mask/other/face_mask
	name = "Face Mask"
	item_path = /obj/item/clothing/mask/breath

/datum/loadout_item/mask/other/surgical
	name = "Surgical Mask"
	item_path = /obj/item/clothing/mask/surgical

/datum/loadout_item/mask/other/faceplate
	name = "Faceplate Mask"
	item_path = /obj/item/clothing/mask/gas/atmos/faceplate

/datum/loadout_item/mask/other/faceplate_eyes
	name = "Faceplate Mask (Eyes)"
	item_path = /obj/item/clothing/mask/gas/atmos/faceplate/why_so_eyes

/**
 * CLOTH COVERS
 */
/datum/loadout_item/mask/cloth
	group = "Cloth Covers"
	abstract_type = /datum/loadout_item/mask/cloth

/datum/loadout_item/mask/cloth/balaclava
	name = "Balaclava"
	item_path = /obj/item/clothing/mask/balaclava

/datum/loadout_item/mask/cloth/snout_balaclava
	name = "Balaclava (Snout)"
	item_path = /obj/item/clothing/mask/snout_balaclava

/datum/loadout_item/mask/cloth/bandana
	name = "Bandana"
	item_path = /obj/item/clothing/mask/bandana

/datum/loadout_item/mask/cloth/bandana_stripe
	name = "Bandana (Stripe)"
	item_path = /obj/item/clothing/mask/bandana/striped

/datum/loadout_item/mask/cloth/bandana_skull
	name = "Bandana (Skull)"
	item_path = /obj/item/clothing/mask/bandana/skull

/datum/loadout_item/mask/cloth/neck_gaiter
	name = "Neck Gaiter"
	item_path = /obj/item/clothing/mask/neck_gaiter

/**
 * COSTUME
 */
/datum/loadout_item/mask/costume
	group = "Costume"
	abstract_type = /datum/loadout_item/mask/costume

/datum/loadout_item/mask/costume/clown
	name = "Clown Mask"
	item_path = /obj/item/clothing/mask/gas/clown_hat

/datum/loadout_item/mask/costume/fakemoustache
	name = "Fake Moustache"
	item_path = /obj/item/clothing/mask/fakemoustache

/datum/loadout_item/mask/costume/paper
	name = "Paper Mask"
	item_path = /obj/item/clothing/mask/paper

/datum/loadout_item/mask/costume/kitsune
	name = "Kitsune Mask"
	item_path = /obj/item/clothing/mask/kitsune
