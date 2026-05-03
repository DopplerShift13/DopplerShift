/*
Hides your voice as unknown while active. Act out the machivalean you always wanted to be, for good or bad.
*/

/datum/power/expert/obfuscate_voice
	name = "Obfuscate Voice"
	desc = "Like an actor, the sheer range in your voice is enough, with a little effort, to sound like someone entirely unfamiliar. Grants the 'Obfuscate Voice' action, making your voice unrecognizeable while active."
	security_record_text = "Subject can change their voice to be distinctly different from their normal voice."
	value = 5

	action_path = /datum/action/cooldown/power/expert/obfuscate_voice

/datum/action/cooldown/power/expert/obfuscate_voice
	name = "Obfuscate Voice"
	desc = "Makes your voice unrecognizeable while active."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_say"

	/// The current in use status effect
	var/datum/status_effect/power/obfuscate_voice/active_effect


/datum/action/cooldown/power/expert/obfuscate_voice/use_action(mob/living/user, atom/target)
	if(active_effect)
		qdel(active_effect)
		active_effect = null
		active = FALSE
		return TRUE

	active_effect = user.apply_status_effect(/datum/status_effect/power/obfuscate_voice, src)
	active = TRUE
	return TRUE

// We pass it on to a status effect both as a convenient handler, and also user feedback that its active with the alert pop-up.
/datum/status_effect/power/obfuscate_voice
	id = "obfuscate_voice"
	duration = STATUS_EFFECT_PERMANENT
	alert_type = /atom/movable/screen/alert/status_effect/obfuscate_voice
	var/datum/action/cooldown/power/expert/obfuscate_voice/source_action

/datum/status_effect/power/obfuscate_voice/on_creation(mob/living/new_owner, datum/action/cooldown/power/expert/obfuscate_voice/passed_action)
	. = ..()
	source_action = passed_action

/datum/status_effect/power/obfuscate_voice/on_apply()
	ADD_TRAIT(owner, TRAIT_UNKNOWN_VOICE, TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/power/obfuscate_voice/on_remove()
	REMOVE_TRAIT(owner, TRAIT_UNKNOWN_VOICE, TRAIT_STATUS_EFFECT(id))
	return

/atom/movable/screen/alert/status_effect/obfuscate_voice
	name = "Obfuscate Voice"
	desc = "Your voice is masked and will appear as 'Unknown' when speaking. Toggle the power again to disable."
	icon_state = "mute" // swap if you have a better icon
