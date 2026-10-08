/obj/item/clothing/shoes/jackboots/frontier_colonist
	name = "\improper CESC shin-plate workboots"
	desc = "A massively heavy pair of boots that come with a hardened toe and protection against liquid intrusion for \
		jungle environments. Their special feature, however, is the large alloy plates that protect the shins from \
		accidents while working. Kneepads not included."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "boots"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	worn_icon_state = "boots"
	armor_type = /datum/armor/colonist_clothing
	resistance_flags = FIRE_PROOF
	/// If we have emissives or not
	var/has_emissives = TRUE

/obj/item/clothing/shoes/jackboots/frontier_colonist/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands && has_emissives)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/shoes/jackboots/frontier_colonist/casual
	name = "frontier casual shoes"
	desc = "Casual laceless shoes, non-flammable yet comfortable for everyday life."
	icon_state = "boots_casual"
	worn_icon_state = "boots_casual"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	has_emissives = FALSE
