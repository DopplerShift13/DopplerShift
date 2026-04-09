// did you know we have motorcycle pants and a motorcycle jacket? now you can stop larping

/// when we receive a low fuel message
#define LOW_FUEL_LEFT_MESSAGE 20
/// how often we burn a little gas, in seconds. with 200 max fuel this is just over thirty minutes of motorcycle time
#define BIKE_FUEL_BURN_INTERVAL 10


/obj/vehicle/ridden/motorcycle
	name = "racing motorcycle"
	desc = "A minimalist racing motorcycle that trades its fairings for a low key look. Nevertheless, the 1200 \
	cubic centimeters of displacement between the rider's legs make it plenty fast and perfectly dangerous."
	icon = 'modular_doppler/vehicles/icons/32x_vehicles.dmi'
	icon_state = "motorcycle"
	max_integrity = 300
	integrity_failure = 0.5
	armor_type = /datum/armor/ridden_atv
	key_type = null
	var/mutable_appearance/motorcycle_cover

	/// looping engine noise
	var/datum/looping_sound/motorcycle_engine/engine_sound
	/// max fuel that this bike can hold
	var/max_fuel = 200
	/// do we start with fuel?
	var/starting_fuel = TRUE
	/// when fuel was last removed
	var/last_fuel_burn = 0
	var/headlights_toggle = FALSE
	var/dismount_sound = 'modular_doppler/modular_sounds/sound/vehicles/bikedismount.ogg'
	var/list/rev_sounds = list(
		'modular_doppler/modular_sounds/sound/vehicles/bikerev-1.ogg',
		'modular_doppler/modular_sounds/sound/vehicles/bikerev-2.ogg',
		'modular_doppler/modular_sounds/sound/vehicles/bikerev-3.ogg',
		'modular_doppler/modular_sounds/sound/vehicles/bikerev-4.ogg',
	)
	/// Cooldown for revving the bike, to prevent spamming
	COOLDOWN_DECLARE(rev_cooldown)
	///Particle holder for low integrity smoking
	var/obj/effect/abstract/particle_holder/smoke = null

/obj/vehicle/ridden/motorcycle/Initialize(mapload)
	. = ..()
	engine_sound = new()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)
	if(!motorcycle_cover)
		motorcycle_cover = mutable_appearance(icon, "motorcycle_cover", MOB_LAYER + 0.1)
	create_reagents(max_fuel, REFILLABLE)
	if(starting_fuel)
		reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	initialize_passenger_action_type(/datum/action/vehicle/ridden/motorcycle/first_gear)
	initialize_passenger_action_type(/datum/action/vehicle/ridden/motorcycle/second_gear)
	initialize_passenger_action_type(/datum/action/vehicle/ridden/motorcycle/third_gear)

/obj/vehicle/ridden/motorcycle/process(seconds_per_tick)
	// we assume a reasonable spaceman turns off their motorcycle when they dismount, so only a ridden motorcycle burns fuel
	if(length(occupants))
		last_fuel_burn += seconds_per_tick
		if(last_fuel_burn >= BIKE_FUEL_BURN_INTERVAL)
			burn_fuel(1)

		var/turf/where_we_spawn_air = get_turf(src)
		where_we_spawn_air.atmos_spawn_air("[GAS_CO2]=5;[TURF_TEMPERATURE(T20C)]")	// technically motorcycle exhaust is more like 600k at the pipe and rapidly cools but we're just gonna cook the station trying to do that

/obj/vehicle/ridden/motorcycle/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	. += "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/vehicle/ridden/motorcycle/post_buckle_mob(mob/living/M)
	add_overlay(motorcycle_cover)
	engine_sound.start(src)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/vehicle/ridden/motorcycle/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		cut_overlay(motorcycle_cover)
	engine_sound.stop(src)
	return ..()

// revs the engine and spends a little fuel
/obj/vehicle/ridden/motorcycle/click_alt_secondary(mob/user)
	if(!is_occupant(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, rev_cooldown))
		return FALSE
	if(get_fuel() < 5)
		to_chat(user, span_notice("The [src]'s engine sputters!."))
		return FALSE
	COOLDOWN_START(src, rev_cooldown, 3 SECONDS)
	to_chat(user, span_notice("You rev the [src]'s engine."))
	playsound(src, pick(rev_sounds), 50, TRUE)
	return TRUE

/obj/vehicle/ridden/motorcycle/welder_act(mob/living/user, obj/item/W)
	if(user.combat_mode)
		return
	. = TRUE
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, "you're already repairing this!")
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, "it's not damaged!")
		return
	if(!W.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED))
		return
	user.balloon_alert_to_viewers("started welding [src]", "started repairing [src]")
	audible_message(span_hear("You hear welding."))
	var/did_the_thing
	while(atom_integrity < max_integrity)
		if(W.use_tool(src, user, 2.5 SECONDS, volume=50))
			did_the_thing = TRUE
			repair_damage(10)
			audible_message(span_hear("You hear welding."))
		else
			break
	if(did_the_thing)
		user.balloon_alert_to_viewers("[(atom_integrity >= max_integrity) ? "fully" : "partially"] repaired [src]")
	else
		user.balloon_alert_to_viewers("stopped welding [src]", "interrupted the repair!")

// returns our fuel level
/obj/vehicle/ridden/motorcycle/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)

// burns some fuel
/obj/vehicle/ridden/motorcycle/proc/burn_fuel(burnt = 0)
	if(!occupant_amount() || get_fuel() <= 0)
		return FALSE
	if(burnt > 0)
		last_fuel_burn = 0
	if(get_fuel() >= burnt)
		reagents.remove_reagent(/datum/reagent/fuel, burnt)
		check_fuel()
		return TRUE
	else
		return FALSE

// checks to see if there's any fuel left, turns off the engine sound and immobilizes the bike if the tank is try.
/obj/vehicle/ridden/motorcycle/proc/check_fuel(mob/user)
	if(get_fuel() <= 0)
		for(var/mob/rider in buckled_mobs)
			balloon_alert(rider, "out of fuel!")
		return FALSE
	if(get_fuel() == LOW_FUEL_LEFT_MESSAGE)
		for(var/mob/rider in buckled_mobs)
			balloon_alert(rider, "low fuel!")
	else
		return

/obj/vehicle/ridden/motorcycle/relaymove(mob/living/user, direction)
	if(get_fuel() <= 0)
		engine_sound.stop(src)
		return FALSE
	return ..()

/obj/vehicle/ridden/motorcycle/atom_break()
	. = ..()
	if (smoke)
		return
	smoke = new(src, /particles/smoke/ash)

/obj/vehicle/ridden/motorcycle/atom_fix()
	. = ..()
	if (smoke)
		QDEL_NULL(smoke)

/obj/vehicle/ridden/motorcycle/atom_destruction(damage_flag)
	explosion(src, light_impact_range = 1, flame_range = 2)
	return ..()

/*
* action datums for turning on our headlight and changing gears
*/

/datum/action/vehicle/ridden/motorcycle/toggle_light
	name = "Toggle Headlights"
	desc = "Turn on your brights!"
	button_icon = 'modular_doppler/vehicles/icons/vehicle_actions.dmi'
	button_icon_state = "headlights"

/*/datum/action/vehicle/ridden/motorcycle/toggle_light/Trigger(mob/clicker, trigger_flags)
	to_chat(owner, span_notice("You flip the switch for the vehicle's headlights."))
	vehicle_ridden_target.headlights_toggle = !vehicle_ridden_target.headlights_toggle
	vehicle_ridden_target.set_light_on(vehicle_ridden_target.headlights_toggle)
	vehicle_ridden_target.update_appearance()
	playsound(owner, vehicle_ridden_target.headlights_toggle ? 'sound/items/weapons/magin.ogg' : 'sound/items/weapons/magout.ogg', 40, TRUE)*/

/datum/action/vehicle/ridden/motorcycle/first_gear
	name = "Shift Into First"
	desc = "Shift into low gear."
	button_icon = 'modular_doppler/vehicles/icons/vehicle_actions.dmi'
	button_icon_state = "first_gear"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED

/datum/action/vehicle/ridden/motorcycle/first_gear/Trigger(mob/clicker, trigger_flags)
	vehicle_ridden_target.RemoveElement(/datum/element/ridable)
	vehicle_ridden_target.AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)

/datum/action/vehicle/ridden/motorcycle/second_gear
	name = "Shift Into Second"
	desc = "Shift into middle gear."
	button_icon = 'modular_doppler/vehicles/icons/vehicle_actions.dmi'
	button_icon_state = "second_gear"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED

/datum/action/vehicle/ridden/motorcycle/second_gear/Trigger(mob/clicker, trigger_flags)
	vehicle_ridden_target.RemoveElement(/datum/element/ridable)
	vehicle_ridden_target.AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle/second_gear)

/datum/action/vehicle/ridden/motorcycle/third_gear
	name = "Shift Into Third"
	desc = "Shift into high gear!"
	button_icon = 'modular_doppler/vehicles/icons/vehicle_actions.dmi'
	button_icon_state = "third_gear"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED

/datum/action/vehicle/ridden/motorcycle/third_gear/Trigger(mob/clicker, trigger_flags)
	vehicle_ridden_target.RemoveElement(/datum/element/ridable)
	vehicle_ridden_target.AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle/third_gear)

/*
* vehicle component datums. gee, motorcycle, how come you have so many vehicle datums? because we use the action datums above
* to swap gears, which makes us go faster and live shorter.
*/

// first gear is just below running speed. Bumping things won't hurt anyone.
/datum/component/riding/vehicle/motorcycle
	keytype = null
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER
	vehicle_move_delay = 1.5

// second gear is pretty fast. bumping things may cause damage.
/datum/component/riding/vehicle/motorcycle/second_gear
	vehicle_move_delay = 1

// third gear is extremely fast. crashing may be fatal.

/datum/component/riding/vehicle/motorcycle/third_gear
	vehicle_move_delay = 0.5

/datum/component/riding/vehicle/motorcycle/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 5),
		TEXT_SOUTH = list(0, 5),
		TEXT_EAST =  list(-2, 5),
		TEXT_WEST =  list(2, 5),
	)

/datum/component/riding/vehicle/motorcycle/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, OBJ_LAYER),
		TEXT_SOUTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

// our looping engine sound

/datum/looping_sound/motorcycle_engine
	mid_sounds = list(
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-1.ogg'=1,
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-2.ogg'=1,
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-3.ogg'=1,
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-4.ogg'=1,
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-5.ogg'=1,
		'modular_doppler/modular_sounds/sound/vehicles/bikeidle-6.ogg'=1,
	)
	mid_length = 1 SECONDS
	start_sound = 'modular_doppler/modular_sounds/sound/vehicles/bikestart.ogg'
	start_length = 1 SECONDS
	volume = 25
