/datum/psyker_event/mild/headache

/datum/psyker_event/mild/headache/execute(mob/living/carbon/human/psyker)
	psyker.add_mood_event("headache", /datum/mood_event/psyker_headache)
	to_chat(psyker, span_danger("Overusing your powers has given you a splitting headache!"))
	return TRUE

/datum/mood_event/psyker_headache
	description = "Overusing my powers has given me a splitting headache!"
	mood_change = -15
	timeout = 1 MINUTES // I wish my headaches went away that fast.
