/*
 Custom action system for supporting the powers system. Use this anytime you add actions to a power.
 Almost all archetypes have their own subtype to handle their own resources and mechanics.
 This one is largely responsible for the actions framework itself.

 Largely modeled after changeling_power.dm
*/
/datum/action/power
	name = "abstract power action - ahelp this"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	/// Maximum state of consciousness before the ability is blocked.
	/// For example, `UNCONSCIOUS` prevents it from being used when in hard crit or dead,
	/// while `DEAD` allows the ability to be used on any stat values.
	var/req_stat = CONSCIOUS
	/// If your power has an active state of any type, use this.
	var/active = FALSE
	/// Does this ability stop working if you are silenced?
	var/disabled_by_silence = TRUE
	/// What power gave the origin?
	var/origin_power
	/// Can only humans use this power?
	var/human_only = TRUE
	/// Can we target ourselves?
	var/target_self = TRUE

	// Is it an ability that requires us to click our mouse?
	var/click_to_activate = FALSE
	/// Maximum targeting range (in tiles) for click_to_activate powers. Set to 0 or null for no range limit.
	var/target_range = 7
	/// If set, clicked target MUST be of this type (or subtype).
	var/target_type = null
	/// The click cooldown added onto the user's next click (only for click_to_activate abilities)
	var/click_cd_override = CLICK_CD_CLICK_ABILITY
	/// If TRUE, we will unset after using our click intercept.
	var/unset_after_click = TRUE
	/// What icon to replace our mouse cursor with when active.
	var/ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

// When you press the button
/datum/action/power/Trigger(mob/clicker, trigger_flags, atom/target)
	var/mob/living/user = owner
	if(!user)
		return

	// Click-to-activate powers set themselves as a click intercept, and then wait for a left click target.
	if(click_to_activate)
		return handle_click_to_activate(user, target)

	// Non-targeted powers just use immediately.
	return try_use(user, target = null)

// Attempts to actively use the action
/datum/action/power/proc/try_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_use(user, target))
		return FALSE
	if(disabled_by_silence && HAS_TRAIT(owner, TRAIT_RESONANCE_SILENCED))
		owner.balloon_alert(user, "silenced!")
		return FALSE
	if(use_action(user, target))
		return TRUE
	return FALSE

// Validates the action can be used.
/datum/action/power/proc/can_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_be_used_by(user)) // Runs can_be_used_by below
		return FALSE
	if(req_stat < user.stat) // Are we conscious?
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	return TRUE

// Checks if we exist (wow) and are human.
/datum/action/power/proc/can_be_used_by(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(QDELETED(user))
		return FALSE
	if(!ishuman(owner) && human_only)
		return FALSE
	return TRUE

// Now we do THINGS!
/datum/action/power/proc/use_action(mob/living/user, atom/target)
	return TRUE

/*
Handles all the logic involved in using a targeted, click-based action.
- First press: enables click intercept (targeting mode)
- Second press (while already active): disables click intercept
- While active: a left click calls InterceptClickOn() and passes the clicked atom as target
*/
/datum/action/power/proc/handle_click_to_activate(mob/living/user, atom/target)
	// If this was called with a direct target (ex: some automated caller), treat it like a click immediately.
	if(target)
		return InterceptClickOn(user, null, target)

	var/datum/action/power/already_set = user.click_intercept
	if(already_set == src)
		// If we clicked ourself and we're already set, unset and return
		return unset_click_ability(TRUE)

	else if(istype(already_set))
		// If we have an active one set already, unset it before we set ours
		already_set.unset_click_ability()

	return set_click_ability()

/// Intercepts client owner clicks to activate the ability.
/// Note: this is called by the click intercept system on left click.
/datum/action/power/proc/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!target)
		return FALSE

	// Checks if we are allowed to actually target that type.
	if(!istype(target, target_type))
		return FALSE

	// Check if we are allowed to target ourselves.
	if(!target_self && target == owner)
		return FALSE

	// Range gate (only applies if target_range is non-zero).
	if(target_range)
		var/turf/clicker_turf = get_turf(clicker)
		var/turf/target_turf = get_turf(target)
		if(clicker_turf && target_turf && get_dist(clicker_turf, target_turf) > target_range)
			owner.balloon_alert("Out of range!")
			return FALSE

	// If the power can't be used, refuse the click and keep intercept state as-is.
	if(!try_use(clicker, target))
		return FALSE

	// Successful click.
	if(unset_after_click)
		unset_click_ability()

	clicker.next_click = world.time + click_cd_override
	return TRUE

/**
 * Set our action as the click override on the passed mob.
 */
/datum/action/power/proc/set_click_ability()
	SHOULD_CALL_PARENT(TRUE)

	owner.click_intercept = src
	if(ranged_mousepointer)
		owner.client?.mouse_override_icon = ranged_mousepointer
		owner.update_mouse_pointer()

	build_all_button_icons(UPDATE_BUTTON_STATUS)
	on_activation(owner)
	return TRUE

/**
 * Unset our action as the click override of the passed mob.
 */
/datum/action/power/proc/unset_click_ability(manual = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	owner.click_intercept = null
	if(ranged_mousepointer)
		owner.client?.mouse_override_icon = initial(owner.client?.mouse_override_icon)
		owner.update_mouse_pointer()

	build_all_button_icons(UPDATE_BUTTON_STATUS)
	if(manual)
		on_deactivation(owner)
	return TRUE

/// These only call on pointed actions
/datum/action/power/proc/on_activation(mob/living/user)
	return

/// Same as above
/datum/action/power/proc/on_deactivation(mob/living/user)
	return
