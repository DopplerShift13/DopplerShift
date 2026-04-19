
/datum/preferences
	/// The selected alt job titles keyed by job title, if any.
	var/list/alt_job_titles = list()

/// Sanitizes our alt job titles, removing any invalid ones.
/datum/preferences/proc/sanitize_alt_job_titles()
	var/list/feedback

	for(var/job_title in alt_job_titles)
		var/datum/job/job_instance = SSjob.get_job(job_title)
		if(isnull(job_instance))
			// Edge case: job isn't real anymore, remove without feedback.
			alt_job_titles -= job_title
			continue
		var/chosen_alt_title = alt_job_titles[job_title]
		if(chosen_alt_title in job_instance.alt_titles)
			continue
		// If it's not an existing alt title, reset and share this with the player.
		alt_job_titles -= job_title
		LAZYADD(feedback, "[chosen_alt_title] > [job_instance.get_default_job_title()]")

	if(LAZYLEN(feedback))
		var/feedback_message = "The following alt titles have been reset:\n[feedback.Join("\n")]"
		to_chat(parent, boxed_message(span_greentext(feedback_message)))
