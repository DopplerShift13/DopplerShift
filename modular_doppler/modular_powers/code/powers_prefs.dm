
/**
 * All the additional procs/vars we need on /datum/preferences for powers to function.
 */

/datum/preferences
	/// List of all our powers, by name.
	var/list/all_powers = list()
	var/power_sanitize_notice


/datum/preferences/proc/sanitize_powers()
	// Returns TRUE if changes were made.
	var/list/new_powers = SSpowers.filter_invalid_powers(all_powers)

	// If the subsystem nuked the list, tell the player why.
	if(!length(new_powers) && SSpowers.sanitize_nuke_reason)
		all_powers = list()
		power_sanitize_notice = SSpowers.sanitize_nuke_reason
		return TRUE

	// Changes were made but we didn't nuke everythin
	if(length(new_powers) != length(all_powers))
		all_powers = new_powers
		return TRUE

	return FALSE

