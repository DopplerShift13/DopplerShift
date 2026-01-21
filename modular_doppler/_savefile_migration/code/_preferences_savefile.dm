
#define DOPPLER_SAVEFILE_VERSION_MAX 1

#define VERSION_NEW_POWERS 1

#define SHOULD_UPDATE_DOPPLER_DATA(version) (version < DOPPLER_SAVEFILE_VERSION_MAX)

// Grabs the savefile
/datum/preferences/proc/get_savefile_version(list/save_data)
	var/savefile_version = save_data["doppler_version"]
	return savefile_version

//Checks if the savefile is older.
/datum/preferences/proc/check_doppler_character_savefile(list/save_data)
	if(isnull(save_data))
		save_data = list()
	var/current_version = get_savefile_version(save_data)
	if(!SHOULD_UPDATE_DOPPLER_DATA(current_version))
		return
	update_character_doppler(current_version, save_data)

/// Updates our character save data.
/datum/preferences/proc/update_character_doppler(current_version, list/save_data)
	// Version for old powers system
	if(current_version < VERSION_NEW_POWERS)
		nuke_old_powers(save_data)

/datum/preferences/proc/save_character_doppler(list/save_data)
	save_data["languages"] = languages
	save_data["alt_job_titles"] = alt_job_titles
	save_data["all_powers"] = all_powers
	// load_character will sanitize any bad data, so assume up-to-date.
	save_data["version"] = DOPPLER_SAVEFILE_VERSION_MAX

#undef DOPPLER_SAVEFILE_VERSION_MAX
#undef VERSION_NEW_POWERS
#undef SHOULD_UPDATE_DOPPLER_DATA
