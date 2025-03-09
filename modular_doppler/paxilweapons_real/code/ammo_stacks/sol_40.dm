// .40 Sol rifle magazines

/obj/item/ammo_box/magazine/c40sol_rifle
	name = "\improper Sol rifle short magazine"
	desc = "A shortened magazine for SolFed rifles, holds fifteen rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "rifle_short"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c40sol
	caliber = CALIBER_SOL40LONG
	max_ammo = 15

/obj/item/ammo_box/magazine/c40sol_rifle/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c40sol_rifle/standard
	name = "\improper Sol rifle magazine"
	desc = "A standard size magazine for SolFed rifles, holds thirty rounds."
	icon_state = "rifle_standard"
	w_class = WEIGHT_CLASS_SMALL
	max_ammo = 30

/obj/item/ammo_box/magazine/c40sol_rifle/standard/starts_empty
	start_empty = TRUE
