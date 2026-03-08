#define SALVAGE_SHUTTLE_STRINGS "~doppler/salvage_shuttle.json"

/datum/map_template/shuttle/salvage_scrap
	name = "DEBUG: Salvage Shuttle Basetype"
	description = "Surely there would be a ship here."
	shuttle_id = "shuttle_salvage_scrap"
	port_id = "salvage"
	prefix = "_maps/shuttles/~doppler_shuttles/salvage/"
	who_can_purchase = null
	width = 35
	height = 24
	/// The name of the ship before it got abandoned, randomized if null
	var/prior_name = null
	/// A general ship class, similarly shaped ships should have the same class to help players
	var/ship_class = "UNKNOWN"
	/// What the ship was doing before it got abandoned, tells players what to expect inside the ship
	var/prior_usage = "BEING BROKEN"
	/// Who owned the ship before it was salvage, randomized if null
	var/prior_owner = null
	/// Operation date, "(year) to (year)", randomized if empty
	var/prior_date = null

/datum/map_template/shuttle/salvage_scrap/New()
	. = ..()
	if(!prior_name)
		prior_name = strings(SALVAGE_SHUTTLE_STRINGS, "ship_name")
	if(!prior_owner)
		prior_owner = strings(SALVAGE_SHUTTLE_STRINGS, "ship_companies")
	if(!prior_date)
		prior_date = "[rand(2490, 2504)] to [rand(2504, 2525)]"

/obj/docking_port/mobile/salvage
	name = "salvaged shuttle"
	shuttle_id = "shuttle_salvage_scrap"
	callTime = 15 SECONDS
	rechargeTime = 30 SECONDS
	prearrivalTime = 10 SECONDS
	preferred_direction = EAST
	dir = NORTH
	port_direction = EAST
	movement_force = list(
		"KNOCKDOWN" = 2,
		"THROW" = 0,
	)

/obj/docking_port/mobile/salvage/canDock(obj/docking_port/stationary/stationary_dock)
	if(!stationary_dock)
		return SHUTTLE_CAN_DOCK
	if(!istype(stationary_dock))
		return SHUTTLE_NOT_A_DOCKING_PORT
	if(stationary_dock.override_can_dock_checks)
		return SHUTTLE_CAN_DOCK
	// check the dock isn't occupied
	var/currently_docked = stationary_dock.get_docked()
	if(currently_docked)
		// by someone other than us
		if(currently_docked != src)
			return SHUTTLE_SOMEONE_ELSE_DOCKED
		else
		// This isn't an error, per se, but we can't let the shuttle code
		// attempt to move us where we currently are, it will get weird.
			return SHUTTLE_ALREADY_DOCKED
	return SHUTTLE_CAN_DOCK

/// Checks if any items in the areas of the docking port would be blocked by the cargo shuttle, and so shouldn't be deleted here
/obj/docking_port/mobile/salvage/proc/check_blacklist()
	for(var/area/shuttle_area as anything in shuttle_areas)
		for (var/list/zlevel_turfs as anything in shuttle_area.get_zlevel_turf_lists())
			for(var/turf/shuttle_turf as anything in zlevel_turfs)
				for(var/atom/passenger in shuttle_turf.get_all_contents())
					if((is_type_in_typecache(passenger, GLOB.blacklisted_salvage_removal_types) || HAS_TRAIT(passenger, TRAIT_BANNED_FROM_CARGO_SHUTTLE)) && !istype(passenger, /obj/docking_port))
						return FALSE
	return TRUE

/area/shuttle/salvaged_shuttle
	name = "Shuttle Salvage"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/salvaged_shuttle
