/*
	BIG FUCKING SPOILERS BELOW

	BIG FUCKING SPOILERS BELOW

	BIG FUCKING SPOILERS BELOW

	Hey so did you know that casting a Thaumaturge's Mending fixes the delam to this specific type?
	This basically causes full-on erasure of the station, systmetically destroying everything (besides mobs) thats adjacent to space until nothing is left.
	This exlcudes shuttles.
	This has the lowest priorities of other delams, so you can bypass this by force-delamming into another special type (which may not be strictly better)
*/

/// Whether this crystal has been tainted by thaumaturgic mending and should later delaminate into erasure.
/obj/machinery/power/supermatter_crystal/var/tainted_by_mending = FALSE

/datum/sm_delam/erasure

/datum/sm_delam/erasure/can_select(obj/machinery/power/supermatter_crystal/sm)
	return sm.is_main_engine && sm.tainted_by_mending

/datum/sm_delam/erasure/delam_progress(obj/machinery/power/supermatter_crystal/sm)
	if(!..())
		return FALSE

	sm.radio.talk_into(
		sm,
		"DANGER: SENSORS FAILING, RESONANT INTERFERENCE.",
		sm.damage >= sm.emergency_point ? sm.emergency_channel : sm.warning_channel,
	)

	var/list/messages = list(
		"Reality begins to fade away before your eyes.",
		"The world seems to vanish around you.",
		"From the edges of your vision, all you see is space.",
		"You feel the cold chill of space, and a difficulty of breath.",
	)
	var/message_to_send = pick(messages)
	for(var/mob/player_mob as anything in GLOB.player_list)
		var/mob/living/living_player = player_mob
		if(!istype(living_player) || !living_player.has_power_in_path(POWER_PATH_THAUMATURGE))
			continue
		to_chat(living_player, span_danger(message_to_send))

	return TRUE

/datum/sm_delam/erasure/on_select(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] is heading towards a mass erasure event. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("is heading towards a mass erasure event.", INVESTIGATE_ENGINE)
	addtimer(CALLBACK(src, PROC_REF(announce_erasure), sm), 2 MINUTES)

/datum/sm_delam/erasure/on_deselect(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] will no longer trigger a mass erasure event. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("will no longer trigger a mass erasure event.", INVESTIGATE_ENGINE)

/datum/sm_delam/erasure/lights(obj/machinery/power/supermatter_crystal/sm)
	..()
	sm.set_light_color("#7266dd")

/datum/sm_delam/erasure/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Supermatter [sm] at [ADMIN_VERBOSEJMP(sm)] triggered a mass erasure event.")
	sm.investigate_log("triggered a mass erasure event.", INVESTIGATE_ENGINE)
	broadcast_erasure_message(sm)
	begin_mass_erasure(sm)
	force_emergency_shuttle(sm)
	return ..()

/datum/sm_delam/erasure/count_down_messages(obj/machinery/power/supermatter_crystal/sm)
	var/list/messages = list()
	messages += "CRYSTAL DELAMINATION IMMINENT. The supermatter has reached critical integrity failure. Resonant phenomena has caused mass-sensor failure. Mass reality altering event imminent. Prepare for unforseen consequences."
	messages += "Crystalline hyperstructure returning to safe operating parameters. Resonant phemona decreasing."
	messages += "remain until crystal delamination."
	return messages

/datum/sm_delam/erasure/proc/announce_erasure(obj/machinery/power/supermatter_crystal/sm)
	if(QDELETED(sm))
		return FALSE
	if(!can_select(sm))
		return FALSE
	priority_announce(
		"Attention: Unusual resonant phenomena is intervening with our anomaly scanners, the earlier Thaumaturgic interaction with the Supermatter has led to unforseen consequences. Mass reality altering events may occur upon delamination. We have no data on this; please prevent this at any and all costs.",
		"4CA Anomalous Observation Branch",
		'sound/announcer/alarm/airraid.ogg',
	)
	return TRUE

/// Spawns the erasure anchor that handles the initial wipe and ongoing hotspot-based spread.
/datum/sm_delam/erasure/proc/begin_mass_erasure(obj/machinery/power/supermatter_crystal/sm)
	var/turf/center_turf = get_turf(sm)
	if(!center_turf)
		return

	var/obj/effect/erasure_anchor/erasure_anchor = new /obj/effect/erasure_anchor(center_turf)
	erasure_anchor.activate_erasure()

/// Sends the station-wide erasure warning text and music, with special messaging for thaumaturges and Void Path heretics.
/datum/sm_delam/erasure/proc/broadcast_erasure_message(obj/machinery/power/supermatter_crystal/sm)
	if(!is_station_level(sm.z))
		return

	for(var/mob/station_mob as anything in GLOB.player_list)
		if(!is_station_level(station_mob.z))
			continue

		var/message_text = "A chill goes down your spine, and the whole world around you feels like its fading away."
		var/datum/antagonist/heretic/heretic_datum = station_mob.mind?.has_antag_datum(/datum/antagonist/heretic)
		if(heretic_datum?.heretic_path?.route == PATH_VOID)
			message_text = "IT IS BEAUTIFUL; THIS POWER TO BEHOLD. THE VOID, IT BECKONS!"
		else
			var/mob/living/living_station_mob = station_mob
			if(istype(living_station_mob) && living_station_mob.has_power_in_path(POWER_PATH_THAUMATURGE))
				message_text = "Reality is begining to unfold, the thaumaturgic magic that previously mended the crystal has now turned on the station, undoing its existence. Is this what magic can do?!"

		SEND_SOUND(station_mob, sound('sound/music/antag/heretic/VoidsEmbrace.ogg', volume = 60))
		to_chat(station_mob, "<font color='#7266dd' size='5'><b>[message_text]</b></font>")

/// Calls the emergency shuttle with a fixed 10 minute timer for the erasure event.
/datum/sm_delam/erasure/proc/force_emergency_shuttle(obj/machinery/power/supermatter_crystal/sm)
	if(!SSshuttle?.emergency)
		return

	SSshuttle.emergency.request(
		signal_origin = get_area(sm),
		reason = "\n\nNature of emergency:\nMass erasure event in progress.",
		red_alert = TRUE,
		set_coefficient = 1,
	)

/obj/effect/erasure_anchor
	name = "mass erasure epicenter"
	desc = "What have we done?!"
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "bhole3"
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	invisibility = INVISIBILITY_OBSERVER

	/// Whether this anchor is still actively erasing the map.
	var/erasure_active = FALSE
	/// Radius, in tiles, of the one-time wipe centered on the supermatter.
	var/initial_wipe_radius = 7
	/// Additional invisible hotspots to create per station z-level, not counting the guaranteed epicenter hotspot.
	var/controllers_per_station_z = 4
	/// How many turfs each hotspot deletes per processing tick.
	var/turfs_erased_per_tick = 2
	/// Maximum number of local frontier entries each hotspot will evaluate per processing tick.
	var/max_attempts_per_tick = 60
	/// Active invisible hotspots currently propagating the erasure.
	var/list/active_hotspots = list()
	/// Cached frontier source turfs grouped by station z-level for hotspot spawning and relocation.
	var/list/frontier_sources_by_z = list()

/// Initializes the anchor inertly so admin-spawned instances do nothing until explicitly activated.
/obj/effect/erasure_anchor/Initialize(mapload)
	return ..()

/// Performs the initial wipe, caches valid frontier sources, and spawns the hotspot controllers.
/obj/effect/erasure_anchor/proc/activate_erasure()
	if(erasure_active)
		return FALSE

	erasure_active = TRUE
	for(var/turf/current_turf as anything in RANGE_TURFS(initial_wipe_radius, src))
		erase_turf(current_turf)

	cache_frontier_sources()
	spawn_initial_hotspots()
	if(!LAZYLEN(active_hotspots))
		qdel(src)
		return FALSE

	return TRUE

/obj/effect/erasure_anchor/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION("activate_erasure", "Activate Erasure")

/obj/effect/erasure_anchor/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(isnull(usr) || !href_list["activate_erasure"] || !check_rights(R_FUN, show_msg = TRUE))
		return

	log_admin("[key_name(usr)] has activated a mass erasure anchor.")
	activate_erasure()

/// Removes hidden underfloor support objects and converts a turf into the appropriate erasure void turf.
/obj/effect/erasure_anchor/proc/erase_turf(turf/target_turf, preferred_void_turf_type)
	if(!target_turf || !is_valid_erasure_target(target_turf))
		return FALSE

	erase_hidden_underfloor_objects(target_turf)
	erase_void_turf_objects(target_turf)
	var/turf/converted_turf = convert_turf_to_erasure_void(target_turf, preferred_void_turf_type)
	if(!converted_turf)
		return FALSE
	return TRUE

/// Deletes only concealed underfloor objects, mirroring singularity cleanup without removing support objects the turf conversion may need.
/obj/effect/erasure_anchor/proc/erase_hidden_underfloor_objects(turf/target_turf)
	if(target_turf.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
		return

	for(var/obj/contained_object as anything in target_turf.contents)
		if(!istype(contained_object))
			continue
		if(!HAS_TRAIT(contained_object, TRAIT_UNDERFLOOR))
			continue
		qdel(contained_object, force = TRUE)

/// Deletes objects on a void turf unless they are explicitly indestructible, preserving the erasure controller objects themselves.
/obj/effect/erasure_anchor/proc/erase_void_turf_objects(turf/target_turf)
	for(var/obj/contained_object as anything in target_turf.contents)
		if(!istype(contained_object))
			continue
		if(contained_object == src || istype(contained_object, /obj/effect/erasure_hotspot))
			continue
		if(contained_object.resistance_flags & INDESTRUCTIBLE)
			continue
		qdel(contained_object, force = TRUE)

/// Builds the cached frontier source lists used to spawn and relocate erasure hotspots.
/obj/effect/erasure_anchor/proc/cache_frontier_sources()
	for(var/station_z as anything in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/station_z_key = "[station_z]"
		frontier_sources_by_z[station_z_key] = collect_frontier_sources_for_z(station_z)

/// Returns a list of space or openspace turfs on the given z-level that border erasable non-space tiles.
/obj/effect/erasure_anchor/proc/collect_frontier_sources_for_z(station_z)
	var/list/frontier_sources = list()
	var/turf/bottom_left_turf = locate(1, 1, station_z)
	var/turf/top_right_turf = locate(world.maxx, world.maxy, station_z)
	if(!bottom_left_turf || !top_right_turf)
		return frontier_sources

	for(var/turf/current_turf as anything in block(bottom_left_turf, top_right_turf))
		if(!is_valid_frontier_source(current_turf))
			continue
		frontier_sources += current_turf

	return frontier_sources

/// Spawns one hotspot at the epicenter plus the configured number of extra hotspots per station z-level.
/obj/effect/erasure_anchor/proc/spawn_initial_hotspots()
	var/list/used_spawn_sources = list()
	var/turf/anchor_turf = get_turf(src)
	var/turf/epicenter_spawn_turf = is_valid_frontier_source(anchor_turf) ? anchor_turf : pick_frontier_source(anchor_turf?.z, used_spawn_sources, TRUE)
	if(epicenter_spawn_turf)
		create_hotspot(epicenter_spawn_turf)
		used_spawn_sources += epicenter_spawn_turf

	for(var/station_z as anything in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/controller_index in 1 to controllers_per_station_z)
			var/turf/spawn_turf = pick_frontier_source(station_z, used_spawn_sources, TRUE)
			if(!spawn_turf)
				break
			create_hotspot(spawn_turf)
			used_spawn_sources += spawn_turf

/// Creates an invisible hotspot controller on the supplied turf and starts its processing loop.
/obj/effect/erasure_anchor/proc/create_hotspot(turf/spawn_turf)
	if(!spawn_turf)
		return null

	var/obj/effect/erasure_hotspot/new_hotspot = new /obj/effect/erasure_hotspot(spawn_turf)
	new_hotspot.owning_anchor = src
	new_hotspot.turfs_erased_per_tick = turfs_erased_per_tick
	new_hotspot.max_attempts_per_tick = max_attempts_per_tick
	active_hotspots += new_hotspot
	new_hotspot.move_to_frontier_source(spawn_turf)
	new_hotspot.begin_processing()
	return new_hotspot

/// Picks a cached frontier source, either strictly from one z-level or by falling back across station z-levels.
/obj/effect/erasure_anchor/proc/pick_frontier_source(preferred_z, list/excluded_sources, strict_z = FALSE)
	if(strict_z)
		var/preferred_z_key = "[preferred_z]"
		return pick_valid_frontier_source_from_list(frontier_sources_by_z[preferred_z_key], excluded_sources)

	var/list/candidate_z_levels = list()
	var/preferred_z_key = "[preferred_z]"
	if(!isnull(frontier_sources_by_z[preferred_z_key]))
		candidate_z_levels += preferred_z
	for(var/station_z as anything in SSmapping.levels_by_trait(ZTRAIT_STATION))
		if(station_z == preferred_z)
			continue
		candidate_z_levels += station_z

	for(var/station_z as anything in candidate_z_levels)
		var/station_z_key = "[station_z]"
		var/turf/frontier_source = pick_valid_frontier_source_from_list(frontier_sources_by_z[station_z_key], excluded_sources)
		if(frontier_source)
			return frontier_source

	return null

/// Returns one valid frontier source from a cached list while removing stale entries that can no longer spread erasure.
/obj/effect/erasure_anchor/proc/pick_valid_frontier_source_from_list(list/frontier_sources, list/excluded_sources)
	if(!islist(frontier_sources) || !frontier_sources.len)
		return null

	var/list/source_pool = frontier_sources.Copy()
	while(source_pool.len)
		var/random_index = rand(1, source_pool.len)
		var/turf/frontier_source = source_pool[random_index]
		source_pool.Cut(random_index, random_index + 1)
		if(excluded_sources)
			if(frontier_source in excluded_sources)
				continue
		if(is_valid_frontier_source(frontier_source))
			return frontier_source
		frontier_sources -= frontier_source

	return null

/// Attempts to relocate a stalled hotspot to a fresh cached frontier source and reseed its local frontier.
/obj/effect/erasure_anchor/proc/relocate_hotspot(obj/effect/erasure_hotspot/hotspot)
	var/turf/new_frontier_source = pick_frontier_source(hotspot?.z, strict_z = TRUE)
	if(!new_frontier_source)
		return FALSE

	hotspot.move_to_frontier_source(new_frontier_source)
	return TRUE

/// Removes a hotspot from the active list and deletes the anchor once no hotspots remain.
/obj/effect/erasure_anchor/proc/unregister_hotspot(obj/effect/erasure_hotspot/hotspot)
	active_hotspots -= hotspot
	if(erasure_active && !LAZYLEN(active_hotspots))
		qdel(src)

/// Returns TRUE when a turf is non-space, non-openspace, not shuttle-protected, and currently borders the erasure void.
/obj/effect/erasure_anchor/proc/is_valid_erasure_candidate(turf/target_turf)
	return is_valid_erasure_target(target_turf) && !is_space_or_openspace(target_turf) && is_adjacent_to_erasure_void(target_turf)

/// Returns TRUE when a turf is already space or openspace and can act as a hotspot spawn frontier.
/obj/effect/erasure_anchor/proc/is_valid_frontier_source(turf/target_turf)
	return is_valid_erasure_target(target_turf) && is_space_or_openspace(target_turf) && is_adjacent_to_erasable_turf(target_turf)

/// Returns TRUE when a turf is on a station z-level and is not protected from erasure.
/obj/effect/erasure_anchor/proc/is_valid_erasure_target(turf/target_turf)
	return !!target_turf && is_station_level(target_turf.z) && !is_erasure_protected_turf(target_turf)

/// Returns TRUE when any cardinally adjacent turf is already part of the erasure void.
/obj/effect/erasure_anchor/proc/is_adjacent_to_erasure_void(turf/target_turf)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(target_turf, direction)
		if(is_space_or_openspace(adjacent_turf))
			return TRUE
	return FALSE

/// Returns TRUE when any cardinally adjacent turf is a valid future erasure target.
/obj/effect/erasure_anchor/proc/is_adjacent_to_erasable_turf(turf/target_turf)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(target_turf, direction)
		if(is_valid_erasure_candidate(adjacent_turf))
			return TRUE
	return FALSE

/// Excludes shuttle tiles from the erasure spread entirely.
/obj/effect/erasure_anchor/proc/is_erasure_protected_turf(turf/target_turf)
	return istype(get_area(target_turf), /area/shuttle)

/// Converts a turf to hard space on the lowest station layer and openspace on higher station layers.
/obj/effect/erasure_anchor/proc/convert_turf_to_erasure_void(turf/target_turf, preferred_void_turf_type)
	if(!target_turf)
		return null

	if(should_convert_to_openspace(target_turf))
		if(isopenspaceturf(target_turf))
			return target_turf

		var/turf/scraped_turf = target_turf.ScrapeAway(2)
		if(isopenspaceturf(scraped_turf))
			return scraped_turf

		var/openspace_turf_type = ispath(preferred_void_turf_type, /turf/open/openspace) ? preferred_void_turf_type : /turf/open/openspace
		var/turf/forced_openspace_turf = scraped_turf?.ChangeTurf(openspace_turf_type)
		return isopenspaceturf(forced_openspace_turf) ? forced_openspace_turf : null

	if(isspaceturf(target_turf))
		return target_turf

	var/turf/open/space/new_space_turf = target_turf.ChangeTurf(/turf/open/space, flags = CHANGETURF_INHERIT_AIR)
	if(!istype(new_space_turf))
		return null
	if(!istype(get_area(new_space_turf), /area/space/nearstation))
		set_turf_to_area(new_space_turf, GLOB.areas_by_type[/area/space/nearstation])
	new_space_turf.update_starlight()
	return new_space_turf

/// Returns TRUE when the turf has another station layer below it and should therefore become openspace instead of hard space.
/obj/effect/erasure_anchor/proc/should_convert_to_openspace(turf/target_turf)
	var/turf/below_turf = GET_TURF_BELOW(target_turf)
	return is_station_level(below_turf?.z)


/// Stops the anchor from processing further and clears its cached state.
/obj/effect/erasure_anchor/Destroy(force)
	erasure_active = FALSE
	QDEL_LIST(active_hotspots)
	active_hotspots.Cut()
	frontier_sources_by_z.Cut()
	return ..()

/*
	Local hotspots which are there to compute propogation (largely for optimization).
	These spawn on a space that borders (open) space and a solid turf, at which point it starts deleting tiles that are not (open) space. It then propogates to its neighbor, and continues to until it stalls, at which point it relocates to another frontier.
*/
/obj/effect/erasure_hotspot
	name = "mass erasure hotspot"
	desc = "What have we done?!"
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "anom"
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER

	/// Anchor coordinating this hotspot's lifecycle and relocation.
	var/obj/effect/erasure_anchor/owning_anchor
	/// Whether this hotspot should keep processing.
	var/hotspot_active = TRUE
	/// How many turfs this hotspot deletes per processing tick.
	var/turfs_erased_per_tick = 2
	/// Maximum number of local frontier entries this hotspot will evaluate per processing tick.
	var/max_attempts_per_tick = 60
	/// Local cardinal frontier candidates adjacent to this hotspot's current erasure pocket.
	var/list/local_frontier_turfs = list()
	/// The exact void turf type this hotspot should propagate while it remains in its current frontier pocket.
	var/preferred_void_turf_type

/// Finishes hotspot initialization without seeding, because the owning anchor is attached immediately after creation.
/obj/effect/erasure_hotspot/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(validate_host_anchor)), 0)
	return .

/// Removes manually spawned hotspots that never received a valid host anchor.
/obj/effect/erasure_hotspot/proc/validate_host_anchor()
	if(QDELETED(src))
		return
	if(istype(owning_anchor))
		return
	qdel(src)

/// Starts this hotspot's repeating processing loop.
/obj/effect/erasure_hotspot/proc/begin_processing()
	if(!hotspot_active)
		return
	addtimer(CALLBACK(src, PROC_REF(process_erasure_tick)), 1 SECONDS)

/// Erases nearby frontier turfs, or relocates this hotspot if its local pocket stalls out.
/obj/effect/erasure_hotspot/proc/process_erasure_tick()
	if(!hotspot_active || QDELETED(owning_anchor) || !owning_anchor.erasure_active)
		qdel(src)
		return

	prune_local_frontier()
	if(!has_viable_frontier())
		if(!owning_anchor.relocate_hotspot(src))
			qdel(src)
			return
		prune_local_frontier()

	var/turfs_erased = 0
	var/max_attempts = min(LAZYLEN(local_frontier_turfs) * 2, max_attempts_per_tick)
	var/current_attempt = 0

	while(LAZYLEN(local_frontier_turfs) && turfs_erased < turfs_erased_per_tick && current_attempt < max_attempts)
		current_attempt++

		var/random_index = rand(1, local_frontier_turfs.len)
		var/turf/target_turf = local_frontier_turfs[random_index]
		local_frontier_turfs.Cut(random_index, random_index + 1)

		if(!owning_anchor.is_valid_erasure_candidate(target_turf))
			continue
		if(!owning_anchor.erase_turf(target_turf, preferred_void_turf_type))
			continue

		turfs_erased++
		enqueue_adjacent_candidates(target_turf)

	if(!LAZYLEN(local_frontier_turfs) || !turfs_erased)
		if(!owning_anchor.relocate_hotspot(src))
			qdel(src)
			return

	addtimer(CALLBACK(src, PROC_REF(process_erasure_tick)), 1 SECONDS)

/// Moves the hotspot to a fresh frontier source and rebuilds its local frontier around that new location.
/obj/effect/erasure_hotspot/proc/move_to_frontier_source(turf/new_frontier_source)
	if(!new_frontier_source)
		return
	forceMove(new_frontier_source)
	if(is_space_or_openspace(new_frontier_source))
		preferred_void_turf_type = new_frontier_source.type
	else
		preferred_void_turf_type = null
	local_frontier_turfs.Cut()
	seed_local_frontier()

/// Removes stale, duplicate, or self-referential frontier entries so stalled hotspots do not orbit invalid work.
/obj/effect/erasure_hotspot/proc/prune_local_frontier()
	var/turf/current_turf = get_turf(src)
	if(!LAZYLEN(local_frontier_turfs))
		return

	for(var/frontier_index = local_frontier_turfs.len, frontier_index >= 1, frontier_index--)
		var/turf/candidate_turf = local_frontier_turfs[frontier_index]
		if(candidate_turf == current_turf || !owning_anchor?.is_valid_erasure_candidate(candidate_turf))
			local_frontier_turfs.Cut(frontier_index, frontier_index + 1)

/// Returns TRUE when this hotspot still has either queued frontier work or a valid frontier source under itself.
/obj/effect/erasure_hotspot/proc/has_viable_frontier()
	if(LAZYLEN(local_frontier_turfs))
		return TRUE

	var/turf/current_turf = get_turf(src)
	return owning_anchor?.is_valid_frontier_source(current_turf)

/// Seeds the hotspot's local frontier using the current turf's cardinal neighbors.
/obj/effect/erasure_hotspot/proc/seed_local_frontier()
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return
	enqueue_adjacent_candidates(current_turf)

/// Adds newly exposed neighboring turfs to this hotspot's local frontier.
/obj/effect/erasure_hotspot/proc/enqueue_adjacent_candidates(turf/origin_turf)
	var/turf/current_turf = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(origin_turf, direction)
		if(adjacent_turf == current_turf)
			continue
		if(!owning_anchor?.is_valid_erasure_candidate(adjacent_turf))
			continue
		local_frontier_turfs |= adjacent_turf

/// Unregisters this hotspot from the anchor and clears its local frontier cache.
/obj/effect/erasure_hotspot/Destroy(force)
	hotspot_active = FALSE
	if(!QDELETED(owning_anchor))
		owning_anchor.unregister_hotspot(src)
	local_frontier_turfs.Cut()
	return ..()
