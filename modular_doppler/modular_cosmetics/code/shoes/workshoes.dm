/obj/item/clothing/shoes/medical
	name = "medical shoes"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/shoes/working.dmi'
	icon_state = "medical_doppler"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working.dmi'
	armor_type = /datum/armor/sneakers_white
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_DIGITIGRADE
		)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working_digi.dmi'
		)

/obj/item/clothing/shoes/workboots/mining
	name = "mining boots"
	desc = "Steel-toed mining boots for mining in hazardous environments. Very good at keeping toes uncrushed."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/shoes/working.dmi'
	icon_state = "explorer"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_DIGITIGRADE
		)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/working_digi.dmi'
		)
	resistance_flags = FIRE_PROOF
