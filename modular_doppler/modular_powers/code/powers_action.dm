/*
 Custom action system for supporting the powers system. Use this anytime you add actions to a power.
 Almost all archetypes have their own subtype to handle their own resources and mechanics.
 This one is largely responsible for the actions framework itself.

 Largely modeled after changeling_power.dm
*/
/datum/action/power
	name = "abstract power action - ahelp this"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	/// Maximum stat before the ability is blocked.
	/// For example, `UNCONSCIOUS` prevents it from being used when in hard crit or dead,
	/// while `DEAD` allows the ability to be used on any stat values.
	var/req_stat = CONSCIOUS
	/// used by a few powers that toggle
	var/active = FALSE
	/// Does this ability stop working if you are silenced?
	var/disabled_by_silence = TRUE
	/// What power gave the origin?
	var/origin_power
	/// Can only humans use this power?
	var/human_only = TRUE

// When you press the button
/datum/action/power/Trigger(mob/clicker, trigger_flags)
	var/mob/user = owner
	if(!user)
		return
	try_use(user)

// Attempts to actively use the action
/datum/action/power/proc/try_use(mob/living/user, mob/living/target)
	SHOULD_CALL_PARENT(TRUE)
	if(disabled_by_silence && HAS_TRAIT(owner, TRAIT_RESONANCE_SILENCED))
		owner.balloon_alert(user, "silenced!")
		return FALSE
	if(use_action(user, target))
		return TRUE
	return FALSE

// Validates the action can be used.
/datum/action/power/proc/can_use(mob/living/user, mob/living/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_be_used_by(user)) // Runs can_be_used_by below
		return FALSE
	if(req_stat < user.stat) // Are we conscious?
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	return TRUE

// Checks if we exist (wow) and are human.
/datum/action/power/proc/can_be_used_by(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(QDELETED(user))
		return FALSE
	if(!ishuman(owner) && human_only)
		return FALSE
	return TRUE

// Now we do THINGS!
/datum/action/power/proc/use_action(mob/living/user, mob/living/target)
	return TRUE
