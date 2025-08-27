#define BRICK_SCRYERPHONE_RINGING_INTERVAL (3 SECONDS)
#define BRICK_SCRYERPHONE_RINGING_DURATION (15 SECONDS)
/// Rate at which we discharge when in use, per second.
#define BRICK_SCRYERPHONE_DISCHARGE_RATE (0.002 * STANDARD_CELL_RATE)
// The calling time left in our cell before we give our first warning, while in a call.
#define BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING (10 MINUTES)
// The calling time left in our cell before we give our last warning, while in a call.
#define BRICK_SCRYERPHONE_TIME_LEFT_LAST_INCALL_WARNING (2 MINUTES)
/// The calling time left in our cell before we start warning whenever we start a call.
#define BRICK_SCRYERPHONE_TIME_LEFT_START_PRECALL_WARNINGS BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING

/obj/item/brick_phone_scryer
	name = "brick scryerphone"
	desc = "An ancient-looking brick phone, refurbished to turn it into a MODlink-compatible device. It can only do video calls now."
	icon = 'icons/obj/antags/gang/cell_phone.dmi'
	icon_state = "phone_off"
	w_class = WEIGHT_CLASS_SMALL

	// Center sprite.
	SET_BASE_PIXEL(3, 3)

	// Thing hits like an actual brick.
	force = 10
	throwforce = 10
	throw_speed = 2
	throw_range = 2

	/// The installed power cell.
	var/obj/item/stock_parts/power_store/cell
	/// The MODlink datum we operate.
	var/datum/mod_link/mod_link
	/// Initial frequency of the MODlink.
	var/starting_frequency
	/// A name tag for the scryer, seen in the list of MODlinks.
	var/label
	
	/// Reference to the MODlink currently calling us.
	var/datum/weakref/calling_mod_link_ref
	/// ID for the timer used to end incoming calls.
	var/calling_timer_id
	/// ID for the timer used for our ringing loop.
	var/calling_loop_timer_id

	/// Whether we have handled our first incall warning for low time left.
	var/first_incall_warning_handled = FALSE
	/// Whether we have handled our last incall warning for low time left.
	var/last_incall_warning_handled = FALSE

	/// Whether this phone has had its ringer silenced.
	var/ringing_silenced = FALSE

/obj/item/brick_phone_scryer/Initialize(mapload)
	. = ..()
	mod_link = new(
		src,
		starting_frequency,
		CALLBACK(src, PROC_REF(get_user)),
		CALLBACK(src, PROC_REF(can_call)),
		CALLBACK(src, PROC_REF(make_link_visual)),
		CALLBACK(src, PROC_REF(get_link_visual)),
		CALLBACK(src, PROC_REF(delete_link_visual))
	)
	mod_link.override_called_logic_callback = CALLBACK(src, PROC_REF(override_called_logic))
	START_PROCESSING(SSobj, src)
	set_label(label)
	register_context()

/obj/item/brick_phone_scryer/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(mod_link)
	calling_mod_link_ref = null
	STOP_PROCESSING(SSobj, src)
	if(calling_timer_id)
		deltimer(calling_timer_id)
		calling_timer_id = null
	if(calling_loop_timer_id)
		deltimer(calling_loop_timer_id)
		calling_loop_timer_id = null
	return ..()

/obj/item/brick_phone_scryer/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	context[SCREENTIP_CONTEXT_CTRL_LMB] = "[label ? "Reset" : "Set"] label"
	if(held_item == src)
		context[SCREENTIP_CONTEXT_LMB] = (calling_mod_link_ref?.resolve() ? "Answer call" : "Call")
		context[SCREENTIP_CONTEXT_RMB] = "[mod_link.link_call ? "End" : "Deny"] call"
	else if(isnull(held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Remove cell"
	else if(istype(held_item, /obj/item/stock_parts/power_store/cell))
		context[SCREENTIP_CONTEXT_LMB] = "[cell ? "Swap" : "Add"] cell"
	else if(istype(held_item, /obj/item/multitool))
		context[SCREENTIP_CONTEXT_LMB] = "Set frequency"
		context[SCREENTIP_CONTEXT_RMB] = "Copy frequency"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/brick_phone_scryer/examine(mob/user)
	. = ..()
	. += span_notice("<b>Left-click</b> inhand to answer calls, <b>Right-click</b> to deny them.")
	if(cell)
		. += span_notice("The battery charge reads [cell.percent()]%. <b>Right-click</b> with an empty hand to remove it.")
	else
		. += span_notice("It is missing a battery. One can be installed by clicking on it with a power cell .")
	. += span_notice("The MODlink ID is [mod_link.id], frequency is [mod_link.frequency || "unset"].")
	. += span_notice("The MODlink label is '[label || "unset"]'.")
	. += span_notice("Using a multitool, <b>left-click</b> to imprint or <b>right-click</b> to copy frequency.")
	. += span_notice("<b>Ctrl-click</b> to [label ? "reset" : "set"] its label.")

/obj/item/brick_phone_scryer/equipped(mob/living/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HANDS)
		mod_link?.end_call()

/obj/item/brick_phone_scryer/dropped(mob/living/user)
	. = ..()
	mod_link?.end_call()

/obj/item/brick_phone_scryer/attack_self(mob/user, modifiers)
	// We're a brick phone. Always go clicky.
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(calling_mod_link)
		answer_call(user)
		return

	if(mod_link.link_call)
		mod_link.end_call()
		return

	if(QDELETED(cell))
		balloon_alert(user, "no cell installed!")
		return
	if(!cell.charge)
		balloon_alert(user, "no charge!")
		return
	if(isnull(mod_link.frequency))
		balloon_alert(user, "set frequency first!")
		return
	check_precall_warnings(user)
	call_link(user, mod_link)

/obj/item/brick_phone_scryer/attack_self_secondary(mob/user, modifiers)
	// We're a brick phone. Always go clicky.
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

	if(mod_link.link_call)
		mod_link.end_call()
		return

	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link))
		balloon_alert(user, "nobody calling!")
		return

	balloon_alert(user, "call denied")
	deny_call()

/obj/item/brick_phone_scryer/attack_hand_secondary(mob/user, list/modifiers)
	if(isnull(cell))
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	user.put_in_hands(cell)
	balloon_alert(user, "cell removed")
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/brick_phone_scryer/item_ctrl_click(mob/user)
	if(!user.is_holding(src))
		return NONE

	// We're a brick phone. Always go clicky.
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

	if(label)
		balloon_alert(user, "reset label")
		set_label(null)
		return CLICK_ACTION_SUCCESS

	var/new_label = reject_bad_text(tgui_input_text(user, "Change the visible label", "Set Label", label, MAX_NAME_LEN))
	if(QDELETED(user) || !user.is_holding(src))
		return CLICK_ACTION_BLOCKING
	if(!new_label)
		balloon_alert(user, "invalid label!")
		return CLICK_ACTION_BLOCKING

	set_label(new_label)
	balloon_alert(user, "set label")
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)
	return CLICK_ACTION_SUCCESS

/obj/item/brick_phone_scryer/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!istype(tool))
		return NONE
	if(isnull(tool.buffer))
		balloon_alert(user, "buffer empty!")
		return ITEM_INTERACT_BLOCKING
	if(!istype(tool.buffer, /datum/mod_link))
		balloon_alert(user, "wrong buffer!")
		return ITEM_INTERACT_BLOCKING
	var/datum/mod_link/buffer_link = tool.buffer
	if(mod_link.frequency == buffer_link.frequency)
		balloon_alert(user, "same frequency!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "set frequency")
	mod_link.frequency = buffer_link.frequency
	return ITEM_INTERACT_SUCCESS

/obj/item/brick_phone_scryer/multitool_act_secondary(mob/living/user, obj/item/multitool/tool)
	if(!istype(tool))
		return NONE
	if(isnull(mod_link.frequency))
		balloon_alert(user, "no frequency!")
		return ITEM_INTERACT_BLOCKING

	tool.set_buffer(mod_link)
	balloon_alert(user, "copied frequency")
	return ITEM_INTERACT_SUCCESS

/obj/item/brick_phone_scryer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stock_parts/power_store/cell))
		return NONE
	if(!user.transferItemToLoc(tool, src))
		return NONE

	if(cell)
		user.put_in_hands(cell)
		balloon_alert(user, "cell swapped")
	else
		balloon_alert(user, "cell installed")
	cell = tool
	reset_incall_warnings()
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

/// Gets the call time left, in deciseconds.
/obj/item/brick_phone_scryer/proc/get_call_time_left()
	if(isnull(cell))
		return 0
	return (cell.charge() / BRICK_SCRYERPHONE_DISCHARGE_RATE) SECONDS

/// Takes in a time in deciseconds, and sends the given user an "X minutes left!" warning.
/obj/item/brick_phone_scryer/proc/warn_minutes_left(mob/living/user, time_in_deciseconds)
	var/seconds = FLOOR(time_in_deciseconds * 0.1, 1)
	var/minutes = FLOOR(seconds / 60, 1)
	if(minutes > 0)
		balloon_alert(user, "[minutes] minute[minutes > 1 ? "s" : ""] left!")
	else
		balloon_alert(user, "no time left!")
	user.playsound_local(get_turf(src), 'sound/machines/beep/twobeep.ogg', 15, vary = TRUE)

/// Checks whether we should send a precall warning, and does so if needed.
/obj/item/brick_phone_scryer/proc/check_precall_warnings(mob/living/user)
	var/time_left = get_call_time_left()
	if(time_left > BRICK_SCRYERPHONE_TIME_LEFT_START_PRECALL_WARNINGS)
		return

	warn_minutes_left(user, time_left)

/// Resets our incall warning trackers, and makes sure we don't give unnecessary warnings.
/obj/item/brick_phone_scryer/proc/reset_incall_warnings()
	first_incall_warning_handled = FALSE
	last_incall_warning_handled = FALSE

	var/time_left = get_call_time_left()
	if(time_left <= BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING)
		first_incall_warning_handled = TRUE
	if(time_left <= BRICK_SCRYERPHONE_TIME_LEFT_LAST_INCALL_WARNING)
		last_incall_warning_handled = TRUE

/// Checks whether we should run our incall warnings, and does so if needed.
/obj/item/brick_phone_scryer/proc/check_incall_warnings()
	var/mob/living/user = get_user()
	if(isnull(user))
		return

	var/time_left = get_call_time_left()
	if(!first_incall_warning_handled)
		if(time_left > BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING)
			return
		warn_minutes_left(user, BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING)
		first_incall_warning_handled = TRUE
		return
	if(!last_incall_warning_handled)
		if(time_left > BRICK_SCRYERPHONE_TIME_LEFT_LAST_INCALL_WARNING)
			return
		warn_minutes_left(user, BRICK_SCRYERPHONE_TIME_LEFT_LAST_INCALL_WARNING)
		last_incall_warning_handled = TRUE
		return

/obj/item/brick_phone_scryer/process(seconds_per_tick)
	if(isnull(mod_link.link_call))
		return
	if(isnull(cell))
		return
	cell.use(BRICK_SCRYERPHONE_DISCHARGE_RATE * seconds_per_tick, force = TRUE)
	check_incall_warnings()

/obj/item/brick_phone_scryer/proc/incoming_call_loop()
	if(isnull(cell))
		return
	if(!cell.charge)
		return

	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link) || calling_mod_link.link_call)
		incoming_call_end()
		return

	var/mob/living/calling_user = calling_mod_link.get_user()
	if(isnull(calling_user))
		incoming_call_end()
		return

	calling_user.playsound_local(get_turf(calling_mod_link.holder), 'sound/machines/beep/twobeep.ogg', 15, vary = TRUE)
	if(!ringing_silenced)
		playsound(src, 'sound/items/weapons/ring.ogg', 15, vary = TRUE)
	perform_shake()
	calling_loop_timer_id = addtimer(CALLBACK(src, PROC_REF(incoming_call_loop)), BRICK_SCRYERPHONE_RINGING_INTERVAL, TIMER_STOPPABLE)

/obj/item/brick_phone_scryer/proc/incoming_call_end(buzz_us = TRUE, buzz_caller = TRUE)
	if(calling_timer_id)
		deltimer(calling_timer_id)
		calling_timer_id = null
	if(calling_loop_timer_id)
		deltimer(calling_loop_timer_id)
		calling_loop_timer_id = null

	if(buzz_us)
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 15, vary = TRUE)
		balloon_alert_to_viewers("call ended!")
	if(buzz_caller)
		var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
		var/mob/living/calling_user = calling_mod_link.get_user()
		if(calling_user)
			calling_user.playsound_local(get_turf(calling_mod_link.holder), 'sound/machines/buzz/buzz-sigh.ogg', 15, vary = TRUE)
	
	calling_mod_link_ref = null

/obj/item/brick_phone_scryer/proc/perform_shake()
	var/atom/topmost_atom = get_atom_on_turf(src)
	topmost_atom.Shake(pixelshiftx = 1, pixelshifty = 1, duration = 0.75 SECONDS, shake_interval = 0.02 SECONDS)

/obj/item/brick_phone_scryer/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == cell)
		cell = null

/obj/item/brick_phone_scryer/proc/set_label(new_label)
	label = new_label
	mod_link.visual_name = new_label ? "[new_label] (Phone)" : "Unlabeled Phone"

/obj/item/brick_phone_scryer/proc/get_user()
	if(!isliving(loc))
		return null
	var/mob/living/user = loc
	if(!user.is_holding(src))
		return null
	return user

/obj/item/brick_phone_scryer/proc/can_call()
	return cell?.charge // You can call this whenever, whatever, forever... As long as it's charged, that is.

/obj/item/brick_phone_scryer/proc/make_link_visual()
	return make_link_visual_generic(mod_link, PROC_REF(on_overlay_change))

/obj/item/brick_phone_scryer/proc/get_link_visual(atom/movable/visuals)
	return get_link_visual_generic(mod_link, visuals, PROC_REF(on_user_set_dir))

/obj/item/brick_phone_scryer/proc/delete_link_visual(old_user)
	return delete_link_visual_generic(mod_link, old_user)

/obj/item/brick_phone_scryer/proc/override_called_logic(datum/mod_link/new_calling, mob/calling_user)
	if(!can_call())
		new_calling.holder.balloon_alert(calling_user, "can't call!")
		return TRUE
	if(mod_link.link_call)
		new_calling.holder.balloon_alert(calling_user, "target already in call!")
		return TRUE
	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(calling_mod_link)
		new_calling.holder.balloon_alert(calling_user, "target busy!")
		return TRUE

	balloon_alert_to_viewers("incoming call!")
	calling_mod_link_ref = WEAKREF(new_calling)
	incoming_call_loop()
	calling_timer_id = addtimer(CALLBACK(src, PROC_REF(incoming_call_end)), BRICK_SCRYERPHONE_RINGING_DURATION, TIMER_STOPPABLE)
	return TRUE

/obj/item/brick_phone_scryer/proc/answer_call(mob/living/user)
	if(!istype(user))
		balloon_alert(user, "invalid user!")
		return

	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link))
		balloon_alert(user, "no calls!")
		return

	incoming_call_end(buzz_us = FALSE, buzz_caller = FALSE)
	var/mob/living/calling_user = calling_mod_link.get_user()
	if(isnull(calling_user))
		balloon_alert(user, "no response!")
		return
	if(mod_link.link_call || calling_mod_link.link_call)
		balloon_alert(user, "already in a call!")
		return

	new /datum/mod_link_call(calling_mod_link, mod_link)
	check_precall_warnings(user)
	calling_mod_link.holder.balloon_alert(calling_user, "call accepted")

/obj/item/brick_phone_scryer/proc/deny_call()
	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link))
		return

	incoming_call_end(buzz_us = FALSE)
	var/mob/living/calling_user = calling_mod_link.get_user()
	if(isnull(calling_user))
		return
	calling_mod_link.holder.balloon_alert(calling_user, "call denied!")

/obj/item/brick_phone_scryer/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods, message_range)
	. = ..()
	if(speaker != loc)
		return
	mod_link.visual.say(raw_message, spans = spans, sanitize = FALSE, language = message_language, message_range = 3, message_mods = message_mods)

/obj/item/brick_phone_scryer/proc/on_overlay_change(atom/source, cache_index, overlay)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(update_link_visual)), 1 TICKS, TIMER_UNIQUE)

/obj/item/brick_phone_scryer/proc/update_link_visual()
	if(QDELETED(mod_link.link_call))
		return
	var/mob/living/user = loc
	mod_link.visual.cut_overlay(mod_link.visual_overlays)
	mod_link.visual_overlays = user.overlays - user.active_thinking_indicator
	mod_link.visual.add_overlay(mod_link.visual_overlays)

/obj/item/brick_phone_scryer/proc/on_user_set_dir(atom/source, dir, newdir)
	SIGNAL_HANDLER
	on_user_set_dir_generic(mod_link, newdir || SOUTH)


/**
 * Pre-loaded brick scryerphones
 */

/obj/item/brick_phone_scryer/loaded/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/power_store/cell/high(src)

/obj/item/brick_phone_scryer/loaded/crew
	starting_frequency = MODLINK_FREQ_NANOTRASEN

/obj/item/brick_phone_scryer/loaded/antag
	starting_frequency = MODLINK_FREQ_SYNDICATE

// Special brick phone that can swap frequencies.
/obj/item/brick_phone_scryer/loaded/antag/burner
	name = "brick burnerphone"
	desc = "An ancient-looking brick phone, refurbished to turn it into a MODlink-compatible device. It can only do video calls now."

/obj/item/brick_phone_scryer/loaded/antag/burner/examine(mob/user)
	. = ..()
	. += span_notice("<b>Alt-click</b> to toggle frequency.")

/obj/item/brick_phone_scryer/loaded/antag/burner/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Toggle frequency range"

/obj/item/brick_phone_scryer/loaded/antag/burner/click_alt(mob/user)
	// We're a brick phone. Always go clicky.
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

	if(mod_link.frequency == MODLINK_FREQ_NANOTRASEN)
		mod_link.frequency = MODLINK_FREQ_SYNDICATE
		balloon_alert(user, "connected to cantina")
		return

	mod_link.frequency = MODLINK_FREQ_NANOTRASEN
	balloon_alert(user, "connected to 9lp")

#undef BRICK_SCRYERPHONE_RINGING_INTERVAL
#undef BRICK_SCRYERPHONE_RINGING_DURATION
#undef BRICK_SCRYERPHONE_DISCHARGE_RATE
#undef BRICK_SCRYERPHONE_TIME_LEFT_FIRST_INCALL_WARNING
#undef BRICK_SCRYERPHONE_TIME_LEFT_LAST_INCALL_WARNING
#undef BRICK_SCRYERPHONE_TIME_LEFT_START_PRECALL_WARNINGS