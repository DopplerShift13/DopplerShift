#define BRICK_SCRYERPHONE_RINGING_INTERVAL (3 SECONDS)
#define BRICK_SCRYERPHONE_RINGING_DURATION (15 SECONDS)

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
	/// An additional name tag for the scryer, seen as "MODlink scryer - [label]"
	var/label

	/// Initial name. Recorded to recognize loadout name changes.
	var/old_name
	/// Override for the base name used when setting labels.
	var/base_name
	
	/// Reference to the MODlink currently calling us.
	var/datum/weakref/calling_mod_link_ref
	/// ID for the timer used to end incoming calls.
	var/calling_timer_id

/obj/item/brick_phone_scryer/Initialize(mapload)
	. = ..()
	old_name = name
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
	register_context()

/obj/item/brick_phone_scryer/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(mod_link)
	calling_mod_link_ref = null
	STOP_PROCESSING(SSobj, src)
	if(calling_timer_id)
		deltimer(calling_timer_id)
		calling_timer_id = null
	return ..()

/obj/item/brick_phone_scryer/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	context[SCREENTIP_CONTEXT_CTRL_LMB] = "[label ? "Reset" : "Set"] name"
	if(held_item == src)
		context[SCREENTIP_CONTEXT_LMB] = "Answer call"
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
	. += span_notice("Using a multitool, <b>left-click</b> to imprint or <b>right-click</b> to copy frequency.")
	. += span_notice("<b>Ctrl-click</b> to set or reset its name.")

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

/obj/item/brick_phone_scryer/click_ctrl(mob/user)
	// We're a brick phone. Always go clicky.
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

	if(label)
		balloon_alert(user, "reset name")
		label = null
		update_name()
		return CLICK_ACTION_SUCCESS

	var/new_label = reject_bad_text(tgui_input_text(user, "Change the visible name", "Set Name", label, MAX_NAME_LEN))
	if(QDELETED(user) || !user.is_holding(src))
		return CLICK_ACTION_BLOCKING
	if(!new_label)
		balloon_alert(user, "invalid name!")
		return CLICK_ACTION_BLOCKING

	label = new_label
	balloon_alert(user, "set name")
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)
	update_name()
	return CLICK_ACTION_SUCCESS

/obj/item/brick_phone_scryer/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!istype(tool))
		return NONE
	if(isnull(tool.buffer))
		balloon_alert(user, "buffer empty!")
		return ITEM_INTERACT_BLOCKING
	if(istype(tool.buffer, /datum/mod_link))
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

	tool.set_buffer(mod_link.frequency)
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
	playsound(src, 'sound/machines/click.ogg', 50, vary = TRUE)

/obj/item/brick_phone_scryer/process(seconds_per_tick)
	if(isnull(mod_link.link_call))
		return
	if(isnull(cell))
		return
	cell.use(0.02 * STANDARD_CELL_RATE * seconds_per_tick, force = TRUE)

/obj/item/brick_phone_scryer/proc/incoming_call_loop()
	if(isnull(cell))
		return
	if(!cell.charge)
		return

	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link) || calling_mod_link.link_call)
		incoming_call_end()
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 15, vary = TRUE)
		return

	var/mob/living/calling_user = calling_mod_link.get_user()
	if(isnull(calling_user))
		incoming_call_end()
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 15, vary = TRUE)
		return

	calling_user.playsound_local(get_turf(calling_mod_link.holder), 'sound/machines/beep/twobeep.ogg', 15, vary = TRUE)
	playsound(src, 'sound/items/weapons/ring.ogg', 15, vary = TRUE)
	Shake(pixelshiftx = 1, pixelshifty = 1, duration = 0.75 SECONDS, shake_interval = 0.02 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(incoming_call_loop)), BRICK_SCRYERPHONE_RINGING_INTERVAL)

/obj/item/brick_phone_scryer/proc/incoming_call_end()
	if(calling_timer_id)
		deltimer(calling_timer_id)
		calling_timer_id = null
	calling_mod_link_ref = null

/obj/item/brick_phone_scryer/update_name(updates)
	. = ..()
	if(isnull(base_name) && (old_name != name)) // If other customization has set our name.
		base_name = name // Then we use that as the base name from now on.

	var/namepart = base_name ? base_name : initial(name)
	var/labelpart = label ? " - [label]" : ""
	name = "[namepart][labelpart]"

/obj/item/brick_phone_scryer/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == cell)
		cell = null

/obj/item/brick_phone_scryer/proc/get_user()
	if(!iscarbon(loc))
		return null
	var/mob/living/carbon/user = loc
	if(!user.is_holding(src))
		return null
	return user

/obj/item/brick_phone_scryer/proc/can_call()
	return cell?.charge // You can call this whenever, whatever, forever... As long as it's charged, that is.

/obj/item/brick_phone_scryer/proc/make_link_visual()
	return make_link_visual_generic(mod_link, PROC_REF(on_overlay_change))

/obj/item/brick_phone_scryer/proc/get_link_visual(atom/movable/visuals)
	return get_link_visual_generic(mod_link, visuals, PROC_REF(on_user_set_dir))

/obj/item/brick_phone_scryer/proc/delete_link_visual()
	return delete_link_visual_generic(mod_link)

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

	incoming_call_end()
	var/mob/living/calling_user = calling_mod_link.get_user()
	if(isnull(calling_user))
		balloon_alert(user, "no response!")
		return
	if(mod_link.link_call || calling_mod_link.link_call)
		balloon_alert(user, "already in a call!")
		return

	new /datum/mod_link_call(calling_mod_link, mod_link)
	calling_mod_link.holder.balloon_alert(calling_user, "call accepted")

/obj/item/brick_phone_scryer/proc/deny_call()
	var/datum/mod_link/calling_mod_link = calling_mod_link_ref?.resolve()
	if(isnull(calling_mod_link))
		return

	incoming_call_end()
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