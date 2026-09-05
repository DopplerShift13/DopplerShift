/* Instantly finishes all the healing on Burden Revered, but puts it on cooldown equal to 2.5x the remaining time. Emergency heal, as regular healing is still slightly faster.
*/
/datum/power/theologist/revered_flash_heal
	name = "Flash Heal"
	desc = "Cast to instantly apply any remaining healing from your A Burden Revered onto its current target.\
	\nDoing so causes Burden Revered to go on cooldown equal to 2.5x the remaining time it would have taken to heal its current target, or 4x if that target is yourself."
	security_record_text = "Subject's healing powers can heal quickly in a short burst, at the cost of a refactory period."
	security_threat = POWER_THREAT_MINOR
	value = 3
	required_powers = list(/datum/power/theologist_root/revered)
	action_path = /datum/action/cooldown/power/theologist/revered_flash_heal
	power_flags = POWER_HUMAN_ONLY | POWER_HEALING

	/// Multiplier on the cooldown if Flash Heal was used on someone else.
	var/recovery_period = 2.5
	/// Multiplier on the cooldown if Flash Heal was used on yourself.
	var/recovery_period_self = 4

/datum/action/cooldown/power/theologist/revered_flash_heal
	name = "Flash Heal"
	desc = "Cast to instantly apply any remaining healing from your A Burden Revered onto its current target.\
	\nDoing so causes Burden Revered to go on cooldown equal to 2.5x the remaining time it would have taken to heal its current target, or 4x if that target is yourself."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "flash_heal"

	/// The Revered action whose active effect this action finishes.
	var/datum/action/cooldown/power/theologist/theologist_root/revered/revered_action
	/// The current Burden Revered effect.
	var/datum/status_effect/power/burden_revered/active_effect

/datum/action/cooldown/power/theologist/revered_flash_heal/Grant(mob/granted_to)
	. = ..()
	var/mob/living/living_owner = granted_to
	if(living_owner)
		var/datum/power/theologist_root/revered/revered_power = living_owner.get_power(/datum/power/theologist_root/revered)
		revered_action = revered_power?.action_path

/// Ensures Burden Revered exists and doesn't runtime when using this power.
/datum/action/cooldown/power/theologist/revered_flash_heal/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(!revered_action)
		user.balloon_alert(user, "no burden revered!")
		return FALSE
	active_effect = revered_action.active_effect
	// Revered calls Destroy() directly when it expires, so already_expired is required in addition to QDELETED() to reject stale references to the finished status effect.
	if(!active_effect || QDELETED(active_effect) || active_effect.already_expired || !active_effect.owner || active_effect.healing_done >= active_effect.healing_max)
		user.balloon_alert(user, "no burden revered!")
		return FALSE
	return TRUE

/datum/action/cooldown/power/theologist/revered_flash_heal/use_action(mob/living/user, atom/target)
	var/mob/living/heal_target = active_effect.owner

	// How much of our healing we still have left to do.
	var/healing_remaining = active_effect.healing_max - active_effect.healing_done
	// Just let Revered handle the heal itself which is way neater.
	var/actual_healing = active_effect.heal_damage(healing_remaining)
	// Convert the actual healing into the time Revered would have needed to heal its current target.
	var/remaining_healing_time = (actual_healing / active_effect.base_healing_amount) SECONDS
	// Record only the healing that was actually applied before normal Revered cleanup and piety reporting.
	active_effect.healing_done += actual_healing
	active_effect.expire()

	var/datum/power/theologist/revered_flash_heal/flash_power = origin_power
	// Self-targeting has the longer recovery period.
	revered_action.StartCooldownSelf(remaining_healing_time * (heal_target == user ? flash_power.recovery_period_self : flash_power.recovery_period))

	// Effects + visuals
	playsound(heal_target, 'sound/effects/magic/staff_healing.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	var/filter_id = "flash_heal_glow"
	heal_target.add_filter(filter_id, 1, list(type = "outline", color = POWER_COLOR_THEOLOGIST, size = 2, alpha = 255))
	heal_target.transition_filter(filter_id, list("alpha" = 0), 2 SECONDS)
	addtimer(CALLBACK(heal_target, PROC_REF(remove_filter), filter_id), 2 SECONDS)

	if(heal_target == user) // healing self
		to_chat(user, span_notice("You expedite the healing on your injuries!"))
	else // healing others
		to_chat(heal_target, span_notice("Your wounds have rapidly healed!"))
		to_chat(user, span_notice("You expedite the healing on [heal_target]'s injuries!"))

	return TRUE
