/datum/psyker_event/severe/hallucinate
	/// Mostly instant shock factor stuff.
	var/static/list/initial_hallucinations = list(
		/datum/hallucination/delusion,
		/datum/hallucination/xeno_attack,
		/datum/hallucination/oh_yeah,
		/datum/hallucination/death,
		/datum/hallucination/fire,
		/datum/hallucination/ice,
		/datum/hallucination/shock
	)

/datum/psyker_event/severe/hallucinate/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("You begin to lose your grip on reality!"))
	// Generaly speaking we don't want these to last too long.
	psyker.set_hallucinations_if_lower(60 SECONDS)
	// We do also want immediate hallucinations as feedback, as the psyker_events double as stress warnings.
	psyker.cause_hallucination(pick(initial_hallucinations), src)
	return TRUE

