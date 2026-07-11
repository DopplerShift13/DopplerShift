/*
	Enchanted root. You are magical! Accelerates qualifying cooldown recovery by 20%.
*/

/datum/power/imbued_root/enchanted
	name = "Enchanted"
	desc = "You ambiently seem to interact more positively with magic. So long as you are not silenced, you regenerate action cooldowns 20% faster. This only affects Resonant and Sorcerous power actions, plus spell-type actions."
	security_record_text = "Subject seems to be able to wield existing magical powers more often."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	magic_flags = POWER_MAGIC_STANDARD
	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "quantum_sparks"
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	no_process_traits = list(TRAIT_RESONANCE_SILENCED)

	/// Additional deciseconds removed from qualifying cooldowns per second.
	var/cooldown_recovery_bonus_per_second = 2

/datum/power/imbued_root/enchanted/process(seconds_per_tick)
	if(!length(power_holder?.actions))
		return

	var/cooldown_reduction = cooldown_recovery_bonus_per_second * seconds_per_tick
	cooldown_reduction *= get_recovery_multiplier()
	if(cooldown_reduction <= 0)
		return

	for(var/datum/action/cooldown/cooldown_action as anything in power_holder.actions)
		if(!should_accelerate_action(cooldown_action))
			continue
		if(cooldown_action.next_use_time <= world.time)
			continue

		cooldown_action.next_use_time = max(world.time, cooldown_action.next_use_time - cooldown_reduction)
		cooldown_action.build_all_button_icons(UPDATE_BUTTON_STATUS)

/// How much we multiply our recovery rate by after all enchanted rider powers contribute their additive percentages.
/datum/power/imbued_root/enchanted/proc/get_recovery_multiplier()
	var/list/recovery_bonus_percents = list()
	SEND_SIGNAL(power_holder, COMSIG_IMBUED_ENCHANTED_RECOVERY_MODIFIERS, recovery_bonus_percents)

	var/total_bonus_percent = 0
	for(var/recovery_bonus_percent in recovery_bonus_percents)
		total_bonus_percent += recovery_bonus_percent

	return 1 + (total_bonus_percent / 100)

/// Proc that returns TRUE/FALSE if a power is qualified to get a CDR reduction from enchanted.
/datum/power/imbued_root/enchanted/proc/should_accelerate_action(datum/action/cooldown/cooldown_action)
	if(istype(cooldown_action, /datum/action/cooldown/power))
		var/datum/action/cooldown/power/power_action = cooldown_action
		var/datum/power/origin_power = power_action.origin_power
		if(!origin_power)
			return FALSE
		return origin_power.archetype == POWER_ARCHETYPE_RESONANT || origin_power.archetype == POWER_ARCHETYPE_SORCEROUS

	return istype(cooldown_action, /datum/action/cooldown/spell)
