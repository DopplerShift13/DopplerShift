/obj/item/clothing/suit/jacket/frontier_colonist
	name = "frontier trenchcoat"
	desc = "A knee length coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jacket"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "jacket"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = NONE
	allowed = null
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/frontier_colonist/Initialize(mapload)
	. = ..()
	allowed |= GLOB.colonist_suit_allowed

/obj/item/clothing/suit/jacket/frontier_colonist/short
	name = "frontier jacket"
	desc = "A short coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles."
	icon_state = "jacket_short"
	worn_icon_state = "jacket_short"
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/jacket/frontier_colonist/medical
	name = "frontier medical jacket"
	desc = "A short coat with a water-resistant exterior and relatively comfortable interior. \
		In between? Just enough protective material to stop the odd sharp thing getting through, \
		though don't expect miracles. This one is colored a bright red and covered in white \
		stripes to denote that someone wearing it might be able to provide medical assistance."
	icon_state = "jacket_med"
	worn_icon_state = "jacket_med"
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/frontier_colonist_flak
	name = "frontier flak jacket"
	desc = "A simple flak jacket with an exterior of water-resistant material. \
		Jackets like these are often found on first wave colonists that want some armor \
		due to the fact they can be made easily within a colony core type machine."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "flak"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "flak"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	allowed = null

/obj/item/clothing/suit/frontier_colonist_flak/Initialize(mapload)
	. = ..()
	allowed |= GLOB.colonist_suit_allowed
