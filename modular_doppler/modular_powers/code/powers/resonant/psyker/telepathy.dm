
// Telepathy, basically lifted from the mutation.

#define TELE_CLICK_NONE 0
#define TELE_CLICK_LEFT 1
#define TELE_CLICK_RIGHT 2
/datum/power/psyker_power/telepathy
	name = "Telepathy"
	desc = "Allows you to mentally communicate messages to targets. Generates a very small amount of stress. Has a speech-bubble that can be toggled on and off using middle click."
	security_record_text = "Subject can initiate one-way communication with a target telepathically."
	value = 1
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/telepathy

/datum/action/cooldown/power/psyker/telepathy
	name = "Telepathy"
	desc = "Allows you to mentally communicate messages to the target. Middle click to toggle speech-bubble while typing."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "telepathy"
	click_to_activate = TRUE
	target_self = FALSE
	target_range = 12
	target_type = /mob/living

	/// The message we send to the target.
	var/message
	/// The span surrounding the telepathy message
	var/telepathy_span = "notice"
	/// The bolded span surrounding the telepathy message
	var/bold_telepathy_span = "boldnotice"
	/// Whether access to area telepathy (right click) is enabled.
	var/aoe_enabled = FALSE
	/// Which mouse click is used in use_action
	var/tele_click_type = 0
	/// Whether to show a speech-bubble while typing a telepathy message.
	var/show_typing_bubble = FALSE
	/// Active telepathy typing bubble overlay.
	var/tmp/mutable_appearance/telepathy_typing_bubble
	/// Timer id for delayed bubble removal.
	var/tmp/telepathy_remove_timer

/datum/action/cooldown/power/psyker/telepathy/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/mods = params2list(params)
	// toggles between telepathy bubble
	if(LAZYACCESS(mods, MIDDLE_CLICK))
		show_typing_bubble = !show_typing_bubble
		if(show_typing_bubble)
			clicker.balloon_alert(clicker, "Typing bubble enabled")
		else
			clicker.balloon_alert(clicker, "Typing bubble disabled")
			stop_telepathy_typing_overlay(clicker, FALSE) // turns it off instantly if needed
		return TRUE
	if(LAZYACCESS(mods, RIGHT_CLICK))
		if(!aoe_enabled)
			return FALSE
		tele_click_type = TELE_CLICK_RIGHT
		// We need a valid living target to proceed, so we basically forcefully get any valid target in range.
		target = get_aoe_dummy_target(clicker)
	else
		tele_click_type = TELE_CLICK_LEFT
	. = ..()
	if(!.)
		tele_click_type = TELE_CLICK_NONE
	return TRUE // always return true to consume the click

/datum/action/cooldown/power/psyker/telepathy/use_action(mob/living/user, atom/target)
	// Sets teh click type.
	var/click_type = tele_click_type
	tele_click_type = TELE_CLICK_NONE
	if(click_type == TELE_CLICK_RIGHT)
		return send_area_thought(user)

	// define mob and set message
	var/mob/living/cast_on = target
	if(show_typing_bubble)
		start_telepathy_typing_overlay(user)
	message = tgui_input_text(user, "What do you wish to whisper to [cast_on]?", "[src]", max_length = MAX_MESSAGE_LEN)
	// if anything happens before we finish typing the message.
	if(QDELETED(src) || QDELETED(user) || QDELETED(cast_on))
		stop_telepathy_typing_overlay(user, FALSE)
		return FALSE

	// out of range
	if(target_range && get_dist(user, cast_on) > target_range)
		user.balloon_alert(user, "they're too far!")
		stop_telepathy_typing_overlay(user, FALSE)
		return FALSE
	// no message
	if(!message)
		stop_telepathy_typing_overlay(user, FALSE)
		return FALSE

	send_thought(user, cast_on, message)
	stop_telepathy_typing_overlay(user, TRUE)
	return TRUE

/datum/action/cooldown/power/psyker/telepathy/on_action_success(mob/living/user, atom/target)
	modify_stress(PSYKER_STRESS_TRIVIAL)
	return ..()

/// Picks a valid mob in view to satisfy target checks for area telepathy; doubles as a check to see if we even have anyone to telepathy to.
/datum/action/cooldown/power/psyker/telepathy/proc/get_aoe_dummy_target(mob/living/user)
	var/list/targets = list()
	for(var/mob/living/target in view(user))
		if(target == user)
			continue
		if(mental && !can_affect_mental(target))
			continue
		targets += target

	if(!length(targets))
		return null
	return pick(targets)

/// Singular transmission
/datum/action/cooldown/power/psyker/telepathy/proc/send_thought(mob/living/caster, mob/living/target, message, disable_feedback = FALSE)
	log_directed_talk(caster, target, message, LOG_SAY, name)

	var/formatted_message = "<span class='[telepathy_span]'>[message]</span>"
	target.balloon_alert(target, "you hear a voice")
	to_chat(target, "<span class='[bold_telepathy_span]'>You hear a voice in your head...</span> [formatted_message]")

	if(!disable_feedback) // So that the AoE version doesnt spam your chat log.
		to_chat(caster, "<span class='[bold_telepathy_span]'>You transmit to [target]:</span> [formatted_message]")
		send_ghost_message(caster, target, formatted_message)


/// AoE transmission
/datum/action/cooldown/power/psyker/telepathy/proc/send_area_thought(mob/living/user)
	if(show_typing_bubble)
		start_telepathy_typing_overlay(user)
	message = tgui_input_text(user, "What do you wish to whisper to everyone in view?", "[src]", max_length = MAX_MESSAGE_LEN)
	if(QDELETED(src) || QDELETED(user))
		stop_telepathy_typing_overlay(user, FALSE)
		return FALSE
	if(!message)
		stop_telepathy_typing_overlay(user, FALSE)
		return FALSE

	// We need to revalidate targeting on each person; you shouldn't be able to whisper to mental or magic immune people
	var/list/targets = list()
	for(var/mob/living/target in view(user))
		if(target == user)
			continue
		if(mental && !can_affect_mental(target))
			continue
		targets += target

	if(!length(targets))
		stop_telepathy_typing_overlay(user, FALSE)
		user.balloon_alert(user, "no minds in view!")
		return FALSE

	var/formatted_message = "<span class='[telepathy_span]'>[message]</span>"
	to_chat(user, "<span class='[bold_telepathy_span]'>You broadcast to everyone in view:</span> [formatted_message]")
	send_ghost_message(user, null, formatted_message, area_broadcast = TRUE)

	// basically goes through send_thought for each target
	for(var/mob/living/target as anything in targets)
		send_thought(user, target, message, disable_feedback = TRUE)
	stop_telepathy_typing_overlay(user, TRUE)
	return TRUE

/// Tells the ghosts that telepathy talk is happening.
/datum/action/cooldown/power/psyker/telepathy/proc/send_ghost_message(mob/living/caster, mob/living/target, formatted_message, area_broadcast = FALSE)
	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		var/from_link = FOLLOW_LINK(ghost, caster)
		var/from_mob_name = "<span class='[bold_telepathy_span]'>[caster] [src]</span>"
		from_mob_name += "<span class='[bold_telepathy_span]'>:</span>"
		var/to_link = ""
		var/to_mob_name
		if(area_broadcast)
			to_mob_name = span_name("area")
		else
			to_link = FOLLOW_LINK(ghost, target)
			to_mob_name = span_name("[target]")

		to_chat(ghost, "[from_link] [from_mob_name] [formatted_message] [to_link] [to_mob_name]")

/// Starts a separate typing bubble overlay while the telepathy prompt is open.
/datum/action/cooldown/power/psyker/telepathy/proc/start_telepathy_typing_overlay(mob/living/user)
	if(!user || QDELETED(user))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_THINKING_IN_CHARACTER) || user.active_typing_indicator || user.active_thinking_indicator)
		return FALSE
	if(telepathy_remove_timer)
		deltimer(telepathy_remove_timer)
		telepathy_remove_timer = null
	if(telepathy_typing_bubble)
		user.cut_overlay(telepathy_typing_bubble) // cut the old to force a sprite update
		telepathy_typing_bubble.icon_state = "default3"
		telepathy_typing_bubble.color = COLOR_LIGHT_PINK
		telepathy_typing_bubble.appearance_flags = RESET_COLOR | KEEP_APART
		user.add_overlay(telepathy_typing_bubble)
		return TRUE
	telepathy_typing_bubble = mutable_appearance('icons/mob/effects/talk.dmi', "default3", MOB_LAYER + 1, appearance_flags = RESET_COLOR | KEEP_APART)
	telepathy_typing_bubble.color = COLOR_LIGHT_PINK
	user.add_overlay(telepathy_typing_bubble)
	return TRUE

/// Stops the separate typing bubble overlay.
/datum/action/cooldown/power/psyker/telepathy/proc/stop_telepathy_typing_overlay(mob/living/user, sent_message)
	if(!user || QDELETED(user))
		return
	if(!telepathy_typing_bubble)
		return
	if(!sent_message) // if we didnt send a message
		if(telepathy_remove_timer)
			deltimer(telepathy_remove_timer)
			telepathy_remove_timer = null
		user.cut_overlay(telepathy_typing_bubble)
		telepathy_typing_bubble = null
		return
	// if we did send a message
	user.cut_overlay(telepathy_typing_bubble) // cut the old to force a sprite update
	telepathy_typing_bubble.icon_state = "default0"
	telepathy_typing_bubble.color = COLOR_LIGHT_PINK
	telepathy_typing_bubble.appearance_flags = RESET_COLOR | KEEP_APART
	user.add_overlay(telepathy_typing_bubble) // reapply to update.
	telepathy_remove_timer = addtimer(CALLBACK(src, PROC_REF(finalize_telepathy_typing_overlay), user, telepathy_typing_bubble), 2.5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/// Removes the telepathy typing bubble overlay after the linger delay, if still applicable.
/datum/action/cooldown/power/psyker/telepathy/proc/finalize_telepathy_typing_overlay(mob/living/user, mutable_appearance/bubble)
	telepathy_remove_timer = null
	if(!user || QDELETED(user))
		return
	if(!telepathy_typing_bubble || telepathy_typing_bubble != bubble)
		return
	if(telepathy_typing_bubble.icon_state != "default0") // we've started typing a new message.
		return
	user.cut_overlay(telepathy_typing_bubble)
	telepathy_typing_bubble = null
