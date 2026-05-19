// Gives a special deep-rooted trauma that silences Resonance powers all-together.
/datum/psyker_event/catastrophic/silence_trauma
	weight = PSYKER_EVENT_RARITY_RARE

/datum/psyker_event/catastrophic/silence_trauma/execute(mob/living/carbon/human/psyker)
	var/datum/brain_trauma/magic/trauma = new /datum/brain_trauma/magic/resonance_silenced
	trauma.gain_text = null
	if(!psyker.gain_trauma(trauma))
	// If we somehow fail to give them the trauma
		QDEL_NULL(trauma)
		return FALSE
	// We replicate the trauma message just in a different span.
	to_chat(psyker, span_userdanger("You feel like you're no longer in touch with your own Resonant powers."))
	return TRUE

