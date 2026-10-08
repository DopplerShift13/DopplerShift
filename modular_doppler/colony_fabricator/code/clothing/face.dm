/obj/item/clothing/mask/gas/atmos/frontier_colonist
	name = "\improper NG-Tek atmosphere/diving mask"
	desc = "Originally based off of patterns found aboard the colony ships for a diving mask, they were refitted early on \
		by in-system research to replace what was found to be a particularly deficient design for early gas masks shipped with \
		the vessels. Due to its origins as a diving mask, the panel is highly angular for hydrodynamics."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "mask"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi'
	)
	worn_icon_state = "mask"
	flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	armor_type = /datum/armor/colonist_hazard
