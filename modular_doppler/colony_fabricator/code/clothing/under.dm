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
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/frontier_colonist/casual
	name = "frontier casualwear"
	desc = "A comfortable jumpsuit with patches of velcro for attaching tablets and tools, and strengthened joints to mitigate wear."
	icon_state = "casualwear"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	can_adjust = FALSE
