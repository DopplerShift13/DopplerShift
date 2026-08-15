// Twitching, pretty mild.
/datum/psyker_event/mild/twitching

/datum/psyker_event/mild/twitching/execute(mob/living/carbon/human/psyker)
	psyker.set_jitter_if_lower(15 SECONDS)
	to_chat(psyker, span_danger("Overusing your powers has made you twitchy!"))
	return TRUE

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/twitching
	name = "Psyker Event: Twitching"
	event_type = /datum/psyker_event/mild/twitching
