
/**
 * Removes the old powers from people's savefiles
 */
/datum/preferences/proc/nuke_old_powers(list/save_data)
	save_data?["powers"] = list()
	log_game("The nuke was dropped, yay")
