// shoes that offset your sprite upwards

/obj/item/clothing/shoes/frankenstompers
	name = "\improper D3M0N1k Frankenstompers"
	desc = "De riguer gear for alternative people. These have a tendency to get thrown into the back of a closet until the foam \
	outsoles disintegrate, or to come apart spontaneously on the dance floor, but nevertheless to dust do these gothy boots \
	inevitably return."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/shoes/casual.dmi'
	icon_state = "frankenstompers"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/shoes/casual.dmi'
	offset = 2
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/casual.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/casual_digi.dmi',
	)
