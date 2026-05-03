/*
 Telekinesis. This is one of the earliest made powers and is a port of how the grab module from MODs do it. It's a bit messy as a consequence; even after this was cleaned up later in production.
*/

#define TK_CLICK_NONE 0
#define TK_CLICK_TRIGGER 1
#define TK_CLICK_MIDDLE 2
#define TK_CLICK_RIGHT 3

/datum/power/psyker_power/telekinesis
	name = "Telekinesis"
	desc = "Grants the ability to manipulate and move various objects. Generates stress based upon weight on pick-up and throw, as well as passively while holding an object."
	security_record_text = "Subject can wield telekinesis to maneuver and fling objects."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/telekinesis

/datum/action/cooldown/power/psyker/telekinesis
	name = "Telekinesis"
	desc = "Middle-click to grab an object, Right-Click to drop, Middle-Click again to punt!"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "repulse"
	click_to_activate = TRUE
	target_self = FALSE

	unset_after_click = FALSE
	target_range = 255 // this is just for show.

	mental = FALSE // We are lifting them with the mind but it doesn't affect the target's mind

	/// Range of the kinesis grab.
	var/grab_range = 8

	/// Stat required for us to grab a mob.
	var/stat_required = DEAD

	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom

	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	/// Overlay we add to the player when using this power.
	var/mutable_appearance/player_icon

	/// Mouse tracker overlay (telekinesis-specific)
	var/atom/movable/screen/fullscreen/cursor_catcher/kinesis/psyker_tk/kinesis_catcher
	/// Which mouse click is used in use_action
	var/tk_click_type = TK_CLICK_NONE

// Auto-clear the grab if we disable the power + a bit of UI feedback.
/datum/action/cooldown/power/psyker/telekinesis/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	if(grabbed_atom)
		clear_grab(playsound = FALSE)
		to_chat(owner, span_notice("You relax your telekinetic powers."))
	else
		to_chat(owner, span_notice("You focus your telekinetic powers...<br><B>Middle-click</B>: Grab/Punt<B> | Right-click</B>: Drop<B> | Move mouse</B>: to drag"))
	return TRUE

// We need to disseminate which mouse-press is done for our effects.
/datum/action/cooldown/power/psyker/telekinesis/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/mods = params2list(params)
	if(LAZYACCESS(mods, RIGHT_CLICK))
		tk_click_type = TK_CLICK_RIGHT
	else if(LAZYACCESS(mods, MIDDLE_CLICK))
		tk_click_type = TK_CLICK_MIDDLE
	else
		return FALSE // do not consume the click on lefties.

	. = ..()
	if(!.)
		tk_click_type = TK_CLICK_NONE
	return TRUE // always return true in right and middle clicks.

/datum/action/cooldown/power/psyker/telekinesis/use_action(mob/living/user, atom/target)
	// gets the mouseclick and saves it; reverts for the next.
	var/click_type = tk_click_type
	tk_click_type = TK_CLICK_NONE

	// Change effects depending on right and middel click.
	switch(click_type)
		// Drops the item.
		if(TK_CLICK_RIGHT)
			if(grabbed_atom)
				clear_grab()
				return TRUE
			return FALSE

		// Grabs if empty, or punts if holding.
		if(TK_CLICK_MIDDLE)
			if(INCAPACITATED_IGNORING(user, INCAPABLE_GRAB))
				owner.balloon_alert(user, span_warning("Cannot grab target!"))
				return FALSE
			// Attempt to grab if we aren't holding anything.
			if(!grabbed_atom)
				if(!target)
					owner.balloon_alert(user, span_warning("No target!"))
					return FALSE
				if(!range_check(user, target))
					owner.balloon_alert(user, span_warning("Too far!"))
					return FALSE
				if(!can_grab(user, target))
					owner.balloon_alert(user, span_warning("Cannot grab target!"))
					return FALSE

				grab_atom(target)
				return TRUE
			// Punt if we are holding something.
			punt_held(user, target)
			return TRUE

	return FALSE

/datum/action/cooldown/power/psyker/telekinesis/Grant(mob/granted_to)
	. = ..()
	if(resonant)
		RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/psyker/telekinesis/Remove(mob/removed_from)
	. = ..()
	if(resonant)
		UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/// Calculates the stres cost of vairous interactions.
/datum/action/cooldown/power/psyker/telekinesis/proc/get_stress_cost_for_atom(atom/target)
	var/cost
	// You shouldn't get as stressed from picking up a pen as a closet.
	if(isitem(target))
		var/obj/item/tk_item = target
		switch(tk_item.w_class)
			if(WEIGHT_CLASS_TINY)
				cost = PSYKER_STRESS_TRIVIAL
			if(WEIGHT_CLASS_SMALL)
				cost = PSYKER_STRESS_TRIVIAL * 2
			if(WEIGHT_CLASS_NORMAL)
				cost = PSYKER_STRESS_TRIVIAL * 4
			if(WEIGHT_CLASS_BULKY)
				cost = PSYKER_STRESS_MINOR * 0.8
	else
		cost = PSYKER_STRESS_MINOR // structures, superheavy things, basically anything that goes beyond w_class.

	return cost

// Important note; because we use the action's proccess, we override cooldown processing.
/datum/action/cooldown/power/psyker/telekinesis/process(seconds_per_tick)
	var/mob/living/user = owner
	if(!grabbed_atom || !user?.client)
		STOP_PROCESSING(SSfastprocess, src)
		return

	if(INCAPACITATED_IGNORING(user, INCAPABLE_GRAB))
		clear_grab()
		return

	if(!range_check(user, grabbed_atom))
		to_chat(user, span_warning("Out of range!"))
		clear_grab()
		return

	if(kinesis_catcher?.mouse_params)
		kinesis_catcher.calculate_params()
	if(!kinesis_catcher?.given_turf)
		return

	var/turf/target_turf = kinesis_catcher.given_turf
	if(!target_turf)
		return

	// Dragging along the floor
	if(grabbed_atom.loc != target_turf)
		var/turf/next_turf = get_step_towards(grabbed_atom, target_turf)

		if(grabbed_atom.Move(next_turf, get_dir(grabbed_atom, next_turf), 8))
			// If the item is in our space, do we scoop it up?
			if(isitem(grabbed_atom) && (user in next_turf))
				var/obj/item/grabbed_item = grabbed_atom
				clear_grab(playsound = FALSE)
				grabbed_item.pickup(user)
				user.put_in_hands(grabbed_item)
				return


	modify_stress(PSYKER_STRESS_TRIVIAL * seconds_per_tick) // As long as you don't do anything fancy and aren't stressed already, you can do this forever.

/// The fun part, punting shit.
/datum/action/cooldown/power/psyker/telekinesis/proc/punt_held(mob/living/user, atom/target)
	if(!grabbed_atom)
		return

	// Where are we throwing it?
	var/turf/throw_turf = target ? get_turf(target) : null

	// If target didn't resolve (common on middle click), derive turf from cursor catcher
	if(!throw_turf && kinesis_catcher)
		kinesis_catcher.calculate_params()
		throw_turf = kinesis_catcher.given_turf

	if(!throw_turf)
		owner.balloon_alert(user, span_warning("No target!"))
		return

	var/atom/movable/launched = grabbed_atom

	// Basically the same stress cost for picking it up.
	modify_stress(get_stress_cost_for_atom(launched))

	clear_grab(playsound = FALSE)
	playsound(launched, 'sound/effects/magic/repulse.ogg', 75, TRUE)

	launched.throw_at(
		throw_turf,
		range = grab_range,
		speed = (launched.density ? 3 : 4),
		thrower = user,
		spin = isitem(launched)
	)

/// The proverbial leash.
/datum/action/cooldown/power/psyker/telekinesis/proc/range_check(mob/living/user, atom/target)
	if(!user || !isturf(user.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	return (target in view(grab_range, user))

/// Can we ACTUALLY grab it or will it just fizz out?
/datum/action/cooldown/power/psyker/telekinesis/proc/can_grab(mob/living/user, atom/target)
	if(user == target)
		return FALSE
	if(!ismovable(target))
		return FALSE
	if(iseffect(target))
		return FALSE

	var/atom/movable/movable_target = target
	if(movable_target.anchored)
		return FALSE
	if(movable_target.throwing)
		return FALSE
	if(movable_target.move_resist >= MOVE_FORCE_OVERPOWERING)
		return FALSE

	if(ismob(movable_target))
		if(!isliving(movable_target))
			return FALSE
		var/mob/living/living_target = movable_target
		if(living_target.buckled)
			return FALSE
		if(living_target.stat < stat_required)
			return FALSE
	else if(isitem(movable_target))
		var/obj/item/item_target = movable_target
		if(item_target.w_class >= WEIGHT_CLASS_GIGANTIC)
			return FALSE
		if(item_target.item_flags & ABSTRACT)
			return FALSE

	return TRUE

/// Attempts to grab a target atom
/datum/action/cooldown/power/psyker/telekinesis/proc/grab_atom(atom/movable/target)
	// If anything was already held, clear it first
	if(grabbed_atom)
		clear_grab(playsound = FALSE)
	grabbed_atom = target
	active = TRUE

	// Mob handling like module_kinesis
	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
		RegisterSignal(grabbed_atom, COMSIG_MOB_STATCHANGE, PROC_REF(on_statchange))

	ADD_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	RegisterSignal(grabbed_atom, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

	playsound(grabbed_atom, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	kinesis_icon = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "psychic",
		layer = grabbed_atom.layer - 0.1,
		appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
	)
	player_icon = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "purplesparkles",
		layer = owner.layer - 0.1,
		appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
	)
	grabbed_atom.add_overlay(kinesis_icon)
	owner.add_overlay(player_icon)

	// Even though the modsuit catcher is global, we want our own so we can tweak the visuals.
	if(!kinesis_catcher)
		kinesis_catcher = owner.overlay_fullscreen("psyker_tk", /atom/movable/screen/fullscreen/cursor_catcher/kinesis/psyker_tk, 0)
		kinesis_catcher.assign_to_mob(owner)

	// Amounts are in the get_stress_cost_for_atom
	modify_stress(get_stress_cost_for_atom(target))

	START_PROCESSING(SSfastprocess, src)

/// Ends the currently ongoing grab on a target.
/datum/action/cooldown/power/psyker/telekinesis/proc/clear_grab(playsound = TRUE)
	active = FALSE
	if(!grabbed_atom)
		// Still ensure the fullscreen overlay is gone if we somehow desynced
		if(owner)
			owner.clear_fullscreen("psyker_tk")
		kinesis_catcher = null
		kinesis_icon = null
		STOP_PROCESSING(SSfastprocess, src)
		return

	// Hold a stable ref so we can safely null grabbed_atom early
	var/atom/movable/held = grabbed_atom
	grabbed_atom = null

	if(playsound)
		playsound(held, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	STOP_PROCESSING(SSfastprocess, src)

	UnregisterSignal(held, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_SET_ANCHORED, COMSIG_ATOM_DISPEL))

	// Remove overlay BEFORE deleting vars
	if(kinesis_icon)
		held.cut_overlay(kinesis_icon)
	kinesis_icon = null
	if(player_icon)
		owner.cut_overlay(player_icon)
	player_icon = null

	if(isliving(held))
		held.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))

	REMOVE_TRAIT(held, TRAIT_NO_FLOATING_ANIM, REF(src))

	// Clear our telekinesis-specific screen overlay
	if(owner)
		owner.clear_fullscreen("psyker_tk")
	kinesis_catcher = null

/// Tells the grab that the mob's state has changed and ends the grab if it becomes invalid.
/datum/action/cooldown/power/psyker/telekinesis/proc/on_statchange(mob/grabbed_mob, new_stat)
	SIGNAL_HANDLER
	if(new_stat < stat_required)
		clear_grab()

/// Tells the grab that the target has become anchored and to tend the grab
/datum/action/cooldown/power/psyker/telekinesis/proc/on_setanchored(atom/movable/grabbed_atom_ref, anchorvalue)
	SIGNAL_HANDLER
	if(grabbed_atom_ref.anchored)
		clear_grab()

/// On dispel, drop the thing.
/datum/action/cooldown/power/psyker/telekinesis/proc/on_dispel(atom/source, atom/dispeller)
	SIGNAL_HANDLER
	if(grabbed_atom)
		clear_grab()
		return DISPEL_RESULT_DISPELLED
	return NONE


/* ------------------------------------------------------------
// Telekinesis-only screen edge
// We do this so we can tweak the actual looks of the overlay.
 ------------------------------------------------------------ */
/atom/movable/screen/fullscreen/cursor_catcher/kinesis/psyker_tk
	icon_state = "kinesis"
	alpha = 180
	color = "#8A2BE2"
	mouse_opacity = MOUSE_OPACITY_OPAQUE

#undef TK_CLICK_NONE
#undef TK_CLICK_TRIGGER
#undef TK_CLICK_MIDDLE
#undef TK_CLICK_RIGHT
