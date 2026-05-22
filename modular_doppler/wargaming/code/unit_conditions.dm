/datum/wargame_condition
	abstract_type = /datum/wargame_condition
	/// The name of the condition
	var/condition_name
	/// How many more turns until the condition goes away on its own
	var/condition_lifetime_left

/// When the condition is applied to a unit stats, what changes
/datum/wargame_condition/proc/applied_to_unit(datum/wargame_unit_stats/stats)
	return

/// When the condition is removed from a unit stats, what changes back
/datum/wargame_condition/proc/removed_from_unit(datum/wargame_unit_stats/stats)
	return

/datum/wargame_condition/hull_damage
	condition_name = "Hull Damage"
	condition_lifetime_left = 2

/datum/wargame_condition/hull_damage/applied_to_unit(datum/wargame_unit_stats/stats)
	stats.armor_class -= 1

/datum/wargame_condition/hull_damage/removed_from_unit(datum/wargame_unit_stats/stats)
	stats.armor_class += 1
