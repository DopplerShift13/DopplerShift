/datum/wargaming_team
	abstract_type = /datum/wargaming_team
	/// The name of the team as displayed on the controllers
	var/team_name
	/// The color of the team as shown in holograms and outfits
	var/team_color = "#fff"
	/// The players currently on this team
	var/list/team_players = list()
	/// Associated list of equipment to the player that linked it
	var/list/players_equipment = list()
