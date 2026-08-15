/datum/wargame_unit_stats/terrain
	abstract_type = /datum/wargame_unit_stats/terrain
	conditions_limit = 4
	possible_conditions = list(
		/datum/wargame_condition/hull_damage/asteroid,
	)
	is_small_vessel = FALSE
	unit_size = WARGAME_SIZE_LARGE
	talkative = FALSE

/datum/wargame_unit_stats/terrain/get_unit_basic_actions()
	return

/datum/wargame_unit_stats/terrain/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] cracks into pieces before fading into a digital cloud!"), \
		blind_message = span_warning("[hologram] cracks into pieces before fading into a digital cloud!"))
	return ..()

/datum/wargame_unit_stats/terrain/asteroid
	unit_class = "asteroid"
	unit_description = "A large asteroid that serves as good cover. Can be broken apart with sufficient damage."
	generates_name = TRUE
	armor_class = 13
	evasion_modifier = 0
	movement_cost = 100
	maximum_action_points = 0
	weaponry = list()

/datum/wargame_unit_stats/terrain/asteroid/create_unit_name(datum/wargaming_team/team)
	return "[pick_list_replacements("~doppler/wargame_identifiers.json", "name_word")] [rand(100, 999)]"

/datum/wargame_unit_stats/terrain/dust_cloud
	unit_class = "dust cloud"
	unit_description = "A large cloud of space dust of some kind. While unserviceable as cover, gives a boost to evasion while inside of it."
	armor_class = 200
	evasion_modifier = 0
	movement_cost = 100
	maximum_action_points = 0
	can_be_a_target = FALSE
	unit_size = WARGAME_EVASION_BONUS
	weaponry = list()
