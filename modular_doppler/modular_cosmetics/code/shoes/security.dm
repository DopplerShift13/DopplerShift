// new doppler shoes

/obj/item/clothing/shoes/utilishoes
	name = "\improper Port Safety PT shoes"
	desc = "Compound layers of knit mesh reveal the faint impression of the sock beneath. Impressively breathable, \
	but they tend to shred at the sidewalls in under six months. Made of 37.34% non-recyclable plastic."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "sec_utilshoes"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_digi.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/shoes/port_safety_kicks
	name = "\improper Port Safety x NG Outfitters collab kicks"
	desc = "An improbable design collaboration between Port Safety and New Gibraltar Outfitters LLC., an outdoors and athleisure \
	apparel and accessories firm. Internal Port Safety memos speak breathlessly of the potential to drive recruitment numbers."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "sec_shoes"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_digi.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

// overrides the security jackboots

/obj/item/clothing/shoes/jackboots/sec
	name = "\improper PS A-95 uniform boots"
	desc = "Port Safety has a source on substantially printed full grain synth leather. Apparel techs in New Gibraltar \
	split the suede layer for gloves and turn the nubuck side of the top grain out to make these reasonably rugged boots. \
	The vegan alternatives breathe worse, but these infamously require an intensive break-in process before they stop blistering. \
	Hop on the locals and search 'A-95 48 hour kerosene soak'."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "sec_jackboots"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_digi.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)
