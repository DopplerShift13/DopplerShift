// Karim Electrics pulse rifle, YIPPIE ALIENS YIPPIE!!

/obj/item/gun/ballistic/automatic/karim
	name = "\improper Karim Pulse Rifle"
	desc = "A compact rifle with high magazine capacity and fire-rate. A novel design that replaces many common firearm \
		components with electrified alternatives, allowing a much smaller size for the firepower it provides. \
		This gives the weapon its distinctive firing sound."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "karim"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "karim"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "karim"
	special_mags = FALSE
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/karim
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.165 SECONDS
	actions_types = list()
	spread = 5
	recoil = 0.1
	pin = /obj/item/firing_pin/explorer/mining
	/// Unloaded .980 underbarrel grenade launcher fired by right clicking
	var/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/underbarrel = /obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/tydhouer/safer
	/// List of the possible firing sounds
	var/list/firing_sound_list = list(
		'sound/items/weapons/gun/smartgun/smartgun_shoot_1.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_2.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_3.ogg',
	)

/obj/item/gun/ballistic/automatic/karim/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)
	underbarrel = new()

/obj/item/gun/ballistic/automatic/karim/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/karim/fire_sounds()
	var/picked_fire_sound = pick(firing_sound_list)
	playsound(src, picked_fire_sound, fire_sound_volume, vary_fire_sound)

/obj/item/gun/ballistic/automatic/karim/emag_act(mob/user, obj/item/card/emag/emag_card)
	pin.emag_act(user, emag_card) // So emagging the gun emags the pin
	return ..()

/obj/item/gun/ballistic/automatic/karim/try_fire_gun(atom/target, mob/living/user, params)
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		return underbarrel.try_fire_gun(target, user, params)
	return ..()

/obj/item/gun/ballistic/automatic/karim/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool))
		if(istype(tool, underbarrel.magazine.ammo_type))
			underbarrel.item_interaction(user, tool, modifiers)
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/gun/ballistic/automatic/karim/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/karim/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/karim/unrestricted/no_mag
	spawnwithmagazine = FALSE

/obj/item/storage/toolbox/guncase/modular/pulse_rifle
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/karim/no_mag
	extra_to_spawn = /obj/item/ammo_box/magazine/karim

/datum/orderable_item/accelerator/pulse_rifle
	purchase_path = /obj/item/gun/ballistic/automatic/karim/no_mag
	cost_per_order = 750

/datum/orderable_item/accelerator/pulse_ammo
	purchase_path = /obj/item/ammo_box/magazine/karim
	cost_per_order = 25

/datum/orderable_item/accelerator/pulse_ammo_minebot
	purchase_path = /obj/item/ammo_box/magazine/karim/minebot
	cost_per_order = 40

// Larp variants of the pulse rifle for the Void Corps; including a longer cool version and a machinegun version

/obj/item/gun/ballistic/automatic/karim/voidcorps
	name = "\improper Karim/EVC Pulse Rifle"
	desc = "A compact rifle with high magazine capacity and fire-rate. A novel design that replaces many common firearm \
		components with electrified alternatives, allowing a much smaller size for the firepower it provides. \
		This specific variant is purpose-built for extra-vehicular combat, with a heavier barrel and upgraded receiver."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "karim_evc"
	worn_icon_state = "karim_evc"
	inhand_icon_state = "karim_evc"
	SET_BASE_PIXEL(-2, 0)
	spawn_magazine_type = /obj/item/ammo_box/magazine/karim/tcc
	pin = /obj/item/firing_pin/implant/mindshield
	/// Evil ass loaded grenade launcher variant
	underbarrel = /obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/tydhouer

/obj/item/gun/ballistic/automatic/karim/voidcorps/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/l6_saw/minhir
	name = "\improper Minhir Heavy Pulse Rifle"
	desc = "A compact machinegun with a staggeringly massive ammunition capacity and a blisteringly high rate of fire \
		designed to capitalize on the efficiency of an electronic firing action. Though weighty, it remains surprisingly \
		compact and easy to carry in comparison to more antiquated squad automatic weapons."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "minhir"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "minhir"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "minhir"
	SET_BASE_PIXEL(-2, 0)
	fire_delay = 0.165 SECONDS
	rof = 0.016 SECONDS /// translates to ~600 rounds per minute, or an entire box emptied in 30 seconds
	/// We have to define all of the normal pulse rifle characteristics because this is an L6 subtype for the sake of the cool feed tray thingy
	spread = 5
	recoil = 0.1
	mag_display = FALSE
	mag_display_ammo = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/karim/minhir
	pin = /obj/item/firing_pin/implant/mindshield
	var/list/firing_sound_list = list(
		'sound/items/weapons/gun/smartgun/smartgun_shoot_1.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_2.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_3.ogg',
	)

/obj/item/gun/ballistic/automatic/l6_saw/minhir/fire_sounds()
	var/picked_fire_sound = pick(firing_sound_list)
	playsound(src, picked_fire_sound, fire_sound_volume, vary_fire_sound)

// overrides base L6 SAW inhand icon behavior
/obj/item/gun/ballistic/automatic/l6_saw/minhir/update_icon_state()
	. = ..()
	inhand_icon_state = "minhir"

/obj/item/gun/ballistic/automatic/l6_saw/minhir/update_overlays()
	. = ..()
	. += "minhir_door_[cover_open ? "open" : "closed"]"

/obj/item/gun/ballistic/automatic/l6_saw/minhir/unrestricted
	pin = /obj/item/firing_pin

/obj/item/firing_pin/explorer/mining
	name = "mining firing pin"
	desc = "A firing pin required by PCAT regulation for powerful explorer's weapons, to prevent their easy use shipboard."
	fail_message = "locked!"
	pin_removable = FALSE

/obj/item/firing_pin/explorer/mining/pin_auth(mob/living/user)
	if(obj_flags & EMAGGED)
		return TRUE
	var/turf/station_check = get_turf(user)
	if(!station_check || is_station_level(station_check.z))
		return FALSE
	return TRUE

/obj/item/gun/ballistic/automatic/karim/toy
	name = "\improper RealToy™ Karim Pulse Rifle"
	desc = "A compact rifle with high magazine capacity and fire-rate. At least, it's a toy that looks \
	an awful lot like one."
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/karim
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	item_flags = NONE
	casing_ejector = FALSE
	pin = /obj/item/firing_pin
	fire_sound = 'sound/items/syringeproj.ogg'
	recoil = 0

/obj/item/ammo_box/magazine/toy/karim
	name = "\improper RealToy™ Karim magazine"
	desc = "A standard size magazine for RealToy™ Karim pulse rifle toys, holds fifty rounds."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "karim_mag"
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM
	max_ammo = 50
