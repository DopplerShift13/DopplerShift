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
	desc = "Allows you to interact with machinery and various other structures within line of sight as if it were next to you."

	value = 2
	action_path = /datum/action/cooldown/power/psyker/manipulate
	mob_trait = TRAIT_NO_UI_DISTANCE
	required_powers = list(/datum/power/psyker_power/telekinesis) //given this lets you grab items from certain things from a distance this is basically a fluff requirement to explain why you can grab objects from a distance.

/datum/action/cooldown/power/psyker/manipulate
	name = "Manipulate"
	desc = "Allows you to interact with machinery and various other structures within line of sight as if it were next to you."
	button_icon = 'icons/mob/actions/actions_mime.dmi'
	button_icon_state = "invisible_box"

	target_type = /obj
	click_to_activate = TRUE
	target_range = 12

	// Saves if its a right click so that all click interactions are routed through use_action.
	var/right_click

	// Saved glow effects on UI elements
	var/list/ui_filters = list()

// We're manipulating click-on to A distnguish between obj machinery and obj structure and B to distinguish between left and right hand clicks.
/datum/action/cooldown/power/psyker/manipulate/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!istype(target, /obj/machinery) && !istype(target, /obj/structure))
		return FALSE

	var/list/mods = params2list(params)
	// Right click functionality.
	if(LAZYACCESS(mods, RIGHT_CLICK))
		right_click = TRUE
	..()

// We use TRAIT_REMOTE_INTERACT (temporarily) as to bypass /mob/living/can_perform_action
/datum/action/cooldown/power/psyker/manipulate/use_action(mob/living/user, atom/target)
	ADD_TRAIT(user, TRAIT_REMOTE_INTERACT, src) // this is specifically for allowing us to bypass the interaction gate.
	new /obj/effect/temp_visual/telekinesis(get_turf(target))
	if(right_click) // rmb
		target.attack_hand_secondary(user)
	else // lmb
		target.attack_hand(user)

	// interact with UI if present.
	if(target.interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		target.ui_interact(user)

		// We save the ui so we can add a filter
		var/datum/tgui/ui = SStgui.get_open_ui(user, target)
		if(ui)
			var/filter_id = "manipulate_glow"
			target.add_filter(filter_id, 1,	list(type = "outline", color = "#ff66cc", size = 2))
			animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
			animate(alpha = 40, time = 2.5 SECONDS)
			ui_filters[ui] = list(target, filter_id)

			RegisterSignal(ui, COMSIG_QDELETING, PROC_REF(on_ui_closed))

	REMOVE_TRAIT(user, TRAIT_REMOTE_INTERACT, src)
	right_click = FALSE
	modify_stress(PSYKER_STRESS_TRIVIAL)
	return TRUE

/datum/action/cooldown/power/psyker/manipulate/proc/on_ui_closed(datum/tgui/ui)
	SIGNAL_HANDLER
	var/list/entry = ui_filters[ui]
	if(entry)
		var/atom/target = entry[1]
		var/filter_id = entry[2]
		target?.remove_filter(filter_id)
		ui_filters -= ui
