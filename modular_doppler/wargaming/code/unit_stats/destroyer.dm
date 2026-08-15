/datum/wargame_unit_stats/destroyer
	abstract_type = /datum/wargame_unit_stats/destroyer
	generates_name = TRUE
	conditions_limit = 4
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
		/datum/wargame_condition/engine_damage,
		/datum/wargame_condition/reactor_damage,
	)
	is_small_vessel = FALSE
	unit_size = WARGAME_SIZE_MEDIUM

/datum/wargame_unit_stats/destroyer/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	hologram.visible_message(span_warning("[hologram] starts to drift off course before shattering into a large debris field!"), \
		blind_message = span_warning("[hologram] starts to drift off course before shattering into a large debris field!"))
	return ..()

/datum/wargame_unit_stats/destroyer/brawler
	unit_class = "destroyer"
	unit_description = "A heavily armored destroyer for close-in brawling engagements."
	armor_class = 12
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/autocannon,
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/medium_cannon,
		/datum/wargame_weapon/missile/torpedo/small,
	)

/datum/wargame_unit_stats/destroyer/beam
	unit_class = "beam frigate"
	unit_description = "A frigate equipped with special anti-ship beam weaponry."
	armor_class = 10
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/missile/swarm,
		/datum/wargame_weapon/anti_ship_beam,
		/datum/wargame_weapon/pd_beam,
	)

/datum/wargame_unit_stats/destroyer/missile
	unit_class = "missile frigate"
	unit_description = "A frigate loaded with lines and lines of launch tubes for various missiles."
	armor_class = 10
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 4
	weaponry = list(
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/missile/cruise,
		/datum/wargame_weapon/missile/swarm,
	)
