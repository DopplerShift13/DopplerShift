/obj/item/ammo_box/magazine/ammo_stack/c585naraka
	name = ".585 naraka casings"
	desc = "A stack of .585 naraka casings."
	icon_state = "stack_spec"
	caliber = CALIBER_585NARAKA
	ammo_type = /obj/item/ammo_casing/c585naraka
	casing_phrasing = "casing"
	max_ammo = 6
	casing_w_spacing = 3
	casing_z_padding = 9

/obj/item/ammo_box/magazine/ammo_stack/c585naraka/full
	start_empty = FALSE

/datum/design/c585naraka_autolathe
	name = ".585 naraka casing (VERY Lethal)"
	id = "c585naraka_autolathe"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ammo_casing/c585naraka
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c585naraka
	name = ".585 naraka casing (VERY Lethal)"
	id = "c585naraka"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ammo_casing/c585naraka
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/techweb_node/basic_arms/New()
	design_ids |= list(
		"c585naraka",
		"c25euro",
	)
	return ..()
