/datum/wargame_weapon/anti_ship_beam
	weapon_name = "Anti-Ship Beam"
	attack_roll = "2d12+7"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = FALSE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_beam"
	action_point_cost = 1

/datum/wargame_weapon/anti_ship_beam/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/beam.ogg', 40, TRUE)

/datum/wargame_weapon/anti_ship_beam/weapon_description()
	return "A high-energy beam for coring large ships with. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/anti_ship_beam/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s spinal beam lens glows before piercing the sky towards [target] with a blinding flash of light!"), \
		blind_message = span_warning("[firer]'s spinal beam lens glows before piercing the sky towards [target] with a blinding flash of light!"))

/datum/wargame_weapon/anti_ship_beam/firing_voiceline(datum/wargame_unit_stats/stats)
	var/list/lines = list(
		"Try not to stare directly at the beam [stats.commander].",
		"Hope you brought your sunglasses today [stats.commander].",
		"Plasma cutters got nothing on me, watch this.",
	)
	return pick(lines)

/datum/wargame_weapon/pd_beam
	weapon_name = "PD Beam"
	attack_roll = "1d20+6"
	damage_roll_bonus = -5
	attack_range = 2
	evadable = FALSE
	radial_icon_state = "weapon_pd_beam"
	action_point_cost = 1

/datum/wargame_weapon/pd_beam/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/beam.ogg', 40, TRUE)

/datum/wargame_weapon/pd_beam/weapon_description()
	return "Highly focused beams with exceptional hit chance but low damage. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/pd_beam/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("Gimbaled lenses all along [firer] turn towards [target] and light up the night with a dazzling laser light show!"), \
		blind_message = span_warning("Gimbaled lenses all along [firer] turn towards [target] and light up the night with a dazzling laser light show!"))

/datum/wargame_weapon/pd_beam/firing_voiceline(datum/wargame_unit_stats/stats)
	var/list/lines = list(
		"Incoming track within range, blink it with the lasers.",
		"Get the spotlights on that track, I want it off the board!",
		"Laser defence responding to incoming track [stats.commander].",
	)
	return pick(lines)
