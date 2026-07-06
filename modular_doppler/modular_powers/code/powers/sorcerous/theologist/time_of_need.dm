/* Reduces cooldowns by spending Piety! This one may be quite potent, so we'll see how it goes.
*/
/datum/power/theologist/time_of_need
	name = "Time of Need"
	desc = "Your conviction is enough to drive you to action. Spend 5 Piety to reduce all your active cooldowns (except this one) by 15 seconds. Has a 10 second cooldown."
	security_record_text = "Subject can fuel their powers with piety, allowing them to wield them more often."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/theologist/time_of_need
	value = 3

	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/theologist/time_of_need
	name = "Time of Need"
	desc = "Your conviction is enough to drive you to action. Spend 5 Piety to reduce all your active cooldowns (except this one) by 15 seconds. Has a 10 second cooldown."
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "adrenaline"
	cooldown_time = 100
	cost = 5

/datum/action/cooldown/power/theologist/time_of_need/use_action(mob/living/user, mob/living/target)
	// checks if we succesfully reduced any cooldown
	var/cooldown_reduced
	// Iterates through every action/cooldown on the mob and checks if it has a cooldown and if its on cooldown
	for(var/datum/action/cooldown/cooldown_action in user.actions)
		if(!cooldown_action.cooldown_time)
			continue
		if(cooldown_action.next_use_time > world.time)
			cooldown_action.next_use_time -= 150 // just reduce next_use_time
			cooldown_action.build_all_button_icons(UPDATE_BUTTON_STATUS)
			START_PROCESSING(SSfastprocess, cooldown_action)
			cooldown_reduced = TRUE
			continue
	// power failed if no cooldowns
	if(!cooldown_reduced)
		user.balloon_alert(user, "no cooldowns!")
		return FALSE

	// effects
	playsound(user, 'sound/effects/magic/charge.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	var/filter_id = "time_of_need"
	user.add_filter(filter_id, 1, list(type = "outline", color = "#ddd166", size = 2, alpha = 255))
	user.transition_filter(filter_id, list("alpha" = 0), 2 SECONDS) // this actually looks smoother
	addtimer(CALLBACK(user, PROC_REF(remove_filter), filter_id), 2 SECONDS)

	return TRUE
