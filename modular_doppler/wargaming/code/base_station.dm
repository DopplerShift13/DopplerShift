/obj/item/wargame_base_station
	name = "wargames base station"
	desc = "A base station for holographic wargames, all controllers and interactive wearables link to this machine and are automatically managed by it."
	icon = 'modular_doppler/wargaming/icons/items.dmi'
	icon_state = "basestation"
	lefthand_file = 'modular_doppler/wargaming/icons/mob/lefthand.dmi'
	righthand_file = 'modular_doppler/wargaming/icons/mob/righthand.dmi'
	inhand_icon_state = "generic"
	worn_icon = 'modular_doppler/wargaming/icons/mob/worn.dmi'
	worn_icon_state = "controller"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON
	drop_sound = 'sound/items/handling/tools/rcd_drop.ogg'
	pickup_sound = 'sound/items/handling/tools/rcd_pickup.ogg'
	do_not_override_chat_colors = TRUE
	slot_flags = ITEM_SLOT_BELT
	chat_color = LIGHT_COLOR_COPPER_OXIDE
	/// List of all team datums this controller is currently managing, empty teams are cleared at game start
	var/list/managed_teams = list()
	/// Nebulous list of teams per round, subtracted from as teams complete their turns
	var/list/teams_per_turn = list()
	/// What phase of the game are we currently in
	var/game_phase = WARGAME_PHASE_NOTHING
	/// The turn mode we are using, one team at a time or all at once
	var/turn_mode = WARGAME_TURN_MODE_STANDARD
	/// Which team's turn is it right now?
	var/datum/wargaming_team/team_turn
	/// How many turns have passed
	var/turn_counter = 1
	/// List of any terrain projectors linked to us
	var/list/terrain_projectors = list()
	/// Radial options for before the game has been started
	var/static/list/pre_game_radial_options = list(
		BASESTATION_JOIN_LEAVE = image(icon = WARGAME_ACTIONS_FILE, icon_state = "join_team"),
		BASESTATION_ADD_TEAM = image(icon = WARGAME_ACTIONS_FILE, icon_state = "add_team"),
		BASESTATION_REMOVE_TEAM = image(icon = WARGAME_ACTIONS_FILE, icon_state = "delete_team"),
		BASESTATION_EDIT_TEAM = image(icon = WARGAME_ACTIONS_FILE, icon_state = "edit_team"),
		BASESTATION_RESET = image(icon = WARGAME_ACTIONS_FILE, icon_state = "reset"),
		BASESTATION_START = image(icon = WARGAME_ACTIONS_FILE, icon_state = "start_game"),
	)
	/// Radial options for after the game has already been started
	var/static/list/mid_game_radial_options = list(
		BASESTATION_END = image(icon = WARGAME_ACTIONS_FILE, icon_state = "end_game"),
		BASESTATION_NEXT = image(icon = WARGAME_ACTIONS_FILE, icon_state = "next_phase"),
	)
	/// Radial options for editing a team
	var/static/list/team_edit_radial_options = list(
		BASESTATION_TEAM_NAME = image(icon = WARGAME_ACTIONS_FILE, icon_state = "team_name"),
		BASESTATION_TEAM_COLOR = image(icon = WARGAME_ACTIONS_FILE, icon_state = "team_color"),
		BASESTATION_TEAM_COMMANDER = image(icon = WARGAME_ACTIONS_FILE, icon_state = "team_commander"),
		BASESTATION_TEAM_PREFIX = image(icon = WARGAME_ACTIONS_FILE, icon_state = "team_prefix"),
	)

/obj/item/wargame_base_station/Initialize(mapload)
	. = ..()
	register_context()
	if(prob(0.01))
		make_special_edition()

/obj/item/wargame_base_station/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Open console menu"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/wargame_base_station/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "basestation_emissive", src, alpha = 100)

/// Turns the console gold and gives it a silly name
/obj/item/wargame_base_station/proc/make_special_edition()
	name = "\improper DopplerStation 2"
	desc = "A base station for holographic wargames, all controllers and interactive wearables link to this machine and are automatically managed by it. \
		This looks like the special pre-order edition of the console, how did one of these get out this far? The faceplate has been replaced with one \
		plated in gold, and someone seems to have left a sticker of a little dolphin on the case. \
		Whoever owned this before must lament their purchase every day, this thing only has one game on it!"
	icon_state = "basestation_gold"
	update_appearance(UPDATE_ICON)

/obj/item/wargame_base_station/examine(mob/user)
	. = ..()
	. += span_notice("Interact with the menu with [EXAMINE_HINT("Alt-Click")].")
	// Game stats
	var/game_stats_text = ""
	game_stats_text += "The game is currently in the [game_phase_2_text(game_phase)] phase.<br>"
	if(turn_mode == WARGAME_TURN_MODE_SIMULTANEOUS)
		game_stats_text += "The game is in simultaneous turns mode, all teams may make actions.<br>"
	else if(team_turn)
		game_stats_text += "It is the turn of team [team_turn.team_name].<br>"
	game_stats_text += game_phase_2_desc(game_phase)
	game_stats_text += "The teams have completed [EXAMINE_HINT("[turn_counter - 1]")] total turns.<br>"
	. += fieldset_block(game_phase_2_text(game_phase, TRUE), game_stats_text, "boxed_message")
	// Player and team stats
	for(var/team as anything in managed_teams)
		var/datum/wargaming_team/team_datum = managed_teams[team]
		var/team_display = ""
		if(length(team_datum.team_players))
			team_display += "Composed of [length(team_datum.team_players)] players:<br>"
			for(var/mob/living/player_on_team as anything in team_datum.team_players)
				team_display += "	- [player_on_team.get_visible_name()]<br>"
		else
			team_display = "Team currently empty."
		. += fieldset_block(span_bold(team), team_display, "boxed_message")

/obj/item/wargame_base_station/click_alt(mob/living/user)
	var/picked_choice = show_radial_menu(user, src, (game_phase == WARGAME_PHASE_NOTHING) ? pre_game_radial_options : mid_game_radial_options, require_near = TRUE, tooltips = TRUE)
	if(isnull(picked_choice))
		play_menu_sound()
		return CLICK_ACTION_BLOCKING
	switch(picked_choice)
		// Pregame options
		if(BASESTATION_JOIN_LEAVE)
			play_menu_sound()
			try_join_leave(user)
		if(BASESTATION_ADD_TEAM)
			play_menu_sound()
			create_new_team(user)
		if(BASESTATION_REMOVE_TEAM)
			play_menu_sound()
			delete_team(user)
		if(BASESTATION_EDIT_TEAM)
			play_menu_sound()
			edit_a_team(user)
		if(BASESTATION_RESET)
			play_menu_sound()
			reset_everything(user)
		if(BASESTATION_START)
			play_menu_sound()
			start_the_game(user)
		// Midgame options
		if(BASESTATION_END)
			play_menu_sound()
			end_the_game(user)
		if(BASESTATION_NEXT)
			play_menu_sound()
			advance_phase(user)
	return CLICK_ACTION_SUCCESS

/// Converts a given game phase number to text
/obj/item/wargame_base_station/proc/game_phase_2_text(phase, capital)
	switch(phase)
		if(WARGAME_PHASE_PLACEMENT)
			return capital ? "Placement" : "placement"
		if(WARGAME_PHASE_ACTION)
			return capital ? "Action" : "action"
		if(WARGAME_PHASE_EFFECTS)
			return capital ? "Effects" : "effects"
		if(WARGAME_PHASE_NOTHING)
			return capital ? "Pre-Game" : "pre-game"

/// Converts a given game phase number to a description of it
/obj/item/wargame_base_station/proc/game_phase_2_desc(phase)
	switch(phase)
		if(WARGAME_PHASE_PLACEMENT)
			return "All teams should use their hologram projectors to create their fleets during this phase, this will be the only opportunity \
				to use the projectors. If battlespace terrain and hazards are desired, the tertiary \"Terrain\" projector should be linked and \
				used instead.<br>"
		if(WARGAME_PHASE_ACTION)
			return "All units on the team who's turn it currently is are allowed to use their action points to move, attack, etc. Events such as \
				ship destruction will not take place until the next phase.<br>"
		if(WARGAME_PHASE_EFFECTS)
			return "In this phase, effects such as ships exploding due to damage are processed. This may take up to a few seconds per event, and \
				control to skip to the next phase will be locked until all effects have been handled.<br>"
		if(WARGAME_PHASE_NOTHING)
			return "The game is currently in the pre-game lobby, nothing will happen until the \"Start Game\" option has been chosen in the menu. \
				In order to start, the game needs at least two teams with at least one person each. These do not need to be different people, allowing \
				for solo play.<br>"

/// Updates every hologram run by a terrain projector
/obj/item/wargame_base_station/proc/update_terrain_holograms()
	for(var/obj/item/wargame_projector/projector as anything in terrain_projectors)
		for(var/obj/structure/wargame_hologram/hologram as anything in projector.projections)
			if(hologram.controllable)
				hologram.unit_stats.effects_phase_process(hologram)

#define MY_CHILD_WILL "Yes"
#define MY_CHILD_WILL_NOT "No"

#define JOIN_A_TEAM "Join"
#define LEAVE_A_TEAM "Leave"

/// Allows the user to join or leave a team of their choosing
/obj/item/wargame_base_station/proc/try_join_leave(mob/living/user)
	if(game_phase != WARGAME_PHASE_NOTHING)
		balloon_alert(user, "already in progress!")
		return
	var/option = tgui_alert(user, "Join or leave a team?", "Team Manager", list(JOIN_A_TEAM, LEAVE_A_TEAM))
	if(isnull(option))
		balloon_alert(user, "no choice made!")
		play_menu_sound()
		return
	play_menu_sound()
	switch(option)
		if(JOIN_A_TEAM)
			var/picked_team = tgui_input_list(user, "Choose which team to join.", "Team Manager", managed_teams)
			if(isnull(picked_team))
				balloon_alert(user, "no choice made!")
				play_menu_sound()
				return
			var/datum/wargaming_team/wargame_team = managed_teams[picked_team]
			if(user in wargame_team.team_players)
				balloon_alert(user, "already in!")
				play_menu_sound()
				return
			wargame_team.team_players += user
			play_menu_sound()
		if(LEAVE_A_TEAM)
			var/picked_team = tgui_input_list(user, "Choose which team to leave.", "Team Manager", managed_teams)
			if(isnull(picked_team))
				balloon_alert(user, "no choice made!")
				play_menu_sound()
				return
			var/datum/wargaming_team/wargame_team = managed_teams[picked_team]
			if(!(user in wargame_team.team_players))
				balloon_alert(user, "not in team!")
				play_menu_sound()
				return
			wargame_team.team_players -= user
			play_menu_sound()

#undef JOIN_A_TEAM
#undef LEAVE_A_TEAM

/// Advances to the next phase, changing to the next team in the list
/obj/item/wargame_base_station/proc/advance_phase(mob/living/user)
	if(game_phase == WARGAME_PHASE_NOTHING)
		balloon_alert(user, "not running!")
		return // ??
	var/certainty = tgui_alert(user, "Advance to the next game phase?", "Advance Phase", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty != MY_CHILD_WILL)
		return
	switch(game_phase)
		if(WARGAME_PHASE_PLACEMENT)
			switch(turn_mode)
				if(WARGAME_TURN_MODE_STANDARD)
					team_turn.ready_all_units()
					say("Action phase, [team_turn.team_name], turn [turn_counter].")
				if(WARGAME_TURN_MODE_SIMULTANEOUS)
					for(var/datum/wargaming_team/starting_team as anything in just_team_datums())
						starting_team.ready_all_units()
					say("Action phase, all teams, turn [turn_counter].")
			game_phase = WARGAME_PHASE_ACTION
		if(WARGAME_PHASE_ACTION)
			if(!length(teams_per_turn) || turn_mode == WARGAME_TURN_MODE_SIMULTANEOUS)
				update_terrain_holograms()
				say("Effects phase, turn [turn_counter].")
				for(var/datum/wargaming_team/team as anything in just_team_datums())
					team.update_all_units()
				game_phase = WARGAME_PHASE_EFFECTS
			else
				game_phase = WARGAME_PHASE_ACTION
				team_turn = teams_per_turn[1]
				team_turn.ready_all_units()
				teams_per_turn -= team_turn
				say("Action phase, [team_turn.team_name], turn [turn_counter].")
		if(WARGAME_PHASE_EFFECTS)
			turn_counter += 1
			say("Turn [turn_counter - 1] complete, beginning turn [turn_counter].")
			switch(turn_mode)
				if(WARGAME_TURN_MODE_STANDARD)
					teams_per_turn = just_team_datums()
					team_turn = teams_per_turn[1]
					team_turn.ready_all_units()
					teams_per_turn -= team_turn
					say("Action phase, [team_turn.team_name], turn [turn_counter].")
				if(WARGAME_TURN_MODE_SIMULTANEOUS)
					for(var/datum/wargaming_team/starting_team as anything in just_team_datums())
						starting_team.ready_all_units()
					say("Action phase, all teams, turn [turn_counter].")
			game_phase = WARGAME_PHASE_ACTION
	play_menu_sound()

/// Ends the game if it is currently running
/obj/item/wargame_base_station/proc/end_the_game(mob/living/user)
	if(game_phase == WARGAME_PHASE_NOTHING)
		balloon_alert(user, "already stopped!")
		return
	var/certainty = tgui_alert(user, "Are you certain you wish to end the game?", "Game Ender", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty != MY_CHILD_WILL)
		play_menu_sound()
		return
	game_phase = WARGAME_PHASE_NOTHING
	play_menu_sound()
	say("Game ended.")

/// Starts the game if it has not already been started
/obj/item/wargame_base_station/proc/start_the_game(mob/living/user)
	// Verify that the game can actually be started or if it has already started
	if(game_phase != WARGAME_PHASE_NOTHING)
		balloon_alert(user, "already started!")
		return
	var/number_of_valid_teams = 0
	for(var/team as anything in managed_teams)
		var/datum/wargaming_team/team_datum = managed_teams[team]
		if(length(team_datum.team_players))
			number_of_valid_teams++
	if(number_of_valid_teams <= 1) // This counts teams that actually have players in them
		balloon_alert(user, "too few teams!")
		return
	// Check if we actually want to start the game
	var/certainty = tgui_alert(user, "Are you certain you wish to start the game?", "Game Starter", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty != MY_CHILD_WILL)
		play_menu_sound()
		return
	// Select what turn mode to use, sequential means one team goes at a time, simultaneous means all teams can move at once.
	var/turn_mode_choice = tgui_alert(user, "Select turn mode. Sequential: One team making actions at a time, rotating. Simultaneous: All teams act at once.", "Turn Mode", list(WARGAME_TURN_MODE_STANDARD, WARGAME_TURN_MODE_SIMULTANEOUS))
	if(isnull(turn_mode_choice))
		balloon_alert(user, "no choice made!")
		play_menu_sound()
		return
	turn_mode = turn_mode_choice
	// Actually start the game now
	game_phase = WARGAME_PHASE_PLACEMENT
	for(var/team as anything in managed_teams)
		var/datum/wargaming_team/team_datum = managed_teams[team]
		if(!length(team_datum.team_players))
			qdel(team_datum)
			managed_teams -= team // Empty teams are wiped before the game starts
	if(turn_mode == WARGAME_TURN_MODE_STANDARD)
		shuffle(managed_teams)
		teams_per_turn = just_team_datums()
		team_turn = teams_per_turn[1]
		teams_per_turn -= team_turn
	turn_counter = 1
	play_menu_sound()
	say("Beginning game, placement phase.")

/// Returns a list of just team datums from the managed_teams list
/obj/item/wargame_base_station/proc/just_team_datums()
	var/team_list = list()
	for(var/team as anything in managed_teams)
		team_list += managed_teams[team]
	return team_list

/// Asks for confirmation before deleting every team
/obj/item/wargame_base_station/proc/reset_everything(mob/living/user)
	var/certainty = tgui_alert(user, "Are you certain you wish to delete every team?", "Deletion Confirmation", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty == MY_CHILD_WILL)
		for(var/team as anything in managed_teams)
			qdel(managed_teams[team])
			managed_teams -= team
	play_menu_sound()

/// Selects a team and edits the name or color
/obj/item/wargame_base_station/proc/edit_a_team(mob/living/user)
	var/editing_team = tgui_input_list(user, "Choose which team you wish to edit.", "Team List", managed_teams)
	if(isnull(editing_team))
		balloon_alert(user, "no choice!")
		play_menu_sound()
		return
	play_menu_sound()
	show_team_edit_radial(user, managed_teams[editing_team])

/// Constantly shows a radial for editing a team until cancelled
/obj/item/wargame_base_station/proc/show_team_edit_radial(mob/living/user, datum/wargaming_team/edited_team)
	var/picked_choice = show_radial_menu(user, src, team_edit_radial_options, require_near = TRUE, tooltips = TRUE)
	if(isnull(picked_choice))
		return
	switch(picked_choice)
		if(BASESTATION_TEAM_NAME)
			var/new_name = tgui_input_text(user, "Give your new team a name.", "Team Name", "Unnamed Combatants")
			if(isnull(new_name))
				balloon_alert(user, "need name!")
				show_team_edit_radial(user, edited_team)
				play_menu_sound()
				return
			if(new_name in managed_teams)
				balloon_alert(user, "name in use!")
				show_team_edit_radial(user, edited_team)
				play_menu_sound()
				return
			play_menu_sound()
			show_team_edit_radial(user, edited_team)
			edited_team.team_name = new_name
		if(BASESTATION_TEAM_COLOR)
			var/new_color = input(user, "Choose your new team color." ,"Color Selection", COLOR_PRIDE_PURPLE) as color|null
			if(isnull(new_color))
				balloon_alert(user, "need color!")
				show_team_edit_radial(user, edited_team)
				play_menu_sound()
				return
			play_menu_sound()
			show_team_edit_radial(user, edited_team)
			edited_team.team_color = new_color
		if(BASESTATION_TEAM_COMMANDER)
			var/new_commander_title = tgui_input_text(user, "How will this team's units address the players? ALL LOWERCASE IF NOT PROPER!", "Commander Title", "fleet")
			if(isnull(new_commander_title))
				balloon_alert(user, "need title!")
				show_team_edit_radial(user, edited_team)
				play_menu_sound()
				return
			play_menu_sound()
			edited_team.team_commander_reference = new_commander_title
			show_team_edit_radial(user, edited_team)
		if(BASESTATION_TEAM_PREFIX)
			var/new_prefix = tgui_input_text(user, "Choose what your ships' automatic titles will be prefixed with, such as 4CA, TTV.", "Ship Name Prefix", "4CA")
			if(isnull(new_prefix))
				balloon_alert(user, "need prefix!")
				show_team_edit_radial(user, edited_team)
				play_menu_sound()
				return
			play_menu_sound()
			edited_team.team_ship_prefix = new_prefix
			show_team_edit_radial(user, edited_team)

/// Lets players pick from a list of existing teams to delete one
/obj/item/wargame_base_station/proc/delete_team(mob/living/user)
	var/deleting_team = tgui_input_list(user, "Choose which team you wish to delete.", "Team List", managed_teams)
	if(isnull(deleting_team))
		balloon_alert(user, "no choice!")
		play_menu_sound()
		return
	var/certainty = tgui_alert(user, "Are you certain you wish to delete [deleting_team]?", "Deletion Confirmation", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty == MY_CHILD_WILL)
		qdel(managed_teams[deleting_team])
		managed_teams -= deleting_team
	play_menu_sound()

/// Interactively create a new team with the user
/obj/item/wargame_base_station/proc/create_new_team(mob/living/user)
	var/datum/wargaming_team/new_team = new()
	var/new_name = tgui_input_text(user, "Give your new team a name.", "Team Name", "Unnamed Combatants")
	if(isnull(new_name)) // How?
		qdel(new_team)
		balloon_alert(user, "needs name!")
		play_menu_sound()
		return
	if(new_name in managed_teams) // This name is already in use, get some new material
		qdel(new_team)
		balloon_alert(user, "name in use!")
		play_menu_sound()
		return
	play_menu_sound()
	new_team.team_name = new_name
	var/new_color = input(user, "Choose your new team color." ,"Color Selection", COLOR_PRIDE_PURPLE) as color|null
	if(isnull(new_color))
		qdel(new_team)
		balloon_alert(user, "needs color!")
		play_menu_sound()
		return
	play_menu_sound()
	new_team.team_color = new_color
	var/new_commander_title = tgui_input_text(user, "How will this team's units address the players? ALL LOWERCASE IF NOT PROPER!", "Commander Title", "fleet")
	if(isnull(new_commander_title))
		balloon_alert(user, "need title!")
		qdel(new_team)
		play_menu_sound()
		return
	play_menu_sound()
	new_team.team_commander_reference = new_commander_title
	var/new_prefix = tgui_input_text(user, "Choose what your ships' automatic titles will be prefixed with, such as 4CA, TTV.", "Ship Name Prefix", "4CA")
	if(isnull(new_prefix))
		balloon_alert(user, "need prefix!")
		qdel(new_team)
		play_menu_sound()
		return
	play_menu_sound()
	new_team.team_ship_prefix = new_prefix
	managed_teams[new_team.team_name] += new_team

/// Plays a clicking sound for menu actions
/obj/item/wargame_base_station/proc/play_menu_sound()
	playsound(src, SFX_REMOTE_MODE_SWITCH, 50, TRUE)

#undef MY_CHILD_WILL
#undef MY_CHILD_WILL_NOT
