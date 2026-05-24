/datum/wargame_weapon/mass_driver
	weapon_name = "Mass Driver"
	attack_roll = "2d12+2"
	damage_roll_bonus = 0
	attack_range = 3
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 2

/datum/wargame_weapon/mass_driver/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/cannon.ogg', 40, TRUE)

/datum/wargame_weapon/mass_driver/weapon_description()
	return "A large mass driver for launching hardened cores at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/mass_driver/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s mass driver ripples the space around it as it charges, piercing a streak across the sky as it fires at [target]!"), \
		blind_message = span_warning("[firer]'s mass driver ripples the space around it as it charges, piercing a streak across the sky as it fires at [target]!"))

/datum/wargame_weapon/mass_driver/firing_voiceline()
	var/static/list/lines = list(
		"We shot this in atmosphere once, you should've seen it!",
		"One-second delivery, or your tungsten rod is free!",
		"Let's see how that ship looks with a brand new hole down the center of it.",
		"Tungsten cube, hot and ready!",
		"A few more shots like this, and we'll have to change the rails out.",
	)
	return pick(lines)

/datum/wargame_weapon/large_cannon
	weapon_name = "7\" Cannon"
	attack_roll = "2d16+4"
	damage_roll_bonus = 0
	attack_range = 3
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 2

/datum/wargame_weapon/large_cannon/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/cannon.ogg', 40, TRUE)

/datum/wargame_weapon/large_cannon/weapon_description()
	return "A large calibre 7 in. cannon for launching shells at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/large_cannon/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s 7\" guns fire at [target], sending a jet of burning plasma out the back of each cannon!"), \
		blind_message = span_warning("[firer]'s 7\" guns fire at [target], sending a jet of burning plasma out the back of each cannon!"))

/datum/wargame_weapon/large_cannon/firing_voiceline()
	var/static/list/lines = list(
		"Target lead and trajectory calculations green, fire at will.",
		"Artillery adds dignity to what would otherwise be a vulgar brawl",
		"Shell, away. Have we ceased life, saer?",
	)
	return pick(lines)

/datum/wargame_weapon/medium_cannon
	weapon_name = "2.5\" Cannon"
	attack_roll = "4d5+4"
	damage_roll_bonus = 0
	attack_range = 2
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 1

/datum/wargame_weapon/medium_cannon/weapon_firing_sound(obj/firer)
	playsound(firer, 'modular_doppler/wargaming/sound/cannon.ogg', 40, TRUE)

/datum/wargame_weapon/medium_cannon/weapon_description()
	return "A medium calibre 2.5 in. cannon fore launching shells at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/medium_cannon/weapon_firing_message(obj/firer, obj/target)
	firer.visible_message(span_warning("[firer]'s 2.5\" guns turn to bear on [target], rattling the vessel as they unleash a volley of shells!"), \
		blind_message = span_warning("[firer]'s 2.5\" guns turn to bear on [target], rattling the vessel as they unleash a volley of shells!"))

/datum/wargame_weapon/medium_cannon/firing_voiceline()
	var/static/list/lines = list(
		"All mounts local control, watch fire for friendlies!",
		"I want all guns on that track, open fire!",
		"Target in range, all guns to local fire director!",
	)
	return pick(lines)
