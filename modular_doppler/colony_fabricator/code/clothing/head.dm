/obj/item/clothing/head/utility/headlights
	name = "head lamp"
	desc = "A flashlight, but stuck to your forehead instead. Genius! How have we never before thought of such a thing?"
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	icon_state = "headlamp"
	body_parts_covered = NONE
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
	)

/obj/item/clothing/head/utility/headlights/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		light_overlay = "light", \
	)

/obj/item/clothing/head/soft/frontier_colonist
	name = "frontier cap"
	desc = "It's a robust baseball hat in a rugged green color."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "cap"
	soft_type = "cap"
	soft_suffix = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "cap"

/obj/item/clothing/head/soft/frontier_colonist/medic
	name = "frontier medical cap"
	desc = "It's a robust baseball hat in a stylish red color. Has a white diamond to denote that its wearer might be able to provide medical assistance."
	icon_state = "cap_medical"
	soft_type = "cap_medical"
	worn_icon_state = "cap_medical"

/obj/item/clothing/head/frontier_colonist_helmet
	name = "frontier soft helmet"
	desc = "A unusual piece of headwear somewhere between a proper helmet and a normal cap."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "tanker"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "tanker"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	flags_inv = 0
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT

/obj/item/clothing/head/frontier_headscarf
	name = "frontier headscarf"
	desc = "A casual wrapping of fabric to keep the sunlight off your head, or just for style."
	icon_state = "colony_headscarf"
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	inhand_icon_state = null
