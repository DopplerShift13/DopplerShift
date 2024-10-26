/obj/item/clothing/suit/bio_suit
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/bio.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/bio_digi.dmi')

/obj/item/clothing/suit/wizrobe
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/wizard.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/wizard_digi.dmi')



/obj/item/clothing/suit/toggle/labcoat
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat_digi.dmi')
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi'

//God damnit TG you *fuckwits*, why didn't you subtype these properly
/obj/item/clothing/suit/toggle/labcoat/genetics
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/chemist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	greyscale_colors = "#547E64#D5E04B#D5E04B#A2A947"
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/virologist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	greyscale_colors = "#547E64#4D9BE6#4D9BE6#4D65B4"
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/coroner
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	greyscale_colors = "#696F80#547E64#547E64#374E4A"
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/science
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/roboticist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	flags_1 = IS_PLAYER_COLORABLE_1
/obj/item/clothing/suit/toggle/labcoat/interdyne
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/labcoat/custom
	name = "custom labcoat"
	desc = "A suit that protects against minor chemical spills. This one's custom!"
	icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#EEEEEE#EEEEEE#EEEEEE"
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
	flags_1 = IS_PLAYER_COLORABLE_1



/// SPACESUITS
/obj/item/clothing/head/helmet/space
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/spacehelm.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/modular_cosmetics/icons/mob/head/spacehelm_muzzled.dmi')

/obj/item/clothing/suit/space
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/spacesuit.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/spacesuit_digi.dmi')

/// RADSUITS
/obj/item/clothing/head/utility/radiation
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/modular_cosmetics/icons/mob/head/basehead_muzzled.dmi')

/obj/item/clothing/suit/utility/radiation
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/suit_digi.dmi')



/// FLAKY SUITS
/obj/item/clothing/suit/chaplainsuit
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/chaplain.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/chaplain_digi.dmi')

/obj/item/clothing/suit/hooded/chaplainsuit
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/chaplain.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/chaplain_digi.dmi')

/obj/item/clothing/suit/hooded/explorer
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/suit_digi.dmi')



/// TODO: migrate these into our normal file
/datum/greyscale_config/labcoat/worn/digi
	name = "Labcoat (Worn, Digitigrade)"
	icon_file = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat_digi.dmi'
