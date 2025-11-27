// Where?? Did the accessories tab go ??

/datum/loadout_item/accessory/ear_tag
	name = "Ear Tag"
	item_path = /obj/item/clothing/accessory/ear_tag
	tag_examine_description = TRUE

/datum/loadout_item/accessory/ear_tag/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	. = ..()
	if(visuals_only)
		return
	var/datum/loadout_item/accessory/ear_tag/our_tag = equipped_item
	var/list/item_details = preference_list[item_path]
	var/prefs_label = item_details?[INFO_EAR_TAG_TEXT]
	our_tag.display = prefs_label ? html_decode(prefs_label) : "Nothing!"

/datum/loadout_item/accessory/vaporizer
	name = "Hydro-Vaporizer"
	item_path = /obj/item/clothing/accessory/vaporizer //Needing the item for breathing already puts it in your inventory, but people might want it for other stuff
