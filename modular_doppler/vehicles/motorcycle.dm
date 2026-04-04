// did you know we have motorcycle pants and a motorcycle jacket? now you can stop larping

///Fuel limit when you will recieve an alert for low fuel message
#define LOW_FUEL_LEFT_MESSAGE 100

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

	/// The looping sound that plays when the bike is not moving
	var/datum/looping_sound/bike_idle/idle_sound
	///max fuel that this bike can hold
	var/max_fuel = 1000
	///do we start with fuel?
	var/starting_fuel = TRUE
	/// Which sound is played when the bike is unbuckled from
	var/dismount_sound = 'modular_doppler/modular_sounds/sound/vehicles/bikedismount.ogg'
	/// A list of potential sounds played when the bike is revved via AltClick
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
	idle_sound = new()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)
	if(!motorcycle_cover)
		motorcycle_cover = mutable_appearance(icon, "motorcycle_cover", MOB_LAYER + 0.1)
	create_reagents(max_fuel)
	if(starting_fuel)
		reagents.add_reagent(/datum/reagent/fuel, max_fuel)

/obj/vehicle/ridden/motorcycle/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	. += "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/vehicle/ridden/motorcycle/post_buckle_mob(mob/living/M)
	add_overlay(motorcycle_cover)
	idle_sound.start(src)
	return ..()

/obj/vehicle/ridden/motorcycle/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		cut_overlay(motorcycle_cover)
	idle_sound.stop(src)
	return ..()

// revs the engine and spends a little fuel
/obj/vehicle/ridden/motorcycle/click_alt_secondary(mob/user)
	if(!is_occupant(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, rev_cooldown))
		return FALSE
	if(get_fuel < 5)
		to_chat(user, span_notice("The [src]'s engine sputters!."))
		return FALSE
	COOLDOWN_START(src, rev_cooldown, 3 SECONDS)
	to_chat(user, span_notice("You rev the [src]'s engine."))
	playsound(src, pick(rev_sounds), 50, TRUE)
	fuel_count -= 5
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

/obj/vehicle/ridden/motorcycle/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel) + reagents.get_reagent_amount(/datum/reagent/toxin/plasma)

/obj/vehicle/ridden/motorcycle/relaymove(mob/living/user, direction)
	if(get_fuel = 0)
		idle_sound.stop(src)
		return FALSE
	return ..()

/obj/vehicle/ridden/motorcycle/Move(newloc, dir)
	. = ..()
	if(!LAZYLEN(buckled_mobs))
		return
	fuel_count--
	if(fuel_count == LOW_FUEL_LEFT_MESSAGE)
		for(var/mob/rider in buckled_mobs)
			balloon_alert(rider, "[fuel_count/fuel_max*100]% fuel left")

/obj/vehicle/ridden/motorcycle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/jerrycan))
		var/obj/item/reagent_containers/jerrycan/gascan = I
		if(gascan.reagents.total_volume == 0)
			balloon_alert(user, "Out of fuel!")
			return
		if(fuel_count >= fuel_max)
			balloon_alert(user, "Already full!")
			return

		var/fuel_transfer_amount = min(gascan.fuel_usage*2, gascan.reagents.total_volume)
		gascan.reagents.remove_reagent(/datum/reagent/fuel, fuel_transfer_amount)
		fuel_count = min(fuel_count + FUEL_PER_CAN_POUR, fuel_max)
		playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
		balloon_alert(user, "[fuel_count/fuel_max*100]%")
		return TRUE

/obj/vehicle/ridden/motorcycle/atom_break()
	. = ..()
	if (smoke)
		return
	smoke = new(src, /particles/smoke/ash)

/obj/vehicle/ridden/motorcycle/atom_fix()
	. = ..()
	if (smoke)
		QDEL_NULL(smoke)

/*
* vehicle component datums. gee, motorcycle, how come you have so many vehicle datums? because we use a proc above
* to swap gears, which makes us go faster and live shorter.
*/

// first gear is just below running speed. Bumping things won't hurt anyone.
/datum/component/riding/vehicle/motorcycle
	keytype = null
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER
	vehicle_move_delay = 1.25

// second gear is pretty fast. bumping things may cause damage.
/datum/component/riding/vehicle/motorcycle/second_gear
	vehicle_move_delay = 1.25

// third gear is extremely fast. crashing may be fatal.

/datum/component/riding/vehicle/motorcycle/third_gear
	vehicle_move_delay = 1.15

/datum/component/riding/vehicle/motorcycle/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 4),
		TEXT_SOUTH = list(0, 4),
		TEXT_EAST =  list(0, 4),
		TEXT_WEST =  list(0, 4),
	)

/datum/component/riding/vehicle/motorcycle/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, OBJ_LAYER),
		TEXT_SOUTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

// our looping idle sound

/datum/looping_sound/bike_idle
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
