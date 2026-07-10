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
	/// Alcohol is mana! Determines if we include the upgrade that makes drunkenness increase our cooldown regen.
	var/alcohol_is_mana = FALSE
	/// How much drunkenness contributes to the bonus recovery multiplier.
	var/alcohol_is_how_much_mana = 5
	/// The cap on how much of a percentage increase Alcohol is Mana! can give us
	var/alcohol_is_maximum = 500

/datum/power/imbued_root/enchanted/process(seconds_per_tick)
	if(!length(power_holder?.actions))
		return

	var/cooldown_reduction = cooldown_recovery_bonus_per_second * seconds_per_tick
	cooldown_reduction *= get_alcohol_is_mana_multiplier()
	if(cooldown_reduction <= 0)
		return

	for(var/datum/action/cooldown/cooldown_action as anything in power_holder.actions)
		if(!should_accelerate_action(cooldown_action))
			continue
		if(cooldown_action.next_use_time <= world.time)
			continue

		cooldown_action.next_use_time = max(world.time, cooldown_action.next_use_time - cooldown_reduction)
		cooldown_action.build_all_button_icons(UPDATE_BUTTON_STATUS)

/// How much we multiply our recovery rate by if we Alcohol is Mana!
/datum/power/imbued_root/enchanted/proc/get_alcohol_is_mana_multiplier()
	if(!alcohol_is_mana)
		return 1

	var/mob/living/power_owner = power_holder
	if(!istype(power_owner))
		return 1

	var/drunk_amount = power_owner.get_drunk_amount()
	if(drunk_amount <= 0)
		return 1

	var/alcohol_bonus_percent = min(drunk_amount * alcohol_is_how_much_mana, alcohol_is_maximum)
	return 1 + (alcohol_bonus_percent / 100)

/// Proc that returns TRUE/FALSE if a power is qualified to get a CDR reduction from enchanted.
/datum/power/imbued_root/enchanted/proc/should_accelerate_action(datum/action/cooldown/cooldown_action)
	if(istype(cooldown_action, /datum/action/cooldown/power))
		var/datum/action/cooldown/power/power_action = cooldown_action
		var/datum/power/origin_power = power_action.origin_power
		if(!origin_power)
			return FALSE
		return origin_power.archetype == POWER_ARCHETYPE_RESONANT || origin_power.archetype == POWER_ARCHETYPE_SORCEROUS

	return istype(cooldown_action, /datum/action/cooldown/spell)
