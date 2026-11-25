/datum/action/cooldown/spell/return_back
	name = "Return"
	desc = "Activates your return beacon."
	sound = 'sound/effects/magic/repulse.ogg'
	button_icon_state = "lightning"
	spell_requirements = NONE
	invocation = "Return on!"
	invocation_type = INVOCATION_WHISPER
	school = SCHOOL_EVOCATION


/datum/action/cooldown/spell/return_back/can_cast_spell(feedback)
	return TRUE


/datum/action/cooldown/spell/return_back/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = cast_on
	if(!istype(cast_on))
		return

	var/mob/dead/observer/ghost = user.ghostize(FALSE)

	do_sparks(10, 1, user, get_turf(user), /datum/effect_system/spark_spread/quantum)

	qdel(user)


	// Get them back to their regular name.
	ghost.set_ghost_appearance()
	if(ghost.client && ghost.client.prefs)
		ghost.deadchat_name = ghost.client.prefs?.read_preference(/datum/preference/name/real_name)
