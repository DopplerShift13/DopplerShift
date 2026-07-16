/datum/map_template/shuttle/salvage_scrap/fengzhou_patrol
	name = "Fengzhou Short Range Patrol"
	suffix = "fengzhou_patrol"
	ship_class = "Fengzhou Short Range Patrol"
	prior_usage = "Local system security patrols."
	ship_hazards = list(
		SALVAGE_HAZARD_ELECTRICAL,
		SALVAGE_HAZARD_FUEL,
		SALVAGE_HAZARD_REACTOR,
		SALVAGE_HAZARD_WEAPONS
	)
	random_owner_types = list(
		/datum/shipbreaking_owner/military,
	)

/datum/map_template/shuttle/salvage_scrap/apate_elint
	name = "Apate Electronic Intelligence Vessel"
	suffix = "apate_elint"
	ship_class = "Apate Electronic Intelligence Vessel"
	prior_usage = "██████ monitoring."
	ship_hazards = list(
		SALVAGE_HAZARD_ELECTRICAL,
		SALVAGE_HAZARD_FUEL,
		SALVAGE_HAZARD_REACTOR,
		SALVAGE_HAZARD_CARGO
	)
	random_owner_types = list(
		/datum/shipbreaking_owner/military,
	)
