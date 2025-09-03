
/**
 * All the additional procs/vars we need on /datum/preferences for powers to function.
 */

/datum/preferences
	/// List of all our powers, by name.
	var/list/all_powers = list()

/datum/preferences/proc/sanitize_powers()
	// TODO: implement some way for this to give FEEDBACK to the player about what got kerploded
	var/list/new_powers = SSpowers.filter_invalid_powers(all_powers)
	if(length(new_powers) != length(all_powers))
		return TRUE
	return FALSE
