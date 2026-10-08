
/**
 * Removes the old powers from people's savefiles
 */
/datum/preferences/proc/nuke_old_powers(list/save_data)
	if(save_data && ("powers" in save_data))
		save_data -= "powers"
		var/ckey_to_log = parent?.ckey || "\[UNKNOWN CKEY\]"
		log_game("[ckey_to_log]'s powers were migrated over from the old powers system.")

/**
 * Generic helper for renaming a saved power entry, since powers are saved to preferences by name (not typepath).
 * Renaming a power's name var without transferring saves would otherwise silently drop it from everyone's save on next load/sanitize.
 *
 * Call this from a dedicated, version-gated migration proc whenever a power's name changes (see rename_beastial_to_bestial() for an example) rather than renaming in-place by hand.
 */
/datum/preferences/proc/rename_saved_power(list/save_data, old_name, new_name)
	var/list/saved_powers = save_data?["all_powers"]
	if(!islist(saved_powers))
		return
	if(!(old_name in saved_powers))
		return
	saved_powers -= old_name
	if(!(new_name in saved_powers))
		saved_powers += new_name
	var/ckey_to_log = parent?.ckey || "\[UNKNOWN CKEY\]"
	log_game("[ckey_to_log]'s power \"[old_name]\" was renamed to \"[new_name]\" in their savefile.")

/**
 * Renames the "Beastial Body" power to its corrected spelling, "Bestial Body", in people's savefiles.
 */
/datum/preferences/proc/rename_beastial_to_bestial(list/save_data)
	rename_saved_power(save_data, "Beastial Body", "Bestial Body")
