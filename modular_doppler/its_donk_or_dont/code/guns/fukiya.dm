/obj/item/gun/ballistic/marsian_super_rifle
	name = "\improper Fukiya Double-Barrel Super Blaster"
	desc = "A double-barrel over-under Donk(tm) blaster."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_48.dmi'
	icon_state = "fukiya"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "fukiya"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "fukiya"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	load_sound = 'modular_doppler/its_donk_or_dont/sound/ramu/ramu_load.wav'
	can_suppress = FALSE
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 15
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/c8marsian
	can_be_sawn_off = FALSE
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	can_be_sawn_off = FALSE
	internal_magazine = TRUE
	casing_ejector = FALSE
	cartridge_wording = "shell"
	tac_reloads = FALSE
	weapon_weight = WEAPON_HEAVY
	projectile_damage_multiplier = 2
	projectile_speed_multiplier = 2

/obj/item/gun/ballistic/marsian_super_rifle/add_bayonet_point()
	return

/obj/item/gun/ballistic/marsian_super_rifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/marsian_super_rifle/starts_empty
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/c8marsian/starts_empty
