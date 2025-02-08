/obj/item/gun/ballistic/revolver/sol
	name = "\improper Eland Revolving Blaster"
	desc = "A small Donk(tm) blaster that can hold 7 darts in a compact shape."
	icon = 'modular_doppler/its_donk_or_dont/icons/pistol_32.dmi'
	icon_state = "eland"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c35sol
	suppressor_x_offset = -1
	w_class = WEIGHT_CLASS_SMALL
	can_suppress = TRUE
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_lightgun.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'

/obj/item/gun/ballistic/revolver/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)
