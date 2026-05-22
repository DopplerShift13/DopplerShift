#define ACTIONS_FILE 'modular_doppler/wargaming/icons/actions.dmi'

/obj/item/wargame_base_station
	name = "wargames base station"
	desc = "A base station for holographic wargames, all controllers and interactive wearables link to this machine and are automatically managed by it."
	icon = 'modular_doppler/wargaming/icons/items.dmi'
	icon_state = "basestation"
	lefthand_file = 'modular_doppler/wargaming/icons/mob/lefthand.dmi'
	righthand_file = 'modular_doppler/wargaming/icons/mob/righthand.dmi'
	inhand_icon_state = "generic"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON
	/// List of all team datums this controller is currently managing, empty teams are cleared at game start
	var/list/managed_teams = list()
	/// What phase of the game are we currently in
	var/game_phase = WARGAME_PHASE_NOTHING
	/// Radial options for before the game has been started
	var/static/list/pre_game_radial_options = list(
		BASESTATION_ADD_TEAM = image(icon = ACTIONS_FILE, icon_state = "add_team"),
		BASESTATION_REMOVE_TEAM = image(icon = ACTIONS_FILE, icon_state = "delete_team"),
		BASESTATION_EDIT_TEAM = image(icon = ACTIONS_FILE, icon_state = "edit_team"),
		BASESTATION_RESET = image(icon = ACTIONS_FILE, icon_state = "reset"),
		BASESTATION_START = image(icon = ACTIONS_FILE, icon_state = "start_game"),
	)
	/// Radial options for after the game has already been started
	var/static/list/mid_game_radial_options = list(
		BASESTATION_END = image(icon = ACTIONS_FILE, icon_state = "end_game"),
	)
	/// Radial options for editing a team
	var/static/list/team_edit_radial_options = list(
		BASESTATION_TEAM_NAME = image(icon = ACTIONS_FILE, icon_state = "team_name"),
		BASESTATION_TEAM_COLOR = image(icon = ACTIONS_FILE, icon_state = "team_color"),
	)

/obj/item/wargame_base_station/click_alt(mob/living/user)
	var/picked_choice = show_radial_menu(user, src, (game_phase == WARGAME_PHASE_NOTHING) ? pre_game_radial_options : mid_game_radial_options, require_near = TRUE, tooltips = TRUE)
	if(isnull(picked_choice))
		return CLICK_ACTION_BLOCKING
	switch(picked_choice)
		if(BASESTATION_ADD_TEAM)
			create_new_team(user)
		if(BASESTATION_REMOVE_TEAM)
			delete_team(user)
		if(BASESTATION_EDIT_TEAM)
			edit_a_team(user)
		if(BASESTATION_RESET)
			reset_everything(user)
		if(BASESTATION_START)
			start_the_game(user)
		if(BASESTATION_END)
			end_the_game(user)
	return CLICK_ACTION_SUCCESS

#define MY_CHILD_WILL "Yes"
#define MY_CHILD_WILL_NOT "No"

/// Ends the game if it is currently running
/obj/item/wargame_base_station/proc/end_the_game(mob/living/user)
	if(game_phase == WARGAME_PHASE_NOTHING)
		balloon_alert(user, "already stopped!")
		return
	var/certainty = tgui_alert(user, "Are you certain you wish to end the game?", "Game Ender", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty != MY_CHILD_WILL)
		return
	game_phase = WARGAME_PHASE_NOTHING

/// Starts the game if it has not already been started
/obj/item/wargame_base_station/proc/start_the_game(mob/living/user)
	if(game_phase != WARGAME_PHASE_NOTHING)
		balloon_alert(user, "already started!")
		return
	if(length(managed_teams) <= 1)
		balloon_alert(user, "too few teams!")
		return
	var/certainty = tgui_alert(user, "Are you certain you wish to start the game?", "Game Starter", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty != MY_CHILD_WILL)
		return
	game_phase = WARGAME_PHASE_PLACEMENT

/// Asks for confirmation before deleting every team
/obj/item/wargame_base_station/proc/reset_everything(mob/living/user)
	var/certainty = tgui_alert(user, "Are you certain you wish to delete every team?", "Deletion Confirmation", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty == MY_CHILD_WILL)
		if(var/team as anything in managed_teams)
			qdel(managed_teams[team])
			managed_teams -= team

/// Selects a team and edits the name or color
/obj/item/wargame_base_station/proc/edit_a_team(mob/living/user)
	var/editing_team = tgui_input_list(user, "Choose which team you wish to edit.", "Team List", managed_teams)
	if(isnull(editing_team))
		balloon_alert(user, "no choice!")
		return
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
				balloon_alert(user, "needs name!")
				continue
			if(new_name in managed_teams)
				balloon_alert(user, "name in use!")
				continue
			edited_team.team_name = new_name
		if(BASESTATION_TEAM_COLOR)
			var/new_color = input(user, "Choose your new team color." ,"Color Selection", COLOR_PRIDE_PURPLE) as color|null
			if(isnull(new_color))
				balloon_alert(user, "needs color!")
				continue
			edited_team.team_color = new_color
	show_team_edit_radial(user, edited_team)

/// Lets players pick from a list of existing teams to delete one
/obj/item/wargame_base_station/proc/delete_team(mob/living/user)
	var/deleting_team = tgui_input_list(user, "Choose which team you wish to delete.", "Team List", managed_teams)
	if(isnull(deleting_team))
		balloon_alert(user, "no choice!")
		return
	var/certainty = tgui_alert(user, "Are you certain you wish to delete [deleting_team]?", "Deletion Confirmation", list(MY_CHILD_WILL, MY_CHILD_WILL_NOT))
	if(certainty == MY_CHILD_WILL)
		qdel(managed_teams[deleting_team])
		managed_teams -= deleting_team

/// Interactively create a new team with the user
/obj/item/wargame_base_station/proc/create_new_team(mob/living/user)
	var/datum/wargaming_team/new_team = new()
	var/new_name = tgui_input_text(user, "Give your new team a name.", "Team Name", "Unnamed Combatants")
	if(isnull(new_name)) // How?
		qdel(new_team)
		balloon_alert(user, "needs name!")
		return
	if(new_name in managed_teams) // This name is already in use, get some new material
		qdel(new_team)
		balloon_alert(user, "name in use!")
		return
	new_team.team_name = new_name
	var/new_color = input(user, "Choose your new team color." ,"Color Selection", COLOR_PRIDE_PURPLE) as color|null
	if(isnull(new_color))
		qdel(new_team)
		balloon_alert(user, "needs color!")
		return
	new_team.team_color = new_color
	managed_teams[new_team.team_name] += new_team

#undef MY_CHILD_WILL
#undef MY_CHILD_WILL_NOT
#undef ACTIONS_FILE
