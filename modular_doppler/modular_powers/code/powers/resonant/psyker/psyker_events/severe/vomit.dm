/datum/psyker_event/severe/vomit

/datum/psyker_event/severe/vomit/can_execute(mob/living/carbon/human/psyker)
	return !HAS_TRAIT(psyker, TRAIT_NOHUNGER) && !HAS_TRAIT(psyker, TRAIT_TOXINLOVER)

/datum/psyker_event/severe/vomit/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("A wave of nausea overwhelms you, making you vomit!"))
	psyker.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 10)
	// Even though they may dryheave, the feedback is there from vomit(), so mission accomplished.
	return TRUE

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/vomit
	name = "Psyker Event: Vomit"
	event_type = /datum/psyker_event/severe/vomit
