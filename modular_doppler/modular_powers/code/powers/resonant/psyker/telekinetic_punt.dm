#define TK_PUNT_CLICK_OVERLAY "psyker_telekinetic_punt_cursor"
/*
	So, power that launches the best nearby object at people. This has a lot of nuance, especially with my insistance on being able to preview which item you will throw.
	This means we on the fly need to compute the best object, before its thrown, and in a way that does not kill the server's processing.
	The datum/telekentic_punt_preview below the action is the best I could do there. When moving your mouse over a tile, it gets the best nearby object to be thrown towards that tile. You can lock objects with middle click too.
*/

/datum/power/psyker_power/telekinetic_punt
	name = "Telekinetic Punt"
	desc = "Quickly punt a nearby object at the target. Activating the power highlights the nearest, strongest object near the cursor, which will be punted automatically at the target when you click the target.\
	\nUnanchored structures deal an additional +10 damage and +1 knockback, and this can wall-stun.\
	\nMiddle-click to lock onto an object, ensuring you will always punt with it."
	security_record_text = "Subject can wield telekinesis to offensively punt objects at targets"
	security_threat = POWER_THREAT_MAJOR
	value = 4
	required_powers = list(/datum/power/psyker_power/telekinesis)
	action_path = /datum/action/cooldown/power/psyker/telekinetic_punt

/datum/action/cooldown/power/psyker/telekinetic_punt
	name = "Telekinetic Punt"
	desc = "Quickly punt a nearby object at the target. Activating the power highlights the nearest, strongest object near the cursor, which will be punted automatically at the target when you click the target.\
	\nUnanchored structures deal an additional +10 damage and +1 knockback, and this can wall-stun.\
	\nMiddle-click to lock onto an object, ensuring you will always punt with it."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "telekinetic_punt" // not a good spriter so this needs a better sprite at one point
	click_to_activate = TRUE
	unset_after_click = FALSE
	target_range = 15
	cooldown_time = 15
	click_cd_override = CLICK_CD_ACTIVATE_ABILITY / 2 // I normally do not change this but it largely has to do with being able to lock with middle-mouse is affected by this. This feels smoother, in a way.

	mental = FALSE // You ain't targeting their mind you're targetting their skull

	/// Minimum damage an item must have to qualify for punt selection.
	var/min_damage_to_punt = 5
	/// Maximum distance from the caster that we will consider puntable objects.
	var/punt_object_distance = 8
	/// Square radius around the cursor that we scan for candidates.
	var/punt_scan_radius = 6
	/// Structures always count as this much base punt damage.
	var/structure_punt_damage = 20
	/// Additional damage structures deal on top of their base punt damage.
	var/structure_bonus_damage = 0
	/// Base knockback applied on a successful punt impact.
	var/base_knockback = 1
	/// Additional knockback granted when the punted object is a structure.
	var/structure_bonus_knockback = 0
	/// Damage thresholds that marks objects as strong enough that we don't need to look further away for better, causing the expanding search area to stop expanding and only use its area for determening the best object.
	var/strong_object_threshold = 20
	/// How much stress we generate upon use?
	var/stress_cost = PSYKER_STRESS_MINOR * 1.5
	/// Active preview session while the power is click-armed.
	var/datum/telekinetic_punt_preview/preview_datum

/// Cleans up any active preview session when the action is removed from its owner.
/datum/action/cooldown/power/psyker/telekinetic_punt/Remove(mob/removed_from)
	QDEL_NULL(preview_datum)
	return ..()

/// Arms the action for click targeting and creates a fresh preview session.
/datum/action/cooldown/power/psyker/telekinetic_punt/set_click_ability(mob/on_who)
	. = ..()
	if(.)
		QDEL_NULL(preview_datum)
		preview_datum = new(src, on_who)
	return .

/// Disarms the action for click targeting and destroys the preview session.
/datum/action/cooldown/power/psyker/telekinetic_punt/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	QDEL_NULL(preview_datum)
	return ..()

/// Intercepts clicks so middle click toggles locking while left click resolves the punt normally.
/datum/action/cooldown/power/psyker/telekinetic_punt/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		handle_middle_click(clicker, target)
		return TRUE
	. = ..()
	return TRUE

/// Handles middle-click target locking separately from the cooldowned punt activation so lock control still works while the action is cooling down.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/handle_middle_click(mob/living/user, atom/target)
	// Datum gets you your targets so if this is happening something's gone wroooong.
	if(!preview_datum || QDELETED(preview_datum))
		user.balloon_alert(user, "power fizzles!")
		return FALSE

	// Finds the turf that you currently are hovering over.
	var/turf/cursor_turf = preview_datum.get_cursor_turf(target)

	// If we are NOT locked onto a specific object and the current object does not pass as valid, we try to find a new valid target to lock o nanyway.
	if(!preview_datum.lock_chambered_target && !is_valid_punt_candidate(user, preview_datum.cached_punt_target, cursor_turf))
		preview_datum.refresh_cached_punt_target(cursor_turf)
	// If we ARE locked onto a specific object...
	if(preview_datum.lock_chambered_target)
		/// ... And the object has become invalid, we clear it out.
		if(!is_valid_punt_candidate(user, preview_datum.cached_punt_target))
			preview_datum.set_cached_punt_target(null)
			user.balloon_alert(user, "object invalid!")
			return FALSE
	/// If we fail to lock on after the first proc, nothing will happen.
	else if(!is_valid_punt_candidate(user, preview_datum.cached_punt_target, cursor_turf))
		user.balloon_alert(user, "nothing chambered!")
		return FALSE
	/// Toggles the lock on/off
	preview_datum.toggle_lock()
	user.balloon_alert(user, preview_datum.lock_chambered_target ? "target locked" : "target unlocked")
	return TRUE

/// Throws the currently chambered object at the clicked target turf.
/datum/action/cooldown/power/psyker/telekinetic_punt/use_action(mob/living/user, atom/target)
	// Datum gets you your targets so if this is happening something's gone wroooong.
	if(!preview_datum || QDELETED(preview_datum))
		user.balloon_alert(user, "power fizzles!")
		return FALSE

	// Finds the turf that you currently are hovering over.
	var/turf/cursor_turf = preview_datum.get_cursor_turf(target)

	/// LEFT CLICK/RIGHT CLICK LOGIC (Punting).

	var/atom/movable/punt_target = preview_datum.cached_punt_target
	// Checks if we are allowed to punt the target
	if(!is_valid_punt_candidate(user, punt_target))
		user.balloon_alert(user, "nothing suitable!")
		return FALSE

	// Gets our destination target
	var/turf/target_turf = get_punt_target_turf(user, punt_target, target)
	if(!target_turf)
		return FALSE

	// Gets a signaler so we can pass extra damage off on hit.
	RegisterSignal(punt_target, COMSIG_MOVABLE_IMPACT, PROC_REF(on_punt_impact))

	// Visual/Audio feedback
	user.visible_message(span_warning("[user] gestures towards [punt_target], punting it with telekinetic force!"))
	playsound(user, 'sound/effects/magic/repulse.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	// This outline marks the punt as telekinetic and is faded out immediately after launch.
	var/filter_id = "psyker_punt_flash"
	punt_target.add_filter(filter_id, 1, list(type = "outline", color = POWER_COLOR_PSYKER, size = 2, alpha = 255))

	// Gets the range and attempts to PUNT the object at it.
	var/punt_range = max(get_dist(punt_target, target_turf), 1)
	if(!punt_target.safe_throw_at(target_turf, range = punt_range, speed = punt_target.density ? 3 : 4, thrower = user, spin = isitem(punt_target), force = MOVE_FORCE_EXTREMELY_STRONG))
		UnregisterSignal(punt_target, COMSIG_MOVABLE_IMPACT)
		user.balloon_alert(user, "can't move that!")
		fade_filter(punt_target, filter_id)
		return FALSE

	// Clean-up of effects + preview
	fade_filter(punt_target, filter_id)
	preview_datum.clear_after_throw(cursor_turf)
	apply_punt_throw_effect(user)

	modify_stress(stress_cost) // cost
	return TRUE

/// Fades and removes the telekinetic outline filter from a thrown object.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/fade_filter(atom/movable/punt_target, filter_id)
	if(!punt_target)
		return
	punt_target.transition_filter(filter_id, list("alpha" = 0), 1.5 SECONDS)
	addtimer(CALLBACK(punt_target, PROC_REF(remove_filter), filter_id), 1.5 SECONDS)

/// Applies a short-lived psychic sparkle overlay to the psyker after a successful punt.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/apply_punt_throw_effect(mob/living/user)
	if(!user)
		return
	var/mutable_appearance/player_icon = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "purplesparkles",
		layer = user.layer - 0.1,
		appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
	)
	user.add_overlay(player_icon)
	addtimer(CALLBACK(src, PROC_REF(remove_punt_throw_effect), user, player_icon), 1.5 SECONDS)

/// Removes the temporary psychic sparkle overlay from the psyker once its linger timer completes.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/remove_punt_throw_effect(mob/living/user, mutable_appearance/player_icon)
	if(!user || !player_icon)
		return
	user.cut_overlay(player_icon)

/// Resolves the turf we actually throw at, clipping locked throws to the furthest reachable turf instead of replacing the object.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_punt_target_turf(mob/living/user, atom/movable/punt_target, atom/desired_target)
	var/turf/desired_turf = get_turf(desired_target)
	if(!desired_turf)
		return null
	if(!preview_datum?.lock_chambered_target)
		return desired_turf
	// If the locked object can directly see the clicked turf, just use it.
	if(desired_turf in view(punt_target))
		return desired_turf

	// Otherwise, clip the throw along that line to the furthest turf inside the object's current view.
	var/list/view_size = getviewsize(user?.client?.view || world.view)
	var/view_range = round(max((view_size[1] - 1) / 2, (view_size[2] - 1) / 2))
	if(view_range <= 0)
		return null
	return get_ranged_target_turf_direct(punt_target, desired_turf, view_range)

/// Validates whether an atom can currently be chambered and punted by this action.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/is_valid_punt_candidate(mob/living/user, atom/movable/candidate, turf/cursor_turf)
	// Object does not exist.
	if(!candidate || QDELETED(candidate))
		return FALSE
	// Object is not in the world
	if(!isturf(candidate.loc))
		return FALSE
	// Object is anchored (can't move)
	if(candidate.anchored)
		return FALSE
	// Object is too dense (or thicc as we call it nowadays).
	if(candidate.move_resist >= MOVE_FORCE_EXTREMELY_STRONG)
		return FALSE
	// Object is too far away.
	if(get_dist(user, candidate) > punt_object_distance)
		return FALSE
	// Object can't be seen by us.
	if(!(candidate in view(user)))
		return FALSE
	// Object isn't within line-of-sight of the hovered turf
	if(cursor_turf && !(cursor_turf in view(candidate)))
		return FALSE

	// Sweet, it's an item. Lets caclulate the punt damage.
	if(isitem(candidate))
		var/obj/item/item_candidate = candidate
		if(item_candidate.item_flags & ABSTRACT)
			return FALSE
		return get_punt_damage(item_candidate) >= min_damage_to_punt
	// It's a structure or machine? Calculate the punt damage.
	if(isstructure(candidate))
		return get_punt_damage(candidate) >= min_damage_to_punt
	if(ismachinery(candidate))
		return get_punt_damage(candidate) >= min_damage_to_punt

	// Whatever you are, we don't want you
	return FALSE

/// Returns the effective damage value used when ranking puntable items and structure-like objects.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_punt_damage(atom/movable/candidate)
	// Item specific calculation
	if(isitem(candidate))
		var/obj/item/item_candidate = candidate
		return max(item_candidate.throwforce, item_candidate.force)
	// Structures and machinery default to 20 cause structures normally do 10 + 1 knockback on impact, and we boost that by another 10.
	// This usually makes them desireable to punt.
	if(isstructure(candidate) || ismachinery(candidate))
		return structure_punt_damage
	return 0

/// Returns a scoring distance which mildly penalizes diagonal offsets to prefer straighter, less obstruction-prone picks.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_effective_punt_distance(turf/cursor_turf, atom/movable/candidate)
	var/base_distance = get_dist(cursor_turf, candidate)
	if(!cursor_turf || !candidate)
		return base_distance

	var/delta_x = abs(cursor_turf.x - candidate.x)
	var/delta_y = abs(cursor_turf.y - candidate.y)
	// Diagonals get an extra tax so equally-close cardinal objects win the selection more often.
	if(delta_x && delta_y)
		return base_distance + 0.5
	return base_distance

/// Treats the effective damage as less based on distance given these have a chance to miss/be obstructed, causing bias to closer objects.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_effective_punt_score(base_damage, distance)
	return max(base_damage * (1 - (0.1 * distance)), 0)

/// Applies additional knockback and manual heavy-object damage when the thrown object impacts something.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/on_punt_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing, caught)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)
	// Nothing happens when caught!
	if(caught)
		return
	// Nothing happens if its an item!
	if(isitem(source))
		return

	var/knockback = base_knockback
	var/damage = get_punt_damage(source)

	// Structures and machinery do bonus damage and knockback.
	if(isstructure(source) || ismachinery(source))
		damage += structure_bonus_damage
		knockback += structure_bonus_knockback

	// When hitting a living mob (usually our target)
	if(isliving(hit_atom))
		var/mob/living/living_target = hit_atom

		living_target.apply_damage(damage, BRUTE)
		if(knockback > 0)
			var/throw_dir = get_dir(source, living_target)
			if(!throw_dir && owner)
				throw_dir = get_dir(owner, living_target)
			if(throw_dir)
				var/atom/throw_target = get_edge_target_turf(living_target, throw_dir)
				living_target.throw_at(throw_target, knockback, 2, owner)

		playsound(living_target, 'sound/items/lead_pipe_hit.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE) // Punt does it, so does ours. Its just funny.
		living_target.log_message("was hit by a telekinetically punted [source] from [owner] for [damage] damage.", LOG_VICTIM)
		owner?.log_message("telekinetically punted [source] into [living_target] for [damage] damage.", LOG_ATTACK)
	// If it has integrity aka structures, damage it instead.
	else if(hit_atom.uses_integrity)
		hit_atom.take_damage(damage, BRUTE, MELEE)

// Decleration of cursor catcher
/atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt

/// Forwards clicks through the fullscreen catcher to the turf currently under the mouse.
/atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt/Click(location, control, params)
	if(usr == owner)
		calculate_params()
	given_turf?.Click(location, control, params)

/*
	This datum largely handles selecting an appropriate item to yeet. If its on a tile that it hasn't processed yet, it will attempt to process it, getting all valid targets within the action's range.
	Once it gets a target, it will select it as cached_punt_target.
	The targetting system has a few specific biases for gameplay:
	- Items are treated as dealing 10% less damage for every turf they are away from the moused-over turf, up to the maximum range of Telekinetic Punt.
	- Diagonals count as 0.5 turfs further away so that it biases towards horizontal/vertical targets.
	- If there is a valid target on the mouse-over turf, it will prefer that.
	- If an object whose force equals the action's strong_object_threshold is found, it will stop broadening its search area and only consider objects currently within it, as we have at least one really good item.
	To try and optimize these massive scans, we only scan once per turf. In addition, lock mode will prevent any repeated checks.

*/
/datum/telekinetic_punt_preview
	/// The action that owns this preview session.
	var/datum/action/cooldown/power/psyker/telekinetic_punt/source_action
	/// The mob currently using the click-intercept preview.
	var/mob/living/owner
	/// Fullscreen cursor tracker used for preview targeting.
	var/atom/movable/screen/fullscreen/cursor_catcher/cursor_tracker
	/// Last cursor turf we calibrated against.
	var/turf/cached_cursor_turf
	/// Current object we intend to punt.
	var/atom/movable/cached_punt_target
	/// Client-only preview image shown beneath the selected object.
	var/image/cached_punt_overlay
	/// Prevents repeated expensive scans within the same tick.
	var/last_preview_tick = -1
	/// Whether the current chambered object is locked in place.
	var/lock_chambered_target = FALSE

/// Creates a preview session, attaches the fullscreen cursor catcher, and begins fast processing.
/datum/telekinetic_punt_preview/New(datum/action/cooldown/power/psyker/telekinetic_punt/new_source_action, mob/living/new_owner)
	. = ..()
	source_action = new_source_action
	owner = new_owner
	if(!source_action || !owner)
		qdel(src)
		return
	cursor_tracker = owner.overlay_fullscreen(TK_PUNT_CLICK_OVERLAY, /atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt, 0)
	cursor_tracker?.assign_to_mob(owner)
	START_PROCESSING(SSfastprocess, src)

/// Tears down the fullscreen overlay, preview image, and back-reference from the owning action.
/datum/telekinetic_punt_preview/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	if(owner)
		owner.clear_fullscreen(TK_PUNT_CLICK_OVERLAY)
	set_cached_punt_target(null)
	if(source_action?.preview_datum == src)
		source_action.preview_datum = null
	cursor_tracker = null
	cached_cursor_turf = null
	cached_punt_target = null
	owner = null
	source_action = null
	return ..()

/// Re-evaluates the chambered object while the power is armed and the cursor moves around.
/datum/telekinetic_punt_preview/process()
	if(!source_action || !owner || owner.click_intercept != source_action)
		qdel(src)
		return

	if(last_preview_tick == world.time)
		return
	last_preview_tick = world.time

	if(cursor_tracker?.mouse_params)
		cursor_tracker.calculate_params()

	var/turf/cursor_turf = cursor_tracker?.given_turf
	if(!cursor_turf || cursor_turf.z != owner.z)
		return
	if(lock_chambered_target)
		if(cached_punt_target && !source_action.is_valid_punt_candidate(owner, cached_punt_target))
			set_cached_punt_target(null)
		if(cached_punt_target)
			return
	else if(cached_punt_target && !source_action.is_valid_punt_candidate(owner, cached_punt_target, cursor_turf))
		set_cached_punt_target(null)
	// We only skip rescanning if the cursor stayed on the exact same turf; adjacent movement now recalculates.
	if(cached_punt_target && cached_cursor_turf && cached_cursor_turf == cursor_turf)
		return

	refresh_cached_punt_target(cursor_turf)

/// Returns the current cursor turf, falling back to the cached turf or the clicked target's turf if needed.
/datum/telekinetic_punt_preview/proc/get_cursor_turf(atom/fallback_target)
	if(cursor_tracker?.mouse_params)
		cursor_tracker.calculate_params()
	return cursor_tracker?.given_turf || cached_cursor_turf || get_turf(fallback_target)

/// Rebuilds the chambered target for the current cursor turf and updates the cache accordingly.
/datum/telekinetic_punt_preview/proc/refresh_cached_punt_target(turf/cursor_turf)
	if(!owner || !cursor_turf)
		set_cached_punt_target(null)
		return
	var/atom/movable/best_target = find_best_punt_target(cursor_turf)
	set_cached_punt_target(best_target)
	if(best_target)
		cached_cursor_turf = cursor_turf
	else
		cached_cursor_turf = null

/// Finds the best punt candidate near the cursor using exact-turf priority and distance-weighted scoring.
/datum/telekinetic_punt_preview/proc/find_best_punt_target(turf/cursor_turf)
	if(!owner || !source_action || !cursor_turf)
		return null

	// If we are hovering a valid target directly, prefer that turf over any nearby "stronger" find.
	var/atom/movable/exact_turf_target = find_best_punt_target_on_hovered_turf(cursor_turf)
	if(exact_turf_target)
		return exact_turf_target

	var/atom/movable/best_target
	var/best_score = -1
	var/best_distance = INFINITY

	for(var/radius in 1 to source_action.punt_scan_radius)
		// Determines if we have found an object that's at or above strong_object_threshold, stopping us from expanding the area.
		var/found_terminal_candidate = FALSE

		/* scan_x is responsible for the top and bottom sides, scan_y is the left and right sides of the expanding radius.
		Just to illustrate: a 5x5 square radius will be handled like so, where C is the cursor, X is a turf scanned by scan_x and Y for scan_y, and . indicates no scan (because it already scanned that turf).
			X X X X X
			Y . . . Y
			Y . C . Y
			Y . . . Y
			X X X X X
		*/

		// Scans the top and bottom sides of the radius square
		for(var/scan_x in (cursor_turf.x - radius) to (cursor_turf.x + radius))
			var/list/top_edge_result = evaluate_scan_turf(cursor_turf, locate(scan_x, cursor_turf.y + radius, cursor_turf.z), best_target, best_score, best_distance)
			best_target = top_edge_result["best_target"]
			best_score = top_edge_result["best_score"]
			best_distance = top_edge_result["best_distance"]
			found_terminal_candidate = top_edge_result["found_terminal_candidate"] || found_terminal_candidate
			if(radius > 0)
				var/list/bottom_edge_result = evaluate_scan_turf(cursor_turf, locate(scan_x, cursor_turf.y - radius, cursor_turf.z), best_target, best_score, best_distance)
				best_target = bottom_edge_result["best_target"]
				best_score = bottom_edge_result["best_score"]
				best_distance = bottom_edge_result["best_distance"]
				found_terminal_candidate = bottom_edge_result["found_terminal_candidate"] || found_terminal_candidate

		// Scans the left and right sides of the radius square
		for(var/scan_y in (cursor_turf.y - radius + 1) to (cursor_turf.y + radius - 1))
			var/list/right_edge_result = evaluate_scan_turf(cursor_turf, locate(cursor_turf.x + radius, scan_y, cursor_turf.z), best_target, best_score, best_distance)
			best_target = right_edge_result["best_target"]
			best_score = right_edge_result["best_score"]
			best_distance = right_edge_result["best_distance"]
			found_terminal_candidate = right_edge_result["found_terminal_candidate"] || found_terminal_candidate
			if(radius > 0)
				var/list/left_edge_result = evaluate_scan_turf(cursor_turf, locate(cursor_turf.x - radius, scan_y, cursor_turf.z), best_target, best_score, best_distance)
				best_target = left_edge_result["best_target"]
				best_score = left_edge_result["best_score"]
				best_distance = left_edge_result["best_distance"]
				found_terminal_candidate = left_edge_result["found_terminal_candidate"] || found_terminal_candidate

		// Once a sufficiently strong nearby object exists, finish this ring and stop expanding outward.
		if(found_terminal_candidate)
			break

	return best_target

/// Evaluates a single turf in the expanding ring scan, returning updated best-candidate state and whether the stop threshold was reached.
/datum/telekinetic_punt_preview/proc/evaluate_scan_turf(turf/cursor_turf, turf/scan_turf, atom/movable/best_target, best_score, best_distance)
	if(!scan_turf)
		return list(
			"best_target" = best_target,
			"best_score" = best_score,
			"best_distance" = best_distance,
			"found_terminal_candidate" = FALSE,
		)

	var/found_terminal_candidate = FALSE

	/// Scans all obj/item on the turf
	for(var/obj/item/item_target in scan_turf)
		var/list/item_evaluation = evaluate_punt_candidate(item_target, cursor_turf, best_score, best_distance)
		if(!item_evaluation)
			continue
		// Indicates we have found an object that deals at least 20 damage, meaning we already have a good enough canidate and don't need to search further.
		found_terminal_candidate = item_evaluation["found_terminal_candidate"] || found_terminal_candidate
		if(!item_evaluation["improved_best_target"])
			continue
		best_target = item_target
		best_score = item_evaluation["best_score"]
		best_distance = item_evaluation["best_distance"]

	/// Scans all obj/structure on the turf
	for(var/obj/structure/structure_target in scan_turf)
		var/list/structure_evaluation = evaluate_punt_candidate(structure_target, cursor_turf, best_score, best_distance)
		if(!structure_evaluation)
			continue
		// Indicates we have found an object that deals at least 20 damage, meaning we already have a good enough canidate and don't need to search further.
		found_terminal_candidate = structure_evaluation["found_terminal_candidate"] || found_terminal_candidate
		if(!structure_evaluation["improved_best_target"])
			continue
		best_target = structure_target
		best_score = structure_evaluation["best_score"]
		best_distance = structure_evaluation["best_distance"]

	/// Scans all obj/machinery on the turf
	for(var/obj/machinery/machinery_target in scan_turf)
		var/list/machinery_evaluation = evaluate_punt_candidate(machinery_target, cursor_turf, best_score, best_distance)
		if(!machinery_evaluation)
			continue
		found_terminal_candidate = machinery_evaluation["found_terminal_candidate"] || found_terminal_candidate
		if(!machinery_evaluation["improved_best_target"])
			continue
		best_target = machinery_target
		best_score = machinery_evaluation["best_score"]
		best_distance = machinery_evaluation["best_distance"]

	return list(
		"best_target" = best_target,
		"best_score" = best_score,
		"best_distance" = best_distance,
		"found_terminal_candidate" = found_terminal_candidate,
	)

/// Scores a single punt candidate against the current best result and reports whether it improves selection or reaches the strong-object stop threshold.
/datum/telekinetic_punt_preview/proc/evaluate_punt_candidate(atom/movable/candidate, turf/cursor_turf, best_score, best_distance = INFINITY, hovered_turf_only = FALSE)
	var/candidate_damage = source_action.get_punt_damage(candidate)
	if(candidate_damage < source_action.min_damage_to_punt)
		return null
	if(!source_action.is_valid_punt_candidate(owner, candidate, cursor_turf))
		return null

	// Gets the distance unless its a comparison against stuff on the hovered stuff.
	var/candidate_distance = hovered_turf_only ? 0 : source_action.get_effective_punt_distance(cursor_turf, candidate)
	var/candidate_score = source_action.get_effective_punt_score(candidate_damage, candidate_distance)
	return list(
		"best_score" = candidate_score,
		"best_distance" = candidate_distance,
		"found_terminal_candidate" = !hovered_turf_only && candidate_damage >= source_action.strong_object_threshold,
		"improved_best_target" = candidate_score > best_score || (candidate_score == best_score && candidate_distance < best_distance),
	)

/// Picks the strongest valid target on the exact hovered turf before any wider scan is considered.
/datum/telekinetic_punt_preview/proc/find_best_punt_target_on_hovered_turf(turf/cursor_turf)
	if(!owner || !source_action || !cursor_turf)
		return null

	var/atom/movable/best_target
	var/best_score = -1

	// Hovering over tiles will scan those tiles for targets and if there's at least one canidate, it will always use only those canidates.

	// Item searching
	for(var/obj/item/item_target in cursor_turf)
		var/list/item_evaluation = evaluate_punt_candidate(item_target, cursor_turf, best_score, hovered_turf_only = TRUE)
		if(!item_evaluation)
			continue
		if(!item_evaluation["improved_best_target"])
			continue
		best_target = item_target
		best_score = item_evaluation["best_score"]

	// Structure searching
	for(var/obj/structure/structure_target in cursor_turf)
		var/list/structure_evaluation = evaluate_punt_candidate(structure_target, cursor_turf, best_score, hovered_turf_only = TRUE)
		if(!structure_evaluation)
			continue
		if(!structure_evaluation["improved_best_target"])
			continue
		best_target = structure_target
		best_score = structure_evaluation["best_score"]

	// Machinery searching
	for(var/obj/machinery/machinery_target in cursor_turf)
		var/list/machinery_evaluation = evaluate_punt_candidate(machinery_target, cursor_turf, best_score, hovered_turf_only = TRUE)
		if(!machinery_evaluation)
			continue
		if(!machinery_evaluation["improved_best_target"])
			continue
		best_target = machinery_target
		best_score = machinery_evaluation["best_score"]

	return best_target

/// Replaces the chambered target and maintains the owner-only marker image beneath it.
/datum/telekinetic_punt_preview/proc/set_cached_punt_target(atom/movable/new_target)
	if(owner?.client && cached_punt_overlay)
		owner.client.images -= cached_punt_overlay
	cached_punt_overlay = null
	// Locks are tied to a specific chambered object; changing the object clears the lock.
	if(cached_punt_target != new_target && lock_chambered_target)
		lock_chambered_target = FALSE
	cached_punt_target = new_target
	if(!new_target || !owner?.client)
		return

	cached_punt_overlay = image('icons/effects/effects.dmi', new_target, "launchpad_pull")
	cached_punt_overlay.layer = new_target.layer - 0.1
	// Reset transform/color so the marker follows the object without inheriting thrown spin or source coloration.
	cached_punt_overlay.appearance_flags = RESET_TRANSFORM | KEEP_APART
	// The source sprite is authored red, so we use a saturation-override filter instead of a simple tint.
	owner.client.images += cached_punt_overlay

/// Toggles the lock on the current chambered target if one exists.
/datum/telekinetic_punt_preview/proc/toggle_lock()
	if(!cached_punt_target)
		return FALSE
	lock_chambered_target = !lock_chambered_target
	return TRUE

/// Clears the chamber after a throw unless the user explicitly locked the current object.
/datum/telekinetic_punt_preview/proc/clear_after_throw(turf/cursor_turf)
	if(lock_chambered_target)
		cached_cursor_turf = cursor_turf
		return
	cached_cursor_turf = null
	set_cached_punt_target(null)

#undef TK_PUNT_CLICK_OVERLAY
