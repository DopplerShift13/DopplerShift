// Internal magazine for the fukiya double rifle

/obj/item/ammo_box/magazine/internal/c8marsian
	name = "8mm marsian over-under tubes"
	ammo_type = /obj/item/ammo_casing/c8marsian
	caliber = CALIBER_8MMMARSIAN
	max_ammo = 2
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/c8marsian/starts_empty
	start_empty = TRUE

// Magazines for the 8mm Marsian snipers

/obj/item/ammo_box/magazine/c8marsian
	name = "\improper Ransu sniper magazine"
	desc = "A standard magazine for holding seven rounds of 8mm Marsian, usually for the Ransu marksman rifle."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "ransu_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/c8marsian
	caliber = CALIBER_8MMMARSIAN
	max_ammo = 7

/obj/item/ammo_box/magazine/c8marsian/starts_empty
	start_empty = TRUE
