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

/obj/item/clothing/gloves/arm_warmers
	name = "arm warmers"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	icon_state = "/obj/item/clothing/gloves/arm_warmers"
	post_init_icon_state = "arm_warmers"
	greyscale_config = /datum/greyscale_config/arm_warmers
	greyscale_config_worn = /datum/greyscale_config/arm_warmers/worn
	greyscale_colors = "#b0becc"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/suede_gloves
	name = "suede gloves"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	icon_state = "/obj/item/clothing/gloves/suede_gloves"
	post_init_icon_state = "suede_gloves"
	greyscale_config = /datum/greyscale_config/suede_gloves
	greyscale_config_worn = /datum/greyscale_config/suede_gloves/worn
	greyscale_colors = "#b0becc"
	flags_1 = IS_PLAYER_COLORABLE_1

//translation gloves for mutes that need radio and departmental swag at the same time

/obj/item/clothing/gloves/fingerless/doppler_security/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "security translation gloves"
	desc = "A cleverly modified fork of the controversial fingerless gloves adopted by Port Safety, these \
	half-fingered archer-style gloves allow for sign language users to 'speak' over radio by capturing \
	the necessary motions from the leading three fingers on each hand. As these only cover a few fingers, \
	they are almost worthless in forensics work. "
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
	worn_icon_state = "fingerish_cargo_radio"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH, TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/doppler_cargo/radio
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	name = "leather cargo translation gloves"
	desc = "Robust, comfortable leather gloves with modified fingertips that allow for sign language users \
	to 'speak' over radio by capturing their hand motions."
	icon_state = "cargo_radio"
	worn_icon_state = "cargo_radio"
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
	desc = "Insulated gloves with simple electronics that both provide protection against electric \
	shock and allow for the user to 'speak' over radio using sign language."
	icon_state = "eng_radio"
	custom_price = PAYCHECK_CREW * 12
	custom_premium_price = PAYCHECK_COMMAND * 7
	clothing_traits = list(TRAIT_CAN_SIGN_ON_COMMS)

//crafting recipes for translator gloves, similar syntax to obsoletefold conversion recipes found in glasses.dm
/datum/crafting_recipe/sec1radio
	name = "Fingerless Security Translation Gloves"
	result = /obj/item/clothing/gloves/fingerless/doppler_security/radio
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/fingerless/doppler_security = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/sec2radio
	name = "Security Translation Gloves"
	result = /obj/item/clothing/gloves/security_radio	//it's a miracle, you've attached all the fingers! does take some cloth though
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/fingerless/doppler_security = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/cloth = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/cargo1radio
	name = "Fingerless Cargo Translation Gloves"
	result = /obj/item/clothing/gloves/doppler_cargo/fingerless/radio
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/doppler_cargo/fingerless = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/cargo2radio
	name = "Leather Cargo Translation Gloves"
	result = /obj/item/clothing/gloves/doppler_cargo/radio
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/doppler_cargo = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/nitrileradio
	name = "Nitrile Translation Gloves"
	result = /obj/item/clothing/gloves/latex/nitrile/radio
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/latex/nitrile = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/insulradio
	name = "Insulated Translation Gloves"
	result = /obj/item/clothing/gloves/color/yellow/radio
	time = 2 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/color/yellow = 1,
		/obj/item/clothing/gloves/radio = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT

//not sure why you'd ever remove the translation capabilities from these but i guess you can?
/datum/crafting_recipe/sec1radioremoval
	name = "Fingerless Security Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/fingerless/doppler_security
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/fingerless/doppler_security/radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/sec2radioremoval
	name = "Security Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/fingerless/doppler_security
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/security_radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/cargo1radioremoval
	name = "Fingerless Cargo Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/doppler_cargo/fingerless
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/doppler_cargo/fingerless/radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/cargo2radioremoval
	name = "Leather Cargo Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/doppler_cargo
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/doppler_cargo/radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/insulradioremoval
	name = "Insulated Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/color/yellow
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/color/yellow/radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
/datum/crafting_recipe/nitrileradioremoval
	name = "Nitrile Translation Gloves Translation Removal"
	result = /obj/item/clothing/gloves/latex/nitrile
	time = 2 SECONDS
	reqs = list(/obj/item/clothing/gloves/latex/nitrile/radio = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT
