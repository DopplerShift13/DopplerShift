/obj/item/clothing/suit/hooded/explorer
	name = "explorer suit"
	desc = "An armoured coat for exploring harsh environments. Includes starched collar."
	icon_state = "explorer"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/working.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/working.dmi'
	inhand_icon_state = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/hooded/explorer/Initialize(mapload)
	. = ..()
	allowed |= list(/obj/item/gun)

/obj/item/clothing/suit/hooded/explorer/get_general_color(icon/base_icon)
	return "#647684"

/obj/item/clothing/head/hooded/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/mining.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/mining.dmi'
	icon_state = "explorer"

// Casual jacket

/obj/item/clothing/suit/armor/vest/miningjacket
	name = "explorer jacket"
	desc = "A finer woolen coat for exploring harsh environments. Includes starched collar."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/working.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/working.dmi'
	icon_state = "explorer_casual"
	inhand_icon_state = null
	armor_type = /datum/armor/hooded_explorer
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/miningjacket/Initialize(mapload)
	. = ..()
	allowed |= GLOB.mining_suit_allowed
