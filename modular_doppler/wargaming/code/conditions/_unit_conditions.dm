/datum/wargame_condition
	abstract_type = /datum/wargame_condition
	/// The name of the condition
	var/condition_name
	/// Brief description of what the condition does
	var/condition_desc
	/// How many more turns until the condition goes away on its own
	var/condition_lifetime_left

/// When the condition is applied to a unit stats, what changes
/datum/wargame_condition/proc/applied_to_unit(datum/wargame_unit_stats/stats)
	return

/// When the condition is removed from a unit stats, what changes back
/datum/wargame_condition/proc/removed_from_unit(datum/wargame_unit_stats/stats)
	return

// special condition for missiles just so they explode
/datum/wargame_condition/missile_failure
	condition_name = "Missile Failure"
	condition_desc = "Complete failure of missile systems, safety self destruct imminent."
	condition_lifetime_left = 2

/datum/wargame_condition/missile_failure/applied_to_unit(datum/wargame_unit_stats/stats)
	stats.maximum_action_points = 0 // Missile is disabled

/datum/wargame_condition/hull_damage
	condition_name = "Hull Damage"
	condition_desc = "Damage to the hull that reduces the armor class of the ship."
	condition_lifetime_left = 2

/datum/wargame_condition/hull_damage/applied_to_unit(datum/wargame_unit_stats/stats)
	stats.armor_class -= 1

/datum/wargame_condition/hull_damage/removed_from_unit(datum/wargame_unit_stats/stats)
	stats.armor_class += 1

/datum/wargame_condition/hull_damage/asteroid
	condition_name = "Surface Fracture"
	condition_desc = "Fracturing of the asteroid surface that reduces the asteroid's armor class."
	condition_lifetime_left = 10

/datum/wargame_condition/engine_damage
	condition_name = "Engine Damage"
	condition_desc = "Damage to the engines that makes movement cost an extra action point."
	condition_lifetime_left = 2

/datum/wargame_condition/engine_damage/applied_to_unit(datum/wargame_unit_stats/stats)
	stats.movement_cost += 1

/datum/wargame_condition/engine_damage/removed_from_unit(datum/wargame_unit_stats/stats)
	stats.movement_cost -= 1

/datum/wargame_condition/reactor_damage
	condition_name = "Reactor Damage"
	condition_desc = "Damage to the ship's reactor that reduces maximum action points by one."
	condition_lifetime_left = 3

/datum/wargame_condition/engine_damage/applied_to_unit(datum/wargame_unit_stats/stats)
	stats.maximum_action_points -= 1

/datum/wargame_condition/engine_damage/removed_from_unit(datum/wargame_unit_stats/stats)
	stats.maximum_action_points += 1
