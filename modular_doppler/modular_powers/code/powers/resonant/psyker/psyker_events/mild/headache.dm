/datum/psyker_event/mild/headache

/datum/psyker_event/mild/headache/execute(mob/living/carbon/human/psyker)
	psyker.add_mood_event("headache", /datum/mood_event/psyker_headache)
	to_chat(psyker, span_danger("A splitting headache pounds through your skull!"))
	return TRUE

/datum/mood_event/psyker_headache
	description = "My head is pounding!"
	mood_change = -15
	timeout = 1 MINUTES // I wish my headaches went away that fast.

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/headache
	name = "Psyker Event: Headache"
	event_type = /datum/psyker_event/mild/headache
