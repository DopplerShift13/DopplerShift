/datum/wargame_weapon/autocannon
	weapon_name = "45mm Autocannon"
	attack_roll = "2d10+2"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = TRUE
	radial_icon_state = "weapon_guns"
	action_point_cost = 1

/datum/wargame_weapon/autocannon/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/autocannonlong.ogg', 75, TRUE)

/datum/wargame_weapon/autocannon/weapon_description()
	return "Low calibre 45mm autocannons for fast moving targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/autocannon/firing_voiceline()
	var/static/list/lines = list(
		"Tracking looks good, let's let 'em have some.",
		"Autocannon belts spooled, ready to fire.",
		"Like to see them dodge this one, shells away.",
	)
	return pick(lines)

/datum/wargame_weapon/pdc
	weapon_name = "26mm PDC"
	attack_roll = "1d12+8"
	damage_roll_bonus = -5
	attack_range = 1
	evadable = FALSE
	radial_icon_state = "weapon_guns_pdc"
	action_point_cost = 1

/datum/wargame_weapon/pdc/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/autocannonlong.ogg', 75, TRUE)

/datum/wargame_weapon/pdc/weapon_description()
	return "Small calibre 26mm autocannons with exceptional hit chance but low damage. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/pdc/firing_voiceline()
	var/static/list/lines = list(
		"We need PDC on that target, now!",
		"One wall of lead, coming right up.",
		"Tracking multiple targets, open fire.",
	)
	return pick(lines)
