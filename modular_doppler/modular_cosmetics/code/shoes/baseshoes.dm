/obj/item/clothing/shoes
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/feet.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/shoes/basefeet_digi.dmi')



/obj/item/clothing/shoes/sneakers
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/sneakers/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/sneakers/worn/digi)

/obj/item/clothing/shoes/sneakers/doppler
	name = "doppler sneakers"
	greyscale_colors = "#2b2b2b#ffffff"

/obj/item/clothing/shoes/sneakers/doppler/med_green
	name = "apple-green sneakers"
	greyscale_colors = "#B7DE5B#ffffff"

/obj/item/clothing/shoes/sneakers/doppler/eng_orange
	name = "orange sneakers"
	greyscale_colors = "#FBB954#ffffff"

/obj/item/clothing/shoes/sneakers/doppler/cmd_electric
	name = "electric-green sneakers"
	greyscale_colors = "#D5E04B#ffffff"

/obj/item/clothing/shoes/sneakers/orange
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/sneakers_orange/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/sneakers_orange/worn/digi)

/obj/item/clothing/shoes/sneakers/marisa
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/sneakers_marisa/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/sneakers_marisa/worn/digi)



/datum/greyscale_config/sneakers/worn
	icon_file = 'icons/mob/clothing/feet.dmi'

/datum/greyscale_config/sneakers_orange/worn
	icon_file = 'icons/mob/clothing/feet.dmi'

/datum/greyscale_config/sneakers_marisa/worn
	icon_file = 'icons/mob/clothing/feet.dmi'

/datum/greyscale_config/sneakers/worn/digi
	name = "Worn Digi Sneakers"
	icon_file = 'modular_doppler/modular_cosmetics/icons/mob/shoes/basefeet_digi.dmi'

/datum/greyscale_config/sneakers_orange/worn/digi
	name = "Orange Worn Digi Sneakers"
	icon_file = 'modular_doppler/modular_cosmetics/icons/mob/shoes/basefeet_digi.dmi'

/datum/greyscale_config/sneakers_marisa/worn/digi
	name = "Worn Digi Marisa Sneakers"
	icon_file = 'modular_doppler/modular_cosmetics/icons/mob/shoes/basefeet_digi.dmi'
