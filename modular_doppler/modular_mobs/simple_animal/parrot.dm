/mob/living/basic/parrot/Initialize(mapload)
	pet_commands |= list(/datum/pet_command/perch, /datum/pet_command/hop_off) // Append perch commands to the existing list rather than editing the list in _parrot.dm. We use |= because it's a shared list
	. = ..()
	AddElement(/datum/element/befriend_petting)

/// Tells a parrot to come for a ride-along
/datum/pet_command/perch
	command_name = "Perch"
	command_desc = "Command a parrot to perch on you."
	radial_icon_state = "follow" // I need to sprite icons for this
	speech_commands = list("perch", "up")

/datum/pet_command/perch/set_command_active(mob/living/parent, mob/living/commander)
	. = ..()
	set_command_target(parent, commander)

/datum/pet_command/perch/execute_action(datum/ai_controller/controller)
	var/mob/living/basic/parrot/parrot = controller.pawn
	var/mob/living/carbon/human/friend = controller.blackboard[BB_CURRENT_PET_TARGET]
	if(QDELETED(friend))
		controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
		return
	if(parrot.buckled == friend) // Skip over everything if the parrot's already on you
		return SUBTREE_RETURN_FINISH_PLANNING
	if(parrot.buckled && parrot.buckled != friend) // Perched on someone else, hop off them first
		parrot.buckled.unbuckle_mob(parrot, force = TRUE)
	if(get_dist(parrot, friend) > 1)
		controller.queue_behavior(/datum/ai_behavior/pet_follow_friend, BB_CURRENT_PET_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING
	if(!parrot.perch_on_human(friend))
		controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
		return
	parrot.manual_emote(" hops up onto [friend]'s shoulder, spreading [parrot.p_their()] wings for a moment before settling down.")
	return SUBTREE_RETURN_FINISH_PLANNING

/// Tells a perched parrot to get off
/datum/pet_command/hop_off
	command_name = "Hop Off"
	command_desc = "Command a parrot to get off of you."
	radial_icon_state = "free" // ditto on icons
	speech_commands = list("off", "down")

/datum/pet_command/hop_off/execute_action(datum/ai_controller/controller)
	var/mob/living/basic/parrot/parrot = controller.pawn
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND) // one-shot, normal behavior resumes afterwards
	var/mob/living/perch = parrot.buckled
	if(!ishuman(perch))
		parrot.manual_emote("gives a confused look, squawking softly.")
		return SUBTREE_RETURN_FINISH_PLANNING
	perch.unbuckle_mob(parrot, force = TRUE) // on_unbuckle() in parrot.dm handles the un-perching
	parrot.manual_emote("squawks and hops off of [perch], flying away.")
	return SUBTREE_RETURN_FINISH_PLANNING
