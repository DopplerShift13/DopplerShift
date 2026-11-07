/obj/item/ammo_box/magazine/ammo_stack/c25euro
	name = ".25 europa casings"
	desc = "A stack of .25 europa casings."
	caliber = CALIBER_25EUROPA
	ammo_type = /obj/item/ammo_casing/c25euro
	max_ammo = 5
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/c25euro/full
	start_empty = FALSE

/datum/design/c25euro_autolathe
	name = ".25 europa casing (Lethal)"
	id = "c25euro_autolathe"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/c25euro
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c25euro_autolathe_less
	name = ".25 europa hunter casing (Lethal)"
	id = "c25euro_autolathe_hunter"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/c25euro/tracer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c25euro
	name = ".25 europa casing (Lethal)"
	id = "c25euro"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/c25euro
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
