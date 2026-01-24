/datum/psyker_event/special/magic_trauma

/datum/psyker_event/special/magic_trauma/execute(mob/living/carbon/human/psyker)
	var/datum/brain_trauma/magic/trauma
	if(prob(65)) // Poltergeists are a bit more thematic so they're a tad more common.
		trauma  = new /datum/brain_trauma/magic/poltergeist
	else // Gets you the stalker, which is even spookier (and bothersome)
		trauma = new /datum/brain_trauma/magic/stalker
	// We are also not going to tell them they got a trauma.
	trauma.gain_text = null
	if(!psyker.gain_trauma(trauma))
		QDEL_NULL(trauma)
		return FALSE
	//Standard message for catastrophic for when we don't explicitly want to tell them what is going to happen to them.
	to_chat(psyker, span_purple("<b>As you strain your psychic powers past the breaking point, you are suddenly hit with a strange sense of clarity..."))
	return TRUE
