/// Returns the start sound.
/datum/looping_sound/proc/get_start_sound()
	return islist(start_sound) ? pick_weight_recursive(start_sound) : start_sound

/datum/looping_sound/proc/get_end_sound()
	return islist(end_sound) ? pick_weight_recursive(end_sound) : end_sound
