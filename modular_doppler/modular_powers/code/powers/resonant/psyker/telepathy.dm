
// Telepathy, basically lifted from the mutation.

#define TELE_CLICK_NONE 0
#define TELE_CLICK_LEFT 1
#define TELE_CLICK_RIGHT 2
/datum/power/psyker_power/telepathy
	name = "Telepathy"
	desc = "Allows you to mentally communicate messages to targets. Generates a petit amount of stress."
	security_record_text = "Subject can initiate one-way communication with a target telepathically."
	value = 1
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/telepathy

/datum/action/cooldown/power/psyker/telepathy
	name = "Telepathy"
	desc = "Allows you to mentally communicate messages to the target."
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

/datum/action/cooldown/power/psyker/telepathy/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/mods = params2list(params)
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
	message = tgui_input_text(user, "What do you wish to whisper to [cast_on]?", "[src]", max_length = MAX_MESSAGE_LEN)

	// if anything happens before we finish typing the message.
	if(QDELETED(src) || QDELETED(user) || QDELETED(cast_on))
		return FALSE

	// out of range
	if(target_range && get_dist(user, cast_on) > target_range)
		user.balloon_alert(user, "they're too far!")
		return FALSE
	// no message
	if(!message)
		return FALSE

	send_thought(user, cast_on, message)
	return TRUE

/datum/action/cooldown/power/psyker/telepathy/on_action_success(mob/living/user, atom/target)
	modify_stress(PSYKER_STRESS_TRIVIAL)
	return ..()

// Picks a valid mob in view to satisfy target checks for area telepathy; doubles as a check to see if we even have anyone to telepathy to.
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

// Singular transmission
/datum/action/cooldown/power/psyker/telepathy/proc/send_thought(mob/living/caster, mob/living/target, message, disable_feedback = FALSE)
	log_directed_talk(caster, target, message, LOG_SAY, name)

	var/formatted_message = "<span class='[telepathy_span]'>[message]</span>"
	target.balloon_alert(target, "you hear a voice")
	to_chat(target, "<span class='[bold_telepathy_span]'>You hear a voice in your head...</span> [formatted_message]")

	if(!disable_feedback) // So that the AoE version doesnt spam your chat log.
		to_chat(caster, "<span class='[bold_telepathy_span]'>You transmit to [target]:</span> [formatted_message]")
		send_ghost_message(caster, target, formatted_message)


// AoE transmission
/datum/action/cooldown/power/psyker/telepathy/proc/send_area_thought(mob/living/user)
	message = tgui_input_text(user, "What do you wish to whisper to everyone in view?", "[src]", max_length = MAX_MESSAGE_LEN)
	if(QDELETED(src) || QDELETED(user))
		return FALSE
	if(!message)
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
		user.balloon_alert(user, "no minds in view!")
		return FALSE

	var/formatted_message = "<span class='[telepathy_span]'>[message]</span>"
	to_chat(user, "<span class='[bold_telepathy_span]'>You broadcast to everyone in view:</span> [formatted_message]")
	send_ghost_message(user, null, formatted_message, area_broadcast = TRUE)

	// basically goes through send_thought for each target
	for(var/mob/living/target as anything in targets)
		send_thought(user, target, message, disable_feedback = TRUE)
	return TRUE

// Tells the ghosts that telepathy talk is happening.
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
