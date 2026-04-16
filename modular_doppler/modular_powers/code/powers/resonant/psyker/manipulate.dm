/*
	I bestow upon thee my attempt to emulate telekines remoter interactions. Allows you to interact with objects from a limited distance.
	This required three nonmodular edits:
	- code\modules\mob\living\living.dm line 1384 to bypass the range gate.
	- code\modules\tgui\states.dm line 128 to bypass the UI closing
	- code\modules\mob\mob.dm line 110 to bypass the interaction gate.
	I condensed it into TRAIT_NO_UI_DISTANCE && TRAIT_REMOTE_INTERACT so that if someone else wants to do something similar, they can.
*/

/datum/power/psyker_power/manipulate
	name = "Manipulate"
	desc = "Allows you to interact with machinery and various other structures within line of sight as if it were next to you. Having UIs open from a distance using this power causes stress build-up."
	security_record_text = "Subject can psychically interact with objects from a distance."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	action_path = /datum/action/cooldown/power/psyker/manipulate
	required_powers = list(/datum/power/psyker_power/telekinesis) //given this lets you grab items from a distance this is basically a fluff requirement to explain why you can grab objects from a distance.

// Normally the golden rule is to let your action handle everything in powers; but in this case we need to actually make it so that we only have TRAIT_NO_UI_DISTANCE while we have a TK'd interface.
/datum/power/psyker_power/manipulate/process(seconds_per_tick)
	if(!power_holder)
		return
	var/datum/action/cooldown/power/psyker/manipulate/manipulate_action = action_path
	var/ui_count = manipulate_action ? length(manipulate_action.ui_filters) : 0
	if(ui_count)
		ADD_TRAIT(power_holder, TRAIT_NO_UI_DISTANCE, src)
		manipulate_action.modify_stress((PSYKER_STRESS_TRIVIAL / 2) * seconds_per_tick * ui_count) // ticks up 0.5 stress per second per ui open.
	else
		REMOVE_TRAIT(power_holder, TRAIT_NO_UI_DISTANCE, src)


/datum/action/cooldown/power/psyker/manipulate
	name = "Manipulate"
	desc = "Allows you to interact with machinery and various other structures within line of sight as if it were next to you."
	button_icon = 'icons/mob/actions/actions_mime.dmi'
	button_icon_state = "invisible_box"

	target_type = /obj
	click_to_activate = TRUE
	target_range = 12

	/// Saves if its a right click so that all click interactions are routed through use_action.
	var/right_click

	/// Saved glow effects on UI elements
	var/list/ui_filters = list()
	/// Whitelist of types allowed to be manipulated.
	var/static/list/target_whitelist = typecacheof(list(
		/obj/machinery,
		/obj/structure,
		/obj/item/radio/intercom,
	))
	/// UI blacklist for targets that should never open a UI via Manipulate.
	var/static/list/ui_blacklist = typecacheof(list(
		/obj/machinery/door/airlock,
	))

// We're manipulating click-on to A distnguish between obj machinery and obj structure and B to distinguish between left and right hand clicks.
/datum/action/cooldown/power/psyker/manipulate/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!is_type_in_typecache(target, target_whitelist))
		return FALSE

	var/list/mods = params2list(params)
	// Right click functionality.
	if(LAZYACCESS(mods, RIGHT_CLICK))
		right_click = TRUE
	..()

// We use TRAIT_REMOTE_INTERACT (temporarily) as to bypass /mob/living/can_perform_action
/datum/action/cooldown/power/psyker/manipulate/use_action(mob/living/user, atom/target)
	ADD_TRAIT(user, TRAIT_REMOTE_INTERACT, src) // this is specifically for allowing us to bypass the range interaction gate.
	new /obj/effect/temp_visual/telekinesis(get_turf(target))
	if(right_click) // rmb
		target.attack_hand_secondary(user)
	else // lmb
		target.attack_hand(user)

	// interact with UI if present and not blacklisted.
	var/allow_ui_interact = (target.interaction_flags_atom & INTERACT_ATOM_UI_INTERACT) && !is_type_in_typecache(target, ui_blacklist)
	if(allow_ui_interact)
		ADD_TRAIT(user, TRAIT_NO_UI_DISTANCE, origin_power) // we give it early so that the we count as being 'valid' before we reach the process.
		target.ui_interact(user)

		// We save the ui so we can add a filter to show it is being interacted with.
		var/datum/tgui/ui = SStgui.get_open_ui(user, target)
		// Some UIs (usually older computers) have different UI logic; in this case we fallback to looking at all the open UIs and trying to find it by comparing the source object.
		if(!ui)
			for(var/datum/tgui/candidate in user.tgui_open_uis)
				if(!candidate?.src_object)
					continue
				if(candidate.src_object == target || candidate.src_object.ui_host(user) == target)
					ui = candidate
					break
		if(ui)
			var/filter_id = "manipulate_glow"
			target.add_filter(filter_id, 1, list(type = "outline", color = "#ff66cc", size = 2))
			var/filter = target.get_filter(filter_id)
			if(filter)
				animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
				animate(alpha = 40, time = 2.5 SECONDS)
			ui_filters[ui] = list(target, filter_id)

			RegisterSignal(target, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
			RegisterSignal(ui, COMSIG_QDELETING, PROC_REF(on_ui_closed))

	REMOVE_TRAIT(user, TRAIT_REMOTE_INTERACT, src)
	right_click = FALSE
	modify_stress(PSYKER_STRESS_TRIVIAL * 2)
	return TRUE

/// Ends the ongoing glow effect when the UI is closed.
/datum/action/cooldown/power/psyker/manipulate/proc/on_ui_closed(datum/tgui/ui)
	SIGNAL_HANDLER
	var/list/entry = ui_filters[ui]
	if(entry)
		var/atom/target = entry[1]
		var/filter_id = entry[2]
		target?.remove_filter(filter_id)
		ui_filters -= ui
		UnregisterSignal(target, COMSIG_ATOM_DISPEL)

/// Closes any open UIs on a manipulated object.
/datum/action/cooldown/power/psyker/manipulate/proc/on_dispel(atom/source, atom/dispeller)
	SIGNAL_HANDLER
	var/list/uis_to_close = list()
	for(var/datum/tgui/ui as anything in ui_filters)
		var/list/entry = ui_filters[ui]
		if(entry && entry[1] == source)
			uis_to_close += ui

	for(var/datum/tgui/ui as anything in uis_to_close)
		ui?.close()
