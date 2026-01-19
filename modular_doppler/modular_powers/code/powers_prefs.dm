
/**
 * All the additional procs/vars we need on /datum/preferences for powers to function.
 */

/datum/preferences
	/// List of all our powers, by name.
	var/list/all_powers = list()


/datum/preferences/proc/sanitize_powers()
	var/list/new_powers = SSpowers.filter_invalid_powers(all_powers)
	var/list/powers_removed = SSpowers.powers_removed
	var/list/feedback

	// If filter_invalid_powers came back with removed powers, we apply the changes and give feedback
	if(LAZYLEN(powers_removed) && !length(new_powers))
		all_powers = list()
		LAZYADD(feedback, "Your powers were removed because of the following reasons:")
		LAZYADD(feedback, powers_removed)
		if(LAZYLEN(feedback))
			to_chat(parent, span_greentext(feedback.Join("\n")))
		return TRUE
	return FALSE

