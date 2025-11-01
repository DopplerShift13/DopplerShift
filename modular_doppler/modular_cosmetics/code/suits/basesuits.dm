/obj/item/clothing/suit/bio_suit
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_TESHARI,
		BODYSHAPE_DIGITIGRADE
		)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/bio.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/bio_digi.dmi'
	)

/obj/item/clothing/suit/wizrobe
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_DIGITIGRADE
		)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/wizard.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/wizard_digi.dmi')

/obj/item/clothing/suit/hooded/wintercoat/medical
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_TESHARI,
		)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/wintercoat.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
		)
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/wintercoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/wintercoat.dmi'

/obj/item/clothing/suit/toggle/labcoat
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_TESHARI,
		BODYSHAPE_DIGITIGRADE
		)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat_digi.dmi'
		)

//mfw they aren't subtyped properly
/obj/item/clothing/suit/toggle/labcoat/genetics
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/chemist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/virologist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/coroner
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/science
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/roboticist
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/interdyne
	greyscale_config_worn_bodyshapes = list(BODYSHAPE_HUMANOID_T = /datum/greyscale_config/labcoat/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/labcoat/worn/digi)
/obj/item/clothing/suit/toggle/labcoat/cmo
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'

/// SPACESUITS
/obj/item/clothing/head/helmet/space
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/spacehelm.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/modular_cosmetics/icons/mob/head/spacehelm_muzzled.dmi')

/obj/item/clothing/head/helmet/space/plasmaman
	supported_bodyshapes = null
	bodyshape_icon_files = null

/obj/item/clothing/suit/space
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/spacesuit.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/spacesuit_digi.dmi')
	species_clothing_color_coords = list(list(SPACESUIT_COLORPIXEL_X_1, SPACESUIT_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/spacesuit)

/// RADSUITS
/obj/item/clothing/head/utility/radiation
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/modular_cosmetics/icons/mob/head/basehead_muzzled.dmi',
	)

/obj/item/clothing/suit/utility/radiation
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi',
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

/obj/item/clothing/suit/hooded/explorer/syndicate
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/suit_digi.dmi',
	)

/// TODO: migrate these into our normal file
/datum/greyscale_config/labcoat/worn/digi
	name = "Labcoat (Worn, Digitigrade)"
	icon_file = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat_digi.dmi'
