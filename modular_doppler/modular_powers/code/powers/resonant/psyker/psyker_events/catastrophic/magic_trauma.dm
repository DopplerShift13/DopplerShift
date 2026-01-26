// Gives one of the wizard's magical traumas.
/datum/psyker_event/catastrophic/magic_trauma
	weight = PSYKER_EVENT_RARITY_RARE

/datum/psyker_event/catastrophic/magic_trauma/execute(mob/living/carbon/human/psyker)
	var/datum/brain_trauma/magic/trauma
	if(prob(65)) // Poltergeists are a bit more thematic so they're a tad more common.
		trauma  = new /datum/brain_trauma/magic/poltergeist
	else // Gets you the stalker, which is even spookier (and bothersome)
		trauma = new /datum/brain_trauma/magic/stalker
	// We are also not going to tell them they got a trauma.
	trauma.gain_text = null

	if(!psyker.gain_trauma(trauma))
	// If we somehow fail to give them the trauma
		QDEL_NULL(trauma)
		return FALSE
	//Standard message for catastrophic for when we don't explicitly want to tell them what is going to happen to them.
	to_chat(psyker, span_userdanger(PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE))
	return TRUE
