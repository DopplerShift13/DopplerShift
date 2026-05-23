/datum/wargame_weapon/rockets
	weapon_name = "Rockets"
	attack_roll = "6d4"
	damage_roll_bonus = 0
	attack_range = 2
	evadable = TRUE
	radial_icon_state = "weapon_rocket"
	action_point_cost = 1

/datum/wargame_weapon/rockets/strike
	maximum_ammo = 4

/datum/wargame_weapon/rockets/weapon_description()
	return "A barrage of unguided rockets from a fixed rack or large launcher. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/rockets/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/swarm_launch.ogg', 40, TRUE)

/datum/wargame_weapon/rockets/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] lets loose a volley of rockets at [target]!"))

/datum/wargame_weapon/rockets/firing_voiceline()
	var/static/list/lines = list(
		"Go for rocket salvo, let's see how they like some of these!",
		"Rockets! Rockets! You're in my party now!",
		"Make it rain on them!",
	)
	return pick(lines)

/datum/wargame_weapon/bombs
	weapon_name = "Bombs"
	attack_roll = "1d20"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_bomb"
	maximum_ammo = 2
	action_point_cost = 1

/datum/wargame_weapon/bombs/weapon_description()
	return "A group of unpowered explosive bombs to crack large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/bombs/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/cannon.ogg', 40, TRUE)

/datum/wargame_weapon/bombs/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] makes a run at [target], releasing a large bomb that drifts toward them!"))

/datum/wargame_weapon/bombs/firing_voiceline()
	var/static/list/lines = list(
		"I got a present for ya!",
		"Kill him! Kill him! Point the nose at him and drop the bomb at him!",
		"Bombs away- Hard burn we're in the blast zone!",
	)
	return pick(lines)
