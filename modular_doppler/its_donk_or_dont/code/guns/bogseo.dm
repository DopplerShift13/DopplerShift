/obj/item/gun/ballistic/automatic/xhihao_smg
	name = "\improper Bogseo Rapid Blaster"
	desc = "A compact Donk(tm) blaster with high firing rate and equally high inaccuracy."
	icon = 'modular_doppler/its_donk_or_dont/icons/smg_32.dmi'
	icon_state = "bogseo"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "bogseo"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "bogseo"
	special_mags = FALSE
	bolt_type = BOLT_TYPE_STANDARD
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	can_suppress = TRUE
	suppressor_x_offset = 9
	burst_size = 1
	fire_delay = 0.15 SECONDS
	actions_types = list()
	projectile_wound_bonus = -20
	spread = 12.5
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	gun_flags = NOT_A_REAL_GUN
	clumsy_check = FALSE

/obj/item/gun/ballistic/automatic/xhihao_smg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/xhihao_smg/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/xhihao_smg/no_mag
	spawnwithmagazine = FALSE
