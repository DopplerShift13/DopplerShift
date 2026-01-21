// Grabs the savefile
/datum/preferences/proc/get_savefile_powers(list/save_data)
	var/powers = save_data["powers"]
	return powers

//Checks if there's old powers; if so clean slate.
/datum/preferences/proc/check_for_old_powers(list/save_data)
	if(isnull(save_data))
		save_data = list()
	var/powers = get_savefile_powers(save_data)
	if(!isnull(powers))
		return TRUE
	return FALSE

