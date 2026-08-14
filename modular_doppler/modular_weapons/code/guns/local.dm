// Tripod machine gun
/obj/item/gun/ballistic/automatic/yanao_tripod
	name = "tripod Yanao-I6 machine gun"
	desc = "Locally produced within Cruesoe's Rest and proudly so from a factory on New Gibraltar, the Yanao is a hefty open bolt machine gun \
		that fires from a continuous belt of .34 NB. The kickback caused by such a round, combined with the high fire rate, \
		make mounting the gun on its tripod a necessity before firing."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "yanao"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "yanao"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/modular_weapons/sounds/crash.wav'
	rack_sound = 'sound/items/weapons/gun/l6/l6_rack.ogg'
	load_sound = 'sound/items/weapons/gun/l6/l6_door.ogg'
	load_empty_sound = 'sound/items/weapons/gun/l6/l6_door.ogg'
	special_mags = FALSE
	mag_display_ammo = TRUE
	bolt_type = BOLT_TYPE_OPEN
	w_class = WEIGHT_CLASS_HUGE // No storing this anywhere
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/yanao
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.125 SECONDS
	actions_types = list()
	spread = 5
	recoil = 0.1
	projectile_speed_multiplier = 1.5
	projectile_damage_multiplier = 0.75
	pin = /obj/item/firing_pin/mounted
	tac_reloads = FALSE
	ejection_angle_offset = 90

/obj/item/gun/ballistic/automatic/yanao_tripod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)
	AddComponent(/datum/component/scope, range_modifier = 1.5)
	AddComponent(/datum/component/deployable_turret, 3 SECONDS, /obj/vehicle/ridden/mounted_turret, 'sound/items/tools/ratchet.ogg', 'modular_doppler/modular_weapons/icons/obj/mounted.dmi')

/obj/item/gun/ballistic/automatic/yanao_tripod/attack_hand(mob/user, list/modifiers)
	var/user_interactable = user.is_holding(src) || istype(loc, /obj/vehicle/ridden/mounted_turret)
	if(!internal_magazine && user_interactable && magazine)
		eject_magazine(user)
		return
	return ..()

/obj/item/gun/ballistic/automatic/yanao_tripod/spawns_empty
	spawnwithmagazine = FALSE

/obj/vehicle/ridden/mounted_turret/yanao_mapping
	name = "tripod yanao but only for mappers"
	desc = "DO NOT PUT ME IN A DEPLOYABLE TURRET COMPONENT YOU WILL SUMMON A GHOST, AND DIE."
	icon = 'modular_doppler/modular_weapons/icons/obj/mounted.dmi'
	icon_state = "yanao"
	mapload_gun = /obj/item/gun/ballistic/automatic/yanao_tripod

// Cheap carbine
/obj/item/gun/ballistic/automatic/sabine_carbine
	name = "\improper NW-Sabine Carabina"
	desc = "Locally produced within Crusoe's Rest and proudly so from a factory on New Gibraltar, the Sabine is a cheaply made \
		and cheap to operate carbine shooting .34 NB like its closest cousing the Marcielle. Unlike the Marcielle, however, the \
		carabina lacks the barrel length and chamber sealing required to make full use of the .34 cartridge's design."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "sabine"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "sabine"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "sabine"
	SET_BASE_PIXEL(-8, 0)
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/sabine
	fire_sound = 'modular_doppler/modular_weapons/sounds/seiba.wav'
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.35 SECONDS
	projectile_damage_multiplier = 0.8
	actions_types = list()
	spread = 7
	recoil = 0.4

/obj/item/gun/ballistic/automatic/sabine_carbine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 4, offset_y = 0, bayonet_overlay = "bayonet_thin", bayonet_overlay_icon = "modular_doppler/modular_weapons/icons/obj/guns48x.dmi")
