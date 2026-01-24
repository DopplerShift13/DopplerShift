/datum/psyker_event/mild/nosebleed

/datum/psyker_event/mild/nosebleed/execute(mob/living/carbon/human/psyker)
	var/obj/item/bodypart/head = psyker.get_bodypart(BODY_ZONE_HEAD)
	if(isnull(head))
		return FALSE
	if(!psyker.can_bleed())
		return FALSE
	head.adjustBleedStacks(5)
	psyker.visible_message(span_notice("[psyker] gets a nosebleed."), span_danger("Overusing your powers has given you a nosebleed!"))
	return TRUE
