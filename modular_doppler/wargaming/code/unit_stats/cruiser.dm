/datum/wargame_unit_stats/cruiser
	abstract_type = /datum/wargame_unit_stats/cruiser
	generates_name = TRUE
	conditions_limit = 4
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
		/datum/wargame_condition/engine_damage,
		/datum/wargame_condition/reactor_damage,
	)
	is_small_vessel = FALSE
	unit_size = WARGAME_SIZE_LARGE

/datum/wargame_unit_stats/cruiser/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] starts to drift off course before shattering into a large debris field!"))
	return ..()

/datum/wargame_unit_stats/cruiser/mass_driver
	unit_class = "mass driver cruiser"
	unit_description = "A cruiser equipped with a heavy mass driver."
	armor_class = 13
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/pd_beam,
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/mass_driver,
		/datum/wargame_weapon/autocannon,
	)

/datum/wargame_unit_stats/cruiser/artillery
	unit_class = "artillery cruiser"
	unit_description = "A cruiser equipped with heavy long-range artillery."
	armor_class = 13
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/pd_beam,
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/large_cannon,
		/datum/wargame_weapon/medium_cannon,
	)

/datum/wargame_unit_stats/cruiser/linebreaker
	unit_class = "battlecruiser"
	unit_description = "A heavily armed and armored cruiser for breaking through fortified enemy lines."
	armor_class = 15
	evasion_modifier = 0
	movement_cost = 2
	maximum_action_points = 4
	conditions_limit = 5
	weaponry = list(
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/missile/torpedo,
		/datum/wargame_weapon/medium_cannon,
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/autocannon,
		/datum/wargame_weapon/anti_ship_beam,
	)
