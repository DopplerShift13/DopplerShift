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
	playsound(firer, 'modular_doppler/wargaming/sound/missile_launch.ogg', 30, TRUE)

/datum/wargame_weapon/missile/cruise/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s missile tubes pop open and dispense a large missile that quickly turns and burns towards [target]!"), \
		blind_message = span_warning("[firer]'s missile tubes pop open and dispense a large missile that quickly turns and burns towards [target]!"))

/datum/wargame_weapon/missile/cruise/weapon_description()
	. = ..()
	return . + "A long range cruise missile for engaging large targets. Becomes a controllable ship if the target is beyond short range."

/datum/wargame_weapon/missile/cruise/firing_voiceline(datum/wargame_unit_stats/stats)
	var/list/lines = list(
		"Drive signature? We'll have a cruise missile right up for them [stats.commander].",
		"Drive cone locked, cruise missile away [stats.commander].",
		"Lock confirmed, launching cruise missile [stats.commander].",
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
	. = ..()
	return . + "Guide the cruise missile into a target. This is a one way trip."

/datum/wargame_weapon/ramming/cruise/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] engages its terminal stage boosters as it dives toward [target] in a spiraling loop!"), \
		blind_message = span_warning("[firer] engages its terminal stage boosters as it dives toward [target] in a spiraling loop!"))

/datum/wargame_weapon/missile/swarm
	weapon_name = "Swarm Missiles"
	attack_roll = "5d4+2"
	damage_roll_bonus = -2
	evadable = FALSE
	radial_icon_state = "weapon_missile_small"
	action_point_cost = 1
	maximum_ammo = 6
	missile_type = /obj/structure/wargame_hologram/controllable/swarm_missile

/datum/wargame_weapon/missile/swarm/strike
	maximum_ammo = 2

/datum/wargame_weapon/missile/swarm/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/swarm_launch.ogg', 40, TRUE)

/datum/wargame_weapon/missile/swarm/weapon_description()
	. = ..()
	return . + "A swarm of small missiles for intercepting other missiles or strike craft. Becomes a controllable ship if the target is beyond short range."

/datum/wargame_weapon/missile/swarm/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] ejects a bouquet of micro-missiles with a puff of gas, which break off into a swarm towards [target]!"), \
		blind_message = span_warning("[firer] ejects a bouquet of micro-missiles with a puff of gas, which break off into a swarm towards [target]!"))

/datum/wargame_weapon/missile/swarm/firing_voiceline(datum/wargame_unit_stats/stats)
	var/list/lines = list(
		"Get some swarmers on that track!",
		"Try dodging the third, fourth, and fifth ones this time!",
		"Solid track, swarmers out [stats.commander].",
	)
	return pick(lines)

/datum/wargame_weapon/ramming/swarm
	weapon_name = "Swarm Missiles Impact"
	attack_roll = "5d4+2"
	damage_roll_bonus = -2
	evadable = FALSE
	action_point_cost = 1

/datum/wargame_weapon/ramming/swarm/weapon_description()
	. = ..()
	return . + "Guide the swarm missiles into a target. This is a one way trip."

/datum/wargame_weapon/ramming/swarm/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] swarm towards [target], burning in high-gee turns to evade defense!"), \
		blind_message = span_warning("[firer] swarm towards [target], burning in high-gee turns to evade defense!"))

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

/datum/wargame_weapon/missile/torpedo/small
	maximum_ammo = 2

/datum/wargame_weapon/missile/torpedo/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/missile_launch.ogg', 30, TRUE)

/datum/wargame_weapon/missile/torpedo/weapon_description()
	. = ..()
	return . + "A beefy torpedo for cracking large ships in two. Becomes a controllable ship if the target is beyond short range."

/datum/wargame_weapon/missile/torpedo/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] dispenses a large torpedo, which slowly spins up and gimbals toward [target]!"), \
		blind_message = span_warning("[firer] dispenses a large torpedo, which slowly spins up and gimbals toward [target]!"))

/datum/wargame_weapon/missile/torpedo/firing_voiceline(datum/wargame_unit_stats/stats)
	var/list/lines = list(
		"The guns ain't enough. I want that track gone.",
		"Torpedo away, stand by for fireworks [stats.commander].",
		"Good track confirmed, torpedo dispensed [stats.commander].",
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
	. = ..()
	return . + "Guide the torpedo into a target. This is a one way trip."

/datum/wargame_weapon/ramming/torpedo/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] ejects its cruise stage and ignites an oversized terminal booster, speeding towards [target]!"), \
		blind_message = span_warning("[firer] ejects its cruise stage and ignites an oversized terminal booster, speeding towards [target]!"))
