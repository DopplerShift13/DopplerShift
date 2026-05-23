/datum/wargame_unit_stats/strike
	abstract_type = /datum/wargame_unit_stats/strike
	generates_name = FALSE
	conditions_limit = 2
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
		/datum/wargame_condition/engine_damage,
		/datum/wargame_condition/reactor_damage,
	)
	is_small_vessel = TRUE
	unit_size = WARGAME_SIZE_SMALL

/datum/wargame_unit_stats/strike/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] starts to careen off course before crackling and exploding!"))
	return ..()

/datum/wargame_unit_stats/strike/wing
	unit_class = "strike wing"
	unit_description = "A strike wing of bombers and its fighter escorts."
	armor_class = 7
	evasion_modifier = 4
	movement_cost = 1
	maximum_action_points = 5
	weaponry = list(
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/rockets,
		/datum/wargame_weapon/bombs,
		/datum/wargame_weapon/ramming/strike,
	)

/datum/wargame_unit_stats/strike/interceptor
	unit_class = "interceptor wing"
	unit_description = "An interceptor wing for interdicting other strike wings or incoming missiles."
	armor_class = 6
	evasion_modifier = 5
	movement_cost = 1
	maximum_action_points = 5
	weaponry = list(
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/autocannon,
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/ramming/strike,
	)
