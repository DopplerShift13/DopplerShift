/*
	Enchanted root. You are magical! Accelerates qualifying cooldown recovery based on your magical power investment.
*/

/datum/power/imbued_root/enchanted
	name = "Enchanted"
	desc = "You ambiently seem to interact more positively with magic. So long as you are not silenced, you regenerate action cooldowns faster based on your magical prowress.\
	\nEvery point invested in a magical power makes your cooldowns go 0.5% faster; this becomes 2% if the power is in the Imbued path.\
	\nThis only affects magical power actions, plus spell-type actions."
	security_record_text = "Subject seems to be able to wield existing magical powers more often."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	magic_flags = POWER_MAGIC_STANDARD
	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "quantum_sparks"
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	no_process_traits = list(TRAIT_RESONANCE_SILENCED)

	///CDR = Cooldown Reduction. Is a gamer term.

	/// Flat deciseconds removed from qualifying cooldowns per second before power-based scaling.
	var/CDR_base = 0
	/// Additional deciseconds removed per point of non-Imbued magical power value.
	var/CDR_per_magic_value = 0.05
	/// Additional deciseconds removed per point of Imbued magical power value.
	var/CDR_per_imbued_magic_value = 0.2
	/// Cached base cooldown recovery per second from the holder's current powers.
	var/CDR_cache = 0
	/// Whether the cached cooldown recovery value needs to be rebuilt.
	var/CDR_cache_dirty = TRUE

/datum/power/imbued_root/enchanted/add(client/client_source)
	. = ..()
	RegisterSignals(power_holder, list(COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED), PROC_REF(on_power_list_changed))

/datum/power/imbued_root/enchanted/remove()
	. = ..()
	UnregisterSignal(power_holder, list(COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED))

/datum/power/imbued_root/enchanted/process(seconds_per_tick)
	if(!length(power_holder?.actions))
		return

	// This calculates the BASE value
	var/cooldown_reduction = get_CDR_per_second() * seconds_per_tick
	// This claculates the MULTIPLIERS value
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

/// Calculates the base cooldown recovery rate from the holder's magical powers.
/// This defaults to using the cached value for optimization; and if its dirty/non-existant we cache a new vlaue.
/datum/power/imbued_root/enchanted/proc/get_CDR_per_second()
	if(CDR_cache_dirty)
		cache_CDR_per_second()

	return CDR_cache

/// Calculates our effective base cooldown recovery bonus and caches it for later procs.
/datum/power/imbued_root/enchanted/proc/cache_CDR_per_second()
	CDR_cache = CDR_base

	for(var/datum/power/power_instance as anything in power_holder?.powers)
		if(!power_instance)
			continue
		if(!power_instance.magic_flags)
			continue
		// Imbued gives extra
		if(power_instance.path == POWER_PATH_IMBUED)
			CDR_cache += power_instance.value * CDR_per_imbued_magic_value
			continue
		// Its magical, so it gives a reduction.
		CDR_cache += power_instance.value * CDR_per_magic_value

	CDR_cache_dirty = FALSE

/// Listens to changes in powers and marks the cache as dirty if the mob's powers are adjusted.
/datum/power/imbued_root/enchanted/proc/on_power_list_changed(mob/living/source, datum/power/changed_power)
	SIGNAL_HANDLER

	CDR_cache_dirty = TRUE

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
		return power_action.resonant // the resonant trait basically should always be true on any magical action; less depth than digging for the base power's bitflags.

	return istype(cooldown_action, /datum/action/cooldown/spell)
