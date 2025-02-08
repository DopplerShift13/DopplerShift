// Karim Electrics pulse rifle, YIPPIE ALIENS YIPPIE!!

/obj/item/gun/ballistic/automatic/karim
	name = "\improper Karim Pulse Blaster"
	desc = "A special Donk(tm) that uses advanced feeding technology to fire darts at rates no other blaster could hope for."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_32.dmi'
	icon_state = "karim"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "karim"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "karim"
	special_mags = FALSE
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/karim
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.15 SECONDS
	actions_types = list()
	spread = 5
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_mediumgun.wav'
	/// List of the possible firing sounds
	var/list/firing_sound_list = list(
		'sound/items/weapons/gun/smartgun/smartgun_shoot_1.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_2.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_3.ogg',
	)

/obj/item/gun/ballistic/automatic/karim/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/karim/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/karim/fire_sounds()
	var/picked_fire_sound = pick(firing_sound_list)
	playsound(src, picked_fire_sound, fire_sound_volume, vary_fire_sound)

/obj/item/gun/ballistic/automatic/karim/no_mag
	spawnwithmagazine = FALSE
