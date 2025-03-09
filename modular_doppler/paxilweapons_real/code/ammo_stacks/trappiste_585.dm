// .585 pistol magazines

/obj/item/ammo_box/magazine/c585trappiste_pistol
	name = "\improper Trappiste pistol magazine"
	desc = "A standard size magazine for Trappiste pistols, holds six rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "pistol_585_standard"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/c585trappiste
	caliber = CALIBER_585TRAPPISTE
	max_ammo = 6

/obj/item/ammo_box/magazine/c585trappiste_pistol/spawns_empty
	start_empty = TRUE

// Cylinder for the takbok

/obj/item/ammo_box/magazine/internal/cylinder/c585trappiste
	ammo_type = /obj/item/ammo_casing/c585trappiste
	caliber = CALIBER_585TRAPPISTE
	max_ammo = 5
