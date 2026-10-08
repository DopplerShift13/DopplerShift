/// Modular smites that expose psyker breakdown events through the admin smite menu.
/datum/smite/psyker_breakdown
	/// The underlying breakdown event this smite triggers.
	var/event_type

/datum/smite/psyker_breakdown/effect(client/user, mob/living/target)
	if(!ishuman(target))
		to_chat(user, span_warning("[name] requires a human target."))
		return

	var/mob/living/carbon/human/human_target = target
	var/datum/psyker_event/psyker_event = new event_type

	if(!psyker_event.can_execute(human_target))
		to_chat(user, span_warning("[name] cannot be executed on [human_target]."))
		qdel(psyker_event)
		return

	if(!psyker_event.execute(human_target))
		to_chat(user, span_warning("[name] failed to execute on [human_target]."))
		message_admins("[ADMIN_LOOKUPFLW(user.mob)] attempted to trigger [name] on [ADMIN_LOOKUPFLW(human_target)], but the Psyker event failed to execute.")
		qdel(psyker_event)
		return

	. = ..()

	if(!psyker_event.lingering)
		qdel(psyker_event)
