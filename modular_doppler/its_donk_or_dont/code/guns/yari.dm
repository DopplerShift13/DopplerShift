/obj/item/gun/ballistic/automatic/suppressed_rifle
	name = "\improper Yari Quiet Blaster"
	desc = "A special Donk(tm) blaster made to fire as quietely as possible."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_48.dmi'
	icon_state = "yari"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "yari"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "yari"
	SET_BASE_PIXEL(-8, 0)
	special_mags = TRUE
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle
	spawn_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle/standard
	load_sound = 'modular_doppler/its_donk_or_dont/sound/yari/yari_magin.wav'
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/yari/yari_rack.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	can_suppress = TRUE
	can_unsuppress = FALSE
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	burst_size = 1
	fire_delay = 0.3 SECONDS
	actions_types = list()
	spread = 7.5
	projectile_damage_multiplier = 1.25

/obj/item/gun/ballistic/automatic/suppressed_rifle/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/new_suppressor = new(src)
	install_suppressor(new_suppressor)
	give_autofire()

/obj/item/gun/ballistic/automatic/suppressed_rifle/add_bayonet_point()
	return

/// Separate proc for handling auto fire just because one of these subtypes isn't otomatica
/obj/item/gun/ballistic/automatic/suppressed_rifle/proc/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/suppressed_rifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/suppressed_rifle/starts_empty
	spawnwithmagazine = FALSE
