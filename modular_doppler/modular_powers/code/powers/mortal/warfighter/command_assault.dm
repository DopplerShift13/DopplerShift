/datum/power/warfighter/command_assault
	name = "Command: Assault"
	desc = "Command nearby allies to focus the target. The target takes 20% more damage for 15 seconds. Duration scales with your command modifier. This status effect cannot stack. \
	\n This scales off of department members within your line of sight (at half efficiency), rather than the target being in your department. Head of staff bonuses still apply."
	security_record_text = "Subject can rally others to increase their effective combat power against one target."
	security_threat = POWER_THREAT_MAJOR // power literally only used for murder
	value = 5
	action_path = /datum/action/cooldown/power/warfighter/command/assault

/datum/action/cooldown/power/warfighter/command/assault
	name = "Command: Assault"
	desc = "Command nearby allies to focus the target. The target takes 20% more damage for 15 seconds. Duration scales with your command modifier. This status effect cannot stack."

	department_los_scaling = TRUE
	cooldown_time = 600
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "assassin"
	action_symbol = "attack"

	/// how much extra damage the target takes
	var/vulnerable_amount = 20
	/// how long the effect lasts
	var/effect_duration = 15 SECONDS

/datum/action/cooldown/power/warfighter/command/assault/use_action(mob/living/user, mob/living/carbon/target)
	target.apply_status_effect(/datum/status_effect/power/command_assault, commander_modifier, vulnerable_amount, effect_duration)
	return TRUE

/*
	Status effect that handles the damage multiplier.
*/
/datum/status_effect/power/command_assault
	id = "command_assault"
	status_type = STATUS_EFFECT_REPLACE
	show_duration = TRUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/command_assault
	/// Percentage increase to incoming damage while this is active.
	var/damage_increase_percent

// Gets the commander modifier, the vuln amount and effect duration from the base.
/datum/status_effect/power/command_assault/on_creation(mob/living/new_owner, commander_modifier, vulnerable_amount, effect_duration)
	if(isnum(commander_modifier))
		duration = effect_duration * commander_modifier
	if(isnum(vulnerable_amount))
		damage_increase_percent = vulnerable_amount
	. = ..()

// Signaler for multiplying damage
/datum/status_effect/power/command_assault/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(modify_incoming_damage))
	return TRUE

// Signaler for multiplying damage
/datum/status_effect/power/command_assault/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
	return

/// Applies the damage mult
/datum/status_effect/power/command_assault/proc/modify_incoming_damage(mob/living/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	damage_mods += (1 + (damage_increase_percent / 100))

/atom/movable/screen/alert/status_effect/command_assault
	name = "Command: Assault"
	desc = "You take increased damage from all sources!"
	icon = 'icons/hud/guardian.dmi'
	icon_state = "assassin"
