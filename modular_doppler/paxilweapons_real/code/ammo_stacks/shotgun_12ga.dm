// Shotgun revolver's cylinder

/obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	name = "\improper 12 GA revolver cylinder"
	ammo_type = /obj/item/ammo_casing/lethal_s12gauge
	caliber = CALIBER_SHOTGUN
	max_ammo = 4
	multiload = FALSE

// 12ga drum for the nomi semi-automatic shotgun

/obj/item/ammo_box/magazine/c12nomi
	name = "\improper Nomi 12ga drum"
	desc = "A large drum for the Nomi repeating shotgun that fits 12ga shotgun shells within. \
		Holds ten shells."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "nomi_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/lethal_s12gauge
	caliber = CALIBER_SHOTGUN
	max_ammo = 10

/obj/item/ammo_box/magazine/c12nomi/starts_empty
	start_empty = TRUE

// 12ga tube for the riot shotguns

/obj/item/ammo_box/magazine/internal/shot/riot/sol
	ammo_type = /obj/item/ammo_casing/lethal_s12gauge
