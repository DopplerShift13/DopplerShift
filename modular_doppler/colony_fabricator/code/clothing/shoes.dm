/obj/item/clothing/shoes/jackboots/frontier_colonist
	name = "heavy frontier boots"
	desc = "A well built pair of tall boots usually seen on the feet of explorers, first wave colonists, \
		and LARPers across the galaxy."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "boots"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	worn_icon_state = "boots"
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/jackboots/frontier_colonist/casual
	name = "frontier casual shoes"
	desc = "Casual laceless shoes, non-flammable yet comfortable for everyday life."
	icon_state = "boots_casual"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
