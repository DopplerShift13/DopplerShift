//pka alts, ported from bubberstation. includes some lore rewrites in the desc and a couple of balance changes (only 10 damage on the pistol?!)
//the shockwave is inaccessible because it seems incredibly unfun unless you load it up with a very specific modset, and also very unfun to play vs

//Proto-Kinetic Accelerators
/obj/item/gun/energy/recharge/kinetic_accelerator/railgun
	name = "proto-kinetic railgun"
	desc = "An earlier, nonmodular design of the proto-kinetic accelerator that lacks an internal buffer. Modern mining accelerators feature a trifunctional self-pacer; it relieves stress on \
	the frame, preserves the internal recharging battery, and allows for greater ore throughput. The PKA-A1 lacks this- it instead dumps all of its energy into a single shot. Violently. \
	It's considered nearly useless for mining or colony-work due to its lengthy recharge. Not a rarity in Crusoe's, but uncommon."
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticrailgun"
	base_icon_state = "kineticrailgun"
	inhand_icon_state = "kineticgun"
	w_class = WEIGHT_CLASS_HUGE
	pin = /obj/item/firing_pin/explorer/mining
	recharge_time = 3 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/railgun)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	weapon_weight = WEAPON_HEAVY
	max_mod_capacity = 15 // A crumb of mod capacity as a treat
	recoil = 3 //railgun go brrrrr
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/recharge/kinetic_accelerator/repeater
	name = "proto-kinetic repeater"
	desc = "The next generation of proto-kinetic acceleration tools, the PKA-D1 features a tightly tuned self-pacer- along with a dual-run capacitor- that allows for extreme \
	throughput in tight bursts. The capacitor creates an internal buffer of three shots, and the self-pacer means recharge is never too far away. Rare on Crusoe's, due to the model \
	entering production a bit less than two years ago. The only downsides are a slightly weaker blast, and a slightly smaller shroud making for a tighter modspace."
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticrepeater"
	base_icon_state = "kineticrepeater"
	inhand_icon_state = "kineticgun"
	recharge_time = 2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/repeater)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	weapon_weight = WEAPON_LIGHT
	max_mod_capacity = 75

/obj/item/gun/energy/recharge/kinetic_accelerator/shotgun
	name = "proto-kinetic shotgun"
	desc = "The PKA-C2 is a modification of the base proto-kinetic accelerator that splits its payload into three seperate shots. Typically used by colonists for its effective site preparation, \
	and decent ore-throughput. It is the workhorse of any excavations where resonators can't be used. High spread, slower recharge, and per-blast lower power means users have to get closer for effective \
	use on fauna, but that won't be a problem for you, right?"
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticshotgun"
	base_icon_state = "kineticshotgun"
	inhand_icon_state = "kineticgun"
	recharge_time = 2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/shotgun)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	weapon_weight = WEAPON_HEAVY
	max_mod_capacity = 60

/obj/item/gun/energy/recharge/kinetic_accelerator/glock
	name = "proto-kinetic pistol"
	desc = "Intended for smaller-sized sophonts and situations that require a more portable solution, the PKA-C1 is a pistol-sized proto-kinetic accelerator. \
	It features a light trigger pull, quicker-filling buffer, and extremely modular frame. \
	The smaller capacitor-size means that individual blasts are far weaker, and have a shorter range before dispersion. The additional mod-space might just make up for it, though..."
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticpistol"
	base_icon_state = "kineticpistol"
	inhand_icon_state = "kineticgun"
	recharge_time = 2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/glock)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	weapon_weight = WEAPON_LIGHT
	max_mod_capacity = 200

/obj/item/gun/energy/recharge/kinetic_accelerator/shockwave //unobtainable for gameplay concern reasons, mainly pvp. without all the modules it seems awful, with all the modules it seems like a baaddd idea
	name = "proto-kinetic shockwave"
	desc = "A failed iteration upon the original proto-kinetic accelerator, the PKA-A1B was the Company's attempt at making a four-in-one tool. Excavation, site preparation, mining,\
	and fauna-deterrence; it could do it all! The deep-spacer's Old Reliable! However, after multiple cave-ins, reliability failures, and a lawsuit that led to a recall, it was shelved. \
	It did, at least, lead to the standardized proto-kinetic accelerator that is common among sophonts nowadays."
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticshockwave"
	base_icon_state = "kineticshockwave"
	inhand_icon_state = "kineticgun"
	recharge_time = 2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/shockwave)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	weapon_weight = WEAPON_LIGHT
	max_mod_capacity = 75

/obj/item/gun/energy/recharge/kinetic_accelerator/shockwave/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	target = get_edge_target_turf(user, user.dir)
	return ..()

/obj/item/gun/energy/recharge/kinetic_accelerator/m79
	name = "proto-kinetic grenade launcher"
	desc = "A marketing gimmick. The PKA-BOOMYSHOOTYEXPLODEY was designed by an online vote. Over the course of two months, voters from around the Orion Spur voted on \
	the design of the weapon, its ammunition, its ergonomics, and- most notably- its name. The PKA-BOOMYSHOOTYEXPLODEY features a fifty-times magnification holographic sight, \
	fifty-gram hairpin trigger, self-heating stock, and a wi-fi extender. Optional finishes include a camo pattern outside of the visible spectrum of ninety-eight percent of all sophonts."
	icon = 'modular_doppler/mining/equipment/guns.dmi'
	icon_state = "kineticglauncher"
	base_icon_state = "kineticglauncher"
	inhand_icon_state = "kineticgun"
	pin = /obj/item/firing_pin/explorer/mining
	recharge_time = 2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/m79)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	max_mod_capacity = 0

/obj/item/gun/energy/recharge/kinetic_accelerator/m79/add_bayonet_point()
	return

//Accelerator Casing
//Fixed maths to use new standards
/obj/item/ammo_casing/energy/kinetic/railgun
	projectile_type = /obj/projectile/kinetic/railgun
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	fire_sound = 'sound/items/weapons/beam_sniper.ogg'

/obj/item/ammo_casing/energy/kinetic/repeater
	projectile_type = /obj/projectile/kinetic/repeater
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.15) //about three shots
	fire_sound = 'sound/items/weapons/kinetic_accel.ogg'

/obj/item/ammo_casing/energy/kinetic/shotgun
	projectile_type = /obj/projectile/kinetic/shotgun
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	pellets = 3
	variance = 50
	fire_sound = 'sound/items/weapons/kinetic_accel.ogg'

/obj/item/ammo_casing/energy/kinetic/glock
	projectile_type = /obj/projectile/kinetic/glock
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	fire_sound = 'sound/items/weapons/kinetic_accel.ogg'

/obj/item/ammo_casing/energy/kinetic/shockwave
	projectile_type = /obj/projectile/kinetic/shockwave
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	pellets = 8
	variance = 360
	fire_sound = 'sound/items/weapons/gun/general/cannon.ogg'

/obj/item/ammo_casing/energy/kinetic/m79
	projectile_type = /obj/projectile/bullet/mining_bomb //uses the mining bomb projectile from the mining modsuit
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	fire_sound = 'sound/items/weapons/gun/general/grenade_launch.ogg'

//Accelerator Projectiles
/obj/projectile/kinetic/railgun
	name = "hyper kinetic force"
	icon_state = null
	damage = 100 // Slightly less than a crusher marked hit (110 methinks), but ranged and really fast moving, big movement slowdown and bulky.
	damage_type = BRUTE
	armor_flag = BOMB
	range = 6
	pressure_decrease = 0.10 //Pressured enviorments are a no go for the railgun
	speed = 10 //NYOOM
	projectile_piercing = PASSMOB

/obj/projectile/kinetic/repeater
	name = "rapid kinetic force"
	icon_state = null
	damage = 20 // Half damage, burst fire and a bit more range.
	damage_type = BRUTE
	armor_flag = BOMB
	range = 4
	log_override = TRUE

/obj/projectile/kinetic/shotgun
	name = "split kinetic force"
	icon_state = null
	damage = 20 // 3 projectiles, 60 base damage. Theoretically more if all shots hit.
	damage_type = BRUTE
	armor_flag = BOMB
	range = 3
	log_override = TRUE

/obj/item/borg/upgrade/modkit/indoors/modify_projectile(obj/projectile/kinetic/shotgun/K)
	..()
	K.pressure_decrease = min(K.pressure_decrease, 0.5)

/obj/projectile/kinetic/glock
	name = "light kinetic force"
	icon_state = null
	damage = 12 // Low dmg, high modularity. Raised by 2 compared to port, it was lowkey extremely bad
	damage_type = BRUTE
	armor_flag = BOMB
	range = 3
	log_override = TRUE

/obj/projectile/kinetic/shockwave
	name = "concussive kinetic force"
	icon_state = null
	damage = 40 // 8 projectiles in a 360 around you. Good for CC and rock clearing.
	damage_type = BRUTE
	armor_flag = BOMB
	range = 1
	log_override = TRUE




// ORDER DATUMS

/datum/orderable_item/accelerator/gun/repeater
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/repeater
	cost_per_order = 1250

/datum/orderable_item/accelerator/gun/shotgun
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/shotgun
	cost_per_order = 1250

// idk what to do with the shockwave, it seems genuinely unfun to play vs, commented out for now i guess unless inspiration his me. feel cute will probably get rid of before merge
/* /datum/orderable_item/accelerator/gun/shockwave
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/shockwave
	cost_per_order = 29999 */

/datum/orderable_item/accelerator/gun/glock
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/glock
	cost_per_order = 1250

/datum/orderable_item/accelerator/gun/railgun
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/railgun
	cost_per_order = 1250

/datum/orderable_item/accelerator/gun/m79
	purchase_path = /obj/item/gun/energy/recharge/kinetic_accelerator/m79
	cost_per_order = 1250

