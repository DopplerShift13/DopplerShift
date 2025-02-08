/obj/item/gun/ballistic/automatic/pistol/trappiste
	name = "\improper Skild Heavy Blaster"
	desc = "A Donk(tm) blaster made to launch Donk(tm) darts extra hard."
	icon = 'modular_doppler/its_donk_or_dont/icons/pistol_32.dmi'
	icon_state = "skild"
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	suppressor_x_offset = 8
	suppressor_y_offset = 0
	fire_delay = 1 SECONDS
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	projectile_damage_multiplier =  1.25

/obj/item/gun/ballistic/automatic/pistol/trappiste/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/pistol/trappiste/no_mag
	spawnwithmagazine = FALSE
