// Bleeding from the eyes and all that. Classic trope.
// Deals a bunch of eye damage, makes you bleed and gives a temporary red overlay.
/datum/psyker_event/severe/eyes_bleed
	lingering = TRUE // Needs to linger to apply the blind remove.

/datum/psyker_event/severe/eyes_bleed/execute(mob/living/carbon/human/psyker)
	var/obj/item/organ/eyes/eyes = psyker.get_organ_slot(ORGAN_SLOT_EYES)
	var/obj/item/bodypart/head/head = psyker.get_bodypart(BODY_ZONE_HEAD)
	if(isnull(eyes))
		return FALSE
	if(!psyker.can_bleed())
		return FALSE
	psyker.visible_message(span_notice("[psyker] begins to bleed from the eyes!"), span_userdanger("You feel blood begin to seep out from your eyes!"))
	eyes.apply_organ_damage(15) // not enough to do anything bad unless it's already damaged.
	head.adjustBleedStacks(10)
	psyker.playsound_local(psyker, 'sound/effects/meatslap.ogg', 50, FALSE)

	// visual effects
	psyker.become_nearsighted(src)
	psyker.add_client_colour(/datum/client_colour/psyker_eyes_bleed, REF(src))
	addtimer(CALLBACK(src, PROC_REF(_remove_blind), psyker), 6 SECONDS)
	return TRUE

/// Callback that removes the red eyeblind
/datum/psyker_event/severe/eyes_bleed/proc/_remove_blind(mob/living/carbon/human/psyker)
	// remove visual effects
	psyker.cure_nearsighted(src)
	psyker.remove_client_colour(REF(src))
	// lingering event so have to qdel self
	qdel(src)
	return

/datum/client_colour/psyker_eyes_bleed
	priority = CLIENT_COLOR_IMPORTANT_PRIORITY
	color = COLOR_RED
	fade_in = 1
	fade_out = 1
