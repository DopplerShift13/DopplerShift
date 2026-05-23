/datum/wargame_weapon/ramming/strike
	attack_roll = "5d5+2"
	damage_roll_bonus = 0
	evadable = TRUE
	small_ship_disadvantage = TRUE
	action_point_cost = 2

/datum/wargame_weapon/ramming/strike/firing_voiceline()
	var/static/list/lines = list(
		"One. Last. Plan!",
		"It's been an honor.",
		"Initiating burn drive, godspeed.",
		"Ah.",
	)
	return pick(lines)

/datum/wargame_weapon/ramming/strike/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer] locks into a collision trajectory with [target], engines burning to full!"))
