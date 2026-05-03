/datum/psyker_event/catastrophic/heart_attack

/datum/psyker_event/catastrophic/heart_attack/execute(mob/living/carbon/human/psyker)
	if(!psyker.can_heartattack() && !psyker.undergoing_cardiac_arrest()) // Can the target have a heartattack? And if so, are they already undergoing a heartattack?
		return FALSE
	psyker.apply_status_effect(/datum/status_effect/heart_attack)
	//Standard message for catastrophic for when we don't explicitly want to tell them what is going to happen to them.
	to_chat(psyker, span_userdanger(PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE))

	return TRUE

