/**
 * A simple voting system to replace the current random events, if no votes are recieved, it will be random.
 */

#define LOW_CHAOS_TIMER_LOWER 10 MINUTES
#define LOW_CHAOS_TIMER_UPPER 20 MINUTES
/// How long does the vote last?
#define EVENT_VOTE_TIME 1 MINUTES
/// How many events will be selected for a particular vote?
#define EVENT_VOTABLES 5

/datum/controller/subsystem/events
	/// List of current events and votes
	var/list/votes = list()
	/// A list of events that can be chosen from
	var/list/possible_events = list()
	/// Events that have passed previously
	var/list/passed = list()
	/// Is the current vote admin only?
	var/admin_only = TRUE
	/// If we are not admin only, do we show the votes and vote outcome?
	var/show_votes = FALSE
	/// Is there currently a vote in progress?
	var/vote_in_progress = FALSE
	/// When the vote will end
	var/vote_end_time = 0
	/// Our current timer ID.
	var/timer_id
	/// A reference to our generated actions, for deletion later.
	var/generated_actions = list()
	/// Our next random low event timer
	var/scheduled_low_chaos = 0
	/// The min amount of time till the next low chaos event
	var/low_chaos_timer_lower = LOW_CHAOS_TIMER_LOWER
	/// Ditto, but max
	var/low_chaos_timer_upper = LOW_CHAOS_TIMER_UPPER

/// Reschedules our low-chaos event timer
/datum/controller/subsystem/events/proc/reschedule_low_chaos(time)
	if(time)
		scheduled_low_chaos = world.time + time
	else
		scheduled_low_chaos = world.time + rand(LOW_CHAOS_TIMER_LOWER, max(LOW_CHAOS_TIMER_LOWER,LOW_CHAOS_TIMER_UPPER))

/// Triggers a random low chaos event
/datum/controller/subsystem/events/proc/trigger_low_chaos_event()
	var/list/low_chaos_events = list()
	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	for(var/datum/round_event_control/event in control)
		if(!event.chaos_level == EVENT_CHAOS_LOW)
			continue
		if(!event.can_spawn_event(players_amt, SSevents.wizardmode))
			continue
		low_chaos_events += event

	var/datum/round_event_control/event = pick_n_take(low_chaos_events)

	reschedule_low_chaos()
	SSevents.passed += event
	event.run_event(TRUE)

/// Starts a vote.
/datum/controller/subsystem/events/proc/start_vote_admin()
	if(!LAZYLEN(GLOB.admins)) // If there are no admins online, just revert to the normal system.
		spawnEvent()
		return
	if(vote_in_progress) // We don't want two votes at once.
		message_admins("EVENT: Attempted to start a vote while one was already in progress.")
		return

	var/possible_votes = list()
	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)

	for(var/datum/round_event_control/event in SSevents.control)
		if(istype(event, /datum/round_event_control/veto))
			possible_events += event // always add veto
			continue
		if(!event.chaos_level || event.chaos_level > EVENT_CHAOS_MED)
			continue
		if(!event.can_spawn_vote(players_amt))
			continue
		possible_votes += event

	for(var/i in 1 to EVENT_VOTABLES)
		possible_events += pick_n_take(possible_votes)

	message_admins(span_boldannounce("EVENT: Vote started for next event! (<a href='?src=[REF(src)];[HrefToken()];open_panel=1'>Vote!</a>)"))

	for(var/client/admin_client in GLOB.admins)
		var/datum/action/vote_event/event_action = new
		admin_client.player_details.player_actions += event_action
		event_action.Grant(admin_client.mob)
		generated_actions += event_action
		if(admin_client?.prefs?.toggles & SOUND_ADMINHELP)
			SEND_SOUND(admin_client.mob, sound('sound/misc/bloop.ogg')) // Admins need a little boop.

	timer_id = addtimer(CALLBACK(src, .proc/end_vote), EVENT_VOTE_TIME, TIMER_STOPPABLE)
	vote_in_progress = TRUE
	vote_end_time = world.time + EVENT_VOTE_TIME

/datum/controller/subsystem/events/proc/start_vote_admin_chaos()
	if(!LAZYLEN(GLOB.admins)) // If there are no admins online, just revert to the normal system.
		spawnEvent()
		return
	if(vote_in_progress) // We don't want two votes at once.
		message_admins("EVENT: Attempted to start a vote while one was already in progress.")
		return

	// Direct chat link is good.
	message_admins(span_boldannounce("EVENT: Vote started for next event! (<a href='?src=[REF(src)];[HrefToken()];open_panel=1'>Vote!</a>)"))

	for(var/client/admin_client in GLOB.admins)
		var/datum/action/vote_event/event_action = new
		admin_client.player_details.player_actions += event_action
		event_action.Grant(admin_client.mob)
		generated_actions += event_action
		if(admin_client?.prefs?.toggles & SOUND_ADMINHELP)
			SEND_SOUND(admin_client.mob, sound('sound/misc/bloop.ogg')) // Admins need a little boop.

	var/possible_votes = list()
	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)

	for(var/datum/round_event_control/event in SSevents.control)
		if(istype(event, /datum/round_event_control/veto))
			possible_events += event
			continue
		if(event.chaos_level <= EVENT_CHAOS_LOW)
			continue
		if(!event.can_spawn_vote(players_amt))
			continue
		possible_votes += event

	for(var/i in 1 to EVENT_VOTABLES)
		possible_events += pick_n_take(possible_votes)

	timer_id = addtimer(CALLBACK(src, .proc/end_vote), EVENT_VOTE_TIME, TIMER_STOPPABLE)
	vote_in_progress = TRUE
	vote_end_time = world.time + EVENT_VOTE_TIME

/datum/controller/subsystem/events/proc/start_player_vote(public_outcome = FALSE)
	if(vote_in_progress) // We don't want two votes at once.
		message_admins("EVENT: Attempted to start a vote while one was already in progress.")
		return

	show_votes = public_outcome
	admin_only = FALSE

	var/possible_votes = list()
	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)

	for(var/datum/round_event_control/event in SSevents.control)
		if(istype(event, /datum/round_event_control/veto))
			possible_events += event
			continue
		if(!event.chaos_level || event.chaos_level > EVENT_CHAOS_MED)
			continue
		if(!event.can_spawn_vote(players_amt))
			continue
		possible_votes += event

	for(var/i in 1 to EVENT_VOTABLES)
		possible_events += pick_n_take(possible_votes)

	// Direct chat link is good.
	for(var/mob/iterating_user in get_eligible_players())
		vote_message(iterating_user, "Vote started for next event! (<a href='?src=[REF(src)];open_panel=1'>Vote!</a>)")
		SEND_SOUND(iterating_user, sound('sound/misc/bloop.ogg')) // a little boop.
		if(iterating_user.client)
			var/client/user_client = iterating_user.client
			var/datum/action/vote_event/event_action = new
			user_client?.player_details?.player_actions += event_action
			event_action.Grant(iterating_user)
			generated_actions += event_action

	timer_id = addtimer(CALLBACK(src, .proc/end_vote), EVENT_VOTE_TIME, TIMER_STOPPABLE)
	vote_in_progress = TRUE
	vote_end_time = world.time + EVENT_VOTE_TIME

/datum/controller/subsystem/events/proc/start_player_vote_chaos(public_outcome = FALSE)
	if(vote_in_progress) // We don't want two votes at once.
		message_admins("EVENT: Attempted to start a vote while one was already in progress.")
		return

	show_votes = public_outcome
	admin_only = FALSE

	var/possible_votes = list()
	var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)

	for(var/datum/round_event_control/event in SSevents.control)
		if(istype(event, /datum/round_event_control/veto))
			possible_events += event
			continue
		if(event.chaos_level <= EVENT_CHAOS_LOW)
			continue
		if(!event.can_spawn_vote(players_amt))
			continue
		possible_votes += event

	for(var/i in 1 to EVENT_VOTABLES)
		possible_events += pick_n_take(possible_votes)

	// Direct chat link is good.
	for(var/mob/iterating_user in get_eligible_players())
		vote_message(iterating_user, "Vote started for next event! (<a href='?src=[REF(src)];open_panel=1'>Vote!</a>)")
		SEND_SOUND(iterating_user, sound('sound/misc/bloop.ogg')) // a little boop.
		if(iterating_user.client)
			var/client/user_client = iterating_user.client
			var/datum/action/vote_event/event_action = new
			user_client?.player_details?.player_actions += event_action
			event_action.Grant(iterating_user)
			generated_actions += event_action

	timer_id = addtimer(CALLBACK(src, .proc/end_vote), EVENT_VOTE_TIME, TIMER_STOPPABLE)
	vote_in_progress = TRUE
	vote_end_time = world.time + EVENT_VOTE_TIME

/// Cancels a vote outright, and does not execute the event.
/datum/controller/subsystem/events/proc/cancel_vote(mob/user)
	if(!vote_in_progress)
		return
	message_admins("EVENT: [key_name_admin(user)] cancelled the current vote.")
	reset()

/// Returns any eligible to vote players.
/datum/controller/subsystem/events/proc/get_eligible_players()
	var/list/eligible_players = list()
	for(var/mob/iterating_user in GLOB.player_list)
		if(!(check_rights_for(iterating_user, R_ADMIN)) && (isdead(iterating_user) || !(iterating_user.mind?.assigned_role.job_flags & JOB_CREW_MEMBER)))
			continue
		eligible_players += iterating_user
	return eligible_players

/// Ends the vote there and then, and executes the event.
/datum/controller/subsystem/events/proc/end_vote()
	if(!LAZYLEN(votes))
		message_admins("EVENT: No votes cast, spawning random event!")
		if(show_votes && !admin_only)
			for(var/mob/iterating_user in get_eligible_players())
				vote_message(iterating_user, "No votes cast, spawning random event!")
		reset()
		spawnEvent()
		return

	var/list/event_weighted_list = list() //We convert the list of votes into a weighted list.

	for(var/iterating_event in votes)
		event_weighted_list[iterating_event] = LAZYLEN(votes[iterating_event])

	var/highest_weight = 0
	var/list/tying_results = list() // If we have a tie, pick a random one from the tie.
	var/datum/round_event_control/winner
	for(var/iterating_event in event_weighted_list)
		if(event_weighted_list[iterating_event] > highest_weight)
			highest_weight = event_weighted_list[iterating_event]
			winner = iterating_event
			tying_results = list() // Clear the tying results if there's a higher winner
		if(event_weighted_list[iterating_event] == highest_weight)
			tying_results += iterating_event

	if(LAZYLEN(tying_results) > 1) // If there's a tie, we need to pick a random one.
		winner = pick(tying_results)

	var/total_votes = 0
	var/list/log_data = list("EVENT VOTE LOG ([world.time])")
	for(var/datum/round_event_control/control in event_weighted_list)
		log_data += "Event vote: [control.name] | VOTES: [event_weighted_list[control]]"
		if(admin_only)
			for(var/admin as anything in votes[control])
				log_data += " - - [admin]"
		total_votes += event_weighted_list[control]

	log_data += "TOTAL VOTES: [total_votes]"
	log_data += "TOTAL PLAYERS: [get_active_player_count(TRUE, TRUE, TRUE)]"
	log_data += "TYPE: [admin_only ? "admin_only" : "public"]"
	log_data += "WINNER: [winner.name]"

	log_event_vote(log_data.Join("\n"))

	if(!winner) //If for whatever reason the algorithm breaks, we still want an event.
		message_admins("EVENT: Vote error, spawning random event!")
		if(show_votes && !admin_only)
			for(var/mob/iterating_user in get_eligible_players())
				vote_message(iterating_user, "Vote error, spawning random event!")
		reset()
		spawnEvent()
		return

	message_admins("EVENT: Vote ended! Winning Event: [winner.name]")
	if(show_votes && !admin_only)
		for(var/mob/iterating_user in get_eligible_players())
			vote_message(iterating_user, "Vote ended! Winning Event: [winner.name]")

	winner.run_event(TRUE)
	SSevents.passed += winner
	reset()

/// Sends the user a formatted message
/datum/controller/subsystem/events/proc/vote_message(mob/user, message)
	to_chat(user, span_infoplain(span_purple("<b>EVENT: [message]</b>")))

/// Proc to reset the vote system to be ready for a new vote.
/datum/controller/subsystem/events/proc/reset()
	remove_action_buttons()
	vote_in_progress = FALSE
	vote_end_time = 0
	admin_only = TRUE
	show_votes = FALSE
	votes = list()
	possible_events = list()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

/// Simply registeres someones vote.
/datum/controller/subsystem/events/proc/register_vote(mob/user, datum/round_event_control/event)
	if(!(user in get_eligible_players()))
		to_chat(user, span_warning("Error, you are not eligible to vote!"))
		return
	if(!(event in votes))
		votes[event] = list()

	var/true_ckey = ckey(user.ckey)

	if(true_ckey in votes[event])
		return

	for(var/iterating_event in votes) // We first check if the user has already voted for something
		if(true_ckey in votes[iterating_event])
			votes[iterating_event] -= true_ckey // If they have, we remove that vote

	votes[event] += true_ckey // Then we add the new vote

	for(var/iterating_event in votes) // We have to check if the votes have nothing in them AFTER we have added the clients vote
		if(LAZYLEN(votes[iterating_event]) <= 0)
			votes -= iterating_event

/// Checks what someone has voted for, if anything.
/datum/controller/subsystem/events/proc/check_vote(ckey)
	var/true_ckey = ckey(ckey)
	for(var/datum/round_event_control/iterating_event in votes)
		if(true_ckey in votes[iterating_event])
			return iterating_event.type
	return FALSE

/// Event can_spawn for the event voting system.
/datum/round_event_control/proc/can_spawn_vote(players_amt)
	if(earliest_start >= world.time - SSticker.round_start_time)
		return FALSE
	if(players_amt < min_players)
		return FALSE
	if(occurrences >= max_occurrences)
		return FALSE
	if(holidayID && !check_holidays(holidayID))
		return FALSE
	if(wizardevent && SSevents.wizardmode != wizardevent)
		return FALSE
	if(EMERGENCY_ESCAPED_OR_ENDGAMED)
		return FALSE
	if(ispath(typepath, /datum/round_event/ghost_role) && !(GLOB.ghost_role_flags & GHOSTROLE_MIDROUND_EVENT))
		return FALSE

	return TRUE

/datum/controller/subsystem/events/proc/remove_action_buttons()
	for(var/datum/action/vote_event/iterating_action in generated_actions)
		if(!QDELETED(iterating_action))
			iterating_action.remove_from_client()
			iterating_action.Remove(iterating_action.owner)
	generated_actions = list()

/datum/controller/subsystem/events/proc/reschedule_custom(time)
	if(!time)
		scheduled = world.time + rand(frequency_lower, max(frequency_lower,frequency_upper))
	else
		scheduled = world.time + time

/datum/controller/subsystem/events/Topic(href, list/href_list)
	..()
	if(admin_only && !check_rights(R_ADMIN, FALSE))
		return
	if(href_list["open_panel"])
		ui_interact(usr)

/datum/controller/subsystem/events/ui_interact(mob/user, datum/tgui/ui)
	if(admin_only && !check_rights_for(user.client, R_ADMIN))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EventPanel")
		ui.open()

/datum/controller/subsystem/events/ui_state(mob/user)
	return GLOB.always_state

/datum/controller/subsystem/events/ui_data(mob/user)
	if(admin_only && !check_rights_for(user.client, R_ADMIN))
		return
	var/list/data = list()

	data["end_time"] = (vote_end_time - world.time) / 10

	data["vote_in_progress"] = vote_in_progress

	data["admin_mode"] = check_rights_for(user.client, R_ADMIN)

	data["next_vote_time"] = (scheduled - world.time) / 10

	data["next_low_chaos_time"] = (scheduled_low_chaos - world.time) / 10

	data["show_votes"] = show_votes

	data["previous_events"] = list()

	for(var/datum/round_event_control/iterating_event in passed)
		data["previous_events"] += iterating_event.name

	// Build a list of runnable events.
	data["event_list"] = list()

	for(var/datum/round_event_control/iterating_event in possible_events)
		data["event_list"] += list(list(
			"name" = iterating_event.name,
			"ref" = REF(iterating_event),
			"votes" = LAZYLEN(votes[iterating_event]),
			"self_vote" = istype(iterating_event, check_vote(user.ckey)) ? TRUE : FALSE,
		))

	return data

/datum/controller/subsystem/events/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(admin_only && !check_rights(R_ADMIN, FALSE))
		return

	switch(action)
		if("register_vote")
			var/selected_event = locate(params["event_ref"]) in SSevents.control
			if(!selected_event)
				return
			register_vote(usr, selected_event)
			return
		if("end_vote")
			if(!check_rights(R_ADMIN))
				return
			end_vote(usr)
			return
		if("cancel_vote")
			if(!check_rights(R_ADMIN))
				return
			cancel_vote(usr)
			return
		if("start_vote_admin")
			if(!check_rights(R_ADMIN))
				return
			start_vote_admin()
			return
		if("start_vote_admin_chaos")
			if(!check_rights(R_ADMIN))
				return
			start_vote_admin_chaos()
			return
		if("start_player_vote")
			if(!check_rights(R_ADMIN))
				return
			var/alert_vote = tgui_alert(usr, "Do you want to show the vote outcome?", "Vote outcome", list("Yes", "No"))
			if(!alert_vote)
				return
			var/public_vote = FALSE
			if(alert_vote == "Yes")
				public_vote = TRUE
			start_player_vote(public_vote)
			return
		if("start_player_vote_chaos")
			if(!check_rights(R_ADMIN))
				return
			var/alert_vote = tgui_alert(usr, "Do you want to show the vote outcome?", "Vote outcome", list("Yes", "No"))
			if(!alert_vote)
				return
			var/public_vote = FALSE
			if(alert_vote == "Yes")
				public_vote = TRUE
			start_player_vote_chaos(public_vote)
			return
		if("reschedule")
			if(!check_rights(R_ADMIN))
				return
			var/alert = tgui_alert(usr, "Set custom time?", "Custom time", list("Yes", "No"))
			if(!alert)
				return
			var/time
			if(alert == "Yes")
				time = tgui_input_number(usr, "Input custom time in seconds", "Custom time", 60, 6000, 1) * 10
			reschedule_custom(time)
			message_admins("[key_name_admin(usr)] has rescheduled the event system.")
			return
		if("reschedule_low_chaos")
			if(!check_rights(R_ADMIN))
				return
			var/alert = tgui_alert(usr, "Set custom time?", "Custom time", list("Yes", "No"))
			if(!alert)
				return
			var/time
			if(alert == "Yes")
				time = tgui_input_number(usr, "Input custom time in seconds", "Custom time", 60, 6000, 1) * 10
			if(!check_rights(R_ADMIN))
				return
			reschedule_low_chaos(time)
			message_admins("[key_name_admin(usr)] has rescheduled the LOW CHAOS event system.")
			return


ADMIN_VERB(event_panel, R_FUN, "Event Panel", "Event Poling Panel.", ADMIN_CATEGORY_EVENTS)
	user.holder.event_panel()

// Panel for admins
/datum/admins/proc/event_panel()
	if(!check_rights(R_FUN))
		return
	SSevents.ui_interact(usr)

// Panel for everyone
/mob/verb/event_vote()
	set category = "OOC"
	set name = "Event Vote"
	if(!SSevents.vote_in_progress)
		to_chat(usr, span_warning("No vote in progress."))
		return
	if(SSevents.admin_only && !check_rights(R_ADMIN, FALSE))
		to_chat(usr, span_warning("You do not have permission to vote."))
		return
	if(!(usr in SSevents.get_eligible_players()))
		to_chat(usr, span_warning("You cannot vote!"))
		return
	SSevents.ui_interact(usr)

// Action button for vote, works like the vote system!
/datum/action/vote_event
	name = "Event Vote!"
	button_icon_state = "vote"

/datum/action/vote_event/Trigger(trigger_flags)
	if(owner)
		owner.event_vote()

/datum/action/vote_event/IsAvailable(feedback = FALSE)
	return TRUE

/datum/action/vote_event/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/player_deets = GLOB.player_details[owner.ckey]
		if(player_deets)
			player_deets.player_actions -= src

/proc/log_event_vote(text)
	if (CONFIG_GET(flag/log_event_votes))
		WRITE_LOG(GLOB.event_vote_log, "EVENT: [text]")

/proc/debug_event_printout()
	for(var/datum/round_event_control/event in SSevents.control)
		to_chat(world, "[event.name] | [event.chaos_level]")

#undef LOW_CHAOS_TIMER_LOWER
#undef LOW_CHAOS_TIMER_UPPER
#undef EVENT_VOTE_TIME
#undef EVENT_VOTABLES
