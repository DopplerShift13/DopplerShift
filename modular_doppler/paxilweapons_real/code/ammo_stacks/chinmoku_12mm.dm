// Modified .40 Sol rifle magazines to fit 12mm chinmoku

/obj/item/ammo_box/magazine/c12chinmoku
	name = "\improper Chinmoku short magazine"
	desc = "A shortened magazine for SolFed rifles, holds fifteen rounds. \
		This one has been modified to fit the dimensionally-close-enough 12mm Chinmoku casings. \
		A white line has been added to indicate you should not try using this in standard sol rifles."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	icon_state = "rifle_alt_short"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c12chinmoku
	caliber = CALIBER_12MMCHINMOKU
	max_ammo = 15

/obj/item/ammo_box/magazine/c12chinmoku/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c12chinmoku/standard
	name = "\improper Chinmoku magazine"
	desc = "A standard size magazine for SolFed rifles, holds thirty rounds. \
		This one has been modified to fit the dimensionally-close-enough 12mm Chinmoku casings. \
		A white line has been added to indicate you should not try using this in standard sol rifles."
	icon_state = "rifle_alt_standard"
	w_class = WEIGHT_CLASS_SMALL
	max_ammo = 30

/obj/item/ammo_box/magazine/c12chinmoku/standard/starts_empty
	start_empty = TRUE
