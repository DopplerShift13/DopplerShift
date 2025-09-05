/datum/loadout_category/modlink
	category_name = "MODlink"
	category_ui_icon = FA_ICON_PHONE
	type_to_generate = /datum/loadout_item/modlink
	tab_order = /datum/loadout_category/pocket::tab_order + 1

/datum/loadout_category/modlink/New()
	. = ..()
	category_info = "(All relabelable)"


/**
 * LOADOUT ITEM DATUMS FOR MODLINKS
 * Each of these must implement some method of applying a label.
 * Due to MODlinks each implementing labeling their own way,
 * this must be specialcased for each item.
 */
/datum/loadout_item/modlink
	abstract_type = /datum/loadout_item/modlink
	has_modlink_label = TRUE

/datum/loadout_item/modlink/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	// Backpack items aren't created if it's a visual equipping, so don't do any on equip stuff. It doesn't exist.
	if(visuals_only)
		return NONE
	return ..()


/**
 * PHONES CATEGORY
 * Use for MODlinks that are primarily held inhand when used.
 */
/datum/loadout_item/modlink/phone
	group = "Phones"
	abstract_type = /datum/loadout_item/modlink/phone

/**
 * WORN CATEGORY
 * Use for MODlinks that are primarily worn when used.
 */
/datum/loadout_item/modlink/worn
	group = "Worn"
	abstract_type = /datum/loadout_item/modlink/worn


/**
 * BRICK SCRYERPHONE
 */
/datum/loadout_item/modlink/phone/brick_scryerphone
	name = "Brick Scryerphone"
	item_path = /obj/item/brick_phone_scryer/loaded/crew
	has_modlink_label = TRUE

/datum/loadout_item/modlink/phone/brick_scryerphone/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	. = ..()
	if(visuals_only)
		return

	var/obj/item/brick_phone_scryer/our_phone = equipped_item
	var/list/item_details = preference_list[item_path]
	var/prefs_label = item_details?[INFO_MODLINK_LABEL]
	our_phone.set_label(prefs_label ? html_decode(prefs_label) : equipper.real_name)

/**
 * MODLINK SCRYER (NECK)
 */
/datum/loadout_item/modlink/worn/link_scryer
	name = "MODlink Scryer"
	item_path = /obj/item/clothing/neck/link_scryer/loaded

/datum/loadout_item/modlink/worn/link_scryer/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	. = ..()
	if(visuals_only)
		return

	var/obj/item/clothing/neck/link_scryer/loaded/our_scryer = equipped_item
	var/list/item_details = preference_list[item_path]
	var/prefs_label = item_details?[INFO_MODLINK_LABEL]
	our_scryer.set_label(prefs_label ? html_decode(prefs_label) : equipper.real_name)
