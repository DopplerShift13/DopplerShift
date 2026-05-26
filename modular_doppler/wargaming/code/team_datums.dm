/datum/wargaming_team
	abstract_type = /datum/wargaming_team
	/// The name of the team as displayed on the controllers
	var/team_name
	/// The color of the team as shown in holograms and outfits
	var/team_color = "#fff"
	/// How does this team's units reference their commander(s)
	var/team_commander_reference = "fleet"
	/// The prefix applied to all automatically generated ship names for this team
	var/team_ship_prefix = "4CA"
	/// The players currently on this team
	var/list/team_players = list()
	/// Tracks hologram projectors associated with this team for updating unit action points with
	var/list/tracked_projectors = list()

/// Sets every controllable hologram in our tracked controllers back to its default amount of action points
/datum/wargaming_team/proc/ready_all_units()
	for(var/obj/item/wargame_projector/projector as anything in tracked_projectors)
		for(var/obj/structure/wargame_hologram/hologram as anything in projector.projections)
			if(hologram.controllable)
				hologram.unit_stats.make_ready()

/// Tells every controllable hologram to update its conditions and explode if necessary
/datum/wargaming_team/proc/update_all_units()
	for(var/obj/item/wargame_projector/projector as anything in tracked_projectors)
		for(var/obj/structure/wargame_hologram/hologram as anything in projector.projections)
			if(hologram.controllable)
				hologram.unit_stats.effects_phase_process(hologram)
