/obj/item/ammo_box/magazine/ammo_stack/c34nb
	name = ".34 NB casings"
	desc = "A stack of .34 NB casings."
	caliber = CALIBER_34NB
	ammo_type = /obj/item/ammo_casing/c34nb
	max_ammo = 5
	casing_w_spacing = 2
	casing_z_padding = 6

/datum/design/c34nb
	name = ".34 NB casing (Lethal)"
	id = "c34nb"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/c34nb
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
