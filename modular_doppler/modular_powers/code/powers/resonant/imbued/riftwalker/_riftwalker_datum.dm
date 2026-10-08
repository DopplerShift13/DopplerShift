/// Global tracker for Riftwalker rifts. Largely stylized after how Heretic influences work.
GLOBAL_DATUM_INIT(riftwalker_network, /datum/riftwalker_network_tracker, new)

// Minimum amount of pairs (two linked rifts) that can spawn
#define RIFTWALKER_MIN_PAIRS 12
// Maximum amount of pairs (two linked rifts) that can spawn
#define RIFTWALKER_MAX_PAIRS 14
// How often the game will attempt to generate rifts before giving up.
#define RIFTWALKER_MAX_GENERATION_ATTEMPTS 200
// How often the game will attempt to generate a rift at a specific location before giving up.
#define RIFTWALKER_LOCATION_ATTEMPTS 25

/// Owns all active rifts and handles their shared generation behavior.
/datum/riftwalker_network_tracker
	/// List of all active rifts.
	var/list/obj/effect/riftwalker_rift/rifts = list()
	/// Debug: counts attempts to find valid rift turfs during generation.
	var/debug_attempts = 0

/datum/riftwalker_network_tracker/Destroy(force)
	if(GLOB.riftwalker_network == src)
		stack_trace("[type] was deleted. Riftwalkers may no longer access rifts. This is bad; call the coders!")
		message_admins("The [type] was deleted. Riftwalkers may no longer access rifts. This is bad; call the coders!")
	QDEL_LIST(rifts)
	return ..()

/// Generates the initial set of rift pairs.
/datum/riftwalker_network_tracker/proc/generate_rifts()
	if(length(rifts))
		return

	var/start_time = world.timeofday
	var/pair_count = rand(RIFTWALKER_MIN_PAIRS, RIFTWALKER_MAX_PAIRS)
	var/generated_pairs = 0
	var/generation_attempts = 0
	debug_attempts = 0

	while(generated_pairs < pair_count && generation_attempts < RIFTWALKER_MAX_GENERATION_ATTEMPTS)
		generation_attempts++
		if(spawn_pair())
			generated_pairs++

	log_game("Riftwalker generate_rifts: [world.timeofday - start_time] ds, attempts=[debug_attempts], rifts=[length(rifts)], requested_pairs=[pair_count], generated_pairs=[generated_pairs], generation_attempts=[generation_attempts]")

/// Resolves a rift type's destinations and creates the complete pair, rolling a type when none is supplied.
/datum/riftwalker_network_tracker/proc/spawn_pair(forced_rift_type_path)
	var/selected_rift_type_path = forced_rift_type_path || pick_weight(GLOB.riftwalker_rift_type_weights)
	// we make a temporary instance of the chosen type so we can call its procs
	var/datum/riftwalker_rift_type/rift_type = new selected_rift_type_path

	var/turf/first_turf = rift_type.find_first_turf(src)
	if(!first_turf)
		qdel(rift_type)
		return FALSE
	var/turf/second_turf = rift_type.find_second_turf(src)
	// Don't want them spawning too close together.
	if(!second_turf || (second_turf.z == first_turf.z && get_dist(first_turf, second_turf) <= 1))
		qdel(rift_type)
		return FALSE

	// If we succesfully found our turfs, then we spawn our actual rifts.
	var/rift_path = rift_type.rift_path
	var/obj/effect/riftwalker_rift/first_rift = new rift_path(first_turf)
	var/obj/effect/riftwalker_rift/second_rift = new rift_path(second_turf)

	// Store the generation type so a neutralized pair can be displaced without changing its rules.
	first_rift.rift_type_path = selected_rift_type_path
	second_rift.rift_type_path = selected_rift_type_path

	// Link up bro
	first_rift.linked_rift = second_rift
	second_rift.linked_rift = first_rift

	// gets rid of the temporary instance.
	qdel(rift_type)

	return TRUE

/// Finds a random valid station turf for an ordinary rift.
/datum/riftwalker_network_tracker/proc/find_random_rift_turf()
	for(var/attempt in 1 to RIFTWALKER_LOCATION_ATTEMPTS)
		debug_attempts++
		var/turf/chosen_location = get_safe_random_station_turf_equal_weight()
		if(is_valid_station_rift_location(chosen_location))
			return chosen_location
	return null

/// Checks whether a station turf can safely hold a rift.
/datum/riftwalker_network_tracker/proc/is_valid_station_rift_location(turf/target_turf)
	return is_station_level(target_turf?.z) && is_clear_rift_location(target_turf)

/// Checks the shared physical placement restrictions for every rift.
/datum/riftwalker_network_tracker/proc/is_clear_rift_location(turf/target_turf)
	if(!isturf(target_turf) || isopenspaceturf(target_turf) || isgroundlessturf(target_turf) || target_turf.is_blocked_turf())
		return FALSE
	for(var/obj/effect/riftwalker_rift/existing_rift in range(1, target_turf))
		return FALSE
	return TRUE

/// Refreshes the rift alternate appearances shown to a mob after its sight traits change.
/datum/riftwalker_network_tracker/proc/update_rift_visibility(mob/viewer)
	for(var/datum/atom_hud/alternate_appearance/rift_hud as anything in GLOB.active_alternate_appearances)
		if(istype(rift_hud, /datum/atom_hud/alternate_appearance/basic/riftwalker))
			rift_hud.check_hud(viewer)

/// The physical rift object.
/obj/effect/riftwalker_rift
	name = "bluespace rift"
	desc = "Bluespace energies connecting two places together; many Bluespace researchers would kill to understand why these rifts form. Some argue that these are left behind by acts of teleportation;\
	but these theories lack any credible research to support these claims."
	icon = 'modular_doppler/modular_powers/icons/powers/effects.dmi'
	icon_state = "riftwalker_blue"
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	/// The rift at the other end of this connection.
	var/obj/effect/riftwalker_rift/linked_rift
	/// Embedded bluespace anomaly core that lets a scanned rift be disabled remotely.
	var/obj/item/assembly/signaler/anomaly/bluespace/riftwalker/anomaly_core
	/// Rift generation type used to preserve this pair's rules when it is displaced.
	var/rift_type_path = /datum/riftwalker_rift_type
	/// Chance for this rift pair to yield a bluespace anomaly core when displaced.
	var/bluespace_core_chance = RIFTWALKER_STANDARD_RIFT_BLUESPACE_CORE_CHANCE
	/// Shared color for the rift's filters.
	var/rift_color = "#6699ff"

/obj/effect/riftwalker_rift/Initialize(mapload)
	. = ..()
	GLOB.riftwalker_network.rifts += src
	anomaly_core = new(src)
	anomaly_core.code = rand(1, 100)
	anomaly_core.set_frequency(sanitize_frequency(rand(MIN_FREE_FREQ, MAX_FREE_FREQ), free = TRUE))
	apply_rift_filters(src)
	src.alpha = 190
	if(!loc)
		return
	var/image/rift_image = image(icon = icon, loc = src, icon_state = icon_state, layer = OBJ_LAYER)
	rift_image.layer = OBJ_LAYER
	rift_image.override = TRUE
	apply_rift_filters(rift_image)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/riftwalker, "riftwalker_rift", rift_image)

/// Applies the rift's outline, blur, and animated rays
/obj/effect/riftwalker_rift/proc/apply_rift_filters(datum/filter_target)
	filter_target.add_filters(list(
		list("name" = "rift_outline", "priority" = 1, "params" = outline_filter(size = 0.15, color = rift_color)),
		list("name" = "rift_blur", "priority" = 2, "params" = gauss_blur_filter(size = 0.5)),
		list("name" = "rift_rays", "priority" = 3, "params" = rays_filter(size = 20, color = rift_color, offset = 0, density = 30, threshold = 0.5, factor = 0, x = 0, y = -2, flags = FILTER_OVERLAY | FILTER_UNDERLAY)),
	))
	var/animated_rays = filter_target.get_filter("rift_rays")
	animate(animated_rays, offset = 10, time = 6 SECONDS, loop = -1)
	animate(offset = 0, time = 0)

/obj/effect/riftwalker_rift/Destroy()
	GLOB.riftwalker_network.rifts -= src
	if(!QDELETED(linked_rift) && linked_rift.linked_rift == src)
		linked_rift.linked_rift = null
	linked_rift = null
	QDEL_NULL(anomaly_core)
	return ..()

/obj/effect/riftwalker_rift/examine(mob/user)
	. = ..()
	. += span_notice("Only riftwalkers can traverse these rifts.")
	. += span_notice("Can be displaced by using a gas analyzer and signaling the appropriate code, or interacting with it using an anomaly neutralizer.")

/// Checks if a mob can see rifts, either through Riftwalker abilities or the goggles.
/obj/effect/riftwalker_rift/proc/can_user_see_rifts(mob/user)
	return HAS_TRAIT(user, TRAIT_IMBUED_RIFTWALKER) || HAS_TRAIT(user, TRAIT_IMBUED_RIFTWALKER_SIGHT_ONLY)

/// Checks if a mob can use a rift to travel.
/obj/effect/riftwalker_rift/proc/can_user_use_rifts(mob/user)
	return HAS_TRAIT(user, TRAIT_IMBUED_RIFTWALKER)

// Teleport logic.
/obj/effect/riftwalker_rift/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!can_user_use_rifts(user))
		return TRUE

	var/slip_in_message = pick("slides sideways in an odd way, and disappears", "jumps into an unseen dimension",\
		"sticks one leg straight out, wiggles [user.p_their()] foot, and is suddenly gone", "stops, then blinks out of reality", \
		"is pulled into an invisible vortex, vanishing from sight")
	var/slip_out_message = pick("silently fades in", "leaps out of thin air","appears", "walks out of an invisible doorway",\
		"slides out of a fold in spacetime")

	to_chat(user, span_notice("You try to align with the bluespace stream..."))
	if(!do_after(user, 2 SECONDS, target = src))
		return TRUE

	var/turf/rift_turf = get_turf(src)
	var/turf/user_turf = get_turf(user)
	var/turf/destination_turf = get_turf(linked_rift) || rift_turf // You teleport to the same space if there is no linked rift.

	user.visible_message(span_warning("[user] [slip_in_message]."), ignored_mobs = user)

	var/atom/movable/pulled = null
	if(ismovable(user.pulling))
		pulled = user.pulling
		var/turf/pulled_turf = get_turf(pulled)
		if(ismob(pulled))
			to_chat(pulled, span_notice("You suddenly find yourself in a different location!"))
		if(do_teleport(pulled, destination_turf, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE))
			play_rift_departure_animation(pulled_turf, pulled)

	if(do_teleport(user, destination_turf, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE))
		play_rift_departure_animation(user_turf, user)
		playsound(destination_turf, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		user.visible_message(span_warning("[user] [slip_out_message]."), span_notice("...and find your way to the other side."))
		if(pulled)
			user.start_pulling(pulled)
	else
		user.visible_message(span_warning("[user] [slip_out_message], ending up exactly where they left."), span_notice("...and find yourself where you started?"))

	return TRUE

/// Makes the user phase out when entering the rift.
/obj/effect/riftwalker_rift/proc/play_rift_departure_animation(turf/departure_turf, atom/movable/user)
	new /obj/effect/temp_visual/portal_animation(departure_turf, src, user)

/obj/effect/riftwalker_rift/attack_ghost(mob/user)
	if(QDELETED(linked_rift))
		return ..()
	user.abstract_move(get_turf(linked_rift))

/// Displaces both ends of this rift connection and replaces them elsewhere.
/obj/effect/riftwalker_rift/proc/disable_rift()
	var/replacement_rift_type_path = rift_type_path
	var/turf/first_rift_turf = get_turf(src)
	var/turf/second_rift_turf = get_turf(linked_rift)
	if(first_rift_turf)
		new /obj/effect/particle_effect/fluid/smoke/bad(first_rift_turf)
	if(second_rift_turf)
		new /obj/effect/particle_effect/fluid/smoke/bad(second_rift_turf)
	// Chance for a bluespace core, as rifts are too numerous to give out guaranteed but is flavorful nontheless.
	if(prob(bluespace_core_chance))
		new /obj/item/raw_anomaly_core/bluespace(drop_location())
	if(!QDELETED(linked_rift))
		QDEL_NULL(linked_rift)
	qdel(src)
	GLOB.riftwalker_network.spawn_pair(replacement_rift_type_path)

/// Reveals the frequency and code needed to disable this rift.
/obj/effect/riftwalker_rift/analyzer_act(mob/living/user, obj/item/analyzer/tool)
	if(!can_user_see_rifts(user) || QDELETED(anomaly_core))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("Analyzing... [src]'s bluespace field is fluctuating along frequency [format_frequency(anomaly_core.frequency)], code [anomaly_core.code]."))
	return ITEM_INTERACT_SUCCESS

/// Lets an anomaly neutralizer close a rift
/obj/effect/riftwalker_rift/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/anomaly_neutralizer))
		return ..()
	if(!can_user_see_rifts(user))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("You neutralize [src] with [attacking_item], frying its circuitry in the process."))
	disable_rift()
	var/obj/item/anomaly_neutralizer/neutralizer = attacking_item
	neutralizer.on_use(src, user)
	return ITEM_INTERACT_SUCCESS

/// A bluespace-core variant held inside a rift disables that rift when its matching signal is received.
/obj/item/assembly/signaler/anomaly/bluespace/riftwalker

/obj/item/assembly/signaler/anomaly/bluespace/riftwalker/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return FALSE
	var/obj/effect/riftwalker_rift/rift = loc
	if(istype(rift))
		rift.disable_rift()
	return TRUE

/// Makes it so that long distance analyzers can scan the the rift as if it were an anomaly.
/obj/effect/riftwalker_rift/ranged_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/analyzer))
		return NONE
	var/obj/item/analyzer/analyzer = tool
	if(!can_see(user, src, analyzer.ranged_scan_distance))
		return NONE
	return analyzer_act(user, analyzer)

// Determines if a mob can see the rift.
/datum/atom_hud/alternate_appearance/basic/riftwalker/mobShouldSee(mob/viewer)
	if(!isliving(viewer))
		return FALSE
	return HAS_TRAIT(viewer, TRAIT_IMBUED_RIFTWALKER) || HAS_TRAIT(viewer, TRAIT_IMBUED_RIFTWALKER_SIGHT_ONLY)

#undef RIFTWALKER_MIN_PAIRS
#undef RIFTWALKER_MAX_PAIRS
#undef RIFTWALKER_MAX_GENERATION_ATTEMPTS
#undef RIFTWALKER_LOCATION_ATTEMPTS
