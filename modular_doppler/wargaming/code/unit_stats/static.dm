/datum/wargame_unit_stats/platform
	abstract_type = /datum/wargame_unit_stats/platform
	generates_name = FALSE
	conditions_limit = 4
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
		/datum/wargame_condition/reactor_damage,
	)
	is_small_vessel = FALSE
	unit_size = WARGAME_SIZE_MEDIUM

/datum/wargame_unit_stats/platform/get_unit_basic_actions()
	var/static/our_actions = list(
		WARGAME_UNIT_ATTACK = image(icon = WARGAME_ACTIONS_FILE, icon_state = "unit_attack"),
	)
	return our_actions

/datum/wargame_unit_stats/platform/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] briefly becomes a new star in the night sky, before fading into a large debris field!"))
	return ..()

/datum/wargame_unit_stats/platform/outpost
	unit_class = "outpost platform"
	unit_description = "A stationary defence platform that trades movement for armor and armament."
	armor_class = 11
	evasion_modifier = 0
	movement_cost = 1000
	maximum_action_points = 2
	weaponry = list(
		/datum/wargame_weapon/autocannon,
		/datum/wargame_weapon/rockets,
		/datum/wargame_weapon/pdc,
	)

/datum/wargame_unit_stats/platform/civilian
	unit_class = "civilian station"
	unit_description = "A civilian station, only lightly armed to deter asteroids and brigands."
	armor_class = 7
	evasion_modifier = 0
	movement_cost = 1000
	maximum_action_points = 2
	weaponry = list(
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/pd_beam,
	)

/datum/wargame_unit_stats/platform/citadel
	unit_class = "military station"
	unit_description = "An armed military station, highly dangerous even without outside support."
	armor_class = 15
	evasion_modifier = 0
	movement_cost = 1000
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/mass_driver,
		/datum/wargame_weapon/medium_cannon,
		/datum/wargame_weapon/pd_beam,
		/datum/wargame_weapon/missile/cruise,
		/datum/wargame_weapon/missile/swarm,
	)
