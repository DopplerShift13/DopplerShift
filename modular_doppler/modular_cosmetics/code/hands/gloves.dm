/obj/item/clothing/gloves/latex/nitrile
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	greyscale_colors = "#B7DE5B"

/obj/item/clothing/gloves/lalune_long
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "designer long gloves"
	desc = "A fancy set of bicep-length black gloves. The La Lune insignia is sewn into the rims."
	icon_state = "lalune_long"
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/gloves/bracer/wraps
	name = "cloth arm wraps"
	desc = "Used for aesthetics, used for wiping sweat from the brow, used for... well, what about you?"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	icon_state = "/obj/item/clothing/gloves/bracer/wraps"
	post_init_icon_state = "arm_wraps"
	inhand_icon_state = "greyscale_gloves"
	greyscale_config = /datum/greyscale_config/armwraps
	greyscale_config_worn = /datum/greyscale_config/armwraps/worn
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1
	supported_bodyshapes = null
	bodyshape_icon_files = null

/obj/item/clothing/gloves/doppler_mining
	name = "mining gloves"
	desc = "A heavily insulated pair of gloves for braving the freezing lands of Truth with all \
		8-10 of your fingers intact."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	icon_state = "explorer"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	worn_icon_state = "explorer"
	greyscale_colors = "#554943"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	clothing_traits = list(TRAIT_QUICK_CARRY)

//translation gloves for mutes that need radio and departmental swag at the same time

/obj/item/clothing/gloves/fingerless/doppler_security/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "security translation gloves"
	desc = "A cleverly modified fork of the controversial fingerless gloves adopted by Port Safety, these \
	half-fingered archer-style gloves allow for sign language users to 'speak' over radio by capturing \
	the necessary motions from the leading three fingers on each hand. As these only cover a few fingers, \
	they are almost worthless in forensics work."
	icon_state = "fingerish_sec_radio"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH, TRAIT_FAST_CUFFING, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/security_radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "full security translation gloves"
	desc = "A pair of Port Safety-approved gloves. These ones have all the fingers, and are specially \
	fitted with sensors that allow sign language users to 'speak' over radio by capturing their hand motions."
	icon_state = "sec_radio"
	clothing_traits = list(TRAIT_FAST_CUFFING, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/doppler_cargo/fingerless/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "fingerless cargo translation gloves"
	desc = "Soft nubuck gloves with modified fingertips. These gloves allow for sign language users to \
	'speak' over radio by capturing the necessary motions from the leading three fingers on each hand."
	icon_state = "fingerish_cargo_radio"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/doppler_cargo/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "leather cargo translation gloves"
	desc = "Robust, comfortable leather gloves with modified fingertips that allow for sign language users \
	to 'speak' over radio by capturing their hand motions."
	icon_state = "leather_cargo_radio"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/latex/nitrile/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "nitrile translation gloves"
	desc = "Durable, sterile gloves with sensors in the fingers that allow for sign language users to \
	'speak' over radio by capturing the necessary motions from the leading three fingers on each hand \
	without compromising on the grip and performance of conventional nitrile gloves."
	icon_state = "med_radio"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/color/yellow/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "insulated translation gloves"
	desc = "Premium insulated gloves that both provide protection against electric shock and allow for \
	the user to 'speak' over radio."
	icon_state = "eng_radio"
	custom_price = PAYCHECK_CREW * 12
	custom_premium_price = PAYCHECK_COMMAND * 7
	clothing_traits = list(TRAIT_CAN_SIGN_ON_COMMS)
