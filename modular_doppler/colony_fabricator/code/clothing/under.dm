/obj/item/clothing/under/frontier_colonist
	name = "frontier jumpsuit"
	desc = "A heavy grey jumpsuit with extra padding around the joints. Two massive pockets included. \
		No matter what you do to adjust it, it's always just slightly too large."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jumpsuit"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	worn_icon_state = "jumpsuit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/frontier_colonist/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_KAHRAMAN)
