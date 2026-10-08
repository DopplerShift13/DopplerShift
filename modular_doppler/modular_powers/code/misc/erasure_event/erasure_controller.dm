/**
 *	This is the Mass Erasure Controller. This is a pipeline that handles, as optimized as possible, the entire slow and steady erasure of the station with as little left over residue as possible. There's a few moving parts:
 *	- The mass erasure controller. This is the central controller and what the hotspots will communicate with. It makes a list of valid spots for them to go to on delam, and co-ordinates them from there. Deleting it stops the event.
 *	- The mass erasure hotspots. These are given a spot by the controller, will appear in that spot, and propagate from it and valid tiles adjacent to it (storing it) until it runs out of stored tiles, after which the controller gives them a new spot.
 *	- The mass erasure residue janitor. This functions similarly to the hotspots but specifically targets junk items that the hotspots often skip over like lattice, having different logic.
 *
 *	This can be spawned as an admin, allowing you to start it for events and such. It'll start disabled until you use Activate Erasure in the VV dropdown box. You can tweak the vars til you do to optimize station deletion :)
**/
/obj/effect/mass_erasure_controller
	name = "mass erasure field"
	desc = "Magic gone awry, altering reality around it at a ludacris scale. What have we done?!"
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "bhole3"
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	invisibility = INVISIBILITY_OBSERVER

	/// Whether this controller is still actively erasing the map.
	var/erasure_active = FALSE
	/// Radius, in tiles, of the one-time wipe centered on the supermatter.
	var/initial_wipe_radius = 7
	/// Radius, in tiles, used when looking in the cater as to where to place the guaranteed hotspot that appears in close proximity of the controller.
	var/epicenter_hotspot_search_radius = 12
	/// Additional invisible hotspots to create per station z-level, not counting the guaranteed epicenter hotspot.
	var/hotspots_per_station_z = 4
	/// How many turfs each hotspot deletes per processing tick. This lives on the controller so VV can be used to tune it pre-activation.
	var/hotspot_turfs_erased_per_tick = 2
	/// Active invisible hotspots currently propagating the erasure.
	var/list/active_hotspots = list()
	/// Active invisible janitors that continuously scrub stray residue from already-erased void tiles.
	var/list/active_residue_janitors = list()
	/// Cached frontier source turfs grouped by station z-level for hotspot spawning and relocation.
	var/list/frontier_sources_by_z = list()
	/// How many residue janitors should exist at once.
	var/residue_janitor_count = 2
	/// How many residue-bearing void turfs each janitor cleans per processing tick. This lives on the controller so VV can be used to tune it pre-activation.
	var/residue_janitor_turfs_erased_per_tick = 2

/// Initializes the controller inertly so admin-spawned instances do nothing until explicitly activated.
/obj/effect/mass_erasure_controller/Initialize(mapload)
	return ..()

/// Performs the initial wipe, caches valid frontier sources, and spawns the hotspot controllers.
/obj/effect/mass_erasure_controller/proc/activate_erasure()
	if(erasure_active)
		return FALSE

	erasure_active = TRUE
	for(var/turf/current_turf as anything in RANGE_TURFS(initial_wipe_radius, src))
		erase_turf(current_turf)

	cache_frontier_sources()
	spawn_initial_hotspots()
	spawn_initial_residue_janitors()
	if(!LAZYLEN(active_hotspots))
		qdel(src)
		return FALSE

	return TRUE

/obj/effect/mass_erasure_controller/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION("activate_erasure", "Activate Erasure")

/obj/effect/mass_erasure_controller/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(isnull(usr) || !href_list["activate_erasure"] || !check_rights(R_FUN, show_msg = TRUE))
		return

	log_admin("[key_name(usr)] has activated a mass erasure controller.")
	message_admins(span_notice("[key_name_admin(usr)] has activated a mass erasure controller."))
	activate_erasure()

/// Removes hidden underfloor support objects and converts a turf into the appropriate erasure void turf.
/obj/effect/mass_erasure_controller/proc/erase_turf(turf/target_turf, preferred_void_turf_type)
	if(!target_turf || !is_valid_erasure_target(target_turf))
		return FALSE

	create_erasure_turf_fade(target_turf)
	erase_hidden_underfloor_objects(target_turf)
	erase_void_turf_objects(target_turf)
	var/turf/converted_turf = convert_turf_to_erasure_void(target_turf, preferred_void_turf_type)
	if(!converted_turf)
		return FALSE
	scrub_nearby_void_turf_objects(converted_turf)
	return TRUE

/// Creates a short-lived visual copy of a turf so erased tiles appear to fade away after conversion.
/obj/effect/mass_erasure_controller/proc/create_erasure_turf_fade(turf/target_turf)
	if(!target_turf)
		return

	new /obj/effect/temp_visual/erasure_turf_fade(target_turf, target_turf)

/// Deletes only concealed underfloor objects, mirroring singularity cleanup without removing support objects the turf conversion may need.
/obj/effect/mass_erasure_controller/proc/erase_hidden_underfloor_objects(turf/target_turf)
	if(target_turf.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
		return

	for(var/obj/contained_object as anything in target_turf.contents)
		if(!istype(contained_object))
			continue
		if(!HAS_TRAIT(contained_object, TRAIT_UNDERFLOOR))
			continue
		qdel(contained_object, force = TRUE)

/// Deletes objects on a void turf unless they are explicitly indestructible, preserving the erasure controller objects themselves.
/obj/effect/mass_erasure_controller/proc/erase_void_turf_objects(turf/target_turf)
	for(var/obj/contained_object as anything in target_turf.contents)
		if(!istype(contained_object))
			continue
		if(contained_object == src || istype(contained_object, /obj/effect/mass_erasure_hotspot) || istype(contained_object, /obj/effect/mass_erasure_residue_janitor))
			continue
		if(contained_object.resistance_flags & INDESTRUCTIBLE)
			continue
		qdel(contained_object, force = TRUE)

/// Re-runs the normal void object cleanup on nearby void turfs so residue on already-erased tiles does not linger.
/obj/effect/mass_erasure_controller/proc/scrub_nearby_void_turf_objects(turf/center_turf)
	if(!center_turf)
		return

	for(var/turf/nearby_turf as anything in RANGE_TURFS(1, center_turf))
		if(!is_space_or_openspace(nearby_turf))
			continue
		erase_void_turf_objects(nearby_turf)

	maintain_residue_janitors()

/// Returns TRUE when an object is one of the narrow residue types the permanent janitor should erase from void tiles.
/obj/effect/mass_erasure_controller/proc/is_residue_cleanup_target(obj/contained_object, list/residue_cleanup_types)
	if(!istype(contained_object))
		return FALSE
	if(contained_object.resistance_flags & INDESTRUCTIBLE)
		return FALSE

	for(var/cleanup_type as anything in residue_cleanup_types)
		if(istype(contained_object, cleanup_type))
			return TRUE
	return FALSE

/// Returns TRUE when a void turf currently contains janitor-eligible residue.
/obj/effect/mass_erasure_controller/proc/has_residue_cleanup_targets(turf/target_turf, list/residue_cleanup_types)
	if(!target_turf || !is_space_or_openspace(target_turf))
		return FALSE

	for(var/obj/contained_object as anything in target_turf.contents)
		if(is_residue_cleanup_target(contained_object, residue_cleanup_types))
			return TRUE
	return FALSE

/// Deletes janitor-eligible residue structures and any other junk objects on a single void turf without cascading into nearby tiles.
/obj/effect/mass_erasure_controller/proc/erase_residue_cleanup_targets(turf/target_turf, list/residue_cleanup_types)
	if(!target_turf)
		return FALSE

	var/did_delete = FALSE
	for(var/obj/contained_object as anything in target_turf.contents)
		if(!is_residue_cleanup_target(contained_object, residue_cleanup_types))
			continue
		qdel(contained_object, force = TRUE)
		did_delete = TRUE
	if(did_delete)
		erase_void_turf_objects(target_turf)
		// We often end up deleting the solars but not the solar floors with the janitor, so explicitly sweep adjacent solar-panel floors too.
		cleanup_adjacent_solar_panel_turfs(target_turf)
	return did_delete

/// Erases adjacent solar-panel floor turfs and their junk objects so orphaned solar installations do not remain after janitor cleanup.
/obj/effect/mass_erasure_controller/proc/cleanup_adjacent_solar_panel_turfs(turf/center_turf)
	if(!center_turf)
		return

	var/preferred_void_turf_type = is_space_or_openspace(center_turf) ? center_turf.type : null
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(center_turf, direction)
		if(!istype(adjacent_turf, /turf/open/floor/iron/solarpanel))
			continue
		erase_hidden_underfloor_objects(adjacent_turf)
		erase_void_turf_objects(adjacent_turf)
		convert_turf_to_erasure_void(adjacent_turf, preferred_void_turf_type)

/// Builds the cached frontier source lists used to spawn and relocate erasure hotspots.
/obj/effect/mass_erasure_controller/proc/cache_frontier_sources()
	for(var/station_z as anything in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/station_z_key = "[station_z]"
		frontier_sources_by_z[station_z_key] = collect_frontier_sources_for_z(station_z)

/// Returns a list of space or openspace turfs on the given z-level that border erasable non-space tiles.
/obj/effect/mass_erasure_controller/proc/collect_frontier_sources_for_z(station_z)
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

/// Spawns one hotspot visibly at the epicenter crater, counting it toward that station z-level's configured controller total.
/obj/effect/mass_erasure_controller/proc/spawn_initial_hotspots()
	var/list/used_spawn_sources = list()
	var/turf/controller_turf = get_turf(src)
	var/controller_z = controller_turf?.z
	var/turf/epicenter_frontier_source = pick_crater_frontier_source(controller_turf, used_spawn_sources)
	if(!epicenter_frontier_source)
		epicenter_frontier_source = pick_frontier_source(controller_z, used_spawn_sources, TRUE)
	if(controller_turf)
		create_epicenter_hotspot(controller_turf, epicenter_frontier_source)
	if(epicenter_frontier_source)
		used_spawn_sources += epicenter_frontier_source

	for(var/station_z as anything in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/hotspots_to_spawn = hotspots_per_station_z
		if(station_z == controller_z && controller_turf)
			hotspots_to_spawn = max(hotspots_to_spawn - 1, 0)
		for(var/hotspot_index in 1 to hotspots_to_spawn)
			var/turf/spawn_turf = pick_frontier_source(station_z, used_spawn_sources, TRUE)
			if(!spawn_turf)
				break
			create_hotspot(spawn_turf)
			used_spawn_sources += spawn_turf

/// Spawns the configured number of permanent residue janitors.
/obj/effect/mass_erasure_controller/proc/spawn_initial_residue_janitors()
	maintain_residue_janitors()

/// Creates an invisible hotspot controller on the supplied turf and starts its processing loop.
/obj/effect/mass_erasure_controller/proc/create_hotspot(turf/spawn_turf)
	if(!spawn_turf)
		return null

	var/obj/effect/mass_erasure_hotspot/new_hotspot = new /obj/effect/mass_erasure_hotspot(spawn_turf)
	new_hotspot.owning_controller = src
	new_hotspot.turfs_erased_per_tick = hotspot_turfs_erased_per_tick
	active_hotspots += new_hotspot
	new_hotspot.move_to_frontier_source(spawn_turf)
	new_hotspot.begin_processing()
	return new_hotspot

/// Creates the guaranteed epicenter hotspot on a crater-local frontier tile when possible, falling back to the controller turf if needed.
/obj/effect/mass_erasure_controller/proc/create_epicenter_hotspot(turf/epicenter_turf, turf/frontier_seed_turf)
	if(!epicenter_turf)
		return null

	var/turf/hotspot_spawn_turf = frontier_seed_turf || epicenter_turf
	var/obj/effect/mass_erasure_hotspot/new_hotspot = new /obj/effect/mass_erasure_hotspot(hotspot_spawn_turf)
	new_hotspot.owning_controller = src
	new_hotspot.turfs_erased_per_tick = hotspot_turfs_erased_per_tick
	active_hotspots += new_hotspot
	if(is_space_or_openspace(hotspot_spawn_turf))
		new_hotspot.preferred_void_turf_type = hotspot_spawn_turf.type
	new_hotspot.local_frontier_turfs.Cut()
	if(frontier_seed_turf)
		new_hotspot.enqueue_adjacent_candidates(frontier_seed_turf)
	new_hotspot.begin_processing()
	return new_hotspot

/// Returns a valid frontier source inside the controller crater when one exists, excluding any already-used spawn sources.
/obj/effect/mass_erasure_controller/proc/pick_crater_frontier_source(turf/controller_turf, list/excluded_sources)
	if(!controller_turf)
		return null

	var/list/crater_frontier_sources = list()
	for(var/turf/current_turf as anything in RANGE_TURFS(epicenter_hotspot_search_radius, controller_turf))
		if(!is_valid_epicenter_frontier_source(current_turf, controller_turf))
			continue
		crater_frontier_sources += current_turf

	return pick_valid_frontier_source_from_list(crater_frontier_sources, excluded_sources)

/// Returns TRUE only for frontier sources that are local to, or directly connected to, the epicenter wipe rather than unrelated pre-existing void pockets.
/obj/effect/mass_erasure_controller/proc/is_valid_epicenter_frontier_source(turf/target_turf, turf/controller_turf)
	if(!is_valid_frontier_source(target_turf) || !controller_turf)
		return FALSE

	if(get_dist(target_turf, controller_turf) <= initial_wipe_radius)
		return TRUE

	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(target_turf, direction)
		if(!is_space_or_openspace(adjacent_turf))
			continue
		if(get_dist(adjacent_turf, controller_turf) <= initial_wipe_radius)
			return TRUE

	return FALSE

/// Creates an invisible janitor controller on the supplied void turf and starts its cleanup loop.
/obj/effect/mass_erasure_controller/proc/create_residue_janitor(turf/spawn_turf)
	if(!spawn_turf)
		return null

	var/obj/effect/mass_erasure_residue_janitor/new_janitor = new /obj/effect/mass_erasure_residue_janitor(spawn_turf)
	new_janitor.owning_controller = src
	new_janitor.turfs_erased_per_tick = residue_janitor_turfs_erased_per_tick
	active_residue_janitors += new_janitor
	new_janitor.move_to_frontier_source(spawn_turf)
	new_janitor.begin_processing()
	return new_janitor

/// Returns TRUE when a void turf is a valid spawn or relocation source for the residue janitor.
/obj/effect/mass_erasure_controller/proc/is_valid_residue_source(turf/target_turf, list/residue_cleanup_types)
	return !!target_turf && is_station_level(target_turf.z) && is_space_or_openspace(target_turf) && has_residue_cleanup_targets(target_turf, residue_cleanup_types)

/// Keeps the configured number of residue janitors alive by spawning them from the active erasure frontier.
/obj/effect/mass_erasure_controller/proc/maintain_residue_janitors()
	while(LAZYLEN(active_residue_janitors) < residue_janitor_count)
		var/turf/spawn_turf = pick_residue_source()
		if(!spawn_turf)
			break
		create_residue_janitor(spawn_turf)

/// Finds a valid janitor source by sampling the active erasure frontier, preferring the janitor's current z-level when available.
/obj/effect/mass_erasure_controller/proc/pick_residue_source()
	return pick_frontier_source()

/// Attempts to relocate a residue janitor to another active frontier turf, preferring the same z-level when possible.
/obj/effect/mass_erasure_controller/proc/relocate_residue_janitor(obj/effect/mass_erasure_residue_janitor/janitor)
	var/preferred_z = janitor?.z
	var/turf/new_residue_source = pick_frontier_source(preferred_z)
	if(!new_residue_source)
		return FALSE

	janitor.move_to_frontier_source(new_residue_source)
	return TRUE

/// Picks a cached frontier source, either strictly from one z-level or by falling back across station z-levels.
/obj/effect/mass_erasure_controller/proc/pick_frontier_source(preferred_z, list/excluded_sources, strict_z = FALSE)
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
/obj/effect/mass_erasure_controller/proc/pick_valid_frontier_source_from_list(list/frontier_sources, list/excluded_sources)
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
/obj/effect/mass_erasure_controller/proc/relocate_hotspot(obj/effect/mass_erasure_hotspot/hotspot)
	var/turf/new_frontier_source = pick_frontier_source(hotspot?.z, strict_z = TRUE)
	if(!new_frontier_source)
		return FALSE

	hotspot.move_to_frontier_source(new_frontier_source)
	return TRUE

/// Removes a hotspot from the active list and deletes the controller once no hotspots remain.
/obj/effect/mass_erasure_controller/proc/unregister_hotspot(obj/effect/mass_erasure_hotspot/hotspot)
	active_hotspots -= hotspot
	if(erasure_active && !LAZYLEN(active_hotspots))
		qdel(src)

/// Removes a residue janitor from the active list when it is deleted.
/obj/effect/mass_erasure_controller/proc/unregister_residue_janitor(obj/effect/mass_erasure_residue_janitor/janitor)
	active_residue_janitors -= janitor

/// Returns TRUE when a turf is non-space, non-openspace, not shuttle-protected, and currently borders the erasure void.
/obj/effect/mass_erasure_controller/proc/is_valid_erasure_candidate(turf/target_turf)
	return is_valid_erasure_target(target_turf) && !is_space_or_openspace(target_turf) && is_adjacent_to_erasure_void(target_turf)

/// Returns TRUE when a turf is already space or openspace and can act as a hotspot spawn frontier.
/obj/effect/mass_erasure_controller/proc/is_valid_frontier_source(turf/target_turf)
	return is_valid_erasure_target(target_turf) && is_space_or_openspace(target_turf) && is_adjacent_to_erasable_turf(target_turf)

/// Returns TRUE when a turf is on a station z-level and is not protected from erasure.
/obj/effect/mass_erasure_controller/proc/is_valid_erasure_target(turf/target_turf)
	return !!target_turf && is_station_level(target_turf.z) && !is_erasure_protected_turf(target_turf)

/// Returns TRUE when any cardinally adjacent turf is already part of the erasure void.
/obj/effect/mass_erasure_controller/proc/is_adjacent_to_erasure_void(turf/target_turf)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(target_turf, direction)
		if(is_space_or_openspace(adjacent_turf))
			return TRUE
	return FALSE

/// Returns TRUE when any cardinally adjacent turf is a valid future erasure target.
/obj/effect/mass_erasure_controller/proc/is_adjacent_to_erasable_turf(turf/target_turf)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(target_turf, direction)
		if(is_valid_erasure_candidate(adjacent_turf))
			return TRUE
	return FALSE

/// Excludes shuttle tiles from the erasure spread entirely.
/obj/effect/mass_erasure_controller/proc/is_erasure_protected_turf(turf/target_turf)
	return istype(get_area(target_turf), /area/shuttle)

/// Converts a turf to hard space on the lowest station layer and openspace on higher station layers.
/obj/effect/mass_erasure_controller/proc/convert_turf_to_erasure_void(turf/target_turf, preferred_void_turf_type)
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
/obj/effect/mass_erasure_controller/proc/should_convert_to_openspace(turf/target_turf)
	var/turf/below_turf = GET_TURF_BELOW(target_turf)
	return is_station_level(below_turf?.z)

/// Stops the controller from processing further and clears its cached state.
/obj/effect/mass_erasure_controller/Destroy(force)
	erasure_active = FALSE
	QDEL_LIST(active_hotspots)
	QDEL_LIST(active_residue_janitors)
	active_hotspots.Cut()
	active_residue_janitors.Cut()
	frontier_sources_by_z.Cut()
	return ..()

/*
	Local hotspots which are there to compute propogation (largely for optimization).
	These spawn on a space that borders (open) space and a solid turf, at which point they start deleting tiles that are not (open) space. They then propagate to their neighbors and continue until they stall, at which point they relocate to another frontier.
*/
/obj/effect/mass_erasure_hotspot
	name = "mass erasure hotspot"
	desc = "What have we done?!"
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "anom"
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM

	/// Controller coordinating this hotspot's lifecycle and relocation.
	var/obj/effect/mass_erasure_controller/owning_controller
	/// Whether this hotspot should keep processing.
	var/hotspot_active = TRUE
	/// How many turfs this hotspot deletes per processing tick. This is assigned by the controller on spawn so VV can tune it centrally there.
	var/turfs_erased_per_tick
	/// Maximum number of local frontier entries this hotspot will evaluate per processing tick.
	var/max_attempts_per_tick = 60
	/// Local cardinal frontier candidates adjacent to this hotspot's current erasure pocket.
	var/list/local_frontier_turfs = list()
	/// The exact void turf type this hotspot should propagate while it remains in its current frontier pocket.
	var/preferred_void_turf_type

/// Finishes hotspot initialization without seeding, because the owning controller is attached immediately after creation.
/obj/effect/mass_erasure_hotspot/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(validate_host_controller)), 0)
	return .

/// Removes manually spawned hotspots that never received a valid host controller.
/obj/effect/mass_erasure_hotspot/proc/validate_host_controller()
	if(QDELETED(src))
		return
	if(istype(owning_controller))
		return
	qdel(src)

/// Starts this hotspot's repeating processing loop.
/obj/effect/mass_erasure_hotspot/proc/begin_processing()
	if(!hotspot_active)
		return
	addtimer(CALLBACK(src, PROC_REF(process_erasure_tick)), 1 SECONDS)

/// Erases nearby frontier turfs, or relocates this hotspot if its local pocket stalls out.
/obj/effect/mass_erasure_hotspot/proc/process_erasure_tick()
	if(!hotspot_active || QDELETED(owning_controller) || !owning_controller.erasure_active)
		qdel(src)
		return

	prune_local_frontier()
	if(!has_viable_frontier())
		if(!owning_controller.relocate_hotspot(src))
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

		if(!owning_controller.is_valid_erasure_candidate(target_turf))
			continue
		if(!owning_controller.erase_turf(target_turf, preferred_void_turf_type))
			continue

		turfs_erased++
		enqueue_adjacent_candidates(target_turf)

	if(!LAZYLEN(local_frontier_turfs) || !turfs_erased)
		if(!owning_controller.relocate_hotspot(src))
			qdel(src)
			return

	addtimer(CALLBACK(src, PROC_REF(process_erasure_tick)), 1 SECONDS)

/// Moves the hotspot to a fresh frontier source and rebuilds its local frontier around that new location.
/obj/effect/mass_erasure_hotspot/proc/move_to_frontier_source(turf/new_frontier_source)
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
/obj/effect/mass_erasure_hotspot/proc/prune_local_frontier()
	var/turf/current_turf = get_turf(src)
	if(!LAZYLEN(local_frontier_turfs))
		return

	for(var/frontier_index = local_frontier_turfs.len, frontier_index >= 1, frontier_index--)
		var/turf/candidate_turf = local_frontier_turfs[frontier_index]
		if(candidate_turf == current_turf || !owning_controller?.is_valid_erasure_candidate(candidate_turf))
			local_frontier_turfs.Cut(frontier_index, frontier_index + 1)

/// Returns TRUE when this hotspot still has either queued frontier work or a valid frontier source under itself.
/obj/effect/mass_erasure_hotspot/proc/has_viable_frontier()
	if(LAZYLEN(local_frontier_turfs))
		return TRUE

	var/turf/current_turf = get_turf(src)
	return owning_controller?.is_valid_frontier_source(current_turf)

/// Seeds the hotspot's local frontier using the current turf's cardinal neighbors.
/obj/effect/mass_erasure_hotspot/proc/seed_local_frontier()
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return
	enqueue_adjacent_candidates(current_turf)

/// Adds newly exposed neighboring turfs to this hotspot's local frontier.
/obj/effect/mass_erasure_hotspot/proc/enqueue_adjacent_candidates(turf/origin_turf)
	var/turf/current_turf = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(origin_turf, direction)
		if(adjacent_turf == current_turf)
			continue
		if(!owning_controller?.is_valid_erasure_candidate(adjacent_turf))
			continue
		local_frontier_turfs |= adjacent_turf

/// Unregisters this hotspot from the controller and clears its local frontier cache.
/obj/effect/mass_erasure_hotspot/Destroy(force)
	hotspot_active = FALSE
	if(!QDELETED(owning_controller))
		owning_controller.unregister_hotspot(src)
	local_frontier_turfs.Cut()
	return ..()

/*
	Permanent janitors that hop between active erasure frontiers and sweep nearby void tiles for narrow residue such as grilles and lattice,
	because these often get skipped by the hotspots and end up orphaned in space.
*/
/obj/effect/mass_erasure_residue_janitor
	name = "mass erasure residue janitor"
	desc = "What have we done?!"
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "anom"
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM

	/// Controller coordinating this janitor's lifecycle and relocation.
	var/obj/effect/mass_erasure_controller/owning_controller
	/// Whether this janitor should keep processing.
	var/janitor_active = TRUE
	/// How many residue-bearing void turfs this janitor may clean per processing tick. This is assigned by the controller on spawn so VV can tune it centrally there.
	var/turfs_erased_per_tick
	/// Maximum number of local residue frontier entries this janitor will evaluate per processing tick.
	var/max_attempts_per_tick = 60
	/// Narrow allowlist of residue objects this janitor is allowed to clean from void tiles.
	var/static/list/residue_cleanup_types = list(
		/obj/structure/grille,
		/obj/structure/lattice,
		/obj/structure/transit_tube,
	)
	/// How many consecutive frontier jumps this janitor may make without finding any residue before it self-deletes.
	var/max_empty_jumps = 100
	/// How many consecutive frontier jumps this janitor has made without finding any residue to propagate through.
	var/consecutive_empty_jumps = 0
	/// Local void turfs containing janitor-eligible residue in the current cleanup pocket.
	var/list/local_residue_turfs = list()

/// Finishes janitor initialization without seeding, because the owning controller is attached immediately after creation.
/obj/effect/mass_erasure_residue_janitor/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(validate_host_controller)), 0)
	return .

/// Removes manually spawned janitors that never received a valid host controller.
/obj/effect/mass_erasure_residue_janitor/proc/validate_host_controller()
	if(QDELETED(src))
		return
	if(istype(owning_controller))
		return
	qdel(src)

/// Starts this janitor's repeating processing loop.
/obj/effect/mass_erasure_residue_janitor/proc/begin_processing()
	if(!janitor_active)
		return
	addtimer(CALLBACK(src, PROC_REF(process_cleanup_tick)), 1 SECONDS)

/// Cleans local residue-bearing void turfs, or relocates this janitor when its current pocket runs dry.
/obj/effect/mass_erasure_residue_janitor/proc/process_cleanup_tick()
	if(!janitor_active || QDELETED(owning_controller) || !owning_controller.erasure_active)
		qdel(src)
		return

	if(!LAZYLEN(owning_controller.active_hotspots))
		qdel(src)
		return

	prune_local_residue_frontier()
	enqueue_current_residue_turf()
	if(!has_viable_frontier())
		seed_local_residue_frontier()
		enqueue_current_residue_turf()
		if(!has_viable_frontier())
			if(!attempt_frontier_jump())
				return
		prune_local_residue_frontier()
		enqueue_current_residue_turf()

	var/current_attempt = 0
	var/cleaned_turfs = 0
	var/max_attempts = min(max(LAZYLEN(local_residue_turfs) * 2, 1), max_attempts_per_tick)

	while(LAZYLEN(local_residue_turfs) && current_attempt < max_attempts && cleaned_turfs < turfs_erased_per_tick)
		current_attempt++

		var/random_index = rand(1, local_residue_turfs.len)
		var/turf/target_turf = local_residue_turfs[random_index]
		local_residue_turfs.Cut(random_index, random_index + 1)

		if(!owning_controller.is_valid_residue_source(target_turf, residue_cleanup_types))
			continue
		if(!owning_controller.erase_residue_cleanup_targets(target_turf, residue_cleanup_types))
			continue

		cleaned_turfs++
		consecutive_empty_jumps = 0
		enqueue_adjacent_residue_candidates(target_turf)

	if(!LAZYLEN(local_residue_turfs) || !cleaned_turfs)
		seed_local_residue_frontier()
		enqueue_current_residue_turf()
		if(!has_viable_frontier())
			if(!attempt_frontier_jump())
				return

	addtimer(CALLBACK(src, PROC_REF(process_cleanup_tick)), 1 SECONDS)

/// Moves the janitor to a fresh active frontier turf and seeds a local cleanup pocket from the first visible residue match.
/obj/effect/mass_erasure_residue_janitor/proc/move_to_frontier_source(turf/new_frontier_source)
	if(!new_frontier_source)
		return
	forceMove(new_frontier_source)
	local_residue_turfs.Cut()
	seed_local_residue_frontier()

/// Attempts to jump this janitor to a fresh frontier; if repeated jumps find no residue, it self-deletes after the configured cap.
/obj/effect/mass_erasure_residue_janitor/proc/attempt_frontier_jump()
	if(!owning_controller.relocate_residue_janitor(src))
		qdel(src)
		return FALSE

	if(has_viable_frontier())
		consecutive_empty_jumps = 0
		return TRUE

	consecutive_empty_jumps++
	if(consecutive_empty_jumps >= max_empty_jumps)
		qdel(src)
		return FALSE

	return TRUE

/// Removes stale or self-referential residue entries so the janitor does not orbit invalid cleanup work.
/obj/effect/mass_erasure_residue_janitor/proc/prune_local_residue_frontier()
	var/turf/current_turf = get_turf(src)
	if(!LAZYLEN(local_residue_turfs))
		return

	for(var/frontier_index = local_residue_turfs.len, frontier_index >= 1, frontier_index--)
		var/turf/candidate_turf = local_residue_turfs[frontier_index]
		if(candidate_turf == current_turf || !owning_controller?.is_valid_residue_source(candidate_turf, residue_cleanup_types))
			local_residue_turfs.Cut(frontier_index, frontier_index + 1)

/// Returns TRUE when this janitor still has a residue frontier queued in its current cleanup pocket.
/obj/effect/mass_erasure_residue_janitor/proc/has_viable_frontier()
	if(LAZYLEN(local_residue_turfs))
		return TRUE

	var/turf/current_turf = get_turf(src)
	return owning_controller?.is_valid_residue_source(current_turf, residue_cleanup_types)

/// Seeds the janitor's local frontier from the first visible residue-bearing void turf in its new frontier pocket.
/obj/effect/mass_erasure_residue_janitor/proc/seed_local_residue_frontier()
	var/turf/starting_turf = find_visible_residue_source()
	if(!starting_turf)
		return
	local_residue_turfs |= starting_turf
	consecutive_empty_jumps = 0
	enqueue_adjacent_residue_candidates(starting_turf)

/// Re-adds the turf beneath the janitor when it still contains valid residue, so the janitor can clean what it is standing on.
/obj/effect/mass_erasure_residue_janitor/proc/enqueue_current_residue_turf()
	var/turf/current_turf = get_turf(src)
	if(!owning_controller?.is_valid_residue_source(current_turf, residue_cleanup_types))
		return
	local_residue_turfs |= current_turf

/// Returns the first residue-bearing void turf visible from this janitor's current frontier position.
/obj/effect/mass_erasure_residue_janitor/proc/find_visible_residue_source()
	for(var/turf/visible_turf as anything in view(7, src))
		if(owning_controller?.is_valid_residue_source(visible_turf, residue_cleanup_types))
			return visible_turf
	return null

/// Adds cardinally adjacent residue-bearing void turfs to this janitor's local cleanup frontier.
/obj/effect/mass_erasure_residue_janitor/proc/enqueue_adjacent_residue_candidates(turf/origin_turf)
	var/turf/current_turf = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(origin_turf, direction)
		if(adjacent_turf == current_turf)
			continue
		if(!owning_controller?.is_valid_residue_source(adjacent_turf, residue_cleanup_types))
			continue
		local_residue_turfs |= adjacent_turf

/// Unregisters this janitor from the controller and clears its local residue cache.
/obj/effect/mass_erasure_residue_janitor/Destroy(force)
	janitor_active = FALSE
	if(!QDELETED(owning_controller))
		owning_controller.unregister_residue_janitor(src)
	local_residue_turfs.Cut()
	return ..()

/// Visual effects for turfs being erased.
/obj/effect/temp_visual/erasure_turf_fade
	name = "erasure remnant"
	icon = null
	icon_state = null
	randomdir = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 4
	layer = ABOVE_OPEN_TURF_LAYER
	plane = GAME_PLANE

/// Copies the erased turf's rendered appearance, then fades it out with a slight upward pull.
/obj/effect/temp_visual/erasure_turf_fade/Initialize(mapload, turf/faded_turf)
	if(faded_turf)
		appearance = faded_turf.appearance
		layer = faded_turf.layer + 0.01
		plane = faded_turf.plane
		dir = faded_turf.dir
		alpha = 220

	. = ..()
	animate(src, alpha = 0, pixel_y = 4, time = duration, easing = QUAD_EASING | EASE_OUT)
