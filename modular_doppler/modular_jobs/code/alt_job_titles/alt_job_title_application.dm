// ALTERNATIVE_JOB_TITLES

/**
 * Sets a human's ID/PDA title to match their preferred alt title for the given job.
 * Run after we apply or make modifications to a given assignment during roundstart/latejoin setup.
 */
/datum/controller/subsystem/job/proc/setup_alt_job_title(mob/living/carbon/human/equipping, datum/job/job, client/player_client)
	if(!player_client)
		return

	if(!ishuman(equipping))
		return

	var/chosen_title = player_client.get_selected_job_title(job)

	var/obj/item/card/id/card = equipping.get_idcard(hand_first = FALSE)
	if(istype(card))
		chosen_title = card.get_modified_title(chosen_title)
		card.assignment = chosen_title
		card.update_label()

	// Look for PDA in belt or L pocket
	var/obj/item/modular_computer/pda/pda = equipping.belt
	if(!istype(pda))
		pda = equipping.l_store
	if(istype(pda))
		pda.saved_job = chosen_title
		pda.UpdateDisplay()


/// Returns the selected job title from preferences, defaulting if no alt title was selected.
/client/proc/get_selected_job_title(datum/job/selected_job)
	var/selected_alt_title = prefs.alt_job_titles[selected_job.title]
	if(selected_alt_title)
		return selected_alt_title
	return selected_job.get_default_job_title()


/// Returns the default job title, if alt titles are present being overridden by the first in the list.
/datum/job/proc/get_default_job_title()
	if(length(alt_titles))
		return alt_titles[1]
	return title
