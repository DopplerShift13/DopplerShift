/datum/power/warfighter/block_fortress
	name = "Fortress Block"
	desc = "Hold your ground and remain steadfast. Focused Block does not decay if you are standing still. Does not apply when stunned or prone."
	security_record_text = "Subject can block an extreme amount of attacks while holding still."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/warfighter/focused_block)

	menu_icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	menu_icon_state = "escarabajo"

	/// The turf occupied at the previous Focused Block decay check.
	var/turf/last_fortress_turf
	/// Consecutive ticks that we stand still.
	var/stationary_ticks

/datum/power/warfighter/block_fortress/add()
	RegisterSignal(power_holder, COMSIG_POWER_ACTION_SUCCESS, PROC_REF(on_power_action_success))
	RegisterSignal(power_holder, COMSIG_POWERS_FOCUSED_BLOCK_SHOULD_DECAY, PROC_REF(on_should_decay))

/datum/power/warfighter/block_fortress/remove()
	UnregisterSignal(power_holder, list(COMSIG_POWER_ACTION_SUCCESS, COMSIG_POWERS_FOCUSED_BLOCK_SHOULD_DECAY))

/// Configures the Focused Block status effect created by the action that just succeeded.
/datum/power/warfighter/block_fortress/proc/on_power_action_success(mob/living/source, datum/action/cooldown/power/used_power, atom/target)
	SIGNAL_HANDLER

	if(!istype(used_power, /datum/action/cooldown/power/warfighter/focused_block))
		return
	var/datum/status_effect/power/focused_block/focused_block_status = source.has_status_effect(/datum/status_effect/power/focused_block)
	if(!focused_block_status)
		return
	last_fortress_turf = get_turf(source)
	stationary_ticks = 1 // start at 1 so if we don't move after use we don't awkwardly decay.

/// Prevents Focused Block from decaying when its owner has not moved since the previous decay check.
/datum/power/warfighter/block_fortress/proc/on_should_decay(mob/living/source, datum/status_effect/power/focused_block/focused_block_status)
	SIGNAL_HANDLER
	var/turf/current_turf = get_turf(source)
	if(source.body_position != STANDING_UP || source.IsStun())
		last_fortress_turf = current_turf
		stationary_ticks = 0
		return
	if(current_turf != last_fortress_turf)
		last_fortress_turf = current_turf
		stationary_ticks = 0
		return
	stationary_ticks++
	if(stationary_ticks >= 2)
		return COMPONENT_POWERS_FOCUSED_BLOCK_DONT_DECAY
