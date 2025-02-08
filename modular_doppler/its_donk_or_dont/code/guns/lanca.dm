/obj/item/gun/ballistic/automatic/lanca
	name = "\improper Lanca Blaster"
	desc = "A long barreled bullpup Donk(tm) blaster meant for long range Donk(tm)ing."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_48.dmi'
	icon_state = "lanca"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "lanca"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "lanca"
	SET_BASE_PIXEL(-8, 0)
	special_mags = FALSE
	bolt_type = BOLT_TYPE_STANDARD
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	can_suppress = TRUE
	suppressor_x_offset = 0
	suppressor_y_offset = 0
	burst_size = 1
	fire_delay = 1.2 SECONDS
	actions_types = list()
	spread = 2.5
	projectile_wound_bonus = -20
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	projectile_damage_multiplier = 1.25
	gun_flags = NOT_A_REAL_GUN
	clumsy_check = FALSE

/obj/item/gun/ballistic/automatic/lanca/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/gun/ballistic/automatic/lanca/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/lanca/no_mag
	spawnwithmagazine = FALSE
