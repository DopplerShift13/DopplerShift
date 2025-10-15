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

/obj/item/clothing/gloves/doppler_cargo
	name = "cargo technician's leather gloves"
	desc = "Calfskin gloves with a generous cut and fit."
	icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_obj.dmi'
	icon_state = "cargo_glove1"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob.dmi'
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = PAYCHECK_CREW * 1.5
	worn_icon_state = "cargo_glove1"

/obj/item/clothing/gloves/doppler_cargo/work_gloves
	name = "cargo technician's work gloves"
	desc = "Textile work gloves with a close fit, cut and sewn from a synthetic tech fabric."
	icon_state = "cargo_glove2"
	worn_icon_state = "cargo_glove2"

/obj/item/clothing/gloves/doppler_cargo/colorblock_gauntlets
	name = "cargo technician's colorblock gauntlets"
	desc = "Brown leather gauntlets with nylon fingertips."
	icon_state = "cargo_glove3"
	worn_icon_state = "cargo_glove3"

/obj/item/clothing/gloves/doppler_cargo/gauntlets
	name = "cargo technician's gauntlets"
	desc = "A pair of leather gauntlets that reach halfway up the forearms."
	icon_state = "cargo_glove4"
	worn_icon_state = "cargo_glove4"

/obj/item/clothing/gloves/doppler_cargo/fingerless
	name = "cargo technician's fingerless gloves"
	desc = "Soft nubuck gloves with raw cut edges where the fingertips were severed in a hasty moment of rear warehouse passion."
	icon_state = "cargo_fingerless"
	worn_icon_state = "cargo_fingerless"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

