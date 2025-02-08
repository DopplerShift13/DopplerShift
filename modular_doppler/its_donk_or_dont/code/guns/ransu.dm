// Variant of the suppressed rifle with a scope and perfect accuracy, also no automatic

/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman
	name = "\improper Ransu Sneak Super Blaster"
	desc = "A special Donk(tm) blaster specially designed to launch Donk(tm) darts quietely and as hard as possible."
	icon_state = "ransu"
	worn_icon_state = "ransu"
	inhand_icon_state = "ransu"
	spawn_magazine_type = /obj/item/ammo_box/magazine/c8marsian
	accepted_magazine_type = /obj/item/ammo_box/magazine/c8marsian
	load_sound = 'modular_doppler/its_donk_or_dont/sound/yari/yari_magin.wav'
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/ransu/ransu_rack.wav'
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	special_mags = FALSE
	can_suppress = TRUE
	can_unsuppress = FALSE
	fire_delay = 1.5 SECONDS
	spread = 0
	projectile_damage_multiplier = 1.5

/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman/add_bayonet_point()
	return

/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman/give_autofire()
	return

/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman/starts_empty
	spawnwithmagazine = FALSE
