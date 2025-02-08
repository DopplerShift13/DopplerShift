// Giant evil 6 gauge shotgun for blowing people to the nearest planet with

/obj/item/gun/ballistic/shotgun/ramu
	name = "\improper Ramu Super Burst Blaster"
	desc = "A rare Donk(tm) blaster that throws darts extra hard."
	icon = 'modular_doppler/its_donk_or_dont/icons/shotgun_48.dmi'
	icon_state = "ramu"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "ramu"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "ramu"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	SET_BASE_PIXEL(-8, 0)
	load_sound = 'modular_doppler/its_donk_or_dont/sound/ramu/ramu_load.wav'
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/ramu/ramu_pump.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	can_suppress = TRUE
	can_unsuppress = TRUE
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'
	suppressor_x_offset = 12
	can_be_sawn_off = FALSE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/s6gauge

/obj/item/gun/ballistic/shotgun/ramu/add_bayonet_point()
	return

/obj/item/gun/ballistic/shotgun/ramu/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/shotgun/ramu/starts_empty
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/s6gauge/starts_empty
