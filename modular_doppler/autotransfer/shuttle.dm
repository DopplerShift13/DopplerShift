/// ADDITIONAL PROC EDITS AS FOLLOWS:
// - code/modules/shuttle/emergency.dm - /obj/docking_port/mobile/emergency/request
// - code/modules/admin/verbs/adminshuttle.dm - cancel_shuttle ADMIN_VERB

/datum/controller/subsystem/shuttle
	var/endvote_passed = FALSE

/datum/controller/subsystem/shuttle/proc/call_end_of_shift_shuttle()
	if(EMERGENCY_IDLE_OR_RECALLED)
		SSshuttle.emergency.request(silent = TRUE)
		priority_announce("The shift has come to an end and the shuttle called. [SSsecurity_level.get_current_level_as_number() == SEC_LEVEL_RED ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]It will arrive in [emergency.timeLeft(600)] minutes.", null, ANNOUNCER_SHUTTLECALLED, "Priority", color_override = "orange")
		log_game("Round end vote passed. Shuttle has been auto-called.")
		message_admins("Round end vote passed. Shuttle has been auto-called.")
	emergency_no_recall = TRUE
	endvote_passed = TRUE
	SSevents.can_fire = FALSE // we're going home

/datum/controller/subsystem/shuttle/proc/revert_end_of_shift()
	emergency_no_recall = FALSE
	endvote_passed = FALSE
	SSevents.can_fire = TRUE
