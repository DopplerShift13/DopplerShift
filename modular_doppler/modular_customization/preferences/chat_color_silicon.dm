
/mob/living/silicon/ai/apply_prefs_job(client/player_client, datum/job/job)
	. = ..()
	apply_chat_color_preference(player_client)

/mob/living/silicon/robot/apply_prefs_job(client/player_client, datum/job/job)
	. = ..()
	var/chat_color_applied = apply_chat_color_preference(player_client)
	if(chat_color_applied && mmi?.brainmob)
		mmi.brainmob.copy_chat_color(src)

/mob/living/silicon/robot/deploy_init(mob/living/silicon/ai/AI)
	. = ..()
	if(get_cached_chat_color(AI.name))
		copy_chat_color(AI)
