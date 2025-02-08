// Osako internal

/obj/item/ammo_box/magazine/internal/boltaction/donk
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM

// Karim specific

/obj/item/ammo_box/magazine/karim
	name = "\improper Karim pulse blaster magazine"
	desc = "A standard size magazine for Karim pulse blasters, holds fifty darts."
	icon = 'modular_doppler/its_donk_or_dont/icons/magazines_and_boxes.dmi'
	icon_state = "karim_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 50
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/karim/spawns_empty
	start_empty = TRUE

// Prior 8mm

/obj/item/ammo_box/magazine/internal/c8marsian
	name = "foam force over-under tubes"
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 2
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/c8marsian/starts_empty
	start_empty = TRUE

// Magazines for the 8mm Marsian snipers

/obj/item/ammo_box/magazine/c8marsian
	name = "\improper Ransu super blaster magazine"
	desc = "A standard magazine for holding seven darts, usually for the Ransu blaster."
	icon = 'modular_doppler/its_donk_or_dont/icons/magazines_and_boxes.dmi'
	icon_state = "ransu_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 7

/obj/item/ammo_box/magazine/c8marsian/starts_empty
	start_empty = TRUE

// Ramu

/obj/item/ammo_box/magazine/internal/s6gauge
	name = "Ramu internal tube"
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 3
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/s6gauge/starts_empty
	start_empty = TRUE

// Prior 12ga

/obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	name = "\improper small foam force revolver cylinder"
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 4
	multiload = FALSE

/obj/item/ammo_box/magazine/c12nomi
	name = "\improper Nomi dart drum"
	desc = "A large drum for the Nomi repeating blaster that fits darts within. \
		Holds ten shells."
	icon = 'modular_doppler/its_donk_or_dont/icons/magazines_and_boxes.dmi'
	icon_state = "nomi_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 10

/obj/item/ammo_box/magazine/c12nomi/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/shot/riot/sol
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM

// Small pistol stuff

/obj/item/ammo_box/magazine/c35sol_pistol
	name = "\improper Donk(tm) advanced pistol magazine"
	desc = "A standard size magazine for Donk(tm) pistols, holds twelve darts."
	icon = 'modular_doppler/its_donk_or_dont/icons/magazines_and_boxes.dmi'
	icon_state = "pistol_35_standard"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 12

/obj/item/ammo_box/magazine/c35sol_pistol/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c35sol_pistol/stendo
	name = "\improper Donk(tm) advanced extended pistol magazine"
	desc = "An extended magazine for Donk(tm) pistols, holds twenty-four darts."
	icon_state = "pistol_35_stended"
	w_class = WEIGHT_CLASS_NORMAL
	max_ammo = 24

/obj/item/ammo_box/magazine/c35sol_pistol/stendo/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/cylinder/c35sol
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 9

// Rifle

/obj/item/ammo_box/magazine/c40sol_rifle
	name = "\improper Donk(tm) rifle short magazine"
	desc = "A shortened magazine for Donk(tm) rifles, holds fifteen darts."
	icon = 'modular_doppler/its_donk_or_dont/icons/magazines_and_boxes.dmi'
	icon_state = "rifle_short"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 15

/obj/item/ammo_box/magazine/c40sol_rifle/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/c40sol_rifle/standard
	name = "\improper Donk(tm) rifle magazine"
	desc = "A standard size magazine for Donk(tm) rifles, holds thirty darts."
	icon_state = "rifle_standard"
	w_class = WEIGHT_CLASS_SMALL
	max_ammo = 30

/obj/item/ammo_box/magazine/c40sol_rifle/standard/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/cylinder/c585trappiste
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 5

