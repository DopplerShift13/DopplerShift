/// Global tracker for Riftwalker rifts. Largely stylized after how Heretic influences work.
GLOBAL_DATUM_INIT(riftwalker_network, /datum/riftwalker_network_tracker, new)

#define RIFTWALKER_MIN_PAIRS 10
#define RIFTWALKER_MAX_PAIRS 12

/datum/riftwalker_network_tracker
	/// List of all active rifts
	var/list/obj/effect/riftwalker_rift/rifts = list()
	/// Debug: counts attempts to find valid rift turfs during generation
	var/debug_attempts = 0

/datum/riftwalker_network_tracker/Destroy(force)
	if(GLOB.riftwalker_network == src)
		stack_trace("[type] was deleted. Riftwalkers may no longer access rifts. This is bad; call the coders!")
		message_admins("The [type] was deleted. Riftwalkers may no longer access rifts. This is bad; call the coders!")
	QDEL_LIST(rifts)
	return ..()

/// Generates the rifts.
/datum/riftwalker_network_tracker/proc/generate_rifts()
	if(length(rifts))
		return
	var/start_time = world.timeofday
	debug_attempts = 0

	var/pair_count = rand(RIFTWALKER_MIN_PAIRS, RIFTWALKER_MAX_PAIRS)
	var/turf/beacon_turf = pick_valid_beacon_turf()
	var/next_pair_id = 1

	// Guarantee at least one pair originates from an active teleport beacon, if possible. Mostly for fluff to suggest the connection between teleportation and the rifts.
	if(beacon_turf)
		var/obj/effect/riftwalker_rift/beacon_rift = new(beacon_turf)
		beacon_rift.pair_id = next_pair_id
		var/turf/partner_turf
		if(prob(25)) // 25% chance it is adjacent to a teleporter.
			var/turf/teleporter_adjacent = pick_adjacent_teleporter_turf()
			if(teleporter_adjacent)
				partner_turf = teleporter_adjacent
		else // normal turf location logic
			partner_turf = find_random_rift_turf()
		// spawn logic.
		if(partner_turf)
			var/obj/effect/riftwalker_rift/partner_rift = new(partner_turf)
			partner_rift.pair_id = next_pair_id
			next_pair_id++
		else
			QDEL_NULL(beacon_rift)


	var/max_iterations = 0 // Just to prevent some form of infinite loop
	// Tries creating rift pairs repeatedly up to the pair_count.
	while(next_pair_id <= pair_count && max_iterations < 200)
		if(!spawn_pair())
			max_iterations++
			continue
		next_pair_id++

	log_game("Riftwalker generate_rifts: [world.timeofday - start_time] ds, attempts=[debug_attempts], rifts=[length(rifts)], pairs=[pair_count], iterations=[max_iterations]")
	return

/// Generates a new pair of rifts.
/datum/riftwalker_network_tracker/proc/spawn_pair()
	var/turf/first_turf = find_random_rift_turf()
	if(!first_turf)
		return FALSE
	var/turf/second_turf = find_random_rift_turf()
	if(!second_turf)
		return FALSE

	var/next_pair_id = 1
	for(var/obj/effect/riftwalker_rift/existing_rift as anything in rifts)
		next_pair_id = max(next_pair_id, existing_rift.pair_id + 1)

	var/obj/effect/riftwalker_rift/first_rift = new(first_turf)
	first_rift.pair_id = next_pair_id
	var/obj/effect/riftwalker_rift/second_rift = new(second_turf)
	second_rift.pair_id = next_pair_id
	return TRUE

/// Main logic that gets the actual turf
/datum/riftwalker_network_tracker/proc/find_random_rift_turf()
	var/tries = 0
	while(tries < 50)
		debug_attempts++
		var/turf/chosen_location = get_safe_random_station_turf_equal_weight()
		if(is_valid_rift_location(chosen_location))
			return chosen_location
		tries++
	return null

/// Checks if a space is a valid space for a rift. Basically blocks space and prevents them from being ontop of eachother.
/datum/riftwalker_network_tracker/proc/is_valid_rift_location(turf/target_turf)
	if(!isturf(target_turf) || !is_station_level(target_turf.z) || isopenspaceturf(target_turf) || isgroundlessturf(target_turf))
		return FALSE
	for(var/obj/thing in target_turf) // don't spawn on dense objects
		if(thing.density)
			return FALSE

	for(var/obj/effect/riftwalker_rift/existing_rift in range(1, target_turf))
		return FALSE

	return TRUE

/// Specifically gets a turf next to a teleporter.
/datum/riftwalker_network_tracker/proc/pick_adjacent_teleporter_turf()
	var/list/turf/candidates = list()
	for(var/obj/machinery/teleport/hub/tele as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/teleport/hub)) // I'm trying this instead of world and seeing how it goes.
		if(!is_station_level(tele.z))
			continue
		var/turf/tele_turf = get_turf(tele)
		if(!tele_turf)
			continue
		for(var/turf/adjacent_turf as anything in range(1, tele_turf))
			if(adjacent_turf == tele_turf) // not ON the teleporter
				continue
			if(is_valid_rift_location(adjacent_turf))
				candidates += adjacent_turf
	if(!length(candidates))
		return null
	return pick(candidates)

/// Specifically gets a turf next to a beacon
/datum/riftwalker_network_tracker/proc/pick_valid_beacon_turf()
	for(var/obj/item/beacon/beacon as anything in GLOB.teleportbeacons)
		var/turf/beacon_turf = get_turf(beacon)
		if(is_station_level(beacon_turf?.z) && is_valid_rift_location(beacon_turf))
			return beacon_turf
	return null

/obj/effect/riftwalker_rift
	name = "bluespace rift"
	desc = "Bluespace energies connecting two places together; many Bluespace researchers would kill to understand why these rifts form. Some argue that these are left behind by heavy sums of teleportation; but these claims are unfounded."
	icon = 'icons/effects/effects.dmi'
	icon_state = "bluestream"
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	/// Which pair this rift belongs to
	var/pair_id = 0

/obj/effect/riftwalker_rift/Initialize(mapload)
	. = ..()
	GLOB.riftwalker_network.rifts += src
	RegisterSignal(src, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	apply_wibbly_filters(src)
	if(!loc)
		return
	var/image/rift_image = image(icon = icon, loc = src, icon_state = icon_state, layer = OBJ_LAYER)
	rift_image.layer = OBJ_LAYER
	rift_image.override = TRUE
	apply_wibbly_filters(rift_image)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/riftwalker, "riftwalker_rift", rift_image)

/obj/effect/riftwalker_rift/Destroy()
	GLOB.riftwalker_network.rifts -= src
	UnregisterSignal(src, COMSIG_ATOM_DISPEL)
	return ..()

/obj/effect/riftwalker_rift/examine(mob/user)
	. = ..()
	. += span_notice("Only riftwalkers can traverse these rifts.")

/// Checks if a mob can see the rifts
/obj/effect/riftwalker_rift/proc/verify_user_can_see(mob/user)
	return HAS_TRAIT(user, TRAIT_ABERRANT_RIFTWALKER)

// Teleport logic.
/obj/effect/riftwalker_rift/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!verify_user_can_see(user))
		return TRUE
	if(HAS_TRAIT(user, TRAIT_RESONANCE_SILENCED))
		user.balloon_alert(user, "silenced!")
		return TRUE

	var/obj/effect/riftwalker_rift/linked_rift = get_paired_rift()

	var/slip_in_message = pick("slides sideways in an odd way, and disappears", "jumps into an unseen dimension",\
		"sticks one leg straight out, wiggles [user.p_their()] foot, and is suddenly gone", "stops, then blinks out of reality", \
		"is pulled into an invisible vortex, vanishing from sight")
	var/slip_out_message = pick("silently fades in", "leaps out of thin air","appears", "walks out of an invisible doorway",\
		"slides out of a fold in spacetime")

	to_chat(user, span_notice("You try to align with the bluespace stream..."))
	if(!do_after(user, 2 SECONDS, target = src))
		return TRUE

	var/turf/source_turf = get_turf(src)
	var/turf/destination_turf = get_turf(linked_rift) || source_turf // you tp to the same space if there's no linked rift.

	new /obj/effect/temp_visual/bluespace_fissure(source_turf)
	new /obj/effect/temp_visual/bluespace_fissure(destination_turf)

	user.visible_message(span_warning("[user] [slip_in_message]."), ignored_mobs = user)

	var/atom/movable/pulled = null
	if(ismovable(user.pulling))
		pulled = user.pulling
		if(ismob(pulled))
			to_chat(pulled, span_notice("You suddenly find yourself in a different location!"))
		do_teleport(pulled, destination_turf, no_effects = TRUE)

	if(do_teleport(user, destination_turf, no_effects = TRUE))
		playsound(destination_turf, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		user.visible_message(span_warning("[user] [slip_out_message]."), span_notice("...and find your way to the other side."))
		if(pulled)
			user.start_pulling(pulled)
	else
		user.visible_message(span_warning("[user] [slip_out_message], ending up exactly where they left."), span_notice("...and find yourself where you started?"))

	return TRUE

/obj/effect/riftwalker_rift/attack_ghost(mob/user)
	var/obj/effect/riftwalker_rift/linked_rift = get_paired_rift()
	if(!linked_rift)
		return ..()
	user.abstract_move(get_turf(linked_rift))

/// On dispel, closes that pair of rifts, and create a new pair somewhere else.
/obj/effect/riftwalker_rift/proc/on_dispel(datum/source, atom/dispeller)
	SIGNAL_HANDLER

	var/obj/effect/riftwalker_rift/linked_rift = get_paired_rift()
	if(!QDELETED(linked_rift))
		QDEL_NULL(linked_rift)
	if(!QDELETED(src))
		QDEL_NULL(src)

	GLOB.riftwalker_network.spawn_pair() // new pair
	return DISPEL_RESULT_DISPELLED

/// Gets the sibling rift of a rift.
/obj/effect/riftwalker_rift/proc/get_paired_rift()
	if(!pair_id)
		return null
	for(var/obj/effect/riftwalker_rift/other_rift as anything in GLOB.riftwalker_network.rifts)
		if(other_rift != src && other_rift.pair_id == pair_id)
			return other_rift
	return null

// Determines if a mob can see it.
/datum/atom_hud/alternate_appearance/basic/riftwalker/mobShouldSee(mob/viewer)
	if(!isliving(viewer))
		return FALSE
	return HAS_TRAIT(viewer, TRAIT_ABERRANT_RIFTWALKER)

#undef RIFTWALKER_MIN_PAIRS
#undef RIFTWALKER_MAX_PAIRS
