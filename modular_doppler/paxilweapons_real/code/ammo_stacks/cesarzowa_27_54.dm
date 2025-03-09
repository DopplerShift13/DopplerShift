// Magazine for the Miecz submachinegun

/obj/item/ammo_box/magazine/miecz
	name = "\improper Miecz submachinegun magazine"
	desc = "A standard size magazine for Miecz submachineguns, holds eighteen rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "miecz_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa
	caliber = CALIBER_CESARZOWA
	max_ammo = 18

/obj/item/ammo_box/magazine/miecz/spawns_empty
	start_empty = TRUE
