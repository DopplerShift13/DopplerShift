
/datum/power/psyker_power/telekinesis
	name = "Telekinesis"
	desc = "Grants the ability to manipulate and move various objects. Generates stress based upon weight on pick-up and throw, as well as passively while holding an object."

	value = 5
	priority = POWER_PRIORITY_BASIC
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/spell/pointed/telekinesis

/datum/action/cooldown/spell/pointed/telekinesis
	name = "Telekinesis"
	desc = "Middle-click to grab an object, Right-Click to drop, Middle-Click again to punt!"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "repulse"

	deactive_msg = "You unfocus your telekinetic powers."
	unset_after_click = FALSE
	cast_range = 255 // this is just for show.
	aim_assist = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	// Range of the kinesis grab.
	var/grab_range = 8

	// Stat required for us to grab a mob.
	var/stat_required = DEAD

	// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom

	// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	// Overlay we add to the player when using this power.
	var/mutable_appearance/player_icon

	// Psyker organ for stress.
	var/obj/item/organ/resonant/psyker/psyker_organ

	// Mouse tracker overlay (telekinesis-specific)
	var/atom/movable/screen/fullscreen/cursor_catcher/kinesis/psyker_tk/kinesis_catcher

	// Reference for the base psyker power, so we can call add_stress.
	var/datum/power/psyker_power/psyker_power

/datum/action/cooldown/spell/pointed/telekinesis/New(Target)
	. = ..()
	// We do this so we can call add_stress from the spell itself.
	if(istype(Target, /datum/power/psyker_power))
		psyker_power = Target

/datum/action/cooldown/spell/pointed/telekinesis/on_activation(mob/on_who)
	// I am to commit a most heinous crime.
	// If I do not call parent, we'll get compile warnings. If I don't do this, there'll be misleading messages that we cannot suppress (we don't use left click because it mimmicks the MODsuit controls)
	// Maintainers forgive my sins.
	var/mob/real_on_who = on_who
	on_who = null
	// Sins end.
	. = ..()
	if(!.)
		return
	psyker_organ = real_on_who.get_organ_slot(ORGAN_SLOT_PSYKER)
	to_chat(real_on_who, span_notice("You focus your telekinetic powers...<br><B>Middle-click</B>: Grab/Punt<B> | Right-click</B>: Drop<B> | Move mouse</B>: to drag"))
	return TRUE

/datum/action/cooldown/spell/pointed/telekinesis/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	clear_grab(playsound = FALSE)
	psyker_organ = null
	return ..()

/datum/action/cooldown/spell/pointed/telekinesis/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(clicker != owner)
		return FALSE

	var/list/mods = params2list(params)

	// Right click: drop if holding. Doesn't need target or range checks.
	if(LAZYACCESS(mods, RIGHT_CLICK))
		if(grabbed_atom)
			clear_grab()
			return TRUE
		return FALSE

	if(INCAPACITATED_IGNORING(clicker, INCAPABLE_GRAB))
		owner.balloon_alert(clicker, span_warning("Cannot grab target!"))
		return FALSE

	// Middle click: grab if empty, punt if holding
	if(LAZYACCESS(mods, MIDDLE_CLICK))
		if(!grabbed_atom)
			if(!target)
				owner.balloon_alert(clicker, span_warning("No target!"))
				return TRUE

			if(!range_check(clicker, target))
				owner.balloon_alert(clicker, span_warning("Too far!"))
				return TRUE

			if(!can_grab(clicker, target))
				owner.balloon_alert(clicker, span_warning("Cannot grab target!"))
				return TRUE

			grab_atom(target)
			return TRUE

		// Holding something: punt
		punt_held(clicker, target, params)
		return TRUE

// You shouldn't get as stressed from picking up a pen as a closet.
/datum/action/cooldown/spell/pointed/telekinesis/proc/get_stress_cost_for_atom(atom/target)
	var/cost = 10

	if(isitem(target))
		var/obj/item/I = target
		switch(I.w_class)
			if(WEIGHT_CLASS_TINY)
				cost = 1
			if(WEIGHT_CLASS_SMALL)
				cost = 2
			if(WEIGHT_CLASS_NORMAL)
				cost = 4
			if(WEIGHT_CLASS_BULKY)
				cost = 8
			else
				cost = 15 // structures, superheavy things, basically anything that goes beyond w_class.

	return cost

/datum/action/cooldown/spell/pointed/telekinesis/process(seconds_per_tick)
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

	// Dragging along hte floor

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


	psyker_power.add_stress(1 * seconds_per_tick) // As long as you don't do anything fancy and aren't stressed already, you can do this forever.

// The fun part, punting shit.
/datum/action/cooldown/spell/pointed/telekinesis/proc/punt_held(mob/living/user, atom/target, params)
	if(!grabbed_atom)
		return

	// Where are we throwing it?
	var/turf/throw_turf = target ? get_turf(target) : null

	// If target didn't resolve (common on middle click), derive turf from click params via catcher
	if(!throw_turf && kinesis_catcher)
		kinesis_catcher.mouse_params = params
		kinesis_catcher.calculate_params()
		throw_turf = kinesis_catcher.given_turf

	if(!throw_turf)
		owner.balloon_alert(user, span_warning("No target!"))
		return

	var/atom/movable/launched = grabbed_atom

	// Basically the same stress cost for picking it up.
	psyker_power.add_stress(get_stress_cost_for_atom(launched))

	clear_grab(playsound = FALSE)
	playsound(launched, 'sound/effects/magic/repulse.ogg', 75, TRUE)

	launched.throw_at(
		throw_turf,
		range = grab_range,
		speed = (launched.density ? 3 : 4),
		thrower = user,
		spin = isitem(launched)
	)

// The proverbial leash.
/datum/action/cooldown/spell/pointed/telekinesis/proc/range_check(mob/living/user, atom/target)
	if(!user || !isturf(user.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(user, target, grab_range))
		return FALSE
	return TRUE

// Can we ACTUALLY grab it or will it just fizz out?
/datum/action/cooldown/spell/pointed/telekinesis/proc/can_grab(mob/living/user, atom/target)
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

/datum/action/cooldown/spell/pointed/telekinesis/proc/grab_atom(atom/movable/target)
	// If anything was already held, clear it first
	if(grabbed_atom)
		clear_grab(playsound = FALSE)
	grabbed_atom = target

	// Mob handling like module_kinesis
	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
		RegisterSignal(grabbed_atom, COMSIG_MOB_STATCHANGE, PROC_REF(on_statchange))

	ADD_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))

	playsound(grabbed_atom, 'sound/effects/magic/magic_missile.ogg', 75, TRUE)

	kinesis_icon = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "psychic",
		layer = grabbed_atom.layer - 0.1,
		appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
	)
	kinesis_icon.color = "#8A2BE2" //mutable appearance doesn't support color?
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
	psyker_power.add_stress(get_stress_cost_for_atom(target))

	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/spell/pointed/telekinesis/proc/clear_grab(playsound = TRUE)
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
		playsound(held, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE)

	STOP_PROCESSING(SSfastprocess, src)

	UnregisterSignal(held, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_SET_ANCHORED))

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

/datum/action/cooldown/spell/pointed/telekinesis/proc/on_statchange(mob/grabbed_mob, new_stat)
	SIGNAL_HANDLER
	if(new_stat < stat_required)
		clear_grab()

/datum/action/cooldown/spell/pointed/telekinesis/proc/on_setanchored(atom/movable/grabbed_atom_ref, anchorvalue)
	SIGNAL_HANDLER
	if(grabbed_atom_ref.anchored)
		clear_grab()


/* ------------------------------------------------------------
// Telekinesis-only screen edge
// We do this so we can tweak the actual looks of the overlay.
 ------------------------------------------------------------ */
/atom/movable/screen/fullscreen/cursor_catcher/kinesis/psyker_tk
	icon_state = "kinesis"
	alpha = 180
	color = "#8A2BE2"
	mouse_opacity = MOUSE_OPACITY_OPAQUE
