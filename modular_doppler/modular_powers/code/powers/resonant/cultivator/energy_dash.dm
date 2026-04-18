/datum/power/cultivator/energy_dash
	name = "Energy Dash"
	desc = "While in Alignment, you can dash forth at extreme speeds. Choose a space that can be reached by walking (even if it requires reasonable detours). You immediately dash there and arrive near-instantly. Costs Dantian to use."
	security_record_text = "Subject can dash at extreme speeds while in their heightened state."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	required_powers = list(/datum/power/cultivator_root)
	required_allow_subtypes = TRUE
	action_path = /datum/action/cooldown/power/cultivator/energy_dash

/datum/action/cooldown/power/cultivator/energy_dash
	name = "Energy Dash"
	desc = "While in Alignment, choose a space to dash to at extreme speeds, so long as you can reach the location by walking. Costs Dantian to use."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "blink"
	cost = 25
	target_type = /turf
	click_to_activate = TRUE

	/// How much seconds inbetween steps. Lower the number = the faster we go.
	var/dash_step_delay = 0.05 SECONDS
	/// Max amount of distance from our starting point that we can START a dash towards
	var/dash_max_distance = 30
	/// Max amounts of steps we can take WHILST a dash is happening
	var/dash_max_steps = 50

// Extra movement gating.
/datum/action/cooldown/power/cultivator/energy_dash/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	// We can't dash if we're already dashing.
	if(active)
		user.balloon_alert(user, "already dashing!")
		return FALSE
	// We can't dash if we're on our ass
	if(user.IsKnockdown())
		owner.balloon_alert(user, "knocked down!")
		return FALSE
	// We can't dash if we're immobilized
	if(HAS_TRAIT(user, TRAIT_IMMOBILIZED))
		owner.balloon_alert(user, "immobilized!")
		return FALSE
	// We can't dash if we're legcuffed.
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(carbon_user.legcuffed)
			owner.balloon_alert(user, "legcuffed!")
			return FALSE
	return TRUE

// Dash to the clicked location using pathfinding.
/datum/action/cooldown/power/cultivator/energy_dash/use_action(mob/living/user, atom/target)
	if(!target)
		return FALSE
	// check & store alignment
	var/datum/action/cooldown/power/cultivator/alignment/alignment_action = get_alignment_action(user)
	if(!alignment_action || !alignment_action.active)
		user.balloon_alert(user, "alignment required!")
		return FALSE

	// Gets our current location & target turf and checks if its a valid space.
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(!user_turf || !target_turf)
		return FALSE
	if(!is_valid_destination(user, target_turf))
		user.balloon_alert(user, "invalid destination!")
		return FALSE

	// Pathfinds the destination
	var/list/path = get_path_to(user, target_turf, max_distance = dash_max_distance, mintargetdist = 0, access = user.get_access(), simulated_only = !HAS_TRAIT(user, TRAIT_SPACEWALK), skip_first = TRUE)
	if(!length(path))
		user.balloon_alert(user, "no clear path!")
		return FALSE
	if(path[length(path)] != target_turf)
		path += target_turf

	// we start dashing!
	active = TRUE
	INVOKE_ASYNC(src, PROC_REF(dash_along_path), user, path, alignment_action.alignment_outline_color)
	return TRUE

/// Moves us along our pre-determined path.
/datum/action/cooldown/power/cultivator/energy_dash/proc/dash_along_path(mob/living/user, list/path, alignment_color)
	ADD_TRAIT(user, TRAIT_IMMOBILIZED, src) // we don't want em moving.
	var/steps = 0
	// for loop that creates afterimages, moves us to the next space and repeats til we're at our destination.
	for(var/turf/next_turf as anything in path)
		if(steps >= dash_max_steps)
			break
		if(QDELETED(user) || user.stat >= DEAD)
			break
		var/dir_to_next = get_dir(user, next_turf)
		new /obj/effect/temp_visual/energy_dash_afterimage(user.loc, dir_to_next, alignment_color)
		var/atom/old_loc = user.loc
		user.Move(next_turf, get_dir(user, next_turf), FALSE, TRUE)
		if(old_loc == user.loc)
			break
		steps++
		SLEEP_CHECK_DEATH(dash_step_delay, user)
	REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, src)
	active = FALSE

/// Validates we can land on the destination turf.
/datum/action/cooldown/power/cultivator/energy_dash/proc/is_valid_destination(mob/living/user, turf/target_turf)
	if(!target_turf || !isopenturf(target_turf))
		return FALSE
	return TRUE

/// Returns an active cultivator alignment action, or the first one found.
/datum/action/cooldown/power/cultivator/energy_dash/proc/get_alignment_action(mob/living/user)
	if(!user)
		return null
	var/datum/action/cooldown/power/cultivator/alignment/first_alignment
	for(var/datum/action/cooldown/power/cultivator/alignment/alignment_action in user.actions)
		if(!first_alignment)
			first_alignment = alignment_action
		if(alignment_action.active)
			return alignment_action
	return first_alignment

/obj/effect/temp_visual/energy_dash_afterimage
	name = "afterimage"
	icon = 'icons/effects/effects.dmi'
	icon_state = "blank_white"
	duration = 5
	randomdir = FALSE

// colors the afterimage to match the alignment
/obj/effect/temp_visual/energy_dash_afterimage/Initialize(mapload, dir_override, alignment_color)
	. = ..()
	if(dir_override)
		setDir(dir_override)
	if(alignment_color)
		add_atom_colour(alignment_color, FIXED_COLOUR_PRIORITY)
	animate(src, alpha = 0, time = duration)
