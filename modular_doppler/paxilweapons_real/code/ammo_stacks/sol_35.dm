// .35 Sol pistol magazines

/obj/item/ammo_box/magazine/c35sol_pistol
	name = "\improper Sol pistol magazine"
	desc = "A standard size magazine for SolFed pistols, holds twelve rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "pistol_35_standard"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c35sol
	caliber = CALIBER_SOL35SHORT
	max_ammo = 12

/obj/item/ammo_box/magazine/c35sol_pistol/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c35sol_pistol/stendo
	name = "\improper Sol extended pistol magazine"
	desc = "An extended magazine for SolFed pistols, holds twenty-four rounds."
	icon_state = "pistol_35_stended"
	w_class = WEIGHT_CLASS_NORMAL
	max_ammo = 24

/obj/item/ammo_box/magazine/c35sol_pistol/stendo/starts_empty
	start_empty = TRUE

// Cylinder for the Eland

/obj/item/ammo_box/magazine/internal/cylinder/c35sol
	ammo_type = /obj/item/ammo_casing/c35sol
	caliber = CALIBER_SOL35SHORT
	max_ammo = 9
