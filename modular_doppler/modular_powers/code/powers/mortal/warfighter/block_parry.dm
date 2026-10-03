/datum/power/warfighter/block_parry
	name = "Parrying Block"
	desc = "With intense focus, you can parry any harm that is sent your way. Focused Block is fixed at 100% and is unaffected by armour piercing in its first 0.5 seconds, but now fully decays it's block bonus over 1 second.\
	\nSuccessfully blocking with Focused Block resets the cooldown during this timing window."
	security_record_text = "Subject can parry attacks in short-succesion with precise timing."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/warfighter/focused_block)

	menu_icon = 'icons/obj/weapons/shields.dmi'
	menu_icon_state = "buckler"

	/// How long it takes for the parry to expire.
	var/parry_decay_duration = 1 SECONDS
	/// How long the guaranteed block period is.
	var/parry_guaranteed_block_duration = 0.5 SECONDS
	/// When the current parry window expires.
	var/parry_window_end

/datum/power/warfighter/block_parry/add()
	RegisterSignal(power_holder, COMSIG_POWER_ACTION_SUCCESS, PROC_REF(on_power_action_success))
	RegisterSignal(power_holder, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_BLOCK, PROC_REF(on_bonus_block))
	RegisterSignal(power_holder, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_ARMOUR_PENETRATION, PROC_REF(on_bonus_armour_penetration))
	RegisterSignal(power_holder, COMSIG_POWERS_FOCUSED_BLOCK_SUCCESSFUL_BLOCK, PROC_REF(on_focused_block_success))

/datum/power/warfighter/block_parry/remove()
	UnregisterSignal(power_holder, list(COMSIG_POWER_ACTION_SUCCESS, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_BLOCK, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_ARMOUR_PENETRATION, COMSIG_POWERS_FOCUSED_BLOCK_SUCCESSFUL_BLOCK))

/// Configures the Focused Block status effect created by the action that just succeeded.
/datum/power/warfighter/block_parry/proc/on_power_action_success(mob/living/source, datum/action/cooldown/power/used_power, atom/target)
	SIGNAL_HANDLER

	if(!istype(used_power, /datum/action/cooldown/power/warfighter/focused_block))
		return
	var/datum/status_effect/power/focused_block/focused_block_status = source.has_status_effect(/datum/status_effect/power/focused_block)
	if(!focused_block_status)
		return
	parry_window_end = world.time + parry_guaranteed_block_duration
	focused_block_status.decay_duration = parry_decay_duration
	focused_block_status.update_block_chance_display()

/// Adds a 100% block chance while the Parrying Block window is active.
/datum/power/warfighter/block_parry/proc/on_bonus_block(mob/living/source, datum/status_effect/power/focused_block/focused_block_status, list/block_chance_bonuses)
	SIGNAL_HANDLER

	if(world.time < parry_window_end)
		block_chance_bonuses += 100

/// Gives Parrying Block enough defensive armor penetration to resist every attack.
/datum/power/warfighter/block_parry/proc/on_bonus_armour_penetration(mob/living/source, datum/status_effect/power/focused_block/focused_block_status, list/block_armour_penetration_bonuses)
	SIGNAL_HANDLER

	if(world.time < parry_window_end)
		block_armour_penetration_bonuses += 100

/// Fully resets Focused Block's cooldown after Focused Block itself blocks during the parry window.
/datum/power/warfighter/block_parry/proc/on_focused_block_success(mob/living/source, datum/status_effect/power/focused_block/focused_block_status, current_block_chance)
	SIGNAL_HANDLER

	if(!focused_block_status.focused_block_action)
		return
	if(world.time < parry_window_end)
		focused_block_status.focused_block_action.ResetCooldown()

		// Feedback
		playsound(source, 'sound/effects/parry.ogg', BLOCK_SOUND_VOLUME, vary = TRUE, falloff_distance = MEDIUM_RANGE_SOUND_EXTRARANGE)
		source.balloon_alert(source, "Parried!")
		to_chat(source, span_notice("You manage to parry the attack!"))
