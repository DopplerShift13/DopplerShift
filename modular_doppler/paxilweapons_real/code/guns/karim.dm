// Karim Electrics pulse rifle, YIPPIE ALIENS YIPPIE!!

/obj/item/gun/ballistic/automatic/karim
	name = "\improper Karim Pulse Rifle"
	desc = "A compact rifle with high magazine capacity and fire-rate. A novel design that replaces many common firearm \
		components with electrified alternatives, allowing a much smaller size for the firepower it provides. \
		This gives the weapon it's distinctive firing sound."
	icon = 'modular_doppler/paxilweapons_real/icons/rifle_32.dmi'
	icon_state = "karim"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "karim"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
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
	recoil = 0.25
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
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
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/karim/fire_sounds()
	var/picked_fire_sound = pick(firing_sound_list)
	playsound(src, picked_fire_sound, fire_sound_volume, vary_fire_sound)

/obj/item/gun/ballistic/automatic/karim/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/karim/examine_more(mob/user)
	. = ..()
	. += "The Miecz is one of the newest weapons to come out of CIN member state hands and \
		into the wild, typically the frontier. It was built alongside the round it fires, the \
		.27-54 Cesarzawa pistol round. Based on the proven Lanca design, it seeks to bring that \
		same reliable weapon design into the factor of a submachinegun. While it is significantly \
		larger than many comparable weapons in SolFed use, it more than makes up for it with ease \
		of control and significant firerate."
	return .

/obj/item/gun/ballistic/automatic/karim/no_mag
	spawnwithmagazine = FALSE
