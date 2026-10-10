/// Psychic feedback causes an android's systems to violently short circuit.
/datum/psyker_event/severe/zapped

/datum/psyker_event/severe/zapped/can_execute(mob/living/carbon/human/psyker)
	return isandroid(psyker) && !HAS_TRAIT(psyker, TRAIT_SHOCKIMMUNE) // androids only.

/datum/psyker_event/severe/zapped/execute(mob/living/carbon/human/psyker)
	var/obj/item/bodypart/affected_bodypart = psyker.get_bodypart(psyker.get_random_valid_zone())
	if(isnull(affected_bodypart))
		return FALSE

	var/shock_flags = SHOCK_NOGLOVES | SHOCK_NOSTUN | SHOCK_SUPPRESS_MESSAGE
	if(!psyker.electrocute_act(5, psyker, 1, shock_flags))
		return FALSE

	psyker.apply_damage(5, BURN, def_zone = affected_bodypart)
	psyker.apply_damage(25, STAMINA, def_zone = affected_bodypart)
	psyker.dropItemToGround(psyker.get_active_held_item())
	psyker.dropItemToGround(psyker.get_inactive_held_item())
	psyker.adjust_confusion(5 SECONDS)
	psyker.visible_message(
		span_danger("Sparks erupt from [psyker] as [psyker.p_their()] systems violently short circuit!"),
		span_userdanger("Your systems are short circuiting!"),
	)
	do_sparks(8, FALSE, psyker)
	playsound(psyker, 'sound/items/weapons/zapbang.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	return TRUE

// Adds the backlash option as a smite for admins.
/datum/smite/psyker_breakdown/zapped
	name = "Psyker Event: Short Circuit (Robotic Only)"
	event_type = /datum/psyker_event/severe/zapped
