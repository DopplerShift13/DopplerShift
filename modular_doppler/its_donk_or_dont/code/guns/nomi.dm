// Drum fed semi-automatic shotgun firing 12ga

/obj/item/gun/ballistic/automatic/nomi_shotgun
	name = "\improper Nomi Burst Blaster"
	desc = "A drum-fed Donk(tm) blaster that fires darts."
	icon = 'modular_doppler/its_donk_or_dont/icons/shotgun_48.dmi'
	icon_state = "nomi"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "nomi"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "nomi"
	SET_BASE_PIXEL(-8, 0)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c12nomi
	load_sound = 'modular_doppler/its_donk_or_dont/sound/nomi/nomi_magin.ogg'
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/nomi/nomi_rack.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	can_suppress = FALSE
	burst_size = 2
	fire_delay = 0.5 SECONDS
	projectile_damage_multiplier = 1.5

/obj/item/gun/ballistic/automatic/nomi_shotgun/add_bayonet_point()
	return

/obj/item/gun/ballistic/automatic/nomi_shotgun/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/nomi_shotgun/starts_empty
	spawnwithmagazine = FALSE
