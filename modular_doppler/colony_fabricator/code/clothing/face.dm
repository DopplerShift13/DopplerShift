/obj/item/clothing/mask/gas/atmos/frontier_colonist
	name = "frontier gas mask"
	desc = "An improved gas mask commonly seen in places where the atmosphere is less than breathable, \
		but otherwise more or less habitable. It's certified to protect against most biological hazards \
		to boot."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "mask"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi'
	)
	worn_icon_state = "mask"
	flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	armor_type = /datum/armor/colonist_hazard
