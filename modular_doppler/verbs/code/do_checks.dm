/mob/living/proc/doverb_checks(message)
	if(!isnull(ckey) && is_banned_from(ckey, "Emote"))
		to_chat(usr, span_boldwarning("You cannot use the do verb (emote banned)."))
		return FALSE

	if(QDELETED(usr))
		return FALSE

	if(client && client.prefs.muted & MUTE_IC)
		to_chat(usr, span_boldwarning("You cannot send IC messages (muted)."))
		return FALSE

	if(!length(message))
		return FALSE

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return FALSE

	//quickly calc our name stub again: duplicate this in say.dm override
	var/name_stub = " (<b>[usr]</b>)"
	if(length(message) > (MAX_MESSAGE_LEN - length(name_stub)))
		to_chat(usr, message)
		to_chat(usr, span_warning("^^^----- The preceding message has been DISCARDED for being over the maximum length of [MAX_MESSAGE_LEN]. It has NOT been sent! -----^^^"))
		return FALSE

	if(usr.stat != CONSCIOUS)
		to_chat(usr, span_notice("You cannot send a Do in your current condition."))
		return FALSE

	var/list/filter_result = is_ic_filtered(message)

	if(filter_result)
		to_chat(usr, span_warning("That Do message contained a word prohibited in IC messages! Consider reviewing the server rules."))
		to_chat(usr, span_warning("\"[message]\""))
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		log_filter("IC Do", message, filter_result)
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, LOWER_TEXT(config.ic_filter_regex.match))
		return FALSE

	filter_result = is_soft_ic_filtered(message)

	if(filter_result)
		if(tgui_alert(usr,"Your Do message contains \"[filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to send it?", "Soft Blocked Word", list("Yes", "No")) != "Yes")
			SSblackbox.record_feedback("tally", "soft_ic_blocked_words", 1, LOWER_TEXT(config.soft_ic_filter_regex.match))
			log_filter("Soft IC Do", message, filter_result)
			return FALSE

		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for do \"[filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Do message: \"[message]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for do \"[filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Do message: \"[message]\"")
		SSblackbox.record_feedback("tally", "passed_soft_ic_blocked_words", 1, LOWER_TEXT(config.soft_ic_filter_regex.match))
		log_filter("Soft IC Do (Passed)", message, filter_result)

	return TRUE
