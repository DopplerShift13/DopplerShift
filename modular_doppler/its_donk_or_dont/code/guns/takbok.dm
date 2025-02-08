/obj/item/gun/ballistic/revolver/takbok
	name = "\improper Takbok Revolving Heavy Blaster"
	desc = "A revolving Donk(tm) blaster made to launch Donk(tm) darts extra hard."
	icon = 'modular_doppler/its_donk_or_dont/icons/pistol_32.dmi'
	icon_state = "takbok"
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c585trappiste
	suppressor_x_offset = 4
	can_suppress = TRUE
	fire_delay = 1 SECONDS
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	projectile_damage_multiplier = 1.25
	gun_flags = NOT_A_REAL_GUN
	clumsy_check = FALSE

/obj/item/gun/ballistic/revolver/takbok/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)
