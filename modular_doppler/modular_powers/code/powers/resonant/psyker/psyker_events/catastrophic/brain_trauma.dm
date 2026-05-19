// Gives deep-rooted normal traumas.
/datum/psyker_event/catastrophic/brain_trauma
	weight = PSYKER_EVENT_RARITY_UNCOMMON

/datum/psyker_event/catastrophic/brain_trauma/execute(mob/living/carbon/human/psyker)
	if(!psyker.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY))
	// If we somehow fail to give them the trauma
		return FALSE
	//Standard message for catastrophic for when we don't explicitly want to tell them what is going to happen to them.
	to_chat(psyker, span_userdanger(PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE))
	return TRUE
