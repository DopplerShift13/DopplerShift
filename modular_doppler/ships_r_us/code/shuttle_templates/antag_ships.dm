// datums for the buyable cantag shuttles

/datum/map_template/shuttle/personal_buyable/antagonist
	personal_shuttle_type = PERSONAL_SHIP_TYPE_ANTAGONIST
	port_id = "tiziran"

/datum/map_template/shuttle/personal_buyable/antagonist/tiziran_corvette
	name = "ITS Kaz'akran"
	description = "A Tiziran warship built for high speed pursuits of lightly armed merchant farers."
	credit_cost = CARGO_CRATE_VALUE * 18
	suffix = "corvette"
	width = 29
	height = 28
	personal_shuttle_size = PERSONAL_SHIP_LARGE

/area/shuttle/personally_bought/tiziran_corvette
	name = "ITS Kaz'akran"

/datum/map_template/shuttle/personal_buyable/antagonist/tiziran_interceptor
	name = "ITF Zul'kath"
	description = "A Tiziran interceptor with a tandem cockpit that was originally developed for hyperspace interdiction."
	credit_cost = CARGO_CRATE_VALUE * 8
	suffix = "interceptor"
	width = 10
	height = 8
	personal_shuttle_size = PERSONAL_SHIP_SMALL

/area/shuttle/personally_bought/tiziran_interceptor
	name = "ITF Zul'kath"
	requires_power = TRUE

// datum for the pirate shuttle

/datum/map_template/shuttle/pirate/tiziran_corvette
	prefix = "_maps/shuttles/~doppler_shuttles/"
	suffix = "raider_shuttle"
	name = "pirate ship (Tiziran Corvette)"

/area/shuttle/pirate/tiziran_corvette
	name = "ITS Kaz'akran"
	requires_power = TRUE
