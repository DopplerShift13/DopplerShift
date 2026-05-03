// A mild dizzy, but enough to be noticed.
/datum/psyker_event/mild/dizziness

/datum/psyker_event/mild/dizziness/execute(mob/living/carbon/human/psyker)
	psyker.set_dizzy_if_lower(15 SECONDS)
	to_chat(psyker, span_danger("Overusing your powers has made you dizzy!"))
	return TRUE
