#define TK_PUNT_CLICK_OVERLAY "psyker_telekinetic_punt_cursor"
#define TK_PUNT_CLICK_NONE 0
#define TK_PUNT_CLICK_LEFT 1
#define TK_PUNT_CLICK_MIDDLE 2

/datum/power/psyker_power/telekinetic_punt
	name = "Telekinetic Punt"
	desc = "Quickly punt a nearby object at the target. Activating the power highlights the nearest, strongest object near the cursor, which will be punted automatically at the target when you click the target.\
	\nUnanchored structures deal an additional +10 damage and +1 knockback, and this can wall-stun."
	security_record_text = "Subject can wield telekinesis to offensively punt objects at targets"
	security_threat = POWER_THREAT_MAJOR
	value = 4
	required_powers = list(/datum/power/psyker_power/telekinesis)
	action_path = /datum/action/cooldown/power/psyker/telekinetic_punt

/datum/action/cooldown/power/psyker/telekinetic_punt
	name = "Telekinetic Punt"
	desc = "Quickly punt a nearby object at the target. Activating the power highlights the nearest, strongest object near the cursor, which will be punted automatically at the target when you click the target.\
	\nUnanchored structures deal an additional +10 damage and +1 knockback, and this can wall-stun."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "immrod"
	click_to_activate = TRUE
	unset_after_click = FALSE
	target_range = 15
	cooldown_time = 5

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
	/// Which mouse click variant we are currently resolving.
	var/tk_punt_click_type = TK_PUNT_CLICK_NONE
	/// Whether the current chambered object is locked in place.
	var/lock_chambered_target = FALSE

/datum/action/cooldown/power/psyker/telekinetic_punt/Grant(mob/granted_to)
	. = ..()
	last_preview_tick = -1

/datum/action/cooldown/power/psyker/telekinetic_punt/Remove(mob/removed_from)
	stop_preview(removed_from)
	return ..()

/datum/action/cooldown/power/psyker/telekinetic_punt/set_click_ability(mob/on_who)
	. = ..()
	if(.)
		start_preview(on_who)
	return .

/datum/action/cooldown/power/psyker/telekinetic_punt/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	stop_preview(on_who)
	return ..()

/datum/action/cooldown/power/psyker/telekinetic_punt/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		tk_punt_click_type = TK_PUNT_CLICK_MIDDLE
		target = cached_punt_target || clicker
	else
		tk_punt_click_type = TK_PUNT_CLICK_LEFT

	. = ..()
	if(!.)
		tk_punt_click_type = TK_PUNT_CLICK_NONE
	return TRUE

/datum/action/cooldown/power/psyker/telekinetic_punt/process()
	if(!owner || owner.click_intercept != src)
		stop_preview(owner)
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
		if(cached_punt_target && !is_valid_punt_candidate(owner, cached_punt_target))
			set_cached_punt_target(null)
		if(cached_punt_target)
			return
	else if(cached_punt_target && !is_valid_punt_candidate(owner, cached_punt_target, cursor_turf))
		set_cached_punt_target(null)
	if(cached_punt_target && cached_cursor_turf && get_dist(cached_cursor_turf, cursor_turf) <= 1)
		return

	refresh_cached_punt_target(owner, cursor_turf)

/datum/action/cooldown/power/psyker/telekinetic_punt/use_action(mob/living/user, atom/target)
	var/click_type = tk_punt_click_type
	tk_punt_click_type = TK_PUNT_CLICK_NONE

	if(cursor_tracker?.mouse_params)
		cursor_tracker.calculate_params()

	var/turf/cursor_turf = cursor_tracker?.given_turf || cached_cursor_turf || get_turf(target)
	if(click_type == TK_PUNT_CLICK_MIDDLE)
		if(!is_valid_punt_candidate(user, cached_punt_target, cursor_turf))
			refresh_cached_punt_target(user, cursor_turf)
		if(!is_valid_punt_candidate(user, cached_punt_target, cursor_turf))
			user.balloon_alert(user, "nothing chambered!")
			return FALSE
		lock_chambered_target = !lock_chambered_target
		user.balloon_alert(user, lock_chambered_target ? "target locked" : "target unlocked")
		return FALSE

	if(!is_valid_punt_candidate(user, cached_punt_target, cursor_turf))
		refresh_cached_punt_target(user, cursor_turf)

	var/atom/movable/punt_target = cached_punt_target
	if(!is_valid_punt_candidate(user, punt_target, cursor_turf))
		user.balloon_alert(user, "nothing suitable!")
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	RegisterSignal(punt_target, COMSIG_MOVABLE_IMPACT, PROC_REF(on_punt_impact))
	user.visible_message(span_warning("[user] hurls [punt_target] at [target] with psychic force!"))
	playsound(user, 'sound/effects/magic/repulse.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	// Glowey effect
	var/filter_id = "psyker_punt_flash"
	punt_target.add_filter(filter_id, 1, list(type = "outline", color = POWER_COLOR_PSYKER, size = 2, alpha = 255))
	punt_target.transition_filter(filter_id, list("alpha" = 0), 2 SECONDS) // this actually looks smoother
	addtimer(CALLBACK(target, PROC_REF(remove_filter), filter_id), 2 SECONDS)

	var/punt_range = max(get_dist(punt_target, target_turf), 1)
	if(!punt_target.safe_throw_at(target_turf, range = punt_range, speed = punt_target.density ? 3 : 4, thrower = null, spin = isitem(punt_target), force = MOVE_FORCE_EXTREMELY_STRONG))
		UnregisterSignal(punt_target, COMSIG_MOVABLE_IMPACT)
		user.balloon_alert(user, "can't move that!")
		return FALSE

	if(lock_chambered_target)
		cached_cursor_turf = cursor_turf
	else
		cached_cursor_turf = null
		set_cached_punt_target(null)

	modify_stress(PSYKER_STRESS_MINOR) // cost
	return TRUE

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/start_preview(mob/on_who)
	if(!on_who)
		return
	if(!cursor_tracker)
		cursor_tracker = on_who.overlay_fullscreen(TK_PUNT_CLICK_OVERLAY, /atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt, 0)
		cursor_tracker.assign_to_mob(on_who)
	cached_cursor_turf = null
	last_preview_tick = -1
	lock_chambered_target = FALSE
	tk_punt_click_type = TK_PUNT_CLICK_NONE
	set_cached_punt_target(null)
	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/stop_preview(mob/on_who)
	STOP_PROCESSING(SSfastprocess, src)
	if(on_who)
		on_who.clear_fullscreen(TK_PUNT_CLICK_OVERLAY)
	cursor_tracker = null
	cached_cursor_turf = null
	last_preview_tick = -1
	lock_chambered_target = FALSE
	tk_punt_click_type = TK_PUNT_CLICK_NONE
	set_cached_punt_target(null)

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/refresh_cached_punt_target(mob/living/user, turf/cursor_turf)
	if(!user || !cursor_turf)
		set_cached_punt_target(null)
		return
	var/atom/movable/best_target = find_best_punt_target(user, cursor_turf)
	set_cached_punt_target(best_target)
	if(best_target)
		cached_cursor_turf = cursor_turf
	else
		cached_cursor_turf = null

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/set_cached_punt_target(atom/movable/new_target)
	if(owner?.client && cached_punt_overlay)
		owner.client.images -= cached_punt_overlay
	cached_punt_overlay = null
	if(cached_punt_target != new_target && lock_chambered_target)
		lock_chambered_target = FALSE
	cached_punt_target = new_target
	if(!new_target || !owner?.client)
		return

	cached_punt_overlay = image('icons/effects/effects.dmi', new_target, "launchpad_pull")
	cached_punt_overlay.layer = new_target.layer - 0.1
	owner.client.images += cached_punt_overlay

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/find_best_punt_target(mob/living/user, turf/cursor_turf)
	var/atom/movable/best_target
	var/best_score = -1
	var/best_distance = INFINITY

	for(var/scan_x in (cursor_turf.x - punt_scan_radius) to (cursor_turf.x + punt_scan_radius))
		for(var/scan_y in (cursor_turf.y - punt_scan_radius) to (cursor_turf.y + punt_scan_radius))
			var/turf/scan_turf = locate(scan_x, scan_y, cursor_turf.z)
			if(!scan_turf)
				continue

			for(var/obj/item/item_target in scan_turf)
				var/item_damage = get_punt_damage(item_target)
				if(item_damage < min_damage_to_punt)
					continue
				if(!is_valid_punt_candidate(user, item_target, cursor_turf))
					continue
				var/item_distance = get_dist(cursor_turf, item_target)
				var/item_score = get_effective_punt_score(item_damage, item_distance)
				if(item_score > best_score || (item_score == best_score && item_distance < best_distance))
					best_target = item_target
					best_score = item_score
					best_distance = item_distance

			for(var/obj/structure/structure_target in scan_turf)
				var/structure_damage = get_punt_damage(structure_target)
				if(structure_damage < min_damage_to_punt)
					continue
				if(!is_valid_punt_candidate(user, structure_target, cursor_turf))
					continue
				var/structure_distance = get_dist(cursor_turf, structure_target)
				var/structure_score = get_effective_punt_score(structure_damage, structure_distance)
				if(structure_score > best_score || (structure_score == best_score && structure_distance < best_distance))
					best_target = structure_target
					best_score = structure_score
					best_distance = structure_distance

	return best_target

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/is_valid_punt_candidate(mob/living/user, atom/movable/candidate, turf/cursor_turf)
	if(!candidate || QDELETED(candidate))
		return FALSE
	if(!isturf(candidate.loc))
		return FALSE
	if(candidate.anchored)
		return FALSE
	if(candidate.move_resist >= MOVE_FORCE_EXTREMELY_STRONG)
		return FALSE
	if(get_dist(user, candidate) > punt_object_distance)
		return FALSE
	if(!(candidate in view(user)))
		return FALSE
	if(cursor_turf && !(cursor_turf in view(candidate)))
		return FALSE
	if(isitem(candidate))
		var/obj/item/item_candidate = candidate
		if(item_candidate.item_flags & ABSTRACT)
			return FALSE
		return get_punt_damage(item_candidate) >= min_damage_to_punt
	if(isstructure(candidate))
		return get_punt_damage(candidate) >= min_damage_to_punt
	return FALSE

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_punt_damage(atom/movable/candidate)
	if(isitem(candidate))
		var/obj/item/item_candidate = candidate
		return max(item_candidate.throwforce, item_candidate.force)
	if(isstructure(candidate))
		return structure_punt_damage
	return 0

/// Treats the effective damage as less based on distance given these have a chance to miss/be obstructed, causing bias to closer objects.
/datum/action/cooldown/power/psyker/telekinetic_punt/proc/get_effective_punt_score(base_damage, distance)
	return max(base_damage * (1 - (0.1 * distance)), 0)

/datum/action/cooldown/power/psyker/telekinetic_punt/proc/on_punt_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing, caught)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)

	var/knockback = base_knockback
	var/mob/thrower = owner
	if(thrownthing?.get_thrower())
		thrower = thrownthing.get_thrower()

	if(caught)
		return

	if(isitem(source))
		if(isliving(hit_atom) && knockback > 0)
			var/mob/living/living_target = hit_atom
			var/throw_dir = get_dir(source, living_target)
			if(!throw_dir && thrower)
				throw_dir = get_dir(thrower, living_target)
			if(throw_dir)
				var/atom/throw_target = get_edge_target_turf(living_target, throw_dir)
				living_target.throw_at(throw_target, knockback, 2, thrower)
		return

	var/damage = get_punt_damage(source)
	if(isstructure(source))
		damage += structure_bonus_damage
		knockback += structure_bonus_knockback

	if(isliving(hit_atom))
		var/mob/living/living_target = hit_atom

		living_target.apply_damage(damage, BRUTE)
		if(knockback > 0)
			var/throw_dir = get_dir(source, living_target)
			if(!throw_dir && thrower)
				throw_dir = get_dir(thrower, living_target)
			if(throw_dir)
				var/atom/throw_target = get_edge_target_turf(living_target, throw_dir)
				living_target.throw_at(throw_target, knockback, 2, thrower)
		playsound(living_target, 'sound/items/lead_pipe_hit.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
		living_target.log_message("was hit by a telekinetically punted [source] from [thrower] for [damage] damage.", LOG_VICTIM)
		thrower?.log_message("telekinetically punted [source] into [living_target] for [damage] damage.", LOG_ATTACK)
	else if(hit_atom.uses_integrity)
		hit_atom.take_damage(damage, BRUTE, MELEE)

/atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt

/atom/movable/screen/fullscreen/cursor_catcher/telekinetic_punt/Click(location, control, params)
	if(usr == owner)
		calculate_params()
	given_turf?.Click(location, control, params)

#undef TK_PUNT_CLICK_OVERLAY
#undef TK_PUNT_CLICK_NONE
#undef TK_PUNT_CLICK_LEFT
#undef TK_PUNT_CLICK_MIDDLE
