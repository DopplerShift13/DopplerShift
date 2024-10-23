/datum/admin_help
	/// Who is handling this admin help?
	var/handler

/datum/admin_help/ClosureLinks(ref_src)
	. = ..()
	. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=handle_issue'>HANDLE</A>)"

// Let the initiator know their ahelp is being handled
/datum/admin_help/proc/handle_issue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return FALSE

	if(handler && handler == usr.ckey) // No need to handle it twice as the same person ;)
		return TRUE

	if(handler && handler != usr.ckey)
		var/response = tgui_alert(usr, "This ticket is already being handled by [handler]. Do you want to continue?", "Ticket already assigned", list("Yes", "No"))
		if(!response || response == "No")
			return FALSE

	var/msg = span_adminhelp("Your ticket is now being handled by [key_name]! Please wait while they type their response and/or gather relevant information.")

	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "handling")
	msg = "Ticket [TicketHref("#[id]")] is being handled by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Being handled by [key_name]", "Being handled by [key_name_admin(usr, FALSE)]")

	handler = "[usr.ckey]"
	return TRUE

/*
/// Confirm that the admin trying to take over the handling of a ticket really wants to do that
/datum/admin_help/proc/confirm_takeover()
	if(!handler || handler != usr.ckey)
		return FALSE
	var/response = tgui_alert(usr, "This ticket is already being handled by [handler]. Do you want to continue?", "Ticket already assigned", list("Yes", "No"))
	if(response == "Yes")
		return TRUE
	return FALSE
*/
