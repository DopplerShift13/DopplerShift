/obj/item/gun/ballistic/revolver/shotgun_revolver
	name = "\improper Bóbr Revolving Blaster"
	desc = "A small revolver style Donk(tm) blaster that can fit four darts in it."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	recoil = SAWN_OFF_RECOIL
	weapon_weight = WEAPON_MEDIUM
	icon = 'modular_doppler/its_donk_or_dont/icons/pistol_32.dmi'
	icon_state = "bobr"
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	spread = SAWN_OFF_ACC_PENALTY
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/revolver/shotgun_revolver/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)
