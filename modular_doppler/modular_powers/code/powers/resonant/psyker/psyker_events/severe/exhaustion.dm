// Head rings, myriad of minor effects and a big chunk of stamina damage.
/datum/psyker_event/severe/exhaustion

/datum/psyker_event/severe/exhaustion/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("A loud ringing plays in your head, and you feel a wave of lethargy creep up on you."))
	psyker.apply_damage(70, STAMINA)
	psyker.adjustOrganLoss(ORGAN_SLOT_BRAIN, BRAIN_DAMAGE_MILD, BRAIN_DAMAGE_MILD)
	psyker.set_jitter_if_lower(5 SECONDS)
	psyker.playsound_local(psyker, 'sound/effects/screech.ogg', 50, FALSE)
	psyker.flash_act(visual = TRUE, length = 1 SECONDS)
	return TRUE
