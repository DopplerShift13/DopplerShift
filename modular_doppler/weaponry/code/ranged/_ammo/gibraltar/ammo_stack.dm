/obj/item/ammo_box/magazine/ammo_stack/c6ng
	name = "6mm NG casings"
	desc = "A stack of 6mm NG casings"
	caliber = CALIBER_6MMGIBRALTAR
	ammo_type = /obj/item/ammo_casing/c6ng
	max_ammo = 14
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/c6ng/full
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c6ng/full/sport
	name = "6mm NG Ultrasport casings"
	ammo_type = /obj/item/ammo_casing/c6ng/match

/obj/item/ammo_box/magazine/ammo_stack/c6ng/full/rubber
	name = "6mm NG Rubber casings"
	ammo_type = /obj/item/ammo_casing/c6ng/rubber

// RND designs

/datum/design/c38/sec
	name = "6mm NG casings (Lethal)"
	desc = "A pile of 6mm casings for you to figure out what to do with."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_box/magazine/ammo_stack/c6ng/full

/datum/design/c38_iceblox
	name = "6mm NG Ultrasport casings (Lethal)"
	desc = "A pile of 6mm casings for you to figure out what to do with."
	build_path = /obj/item/ammo_box/magazine/ammo_stack/c6ng/full/sport

/datum/design/c38_rubber
	name = "6mm NG rubber casings (Less Lethal)"
	desc = "A pile of 6mm casings for you to figure out what to do with."
	build_path = /obj/item/ammo_box/magazine/ammo_stack/c6ng/full/rubber

/datum/design/c38
	name = "6mm NG casing (Lethal)"
	id = "c38"
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/ammo_casing/c6ng
