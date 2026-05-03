/*
	Gives pain negation as well as stam-damage immunity.
*/
/datum/power/warfighter/command_grit
	name = "Command: Grit"
	desc = "Whilst active, the target ignores pain for 15 seconds, as well as slowdown from damage and stamina loss. Has a long cooldown. Increased effect lenghtens duration."
	security_record_text = "Subject has an unusual charisma and can motivate others to grit through any pain or injury without slowing down."
	security_threat = POWER_THREAT_MAJOR // you dont want this guy supporting your takedown target
	value = 5
	required_powers
	action_path = /datum/action/cooldown/power/warfighter/command/grit
	required_powers = list(/datum/power/warfighter/command_recover)

/datum/action/cooldown/power/warfighter/command/grit
	name = "Command: Grit"
	desc = "Whilst active, the target ignores pain for 15 seconds, as well as slowdown from damage and stamina loss. Has a long cooldown. Increased effect lenghtens duration."

	cooldown_time = 600
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "protector"
	action_symbol = "guard"

/datum/action/cooldown/power/warfighter/command/grit/use_action(mob/living/user, mob/living/carbon/target)
	..()
	target.apply_status_effect(/datum/status_effect/power/command_grit, commander_modifier)

// Status effect that Burden Revered applies
/datum/status_effect/power/command_grit
	id = "command_grit"
	show_duration = TRUE
	duration = 15 SECONDS // baseline
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/command_grit

/datum/status_effect/power/command_grit/on_creation(mob/living/new_owner, commander_modifier)
	if(isnum(commander_modifier))
		duration = 15 SECONDS * commander_modifier
	. = ..()

/datum/status_effect/power/command_grit/on_apply()
	ADD_TRAIT(owner, TRAIT_ANALGESIA, type)
	owner.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/damage_slowdown)
	owner.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/basic_stamina_slowdown)
	return TRUE

/datum/status_effect/power/command_grit/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANALGESIA, type)
	owner.remove_movespeed_mod_immunities(src, /datum/movespeed_modifier/damage_slowdown)
	owner.remove_movespeed_mod_immunities(src, /datum/movespeed_modifier/basic_stamina_slowdown)
	return

/atom/movable/screen/alert/status_effect/command_grit
	name = "Grit"
	desc = "You ignore pain for a duration, including the slowdowns from damage and stamina!"
	icon = 'icons/hud/guardian.dmi'
	icon_state = "standard"
