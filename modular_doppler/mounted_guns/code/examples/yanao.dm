// Tripod machine gun
/obj/item/gun/ballistic/automatic/yanao_tripod
	name = "tripod Yanao-I6 chaingun"
	desc = "Locally produced within Cruesoe's Rest and proudly so from a factory on New Gibraltar, the Yanao is a hefty open bolt chaingun \
		that fires from a continuous belt of .34 NB. The kickback caused by such a round, combined with the high fire rate, \
		make mounting the gun on its tripod a necessity before firing."
	icon = 'modular_doppler/mounted_guns/icons/examples/gun_x48.dmi'
	icon_state = "yanao"
	lefthand_file = 'modular_doppler/mounted_guns/icons/examples/inhands_left.dmi'
	righthand_file = 'modular_doppler/mounted_guns/icons/examples/inhands_right.dmi'
	inhand_icon_state = "yanao"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/modular_weapons/sounds/crash.wav'
	rack_sound = 'sound/items/weapons/gun/l6/l6_rack.ogg'
	load_sound = 'sound/items/weapons/gun/l6/l6_door.ogg'
	load_empty_sound = 'sound/items/weapons/gun/l6/l6_door.ogg'
	special_mags = FALSE
	mag_display_ammo = TRUE
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	w_class = WEIGHT_CLASS_HUGE
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
	AddComponent(/datum/component/deployable_turret, 3 SECONDS, /obj/vehicle/ridden/mounted_turret, 'sound/items/tools/ratchet.ogg', 'modular_doppler/mounted_guns/icons/examples/turrets.dmi')

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
	icon = 'modular_doppler/mounted_guns/icons/examples/turrets.dmi'
	icon_state = "yanao"
	mapload_gun = /obj/item/gun/ballistic/automatic/yanao_tripod

/obj/item/ammo_box/magazine/yanao
	name = "\improper yanao belt box (.34)"
	desc = "A large belt box for the yanao machine gun, holds 50 rounds of .34 NB."
	icon = 'modular_doppler/mounted_guns/icons/examples/objects.dmi'
	icon_state = "yanao_box"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c34nb
	caliber = CALIBER_34NB
	max_ammo = 50
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/yanao/spawns_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/yanao/kill_everyone
	name = "\improper yanao belt box (.34 Special)"
	ammo_type = /obj/item/ammo_casing/c34nb/special
