/// Relative spawn weights for each rift pair type.
GLOBAL_LIST_INIT(riftwalker_rift_type_weights, list(
	/datum/riftwalker_rift_type = 50,
	/datum/riftwalker_rift_type/teleporter = 25,
	/datum/riftwalker_rift_type/maintenance = 15,
	/datum/riftwalker_rift_type/red = 10,
))

// Chance for teleporter rifts that spawn by a teleporter to link to a beacon.
#define RIFTWALKER_TELEPORTER_BEACON_LINK_CHANCE 66
// Chance for a maintenance rift's second rift to also spawn in maintenance.
#define RIFTWALKER_MAINTENANCE_SECOND_RIFT_CHANCE 33
// Chance for a red rift to lead to a space ruin, otherwise leading to a mining ruin.
#define RIFTWALKER_SPACE_RUIN_CHANCE 66

/// Defines a rift pair's location rules and the rift object it creates.
/datum/riftwalker_rift_type
	var/rift_path = /obj/effect/riftwalker_rift

/*
*
* Standard rift: First and second rift are two random (safe) tiles on the station.
*
*/
/datum/riftwalker_rift_type/proc/find_first_turf(datum/riftwalker_network_tracker/network)
	return network.find_random_rift_turf()

/datum/riftwalker_rift_type/proc/find_second_turf(datum/riftwalker_network_tracker/network)
	return network.find_random_rift_turf()

/*
*
 * Teleporter Rift: The first rift is associated with a beacon, teleport hub, or gateway; the second rift is either random, or if the first is a teleport-hub rift, it may link to a beacon.
*
*/
/datum/riftwalker_rift_type/teleporter
	/// Whether the first rift selected a teleport hub, enabling its potential beacon link.
	var/first_rift_uses_teleporter = FALSE

/// Randomly rolls between becaons, teleporters or gateways. Places the spawning rift there.
/datum/riftwalker_rift_type/teleporter/find_first_turf(datum/riftwalker_network_tracker/network)
	first_rift_uses_teleporter = FALSE
	var/list/first_rift_options = shuffle(list("beacon", "teleporter", "gateway"))
	for(var/first_rift_option as anything in first_rift_options)
		var/turf/first_turf
		switch(first_rift_option)
			if("beacon")
				first_turf = pick_valid_beacon_turf(network)
			if("teleporter")
				first_turf = pick_adjacent_teleporter_turf(network)
			if("gateway")
				first_turf = pick_gateway_area_turf(network)
		if(!first_turf)
			continue
		first_rift_uses_teleporter = first_rift_option == "teleporter"
		return first_turf

/datum/riftwalker_rift_type/teleporter/find_second_turf(datum/riftwalker_network_tracker/network)
	if(first_rift_uses_teleporter && prob(RIFTWALKER_TELEPORTER_BEACON_LINK_CHANCE))
		var/turf/beacon_turf = pick_valid_beacon_turf(network)
		if(beacon_turf)
			return beacon_turf
	return ..()

/// Finds a valid turf adjacent to a station teleport hub.
/datum/riftwalker_rift_type/teleporter/proc/pick_adjacent_teleporter_turf(datum/riftwalker_network_tracker/network)
	var/list/turf/candidates = list()
	for(var/obj/machinery/teleport/hub/teleporter as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/teleport/hub))
		if(!is_station_level(teleporter.z))
			continue
		var/turf/teleporter_turf = get_turf(teleporter)
		if(!teleporter_turf)
			continue
		for(var/turf/adjacent_turf as anything in range(1, teleporter_turf))
			if(adjacent_turf != teleporter_turf && network.is_valid_station_rift_location(adjacent_turf))
				candidates += adjacent_turf
	return length(candidates) ? pick(candidates) : null

/// Finds a valid station teleport beacon turf.
/datum/riftwalker_rift_type/teleporter/proc/pick_valid_beacon_turf(datum/riftwalker_network_tracker/network)
	var/list/turf/candidates = list()
	for(var/obj/item/beacon/beacon as anything in GLOB.teleportbeacons)
		var/turf/beacon_turf = get_turf(beacon)
		if(network.is_valid_station_rift_location(beacon_turf))
			candidates += beacon_turf
	return length(candidates) ? pick(candidates) : null

/// Finds a valid turf in the station gateway's area, if the map has one.
/datum/riftwalker_rift_type/teleporter/proc/pick_gateway_area_turf(datum/riftwalker_network_tracker/network)
	var/area/gateway_area = get_area(GLOB.the_gateway)
	if(!gateway_area)
		return null
	var/list/turf/candidates = list()
	for(var/turf/gateway_turf as anything in gateway_area)
		if(network.is_valid_station_rift_location(gateway_turf))
			candidates += gateway_turf
	return length(candidates) ? pick(candidates) : null

/*
*
* Maintenance Rift: The first rift always spawns in maintenance. The second has a one-in-three chance to also spawn there, otherwise following normal placement rules.
*
*/
/datum/riftwalker_rift_type/maintenance

/datum/riftwalker_rift_type/maintenance/find_first_turf(datum/riftwalker_network_tracker/network)
	return pick_valid_maintenance_turf(network)

/datum/riftwalker_rift_type/maintenance/find_second_turf(datum/riftwalker_network_tracker/network)
	if(prob(RIFTWALKER_MAINTENANCE_SECOND_RIFT_CHANCE))
		var/turf/maintenance_turf = pick_valid_maintenance_turf(network)
		if(maintenance_turf)
			return maintenance_turf
	return ..()

/// Finds a clear station-maintenance turf suitable for a rift.
/datum/riftwalker_rift_type/maintenance/proc/pick_valid_maintenance_turf(datum/riftwalker_network_tracker/network)
	var/list/turf/candidates = list()
	for(var/turf/maintenance_turf as anything in get_area_turfs(/area/station/maintenance, subtypes = TRUE))
		if(network.is_valid_station_rift_location(maintenance_turf))
			candidates += maintenance_turf
	return length(candidates) ? pick(candidates) : null

/*
*
* Red Rift: Spooky and dangerous! The first rift spawns somewhere random, while the second always leads to a breathable ruin.
* These look visually distinct to differentiate them, and you are entering quite obviously at your own risk.
* Unlike blue rifts you can't drag things with you (be weird with the flavor) - just you, amigo.
*
*/
/datum/riftwalker_rift_type/red
	rift_path = /obj/effect/riftwalker_rift/red
	/// Ruin areas that red rifts must never provide access to.
	var/static/list/area_blacklist = typecacheof(list(
		/area/ruin/space/has_grav/powered/undisclosed_location, // cozy-zone for cantags lets give them their peace.
	))

/datum/riftwalker_rift_type/red/find_second_turf(datum/riftwalker_network_tracker/network)
	return pick_valid_ruin_turf(network)

/// Finds a clear, breathable floor within a space ruin or a ruin on the mining z-level.
/datum/riftwalker_rift_type/red/proc/pick_valid_ruin_turf(datum/riftwalker_network_tracker/network)
	var/pick_space_ruin = prob(RIFTWALKER_SPACE_RUIN_CHANCE)
	var/list/preferred_ruin_levels = SSmapping.levels_by_trait(pick_space_ruin ? ZTRAIT_SPACE_RUINS : ZTRAIT_MINING)
	var/turf/preferred_turf = pick_ruin_turf_from_levels(network, preferred_ruin_levels)
	if(preferred_turf)
		return preferred_turf
	var/list/fallback_ruin_levels = SSmapping.levels_by_trait(pick_space_ruin ? ZTRAIT_MINING : ZTRAIT_SPACE_RUINS)
	return pick_ruin_turf_from_levels(network, fallback_ruin_levels)

/// Selects a clear, breathable ruin floor from the available z-levels.
/datum/riftwalker_rift_type/red/proc/pick_ruin_turf_from_levels(datum/riftwalker_network_tracker/network, list/ruin_levels)
	var/list/turf/candidates = list()
	for(var/ruin_level in ruin_levels)
		for(var/turf/ruin_turf as anything in get_area_turfs(/area/ruin, target_z = ruin_level, subtypes = TRUE))
			network.debug_attempts++
			if(!istype(ruin_turf, /turf/open/floor))
				continue
			var/area/ruin_area = get_area(ruin_turf)
			if(is_type_in_typecache(ruin_area, area_blacklist))
				continue
			if(network.is_clear_rift_location(ruin_turf) && is_safe_turf(ruin_turf))
				candidates += ruin_turf
	return length(candidates) ? pick(candidates) : null

// Red rifts work differently, as they have have a windup, transit and arrival phase.
#define RIFTWALKER_RED_RIFT_WINDUP_DURATION (2 SECONDS)
#define RIFTWALKER_RED_RIFT_TRANSIT_DURATION (10 SECONDS)
#define RIFTWALKER_RED_RIFT_ARRIVAL_DURATION (3 SECONDS)
#define RIFTWALKER_RED_RIFT_TOTAL_DURATION (RIFTWALKER_RED_RIFT_WINDUP_DURATION + RIFTWALKER_RED_RIFT_TRANSIT_DURATION)
/// Screen effects
#define RIFTWALKER_RED_RIFT_KINESIS_FULLSCREEN "riftwalker_red_rift_kinesis"
#define RIFTWALKER_RED_RIFT_COLOR_FILTER "riftwalker_red_rift_color"
#define RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER "riftwalker_red_rift_displacement"

/// ITS SPOOKY, IT (MIGHT) BE REDSPACE, IT MAY JUST BE RESONANT FUCKERY - WHO KNOWS, I AIN'T EXPLAINING SHIT
/obj/effect/riftwalker_rift/red
	name = "red bluespace rift"
	bluespace_core_chance = RIFTWALKER_RED_RIFT_BLUESPACE_CORE_CHANCE
	desc = "Redspace is a theory long debunked as folly. Most of it stems from similarities drawn to the redshift and blueshift phenomena: if bluespace reduces relative distance between locations, then redspace must increase relative distance - but then how would it still function as a gateway? Ultimately no empirical evidence of redspace was ever discovered. \
	Yet with the Reality Anchors broken, has that changed in any capacity? Has the absence of the binding laws of reality given way to that which could not exist?"
	icon_state = "riftwalker_red"
	rift_color = "#fc5f5f"

/obj/effect/riftwalker_rift/red/examine(mob/user)
	. = ..()
	. += span_bolddanger("... You have a bad feeling about this.")

/// Red rifts are deliberately slow: users are held inside their destination rift while the sequence completes.
/obj/effect/riftwalker_rift/red/attack_hand(mob/living/user, list/modifiers)
	if(!can_user_use_rifts(user))
		return TRUE
	if(QDELETED(linked_rift))
		to_chat(user, span_warning("It leads nowhere! Bah, all for show."))
		return TRUE

	var/obj/effect/riftwalker_rift/red/destination_rift = linked_rift
	if(!istype(destination_rift))
		return TRUE

	// Message upon entering: shows a different one with rift instability.
	var/datum/status_effect/rift_instability/rift_instability = user.has_status_effect(/datum/status_effect/rift_instability)
	var/user_message = "Pain strikes your arm as it is stretched and pulled into [name]!"
	if(rift_instability)
		user_message = "You feel your body being torn asunder as you enter the rift; this was a mistake!"
	var/datum/riftwalker_red_rift_transit/transit = new(user, src, destination_rift)
	transit.begin_windup(user)
	user.visible_message(
		span_warning("[user] turns red as [user.p_they()] [user.p_are()] stretched and scattered into nothingness!"),
		span_userdanger(user_message)
	)
	// Failure states, including if the rift is deleted, in which case you lose your arm.
	if(!do_after(user, RIFTWALKER_RED_RIFT_WINDUP_DURATION, target = src, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_INCAPACITATED | IGNORE_SLOWDOWNS))
		if(QDELETED(src))
			transit.rip_user_arm(user)
		transit.cancel(user)
		return TRUE
	if(QDELETED(destination_rift) || QDELETED(src))
		if(QDELETED(src))
			transit.rip_user_arm(user)
		transit.cancel(user)
		return TRUE
	transit.begin_transit(user)
	return TRUE

/// Stores a single user's rift journey while using red rifts.
/datum/riftwalker_red_rift_transit
	/// Rift the mob enters from
	var/obj/effect/riftwalker_rift/red/origin_rift
	/// Rift the user will exit from
	var/obj/effect/riftwalker_rift/red/destination_rift
	/// Turf the user started on
	var/turf/origin_turf
	/// Turf the user will exit from
	var/turf/destination_turf
	/// Have we started teleporting?
	var/transit_started = FALSE
	/// User alpha captured before the red rift fades them out.
	var/initial_user_alpha

/datum/riftwalker_red_rift_transit/New(mob/living/new_user, obj/effect/riftwalker_rift/red/new_origin_rift, obj/effect/riftwalker_rift/red/new_destination_rift)
	. = ..()
	origin_rift = new_origin_rift
	destination_rift = new_destination_rift
	origin_turf = get_turf(new_user)
	destination_turf = get_turf(new_destination_rift)
	initial_user_alpha = new_user.alpha

/// Applies filters and stuns the user to prevent canceling the process.
/datum/riftwalker_red_rift_transit/proc/begin_windup(mob/living/user)
	if(QDELETED(user))
		return
	user.add_filter(RIFTWALKER_RED_RIFT_COLOR_FILTER, 1, color_matrix_filter(COLOR_WHITE))
	user.transition_filter(RIFTWALKER_RED_RIFT_COLOR_FILTER, color_matrix_filter(COLOR_RED), RIFTWALKER_RED_RIFT_WINDUP_DURATION)
	user.remove_filter(RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER)
	user.add_filter(RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER, 10, list("type" = "displace", "x" = 0, "y" = 0, "size" = 0))
	addtimer(CALLBACK(src, PROC_REF(animate_displacement), user), 0.1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(fade_user_out), user), RIFTWALKER_RED_RIFT_WINDUP_DURATION * 0.75)
	ADD_TRAIT(user, TRAIT_IMMOBILIZED, REF(src))
	user.Stun(RIFTWALKER_RED_RIFT_TOTAL_DURATION, ignore_canstun = TRUE)
	playsound(origin_turf, 'modular_doppler/modular_powers/sounds/riftwalker/red_rift_walk.ogg', 50, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)

/// Begins the displacement animation
/datum/riftwalker_red_rift_transit/proc/animate_displacement(mob/living/user)
	if(QDELETED(user))
		return
	var/displacement_filter = user.get_filter(RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER)
	if(!displacement_filter)
		return
	animate(displacement_filter, flags = ANIMATION_END_NOW)
	animate(displacement_filter, size = -15, time = RIFTWALKER_RED_RIFT_WINDUP_DURATION - (0.1 SECONDS))

/// Fades the user over the final quarter of the windup
/datum/riftwalker_red_rift_transit/proc/fade_user_out(mob/living/user)
	if(QDELETED(user))
		return
	animate(user, alpha = 0, time = RIFTWALKER_RED_RIFT_WINDUP_DURATION * 0.25)

/// Moves the user out of the world and applies UI FX as part of rift travel.
/datum/riftwalker_red_rift_transit/proc/begin_transit(mob/living/user)
	if(QDELETED(user) || QDELETED(destination_rift))
		cancel(user)
		return
	transit_started = TRUE
	new /obj/effect/temp_visual/portal_animation(origin_turf, origin_rift, user)
	user.forceMove(destination_rift)
	user.overlay_fullscreen(RIFTWALKER_RED_RIFT_KINESIS_FULLSCREEN, /atom/movable/screen/fullscreen/red_rift_kinesis, 0)
	apply_red_rift_tint(user)
	addtimer(CALLBACK(src, PROC_REF(begin_arrival), user), RIFTWALKER_RED_RIFT_TRANSIT_DURATION - RIFTWALKER_RED_RIFT_ARRIVAL_DURATION)
	addtimer(CALLBACK(src, PROC_REF(finish_transit), user), RIFTWALKER_RED_RIFT_TRANSIT_DURATION)

/// Applies a dark-red tint, then starts its fade once the initial colour has reached the client.
/datum/riftwalker_red_rift_transit/proc/apply_red_rift_tint(mob/living/user)
	if(QDELETED(user) || !user.hud_used)
		return
	var/filter_name = "riftwalker_red_rift_tint_[REF(src)]"
	for(var/atom/movable/screen/plane_master/game_plane as anything in user.hud_used.get_true_plane_masters(RENDER_PLANE_GAME))
		game_plane.add_filter(filter_name, 10, color_matrix_filter(COLOR_DARK_RED))
	addtimer(CALLBACK(src, PROC_REF(animate_red_rift_tint), user), 0.1 SECONDS)

/// Fades the tint from dark red back to nothing over the duration.
/datum/riftwalker_red_rift_transit/proc/animate_red_rift_tint(mob/living/user)
	if(QDELETED(user) || !user.hud_used)
		return
	var/filter_name = "riftwalker_red_rift_tint_[REF(src)]"
	for(var/atom/movable/screen/plane_master/game_plane as anything in user.hud_used.get_true_plane_masters(RENDER_PLANE_GAME))
		var/red_rift_tint = game_plane.get_filter(filter_name)
		if(red_rift_tint)
			animate(red_rift_tint, color = COLOR_MATRIX_IDENTITY, time = RIFTWALKER_RED_RIFT_TRANSIT_DURATION - (0.1 SECONDS), easing = SINE_EASING | EASE_OUT)

/// Removes the above-mentioned red-tint entirely
/datum/riftwalker_red_rift_transit/proc/remove_red_rift_tint(mob/living/user)
	if(QDELETED(user) || !user.hud_used)
		return
	var/filter_name = "riftwalker_red_rift_tint_[REF(src)]"
	for(var/atom/movable/screen/plane_master/game_plane as anything in user.hud_used.get_true_plane_masters(RENDER_PLANE_GAME))
		game_plane.remove_filter(filter_name)

/// Plays the arrival effect during the several seconds before the user returns to physical space.
/datum/riftwalker_red_rift_transit/proc/begin_arrival(mob/living/user)
	if(QDELETED(user) || QDELETED(destination_rift) || user.loc != destination_rift)
		return
	new /obj/effect/temp_visual/red_rift_arrival(destination_turf, destination_rift, user, initial_user_alpha)
	var/sound/reversed_gateway_sound = sound('modular_doppler/modular_powers/sounds/riftwalker/red_rift_walk.ogg')
	reversed_gateway_sound.frequency = -1
	playsound(destination_turf, reversed_gateway_sound, 50, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)

/// Places the user at the destination once the red-rift effects have fully played.
/datum/riftwalker_red_rift_transit/proc/finish_transit(mob/living/user)
	if(QDELETED(user))
		qdel(src)
		return
	clear_transit_effects(user)
	if(user.loc == destination_rift || isnull(user.loc))
		var/turf/arrival_turf = !QDELETED(destination_rift) ? get_turf(destination_rift) : origin_turf
		if(arrival_turf)
			user.forceMove(arrival_turf)
			// Applies a negative status effect if you go back too quick
			var/already_unstable = !!user.has_status_effect(/datum/status_effect/rift_instability)
			user.apply_status_effect(/datum/status_effect/rift_instability)
			// Or does worse.
			if(already_unstable)
				apply_rift_instability(user)
			user.visible_message(
				span_warning("[user] forms into being!"),
				span_warning("After what feels like days inside the rift, you finally feel whole again.")
			)
	qdel(src)

/// Harms the user after entering another red rift shortly after entering another
/// Mathematically, you're looking at about a 25% chance of receiving an injury that will kill you without immediate treatment.
/datum/riftwalker_red_rift_transit/proc/apply_rift_instability(mob/living/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/carbon_user = user
	// Vomit up blood
	if(carbon_user.get_bodypart(BODY_ZONE_HEAD))
		carbon_user.vomit(MOB_VOMIT_BLOOD | MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM | MOB_VOMIT_FORCE, lost_nutrition = 0)
		carbon_user.blood_volume = max(carbon_user.blood_volume - 20, 0)
	// Deal up to 100 brute damage to the body.
	user.adjustBruteLoss(rand(0, 100))
	// Deal up to 200 damage randomly spread across organs
	var/list/obj/item/organ/chest_organs = list()
	for(var/obj/item/organ/organ as anything in carbon_user.organs)
		if(organ.zone == BODY_ZONE_CHEST)
			chest_organs += organ
	var/total_organ_damage = rand(0, 200)
	if(length(chest_organs) && total_organ_damage)
		var/remaining_damage = total_organ_damage
		var/remaining_organs = length(chest_organs)
		for(var/obj/item/organ/damaged_organ as anything in shuffle(chest_organs))
			// if there's only 1 organ left it takes the remaining pooled damage
			var/organ_damage = remaining_organs > 1 ? rand(0, remaining_damage) : remaining_damage
			damaged_organ.apply_organ_damage(organ_damage)
			// If the organ is completely destroyed, it is teleported outside of the body as to indicate "oh fuck"
			if(damaged_organ.organ_flags & ORGAN_FAILING)
				damaged_organ.Remove(carbon_user)
				damaged_organ.forceMove(get_turf(carbon_user))
				to_chat(carbon_user, span_userdanger("[damaged_organ] appears beside you as you exit the rift!"))
			remaining_damage -= organ_damage
			remaining_organs--
	// 10% chance per limb to lose it, including head and body.
	for(var/obj/item/bodypart/bodypart as anything in carbon_user.bodyparts.Copy())
		if(prob(10))
			if(bodypart.dismember(silent = TRUE))
				to_chat(carbon_user, span_userdanger("[bodypart] is detached as you exit the rift!"))

/// Proc that handels the cancel signal.
/datum/riftwalker_red_rift_transit/proc/cancel(mob/living/user)
	clear_transit_effects(user)
	qdel(src)

/// Tears off an arm left behind when the entrance rift collapses during the wind-up
/datum/riftwalker_red_rift_transit/proc/rip_user_arm(mob/living/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/carbon_user = user
	var/list/available_arms = list()
	var/obj/item/bodypart/left_arm = carbon_user.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/right_arm = carbon_user.get_bodypart(BODY_ZONE_R_ARM)
	if(left_arm)
		available_arms += left_arm
	if(right_arm)
		available_arms += right_arm
	if(!length(available_arms))
		return
	var/obj/item/bodypart/ripped_arm = pick(available_arms)
	carbon_user.visible_message(
		span_danger("[carbon_user]'s [ripped_arm.name] tears clean off!"),
		span_userdanger("The collapsing rift catches your [ripped_arm.name] and tears it clean off!")
	)
	ripped_arm.dismember(BRUTE, TRUE)

/// Removes any lingering visual effects
/datum/riftwalker_red_rift_transit/proc/clear_transit_effects(mob/living/user)
	if(QDELETED(user))
		return
	user.remove_filter(RIFTWALKER_RED_RIFT_COLOR_FILTER)
	user.remove_filter(RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER)
	user.alpha = initial_user_alpha
	REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, REF(src))
	remove_red_rift_tint(user)
	user.clear_fullscreen(RIFTWALKER_RED_RIFT_KINESIS_FULLSCREEN, FALSE)

/// Red-tinted kinesis overlay.
/atom/movable/screen/fullscreen/red_rift_kinesis
	icon_state = "kinesis"
	color = COLOR_DARK_RED
	alpha = 96

/datum/mood_event/red_rift_travel
	description = "That rift was horrible to travel with. I feel as if I had just been quartered!"
	mood_change = -10

/// A temporary warning that another red-rift journey will injure the user's body.
/datum/status_effect/rift_instability
	id = "rift_instability"
	duration = 1 MINUTES
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/rift_instability

/datum/status_effect/rift_instability/on_apply()
	owner.add_mood_event("red_rift_travel", /datum/mood_event/red_rift_travel)
	return TRUE

/datum/status_effect/rift_instability/on_remove()
	owner.clear_mood_event("red_rift_travel")

/atom/movable/screen/alert/status_effect/rift_instability
	name = "Rift Instability"
	desc = "Your recent experience with a Red Rift has left your body very vulnerable. Entering it again so soon may be a terrible idea."
	icon = 'modular_doppler/modular_powers/icons/powers/effects.dmi'
	icon_state = "riftwalker_red"
	alerttooltipstyle = "cult"

/// Handles the fade-in colors of red rift arrivals.
/obj/effect/temp_visual/red_rift_arrival
	duration = RIFTWALKER_RED_RIFT_ARRIVAL_DURATION

/obj/effect/temp_visual/red_rift_arrival/Initialize(mapload, atom/portal, atom/movable/teleporting, arrival_alpha)
	. = ..()
	if(isnull(portal) || isnull(teleporting))
		return
	appearance = teleporting.appearance
	dir = teleporting.dir
	layer = portal.layer + 0.01
	// Alpha zero isn't liked by BYOND, animation only works at 1 alpha?
	alpha = 1
	addtimer(CALLBACK(src, PROC_REF(fade_in), arrival_alpha), 0.1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(restore_displacement)), 0.1 SECONDS)

/// Starts the arrival alpha animation.
/obj/effect/temp_visual/red_rift_arrival/proc/fade_in(arrival_alpha)
	if(QDELETED(src))
		return
	animate(src, pixel_x = 0, pixel_y = 0, alpha = arrival_alpha, time = duration * 0.25, flags = ANIMATION_PARALLEL)

/// Applies the displacement filter and returns the mob to normal over the course of the animation.
/obj/effect/temp_visual/red_rift_arrival/proc/restore_displacement()
	var/displacement_filter = get_filter(RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER)
	if(!displacement_filter)
		return
	animate(displacement_filter, flags = ANIMATION_END_NOW)
	animate(displacement_filter, size = 0, time = duration - (0.1 SECONDS))

#undef RIFTWALKER_TELEPORTER_BEACON_LINK_CHANCE
#undef RIFTWALKER_MAINTENANCE_SECOND_RIFT_CHANCE
#undef RIFTWALKER_SPACE_RUIN_CHANCE
#undef RIFTWALKER_RED_RIFT_WINDUP_DURATION
#undef RIFTWALKER_RED_RIFT_TRANSIT_DURATION
#undef RIFTWALKER_RED_RIFT_ARRIVAL_DURATION
#undef RIFTWALKER_RED_RIFT_TOTAL_DURATION
#undef RIFTWALKER_RED_RIFT_KINESIS_FULLSCREEN
#undef RIFTWALKER_RED_RIFT_COLOR_FILTER
#undef RIFTWALKER_RED_RIFT_DISPLACEMENT_FILTER
