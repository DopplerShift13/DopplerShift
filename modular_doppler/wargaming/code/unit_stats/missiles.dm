/datum/wargame_unit_stats/missile
	abstract_type = /datum/wargame_unit_stats/missile
	talkative = FALSE
	generates_name = TRUE

/datum/wargame_unit_stats/missile/create_unit_name()
	return "Track [pick_list_replacements("~doppler/wargame_identifiers.json", "name_word")] [rand(1,99)]"

/datum/wargame_unit_stats/missile/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] is reduced to data with a bright spark!"), \
		blind_message = span_warning("[hologram] is reduced to data with a bright spark!"))
	return ..()

/datum/wargame_unit_stats/missile/cruise
	unit_class = "cruise missile"
	unit_description = "A long range cruise missile."
	conditions_limit = 0 // Anything will instantly destroy this
	possible_conditions = list(
		/datum/wargame_condition/missile_failure,
	)
	armor_class = 4
	evasion_modifier = 1
	movement_cost = 1
	maximum_action_points = 3
	is_small_vessel = TRUE
	unit_size = WARGAME_SIZE_SMALL
	weaponry = list(
		/datum/wargame_weapon/ramming/cruise,
	)

/datum/wargame_unit_stats/missile/swarm
	unit_class = "swarm missiles"
	unit_description = "A swarm of small interceptor missiles."
	conditions_limit = 0 // Anything will instantly destroy this
	possible_conditions = list(
		/datum/wargame_condition/missile_failure,
	)
	armor_class = 2
	evasion_modifier = 2
	movement_cost = 1
	maximum_action_points = 2
	is_small_vessel = TRUE
	unit_size = WARGAME_SIZE_SMALL
	weaponry = list(
		/datum/wargame_weapon/ramming/swarm,
	)

/datum/wargame_unit_stats/missile/torpedo
	unit_class = "torpedo"
	unit_description = "A large anti-capital ship torpedo."
	conditions_limit = 0 // Anything will instantly destroy this
	possible_conditions = list(
		/datum/wargame_condition/missile_failure,
	)
	armor_class = 5
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 2
	is_small_vessel = TRUE
	unit_size = WARGAME_SIZE_SMALL
	weaponry = list(
		/datum/wargame_weapon/ramming/torpedo,
	)
