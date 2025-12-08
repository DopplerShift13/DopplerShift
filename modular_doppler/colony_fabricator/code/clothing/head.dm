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
		starting_light = new /obj/item/flashlight(src), \
		is_light_removable = FALSE, \
		light_overlay = "light", \
	)
