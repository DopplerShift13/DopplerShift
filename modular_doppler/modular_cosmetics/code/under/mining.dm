/obj/item/clothing/under/rank/cargo/miner
	name = "explorer overalls"
	desc = "It's a snappy turtleneck with a sturdy set of overalls."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/mining.dmi'
	icon_state = "miner"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/mining.dmi'
	resistance_flags = FIRE_PROOF
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/under/mining.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/mining_digi.dmi'
	)

/obj/item/clothing/under/rank/cargo/miner/lavaland
	name = "explorer turtleneck"
	desc = "It's a snappy turtleneck with a pair of working pants."
	icon_state = "explorer"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/under/mining.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/mining_digi.dmi'
	)
