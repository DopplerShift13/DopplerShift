// Pistol but its evil and uses miecz magazines

/obj/item/gun/ballistic/automatic/pistol/weevil
	name = "\improper Zomushi Blaster"
	desc = "A stealthy looking Donk(tm) blaster."
	icon = 'modular_doppler/its_donk_or_dont/icons/pistol_32.dmi'
	icon_state = "zomushi"
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/zomushi/zomushi_rack.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	suppressor_x_offset = 7
	suppressor_y_offset = 0
	fire_delay = 0.25 SECONDS

/obj/item/gun/ballistic/automatic/pistol/weevil/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/pistol/weevil/starts_empty
	spawnwithmagazine = FALSE
