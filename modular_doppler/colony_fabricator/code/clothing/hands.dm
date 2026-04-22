/obj/item/clothing/gloves/frontier_colonist
	name = "frontier gloves"
	desc = "A sturdy pair of black gloves that'll keep your precious fingers protected from the outside world. \
		They go a bit higher up the arm than most gloves should, and you aren't quite sure why."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "gloves"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "gloves"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	greyscale_colors = "#3a373e"
	siemens_coefficient = 0.25 // Doesn't insulate you entirely, but makes you a little more resistant
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	clothing_traits = list(TRAIT_QUICK_CARRY)
