/obj/item/ammo_box/magazine/ammo_stack/avispa_stingball
	name = "\improper fistfull of balls"	//sorry
	desc = "A stack of .61 stingballs"
	caliber = CALIBER_STINGBALL
	ammo_type = /obj/item/ammo_casing/avispa_stingball
	casing_phrasing = "ball"
	max_ammo = 12
	casing_w_spacing = 3
	casing_z_padding = 4

/datum/design/avispa_stingball_autolathe
	name = ".61 stingballs (Less Lethal)"
	id = "61stingball_autolathe"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/avispa_stingball
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
