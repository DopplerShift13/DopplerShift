/datum/wargame_weapon/missile/cruise
	weapon_name = "Cruise Missile"
	attack_roll = "1d20+4"
	damage_roll_bonus = 0
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_missile"
	action_point_cost = 1
	maximum_ammo = 6
	missile_type = /obj/structure/wargame_hologram/controllable/cruise_missile

/datum/wargame_weapon/missile/cruise/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/missile_launch.ogg', 50, TRUE)

/datum/wargame_weapon/missile/cruise/weapon_description()
	return "A long range cruise missile for engaging large targets. Becomes a controllable ship if the target is beyond short range. \
		Max target range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/missile/cruise/firing_voiceline()
	var/static/list/lines = list(
		"Drive signature? Ask them to hold this cruise missile for us.",
		"Drive cone locked, cruise missile away.",
		"Lock confirmed, launching cruise missile.",
	)
	return pick(lines)

/datum/wargame_weapon/ramming/cruise
	weapon_name = "Cruise Missile Impact"
	attack_roll = "1d20+4"
	damage_roll_bonus = 0
	evadable = TRUE
	small_ship_disadvantage = TRUE
	action_point_cost = 1

/datum/wargame_weapon/ramming/cruise/weapon_description()
	return "Guide the cruise missile into a target. This is a one way trip. \
		Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/missile/swarm
	weapon_name = "Swarm Missiles"
	attack_roll = "5d4+2"
	damage_roll_bonus = -2
	evadable = FALSE
	radial_icon_state = "weapon_missile_small"
	action_point_cost = 1
	maximum_ammo = 12
	missile_type = /obj/structure/wargame_hologram/controllable/swarm_missile

/datum/wargame_weapon/missile/swarm/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/swarm_launch.ogg', 75, TRUE)

/datum/wargame_weapon/missile/swarm/weapon_description()
	return "A swarm of small missiles for intercepting other missiles or strike craft. Becomes a controllable ship if the target is beyond short range. \
		Max target range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/missile/swarm/firing_voiceline()
	var/static/list/lines = list(
		"Get some swarmers on that track!",
		"Try doding the third, fourth, and fifth ones this time!",
		"Solid track, swarmers out",
	)
	return pick(lines)

/datum/wargame_weapon/ramming/swarm
	weapon_name = "Swarm Missiles Impact"
	attack_roll = "5d4+2"
	damage_roll_bonus = -2
	evadable = FALSE
	action_point_cost = 1

/datum/wargame_weapon/ramming/swarm/weapon_description()
	return "Guide the swarm missiles into a target. This is a one way trip. \
		Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/missile/torpedo
	weapon_name = "Torpedo"
	attack_roll = "2d20+4"
	damage_roll_bonus = 0
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_torpedo"
	action_point_cost = 1
	maximum_ammo = 4
	missile_type = /obj/structure/wargame_hologram/controllable/torpedo

/datum/wargame_weapon/missile/torpedo/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/missile_launch.ogg', 50, TRUE)

/datum/wargame_weapon/missile/torpedo/weapon_description()
	return "A beefy torpedo for cracking large ships in two. Becomes a controllable ship if the target is beyond short range. \
		Max target range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/missile/torpedo/firing_voiceline()
	var/static/list/lines = list(
		"The guns ain't enough. I want that track gone.",
		"Torpedo away, stand by for fireworks.",
		"Good track confirmed, torpedo dispensed.",
	)
	return pick(lines)

/datum/wargame_weapon/ramming/torpedo
	weapon_name = "Torpedo Impact"
	attack_roll = "2d20+4"
	damage_roll_bonus = 0
	evadable = TRUE
	small_ship_disadvantage = TRUE
	action_point_cost = 1

/datum/wargame_weapon/ramming/torpedo/weapon_description()
	return "Guide the torpedo into a target. This is a one way trip. \
		Max range of [attack_range] tiles. [action_point_cost] AP to fire."
