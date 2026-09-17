/datum/job/map_check()
	. = ..()
	if(!.) // This means the job has been disabled by the map json already so who cares
		return FALSE
	var/edited_job_outfit = CHECK_MAP_JOB_CHANGE(title, "outfit_override")
	if(!isnull(edited_job_outfit))
		outfit = edited_job_outfit
	var/edited_job_outfit_plasma = CHECK_MAP_JOB_CHANGE(title, "outfit_override_plasma")
	if(!isnull(edited_job_outfit_plasma))
		plasmaman_outfit = edited_job_outfit
	return TRUE
