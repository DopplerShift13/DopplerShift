/datum/psyker_event/catastrophic/heart_attack

/datum/psyker_event/catastrophic/heart_attack/can_execute(mob/living/carbon/human/psyker)
	return psyker.can_heartattack() && !psyker.undergoing_cardiac_arrest() // Must be capable of getting a hearattack

/datum/psyker_event/catastrophic/heart_attack/execute(mob/living/carbon/human/psyker)
	psyker.apply_status_effect(/datum/status_effect/heart_attack)
	//Standard message for catastrophic for when we don't explicitly want to tell them what is going to happen to them.
	to_chat(psyker, span_userdanger(PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE))

	return TRUE

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/heart_attack
	name = "Psyker Event: Cardiac Arrest"
	event_type = /datum/psyker_event/catastrophic/heart_attack
