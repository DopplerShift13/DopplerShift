// did you know we have motorcycle pants and a motorcycle jacket? now you can stop larping

/obj/vehicle/ridden/motorcycle
	name = "motorcycle"
	desc = ""
	icon = 'modular_doppler/vehicles/icons/32x_vehicles.dmi'
	icon_state = "motorcycle"
	max_integrity = 300
	integrity_failure = 0.5
	armor_type = /datum/armor/ridden_atv
	key_type = null
	var/mutable_appearance/motorcycle_cover

	/// reference to the attached sidecar, if present
	var/obj/item/sidecar/attached_sidecar
	/// The looping sound that plays when the bike is not moving
	var/datum/looping_sound/bike_idle/idle_sound
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

/obj/vehicle/ridden/motorcycle/post_buckle_mob(mob/living/M)
	add_overlay(motorcycle_cover)
	idle_sound.start(src)
	return ..()

/obj/vehicle/ridden/motorcycle/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		cut_overlay(motorcycle_cover)
	idle_sound.stop(src)
	return ..()

/obj/vehicle/ridden/motorcycle/click_alt_secondary(mob/user)
	if(!is_occupant(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, rev_cooldown))
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

/obj/vehicle/ridden/motorcycle/Move(newloc, dir)
	. = ..()
	if(!LAZYLEN(buckled_mobs))
		return

/obj/vehicle/ridden/motorcycle/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(I, /obj/item/sidecar))
		if(DOING_INTERACTION_WITH_TARGET(user, src))
			balloon_alert(user, "Already busy!")
			return FALSE
		if(LAZYLEN(buckled_mobs))
			balloon_alert("There is a rider already!")
			return TRUE
		balloon_alert(user, "You start attaching the sidecar...")
		if(!do_after(user, 3 SECONDS, NONE, src))
			return TRUE
		user.temporarilyRemoveItemFromInventory(I)
		I.forceMove(src)
		attached_sidecar = I
		cut_overlay(motorcycle_cover)
		motorcycle_cover.icon_state = "sidecar_cover"
		motorcycle_cover.icon = 'icons/obj/motorcycle_sidecar.dmi'
		motorcycle_cover.pixel_x = -9
		sidecar_dir_change(newdir = dir)
		RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(sidecar_dir_change))
		add_overlay(motorcycle_cover)
		RemoveElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)
		AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle/sidecar)
		max_buckled_mobs = 2
		max_occupants = 2
		return TRUE
	return ..()

/obj/vehicle/ridden/motorcycle/proc/sidecar_dir_change(datum/source, dir, newdir)
	SIGNAL_HANDLER
	switch(newdir)
		if(NORTH)
			pixel_x = 9
		if(SOUTH)
			pixel_x = -9
		if(EAST, WEST)
			pixel_x = 0

/obj/vehicle/ridden/motorcycle/wrench_act(mob/living/user, obj/item/I)
	if(!attached_sidecar)
		balloon_alert(user, "No sidecar attached!")
		return TRUE
	if(LAZYLEN(buckled_mobs))
		balloon_alert(user, "Someone is riding this!")
		return TRUE
	if(user.do_actions)
		balloon_alert(user, "Already busy!")
		return FALSE
	if(!do_after(user, 3 SECONDS, NONE, src))
		return TRUE
	attached_sidecar.forceMove(get_turf(src))
	attached_sidecar = null
	RemoveElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle/sidecar)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)
	max_buckled_mobs = 1
	max_occupants = 1
	cut_overlay(motorcycle_cover)
	motorcycle_cover.icon_state = "motorcycle_cover"
	motorcycle_cover.icon = 'icons/obj/vehicles.dmi'
	motorcycle_cover.pixel_x = 0
	pixel_x = initial(pixel_x)
	add_overlay(motorcycle_cover)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	balloon_alert(user, "You dettach the sidecar!")
	return TRUE

/obj/vehicle/ridden/golfcart/atom_break()
	. = ..()
	if (smoke)
		return
	smoke = new(src, /particles/smoke/ash)

/obj/vehicle/ridden/golfcart/atom_fix()
	. = ..()
	if (smoke)
		QDEL_NULL(smoke)

//internal storage
/obj/item/vehicle_module/storage/motorcycle
	name = "internal storage"
	desc = "A set of handy compartments to store things in."
	storage_type = /datum/storage/internal/motorcycle_pack

/**
 * Sidecar that when attached lets you put two people on the bike
 */
/obj/item/sidecar
	name = "motorcycle sidecar"
	desc = "A detached sidecar for TGMC motorcycles, which can be attached to them, allowing a second passenger. Use a wrench to dettach the sidecar."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "sidecar"

// vehicle component datums

/datum/component/riding/vehicle/motorcycle
	keytype = null
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER
	vehicle_move_delay = 1.25

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
