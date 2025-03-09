// .980 grenade magazines

/obj/item/ammo_box/magazine/c980_grenade
	name = "\improper Kiboko grenade box"
	desc = "A standard size box for .980 grenades, holds four shells."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "kiboko_standard"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/c980grenade
	caliber = CALIBER_980TYDHOUER
	max_ammo = 4

/obj/item/ammo_box/magazine/c980_grenade/chill_out
	ammo_type = /obj/item/ammo_casing/c980grenade/flechette

/obj/item/ammo_box/magazine/c980_grenade/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c980_grenade/drum
	name = "\improper Kiboko grenade drum"
	desc = "A drum for .980 grenades, holds six shells."
	icon_state = "kiboko_drum"
	w_class = WEIGHT_CLASS_NORMAL
	max_ammo = 6

/obj/item/ammo_box/magazine/c980_grenade/drum/chill_out
	ammo_type = /obj/item/ammo_casing/c980grenade/flechette

/obj/item/ammo_box/magazine/c980_grenade/drum/starts_empty
	start_empty = TRUE
