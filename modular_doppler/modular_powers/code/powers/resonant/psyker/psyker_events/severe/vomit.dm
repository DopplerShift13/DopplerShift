/datum/psyker_event/severe/vomit

/datum/psyker_event/severe/vomit/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("A wave of psychic energy overwhelms you, making you vomit!"))
	psyker.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 10)
	// Even though they may dryheave, the feedback is there from vomit(), so mission accomplished.
	return TRUE
