/datum/wargame_unit_stats/corvette
	abstract_type = /datum/wargame_unit_stats/corvette
	generates_name = TRUE
	conditions_limit = 2
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
		/datum/wargame_condition/engine_damage,
		/datum/wargame_condition/reactor_damage,
	)
	is_small_vessel = TRUE
	unit_size = WARGAME_SIZE_SMALL

/datum/wargame_unit_stats/corvette/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] flashes and disappears as its reactor goes critical!"))
	return ..()

/datum/wargame_unit_stats/corvette/picket
	unit_class = "picket corvette"
	unit_description = "A corvette fitted with PDC for fleet defence."
	armor_class = 8
	evasion_modifier = 2
	movement_cost = 1
	maximum_action_points = 3
	weaponry = list(
		/datum/wargame_weapon/pdc,
	)
