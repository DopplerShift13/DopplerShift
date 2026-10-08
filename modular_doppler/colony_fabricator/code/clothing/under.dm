/obj/item/clothing/under/frontier_colonist
	name = "frontier worksuit"
	desc = "Large gray working pants made of a thick plastic-like material, cuffed with phosphorescent strips and a matching belt. \
		Though the top is a remarkably comfortable yet completely simple elbow-length tee, the bottoms are designed with long-legged \
		underclothing in mind and will feel like wearing a blue tarp otherwise."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "jumpsuit"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	inhand_icon_state = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_digi.dmi',
	)
	worn_icon_state = "jumpsuit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/frontier_colonist/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/under/frontier_colonist/sensors_off //for cantina spawns . they shouldnt be leaked immediately
	sensor_mode = SENSOR_OFF

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
