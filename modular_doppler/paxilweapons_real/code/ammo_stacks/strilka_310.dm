// .310 magazine for the Lanca rifle

/obj/item/ammo_box/magazine/lanca
	name = "\improper Lanca rifle magazine"
	desc = "A standard size magazine for Lanca rifles, holds five rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "lanca_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/strilka310
	caliber = CALIBER_STRILKA310
	max_ammo = 5

/obj/item/ammo_box/magazine/lanca/spawns_empty
	start_empty = TRUE
