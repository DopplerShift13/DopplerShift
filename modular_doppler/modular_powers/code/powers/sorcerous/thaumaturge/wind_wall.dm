/*
	Creates a 1x5 wall of wind (blocked by walls and other full tile movement blockers).
	Stops any and all projectiles from passing through, slows down anyone passing through the area, and prevents atmos from passing through this tile. Holofan mini!
	In no-grav, it pushes the mob back rather than let them pass through.
	Duration 30 + (30 * (affinity - 3)) seconds.
	Has target previews!
	Gale Blast is unaffected by the wall.
*/
#define THAUMATURGE_WIND_WALL_CURSOR "thaumaturge_wind_wall_cursor"

/datum/power/thaumaturge/wind_wall
	name = "Wall of Wind"
	desc = "Creates a turbulent wall of wind at a point that you can see. This stops any and all projectiles or thrown objects from passing through, slows down anyone trying to pass through, and prevent atmos from passing through any affected spaces.\
	\nCreatures that remain standing in the area are deafened and take steady amounts of ear damage. Blocks mobs without gravity from passing through.\
	\nLasts for 30 seconds. Right-click to rotate during placement mode. Wind spell projectiles pass through without complications.\
	\nRequires Affinity 3. Excess affinity increases duration by 30 seconds per point."
	security_record_text = "Subject can create wind barriers that stop atmosphere and projectiles."
	security_threat = POWER_THREAT_MAJOR
	value = 3
	action_path = /datum/action/cooldown/power/thaumaturge/wind_wall
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/wind_wall
	name = "Wall of Wind"
	desc = "Creates a wall of wind at the location that blocks projectiles, makes traversal difficult (especially in zero-gravity) and prevents atmospherics effects from passing through. Lasts for 30 seconds. Right-click to rotate."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "wind_wall"
	required_affinity = 3
	prep_cost = 3
	click_to_activate = TRUE
	unset_after_click = TRUE
	target_range = 15
	aim_assist = FALSE

	/// Base lifetime of each wall segment.
	var/base_duration = 30 SECONDS
	/// Additional lifetime per affinity above the requirement.
	var/duration_affinity_bonus = 30 SECONDS
	/// True for an east-west wall; false for a north-south wall.
	var/horizontal_placement = TRUE
	/// The active cursor preview, if this action is armed.
	var/datum/wind_wall_preview/preview_datum

/// Makes sure that we dont have the lingering cursor
/datum/action/cooldown/power/thaumaturge/wind_wall/Remove(mob/removed_from)
	QDEL_NULL(preview_datum)
	return ..()

/// Turns on preview mode when we select the power
/datum/action/cooldown/power/thaumaturge/wind_wall/set_click_ability(mob/on_who)
	. = ..()
	if(.)
		QDEL_NULL(preview_datum)
		preview_datum = new(src, on_who)
	return .

/// Turns off preview mode when we select the power.
/datum/action/cooldown/power/thaumaturge/wind_wall/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	QDEL_NULL(preview_datum)
	return ..()

/// Listens to the right-click function so we can pass on rotations to the preview_datum that handles the actual palcement.
/datum/action/cooldown/power/thaumaturge/wind_wall/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		horizontal_placement = !horizontal_placement
		preview_datum?.refresh()
		clicker.balloon_alert(clicker, "wall rotated")
		return TRUE
	return ..()

/// Places wall, gets wall, wabam.
/datum/action/cooldown/power/thaumaturge/wind_wall/use_action(mob/living/user, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	var/list/wall_turfs = get_wall_turfs(target_turf)
	for(var/turf/wall_turf as anything in wall_turfs)
		if(has_wind_wall_segment(wall_turf))
			user.balloon_alert(user, "no room for a wall!")
			return FALSE
	var/wall_duration = base_duration + (max(affinity - required_affinity, 0) * duration_affinity_bonus)
	var/segments_created = 0
	var/datum/wind_wall_sound_controller/sound_controller = new
	for(var/turf/wall_turf as anything in wall_turfs)
		if(!can_place_wall_on(wall_turf))
			continue
		new /obj/effect/thaumaturge_wind_wall(wall_turf, wall_duration, sound_controller)
		segments_created++

	if(!segments_created)
		qdel(sound_controller)
		user.balloon_alert(user, "no room for a wall!")
		return FALSE
	user.visible_message(span_warning("[user] conjures a roaring wall of wind!"))
	playsound(user, 'sound/effects/podwoosh.ogg', 60, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	return TRUE

/// Returns the five turfs centered on the aimed turf rotated in the selected direction.
/datum/action/cooldown/power/thaumaturge/wind_wall/proc/get_wall_turfs(turf/center_turf)
	var/list/wall_turfs = list()
	if(!center_turf)
		return wall_turfs
	for(var/placement_offset in -2 to 2)
		var/turf/wall_turf
		if(horizontal_placement)
			wall_turf = locate(center_turf.x + placement_offset, center_turf.y, center_turf.z)
		else
			wall_turf = locate(center_turf.x, center_turf.y + placement_offset, center_turf.z)
		if(wall_turf)
			wall_turfs += wall_turf
	return wall_turfs

/// Checks if we're allowed to place a wall somewhere.
/// Dense turfs cannot hold a wall. Existing segments are also not stacked.
/datum/action/cooldown/power/thaumaturge/wind_wall/proc/can_place_wall_on(turf/wall_turf)
	if(!wall_turf || wall_turf.is_blocked_turf(TRUE))
		return FALSE
	if(has_wind_wall_segment(wall_turf))
		return FALSE
	return TRUE

/// Returns whether this turf already belongs to an active wind wall.
/datum/action/cooldown/power/thaumaturge/wind_wall/proc/has_wind_wall_segment(turf/wall_turf)
	if(locate(/obj/effect/thaumaturge_wind_wall) in wall_turf)
		return TRUE
	return FALSE

/// The effect that handles the actual wall effect.
/obj/effect/thaumaturge_wind_wall
	name = "wall of wind"
	desc = "A roaring column of wind that blocks incoming projectiles."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-grey"
	anchored = TRUE
	density = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	resistance_flags = FIRE_PROOF | FREEZE_PROOF
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	/// Raw sound damage per second. Standard ears apply their 0.125 multiplier, resulting in 1 ear damage per second.
	var/ear_damage = 8
	/// Temporary deafness added to an unprotected occupant each processing tick.
	var/deafen_duration = 2 SECONDS
	/// Wind projectiles that are allowed to pass through the barrier.
	var/static/list/wind_projectile_whitelist = typecacheof(list(
		/obj/projectile/resonant/gale_blast,
	))
	/// Shared controller that supplies one contextual ambience loop for this entire wall.
	var/datum/wind_wall_sound_controller/sound_controller

/// Sets-up the sound-controller so we don't get our ears blasted.
/obj/effect/thaumaturge_wind_wall/Initialize(mapload, wall_duration, datum/wind_wall_sound_controller/new_sound_controller)
	. = ..()
	air_update_turf(TRUE, TRUE)
	var/static/list/loc_connections = list(COMSIG_ATOM_EXITED = PROC_REF(on_turf_exited))
	AddElement(/datum/element/connect_loc, loc_connections)
	sound_controller = new_sound_controller
	sound_controller?.add_segment(src)
	START_PROCESSING(SSfastprocess, src)
	if(wall_duration)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/thaumaturge_wind_wall, expire)), wall_duration)

/obj/effect/thaumaturge_wind_wall/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	sound_controller?.remove_segment(src)
	sound_controller = null
	for(var/atom/movable/contained_atom as anything in loc)
		if(!isliving(contained_atom))
			continue
		var/mob/living/occupant = contained_atom
		occupant.remove_movespeed_modifier(/datum/movespeed_modifier/thaumaturge_wind_wall)
	air_update_turf(TRUE, FALSE)
	return ..()

/// Removes the wall upon expiration
/obj/effect/thaumaturge_wind_wall/proc/expire()
	qdel(src)

/// Checks if we passthrough whitelisted projectiles or if the mob has gravity.
/obj/effect/thaumaturge_wind_wall/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(isprojectile(mover))
		return is_type_in_typecache(mover, wind_projectile_whitelist)
	if(mover.throwing)
		return FALSE
	if(isliving(mover))
		var/mob/living/moving_living = mover
		if(!moving_living.has_gravity())
			moving_living.balloon_alert(moving_living, "no gravity!")
			return FALSE
		return TRUE
	return TRUE

/obj/effect/thaumaturge_wind_wall/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isliving(arrived))
		apply_movement_slowdown(arrived)

/obj/effect/thaumaturge_wind_wall/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone))
		var/mob/living/departing_living = gone
		departing_living.remove_movespeed_modifier(/datum/movespeed_modifier/thaumaturge_wind_wall)

/// BLASTS YOUR BLOODY EARS OUT FOR BEING IN A WIND TURBINE
/obj/effect/thaumaturge_wind_wall/process(seconds_per_tick)
	for(var/atom/movable/contained_atom as anything in loc)
		if(!isliving(contained_atom))
			continue
		var/mob/living/occupant = contained_atom
		apply_movement_slowdown(occupant)
		apply_ear_effects(occupant, seconds_per_tick)

/// Applies ear-damage to those inside the wall.
/obj/effect/thaumaturge_wind_wall/proc/apply_ear_effects(mob/living/occupant, seconds_per_tick)
	if(occupant.get_ear_protection() >= 1)
		return
	occupant.sound_damage(ear_damage * seconds_per_tick, deafen_duration)

/// Applies the slowdown effect to the mob.
/obj/effect/thaumaturge_wind_wall/proc/apply_movement_slowdown(mob/living/occupant)
	if(!occupant || !occupant.has_gravity())
		return
	occupant.add_movespeed_modifier(/datum/movespeed_modifier/thaumaturge_wind_wall)

/// Stops projectiles fired from inside the wall as they attempt to leave its turf.
/obj/effect/thaumaturge_wind_wall/proc/on_turf_exited(datum/source, atom/movable/leaving_atom, direction)
	SIGNAL_HANDLER
	if(!isprojectile(leaving_atom) || is_type_in_typecache(leaving_atom, wind_projectile_whitelist))
		return
	var/obj/projectile/leaving_projectile = leaving_atom
	impact_projectile_on_floor(leaving_projectile, leaving_projectile.def_zone)

/// Redirects an intercepted projectile to the turf so its normal floor impact behavior still occurs.
/obj/effect/thaumaturge_wind_wall/proc/impact_projectile_on_floor(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE, blocked = 0)
	if(!hitting_projectile || QDELETED(hitting_projectile))
		return BULLET_ACT_BLOCK
	var/turf/wall_turf = get_turf(src)
	if(wall_turf)
		wall_turf.projectile_hit(hitting_projectile, def_zone, piercing_hit, blocked)
	qdel(hitting_projectile)
	return BULLET_ACT_BLOCK

/// Redirect normal projectiles to the floor instead of letting them impact the wind-wall effect itself.
/obj/effect/thaumaturge_wind_wall/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE, blocked = 0)
	if(is_type_in_typecache(hitting_projectile, wind_projectile_whitelist))
		return ..()
	impact_projectile_on_floor(hitting_projectile, def_zone, piercing_hit, blocked)
	. = ..()
	return BULLET_ACT_BLOCK

/datum/movespeed_modifier/thaumaturge_wind_wall
	multiplicative_slowdown = 0.2

/atom/movable/screen/fullscreen/cursor_catcher/wind_wall

/atom/movable/screen/fullscreen/cursor_catcher/wind_wall/Click(location, control, params)
	if(usr == owner)
		calculate_params()
	given_turf?.Click(location, control, params)

/// Lets the user preview where they are placing wind-wall and handles most of the cursor tracking.
/datum/wind_wall_preview
	/// Action we belong to
	var/datum/action/cooldown/power/thaumaturge/wind_wall/source_action
	/// The user of the action
	var/mob/living/owner
	/// Cursor tracker effect for checking where our mouse is
	var/atom/movable/screen/fullscreen/cursor_catcher/wind_wall/cursor_tracker
	/// The turf the tracker thinks we're on.
	var/turf/cached_cursor_turf
	/// The icons that are shown to the user when we are previewing them.
	var/list/preview_images = list()

/datum/wind_wall_preview/New(datum/action/cooldown/power/thaumaturge/wind_wall/new_source_action, mob/living/new_owner)
	. = ..()
	source_action = new_source_action
	owner = new_owner
	if(!source_action || !owner)
		qdel(src)
		return
	cursor_tracker = owner.overlay_fullscreen(THAUMATURGE_WIND_WALL_CURSOR, /atom/movable/screen/fullscreen/cursor_catcher/wind_wall, 0)
	cursor_tracker?.assign_to_mob(owner)
	START_PROCESSING(SSfastprocess, src)

/datum/wind_wall_preview/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	clear_preview()
	owner?.clear_fullscreen(THAUMATURGE_WIND_WALL_CURSOR)
	if(source_action?.preview_datum == src)
		source_action.preview_datum = null
	cursor_tracker = null
	cached_cursor_turf = null
	owner = null
	source_action = null
	return ..()

/// Gets the turf that our mouse is currently on.
/datum/wind_wall_preview/process()
	if(!source_action || !owner || owner.click_intercept != source_action)
		qdel(src)
		return
	if(cursor_tracker?.mouse_params)
		cursor_tracker.calculate_params()
	var/turf/cursor_turf = cursor_tracker?.given_turf
	if(!cursor_turf || cursor_turf.z != owner.z || cursor_turf == cached_cursor_turf)
		return
	cached_cursor_turf = cursor_turf
	refresh()

/// Refrehses the preview we show to the caster.
/datum/wind_wall_preview/proc/refresh()
	clear_preview()
	if(!owner?.client || !source_action || !cached_cursor_turf)
		return
	for(var/turf/wall_turf as anything in source_action.get_wall_turfs(cached_cursor_turf))
		if(source_action.has_wind_wall_segment(wall_turf))
			return
	for(var/turf/wall_turf as anything in source_action.get_wall_turfs(cached_cursor_turf))
		if(!source_action.can_place_wall_on(wall_turf))
			continue
		var/image/preview_image = image('icons/effects/effects.dmi', wall_turf, "forcefield")
		preview_image.alpha = 150
		preview_image.layer = wall_turf.layer + 0.1
		preview_image.appearance_flags = RESET_TRANSFORM | KEEP_APART
		owner.client.images += preview_image
		preview_images += preview_image

/// Removes the preview images.
/datum/wind_wall_preview/proc/clear_preview()
	if(owner?.client && LAZYLEN(preview_images))
		owner.client.images -= preview_images
	preview_images.Cut()


/*
	Welcome to sound management hell. Because this is a static emplacement with multiple segments, and conditional looping sounds, there are several datums that handle this. PArticularly:
	- wind_wall_sound_controller is the central controller that handles the audio for all segments that are part of one wall
	- wind_wall_listener_sound is assigned to a specific listener and handles the audiotrack they specifically hear
*/

/// Datum that handles the sound system for wind wall.
/// Each listener receives an outside or inside loop, never duplicate loops from all five segments.
/datum/wind_wall_sound_controller
	/// How far from any wall segment the outside wind sound can be heard.
	var/sound_range = 4
	/// The segments currently maintained by this controller.
	var/list/segments = list()
	/// Associative list of listener mobs and their dedicated wind-wall audio state.
	var/list/tracked_listeners = list()

/datum/wind_wall_sound_controller/New()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/datum/wind_wall_sound_controller/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_LIST_ASSOC_VAL(tracked_listeners)
	segments.Cut()
	return ..()

/// Adds segments to the existing sound controller.
/datum/wind_wall_sound_controller/proc/add_segment(obj/effect/thaumaturge_wind_wall/new_segment)
	if(new_segment)
		segments += new_segment

/// Removes a segment when its destroyed.
/datum/wind_wall_sound_controller/proc/remove_segment(obj/effect/thaumaturge_wind_wall/old_segment)
	segments -= old_segment
	if(!length(segments))
		qdel(src)

/// Plays the looping sound to any would-be listeners.
/datum/wind_wall_sound_controller/process()
	/// Each listener's distance from its nearest segment. Every segment contributes to this.
	var/list/nearby_distances = list()
	var/list/inside_mobs = list()
	// Gets everyone in range of segments and records their nearest segment.
	for(var/obj/effect/thaumaturge_wind_wall/wall_segment as anything in segments)
		if(QDELETED(wall_segment))
			segments -= wall_segment
			continue
		for(var/atom/movable/nearby_atom as anything in range(sound_range, wall_segment))
			if(!isliving(nearby_atom))
				continue
			var/mob/living/listener = nearby_atom
			if(!listener.client)
				continue
			var/segment_distance = get_dist(listener, wall_segment)
			var/nearest_distance = nearby_distances[listener]
			if(isnull(nearest_distance) || segment_distance < nearest_distance)
				nearby_distances[listener] = segment_distance
			if(listener.loc == wall_segment.loc)
				inside_mobs[listener] = TRUE

	// No segments? begone
	if(!length(segments))
		qdel(src)
		return

	// Removes mobs that move away from the sound-system.
	for(var/mob/living/tracked_listener as anything in tracked_listeners)
		var/datum/wind_wall_listener_sound/listener_sound = tracked_listeners[tracked_listener]
		if(QDELETED(listener_sound))
			tracked_listeners -= tracked_listener
			continue
		if(isnull(nearby_distances[tracked_listener]))
			listener_sound.update_location(FALSE, FALSE)

	/// Updates each nearby listener's outside/inside audio state.
	for(var/mob/living/nearby_listener as anything in nearby_distances)
		var/datum/wind_wall_listener_sound/listener_sound = tracked_listeners[nearby_listener]
		if(QDELETED(listener_sound))
			listener_sound = null
		if(!listener_sound)
			listener_sound = new(nearby_listener)
			tracked_listeners[nearby_listener] = listener_sound
		listener_sound.update_location(TRUE, !!inside_mobs[nearby_listener], nearby_distances[nearby_listener], sound_range)

/// Per-listener wind-wall audio. Direct channels avoid overlap with unrelated sounds.
/datum/wind_wall_listener_sound
	var/mob/living/listener
	/// Tracks the dedicated channel for each wind loop.
	var/list/sound_channels = list()
	/// Tracks fade timers so re-entering an area can cancel the outgoing fade.
	var/list/fade_timers = list()
	/// Tracks the current fade step per loop.
	var/list/fade_steps = list()
	/// The volume each loop had before an exit transition began.
	var/list/target_volumes = list()
	/// The volume currently applied to each channel, avoiding redundant client sound updates.
	var/list/current_volumes = list()
	/// Fraction of the remaining distance-volume change applied per fast-process tick.
	var/distance_volume_smoothing = 0.5
	/// Ten half-decisecond steps retain the intended 0.5-second transition while reducing audible volume jumps.
	var/fade_step_count = 10
	var/fade_step_delay = 0.5
	var/list/sound_files = list(
		"outside" = 'modular_doppler/modular_powers/sounds/windwall/wind_wall.ogg',
		"inside" = 'modular_doppler/modular_powers/sounds/windwall/wind_wall_inside.ogg',
	)
	var/list/sound_volumes = list(
		"outside" = 40,
		"inside" = 80,
	)
	/// The quietest volume retained on the edge of the outside sound range before its exit fade begins.
	var/minimum_outside_volume = 10

/datum/wind_wall_listener_sound/New(mob/living/new_listener)
	. = ..()
	listener = new_listener

/datum/wind_wall_listener_sound/Destroy()
	for(var/sound_kind as anything in fade_timers)
		var/fade_timer = fade_timers[sound_kind]
		if(fade_timer)
			deltimer(fade_timer)
	for(var/sound_kind as anything in sound_channels)
		stop_sound(sound_kind)
	fade_timers.Cut()
	fade_steps.Cut()
	target_volumes.Cut()
	current_volumes.Cut()
	sound_channels.Cut()
	listener = null
	return ..()

/// Switches between the outside loop and the conditional inside loop.
/datum/wind_wall_listener_sound/proc/update_location(is_nearby, is_inside, nearest_segment_distance, maximum_sound_distance)
	if(!listener?.client)
		qdel(src)
		return
	if(is_inside)
		start_sound("inside", sound_volumes["inside"])
		fade_sound("outside")
		return
	if(is_nearby)
		start_sound("outside", get_outside_volume(nearest_segment_distance, maximum_sound_distance))
		fade_sound("inside")
		return
	fade_sound("outside")
	fade_sound("inside")

/// Starts a loop, or restores it immediately if it was in the process of fading out.
/datum/wind_wall_listener_sound/proc/start_sound(sound_kind, target_volume)
	var/fade_timer = fade_timers[sound_kind]
	if(fade_timer)
		deltimer(fade_timer)
		fade_timers[sound_kind] = null
	target_volumes[sound_kind] = target_volume
	var/sound_channel = sound_channels[sound_kind]
	if(sound_channel)
		if(current_volumes[sound_kind] == target_volume)
			return
		var/current_volume = current_volumes[sound_kind]
		var/next_volume = current_volume + ((target_volume - current_volume) * distance_volume_smoothing)
		if(abs(target_volume - next_volume) < 1)
			next_volume = target_volume
		listener.set_sound_channel_volume(sound_channel, next_volume)
		current_volumes[sound_kind] = next_volume
		return
	sound_channel = SSsounds.reserve_sound_channel_datumless()
	sound_channels[sound_kind] = sound_channel
	current_volumes[sound_kind] = target_volume
	SEND_SOUND(listener, sound(sound_files[sound_kind], repeat = TRUE, channel = sound_channel, volume = target_volume))

/// Returns the outside-loop volume for a listener's nearest wall segment.
/datum/wind_wall_listener_sound/proc/get_outside_volume(nearest_segment_distance, maximum_sound_distance)
	// Preserve quiet audio at the edge for the exit fade, with a gentler curve across the short four-tile range.
	var/distance_fraction = nearest_segment_distance / maximum_sound_distance
	var/volume_fraction = sqrt(max(1 - distance_fraction, 0))
	return minimum_outside_volume + ((sound_volumes["outside"] - minimum_outside_volume) * volume_fraction)

/// Gradually fades a loop over 0.5 seconds before releasing its sound channel.
/datum/wind_wall_listener_sound/proc/fade_sound(sound_kind)
	if(!sound_channels[sound_kind] || fade_timers[sound_kind])
		return
	fade_steps[sound_kind] = 0
	fade_timers[sound_kind] = addtimer(CALLBACK(src, PROC_REF(reduce_sound_volume), sound_kind), fade_step_delay, TIMER_STOPPABLE)

/// Lowers a loop's volume by one fade step and schedules the next step if required.
/datum/wind_wall_listener_sound/proc/reduce_sound_volume(sound_kind)
	// This callback has consumed its timer; keeping its ID causes later deltimer() calls to runtime.
	fade_timers[sound_kind] = null
	var/sound_channel = sound_channels[sound_kind]
	if(!sound_channel || !listener)
		return
	var/fade_step = fade_steps[sound_kind] + 1
	fade_steps[sound_kind] = fade_step
	var/current_volume = target_volumes[sound_kind] * max(fade_step_count - fade_step, 0) / fade_step_count
	listener.set_sound_channel_volume(sound_channel, current_volume)
	current_volumes[sound_kind] = current_volume
	if(fade_step >= fade_step_count)
		fade_timers[sound_kind] = null
		stop_sound(sound_kind)
		if(!has_active_sounds())
			qdel(src)
		return
	fade_timers[sound_kind] = addtimer(CALLBACK(src, PROC_REF(reduce_sound_volume), sound_kind), fade_step_delay, TIMER_STOPPABLE)

/// Stops a loop immediately and releases its reserved sound channel.
/datum/wind_wall_listener_sound/proc/stop_sound(sound_kind)
	var/sound_channel = sound_channels[sound_kind]
	if(!sound_channel || !listener)
		return
	listener.stop_sound_channel(sound_channel)
	SSsounds.free_sound_channel(sound_channel)
	sound_channels[sound_kind] = null
	current_volumes[sound_kind] = null

/// Returns whether this listener still has either wind loop active.
/datum/wind_wall_listener_sound/proc/has_active_sounds()
	for(var/sound_kind as anything in sound_channels)
		if(sound_channels[sound_kind])
			return TRUE
	return FALSE

#undef THAUMATURGE_WIND_WALL_CURSOR
