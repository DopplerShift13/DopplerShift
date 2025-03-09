// Magazine for the Karim rifle

/obj/item/ammo_box/magazine/karim
	name = "\improper Karim pulse rifle magazine"
	desc = "A standard size magazine for Karim pulse rifles, holds fifty rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "karim_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/europan4mm
	caliber = CALIBER_CESARZOWA
	max_ammo = 50
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/karim/spawns_empty
	start_empty = TRUE
