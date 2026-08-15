
/**
 * All the additional procs/vars we need on /datum/preferences for powers to function.
 */

/datum/preferences
	/// List of all our powers, by name.
	var/list/all_powers = list()

/// Clears all powers and related augment assignments.
/datum/preferences/proc/nuke_powers_prefs(reasons)
	all_powers = list()

	// This is a bit messy with how augmented is implemented but we can't skip these.
	if(GLOB.preference_entries[/datum/preference/choiced/augment_left])
		write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], AUGMENTED_NO_AUGMENT)
	if(GLOB.preference_entries[/datum/preference/choiced/augment_right])
		write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], AUGMENTED_NO_AUGMENT)

	// No reason
	if(!islist(reasons))
		reasons = isnull(reasons) ? list("unspecified reason") : list(reasons)

	// Have a reason: Logged in the game and told to the user.
	if(length(reasons))
		var/list/feedback
		LAZYADD(feedback, "Your powers were removed because of the following reasons:")
		LAZYADD(feedback, reasons)
		if(LAZYLEN(feedback))
			// This doesn't work if the player joins the game with an invalid file. SAD!
			to_chat(parent, span_greentext(jointext(feedback, "\n")))

		var/ckey_to_log = parent?.ckey || "unknown"
		log_game("[ckey_to_log]'s powers preferences were nuked: [jointext(reasons, "; ")]")

	save_character()
	return TRUE

/// Runs sanitization for powers by going through filter_invalid_poewrs() and also authentication that the save entry is proper.
/// If sanitization fails, removes all the player's power prefs and returns a message as to why.
/datum/preferences/proc/sanitize_powers()
	var/list/new_powers = SSpowers.filter_invalid_powers(all_powers, parent)
	var/list/powers_removed = SSpowers.powers_removed
	var/invalid_reason = null

	for(var/power_name in all_powers)
		if(!istext(power_name) || !ispath(SSpowers.powers[power_name]))
			invalid_reason = "Invalid power entry: [power_name]"
			break

	// If filter_invalid_powers came back with removed powers, we apply the changes and give feedback
	if(invalid_reason)
		nuke_powers_prefs(invalid_reason)
		return TRUE

	if(LAZYLEN(powers_removed) && !length(new_powers))
		nuke_powers_prefs(powers_removed)
		return TRUE

	if(new_powers.len != all_powers.len)
		all_powers = new_powers
		return TRUE
	return FALSE
