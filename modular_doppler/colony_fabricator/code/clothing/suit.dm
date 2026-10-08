/obj/item/clothing/suit/toggle/jacket/frontier_colonist
	name = "\improper Ispanlita jacket"
	desc = "Taking its name from the city that spawned its creation, insulating jackets were deemed not to be a necessity in the limited \
		databanks of the original colony ships, and thus were a later invention by local developers once the discovery of the Truth \
		climate cycle was made along with the need to inhabit colder areas of the system. Comes with reflective stripes to ensure \
		the wearer can still be identified in harsh weather."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jacket"
	base_icon_state = "jacket"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	inhand_icon_state = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
	)
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = NONE
	allowed = list()
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo
	toggle_noun = "zipper"
	/// If this suit item has emissives or not
	var/has_emissives = TRUE

/obj/item/clothing/suit/toggle/jacket/frontier_colonist/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands && has_emissives) // This uses base icon state because of the toggling aspect
		. += emissive_appearance(icon_file, "[base_icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/suit/toggle/jacket/frontier_colonist/Initialize(mapload)
	. = ..()
	allowed = GLOB.colonist_suit_allowed

/obj/item/clothing/suit/toggle/jacket/frontier_colonist/worker
	name = "\improper Ispanlita worker's jacket"
	icon_state = "jacket_work"
	base_icon_state = "jacket_work"
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/toggle/jacket/frontier_colonist/medical
	name = "\improper Ispanlita medic's jacket"
	icon_state = "jacket_med"
	base_icon_state = "jacket_med"
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/frontier_colonist_flak
	name = "thermoset breastplate"
	desc = "A pair of thick thermoset plastic panels made to be worn under a jacket or vest to protect the wearer. \
		These see use most commonly in salvage and contruction workers on New Gibraltar, but are common in most work roles \
		requiring extra protection against anything outside of a gunshot."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "flak"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "flak"
	inhand_icon_state = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
	)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	allowed = list()

/obj/item/clothing/suit/frontier_colonist_flak/Initialize(mapload)
	. = ..()
	allowed = GLOB.colonist_suit_allowed

/obj/item/clothing/suit/toggle/jacket/frontier_colonist/casual
	name = "\improper NG-Tek casual raincloak"
	desc = "A lightweight raincloak with a reflective stripe around the chest for wear when not doing heavy work."
	icon_state = "raincloak"
	has_emissives = FALSE
