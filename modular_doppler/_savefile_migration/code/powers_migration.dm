
/**
 * Removes the old powers from people's savefiles
 */
/datum/preferences/proc/nuke_old_powers(list/save_data)
	if(save_data && ("powers" in save_data))
		save_data -= "powers"
		var/ckey_to_log = parent?.ckey || "unknown"
		log_game("[ckey_to_log]'s powers were migrated over from the old powers system.")
