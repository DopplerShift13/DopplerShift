/datum/wargame_weapon/autocannon
	weapon_name = "45mm Autocannon"
	attack_roll = "2d10+2"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = TRUE
	radial_icon_state = "weapon_guns"
	action_point_cost = 1

/datum/wargame_weapon/autocannon/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/autocannonlong.ogg', 40, TRUE)

/datum/wargame_weapon/autocannon/weapon_description()
	return "Low calibre 45mm autocannons for fast moving targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/autocannon/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s 45mm autocannon tracks toward [target], following the target for mere moments before sending a burst of shells at it!"))

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
	playsound(firer, 'modular_doppler/wargaming/sound/autocannonlong.ogg', 40, TRUE)

/datum/wargame_weapon/pdc/weapon_description()
	return "Small calibre 26mm autocannons with exceptional hit chance but low damage. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/pdc/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s point defence grid quickly gimbals toward [target], filling the sky with a dense rain of tracers!"))

/datum/wargame_weapon/pdc/firing_voiceline()
	var/static/list/lines = list(
		"We need PDC on that target, now!",
		"One wall of lead, coming right up.",
		"Tracking multiple targets, open fire.",
	)
	return pick(lines)
