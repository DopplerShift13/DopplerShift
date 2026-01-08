/obj/item/clothing/gloves/doppler_cargo
	name = "leather gloves"
	desc = "Calfskin gloves with a generous cut and fit."
	icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_obj.dmi'
	icon_state = "cargo_glove1"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob.dmi'
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = PAYCHECK_CREW * 1.5
	worn_icon_state = "cargo_glove1"

/obj/item/clothing/gloves/doppler_cargo/work_gloves
	name = "work gloves"
	desc = "Textile work gloves with a close fit, cut and sewn from a synthetic tech fabric."
	icon_state = "cargo_glove2"
	worn_icon_state = "cargo_glove2"

/obj/item/clothing/gloves/doppler_cargo/colorblock_gauntlets
	name = "colorblock gauntlets"
	desc = "Brown leather gauntlets with nylon fingertips."
	icon_state = "cargo_glove3"
	worn_icon_state = "cargo_glove3"

/obj/item/clothing/gloves/doppler_cargo/gauntlets
	name = "leather gauntlets"
	desc = "A pair of leather gauntlets that reach halfway up the forearms."
	icon_state = "cargo_glove4"
	worn_icon_state = "cargo_glove4"

/obj/item/clothing/gloves/doppler_cargo/fingerless
	name = "fingerless gloves"
	desc = "Soft nubuck gloves with raw cut edges where the fingertips were severed in a hasty moment of rear warehouse passion."
	icon_state = "cargo_fingerless"
	worn_icon_state = "cargo_fingerless"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)
