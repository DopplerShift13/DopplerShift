/// Tosses you around physically into various dangerous objects.
/datum/psyker_event/catastrophic/tossed_around
	lingering = TRUE
	weight = PSYKER_EVENT_RARITY_UNCOMMON

	/// Pity system
	var/max_ticks = 20

	/// The throw range
	var/throw_range = 10
	/// The throw speed
	var/throw_speed = 3

	/// Hand-made list of objects we prefer to smash people into, and will default to when throwing. Should only contain items with funny effects when thrown into them.
	var/list/special_object_types = list(
		/turf/open/chasm, // this one's evil
		/turf/open/space,
		/turf/open/lava, // how cooked do you want your spaceman
		/turf/open/floor/tram/plate, // THE TRAM CALLS
		/obj/structure/table/glass,
		/obj/structure/window,
		/obj/structure/grille,
		/obj/machinery/teleport/hub,
		/obj/machinery/vending, // we have a special interaction where there is a chance they're knocked over.
		/obj/structure/musician, // they make funny noises
		/obj/machinery/disposal, // flushes you too
		/obj/machinery/power/supermatter_crystal, // if you break down next to a SM crystal you deserve this
		/mob/living,

	)

	/// typecach for reference sake
	var/static/list/special_object_typecache
	/// Track impact handling for this event
	var/mob/living/carbon/human/impact_owner
	/// Are we expecting the mob to impact a surface.
	var/expecting_impact = FALSE

/datum/psyker_event/catastrophic/tossed_around/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("Your Resonant powers send you hurling through the air!"))
	RegisterSignal(psyker, COMSIG_MOVABLE_IMPACT, PROC_REF(on_toss_impact))
	impact_owner = psyker
	addtimer(CALLBACK(src, PROC_REF(_toss_tick), psyker, 0), 1 SECONDS)
	return TRUE

/// Every tick, we try to fling the mob at dangerous things; or in random directs, and then determine if we want to do it AGAIN
/datum/psyker_event/catastrophic/tossed_around/proc/_toss_tick(mob/living/carbon/human/psyker, tick_count)
	if(!psyker || QDELETED(psyker))
		qdel(src)
		return
	if(tick_count >= max_ticks)
		qdel(src)
		return

	// no escape
	psyker.Knockdown(3 SECONDS)

	if(!special_object_typecache)
		special_object_typecache = typecacheof(special_object_types)

	var/list/nearby_specials = typecache_filter_list(oview(throw_range, psyker), special_object_typecache)
	var/list/valid_specials = list()

	for(var/atom/special as anything in nearby_specials)
		if(special == psyker) // makes it so mob/living doesnt throw the psyker at themselves
			continue
		if(can_see(psyker, special, throw_range))
			valid_specials += special

	var/turf/target_turf
	var/atom/target_special
	if(length(valid_specials)) // if we have special things to throw people at
		target_special = pick(valid_specials)
		target_turf = get_turf(target_special)
	else // if we don't: just toss them somewhere random
		target_turf = get_ranged_target_turf(psyker, pick(GLOB.alldirs), throw_range)

	var/datum/callback/throw_callback
	if(target_turf) // YEET!
		psyker.throw_at(target_turf, range = throw_range, speed = throw_speed, thrower = psyker, spin = TRUE, callback = throw_callback)

	// 95% chance to continue applying effects
	if(!prob(95))
		qdel(src)
		return

	addtimer(CALLBACK(src, PROC_REF(_toss_tick), psyker, tick_count + 1), 1 SECONDS)

/// Forcefully flushes disposals on impact
/datum/psyker_event/catastrophic/tossed_around/proc/flush_disposal(mob/living/carbon/human/psyker, obj/machinery/disposal/target_disposal)
	if(!psyker || QDELETED(psyker) || !target_disposal || QDELETED(target_disposal))
		return
	target_disposal.flush()
	return

/// Runs a variety of on-hit effects when tossed into a surface.
/datum/psyker_event/catastrophic/tossed_around/proc/on_toss_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/psyker = source
	if(!psyker || QDELETED(psyker))
		return

	// At least 5 brute on any impact
	psyker.apply_damage(5, BRUTE)

	// If we hit a disposal bin, force the mob into it and flush.
	if(istype(hit_atom, /obj/machinery/disposal))
		var/obj/machinery/disposal/target_disposal = hit_atom
		if(psyker.loc != target_disposal)
			psyker.forceMove(target_disposal)
			target_disposal.update_appearance()
			target_disposal.flush = TRUE
	// If we hit a vending machine, give it a chance to knock over onto the psyker.
	else if(istype(hit_atom, /obj/machinery/vending))
		if(prob(50))
			var/obj/machinery/vending/vendor = hit_atom
			vendor.tilt(psyker)

/datum/psyker_event/catastrophic/tossed_around/Destroy()
	if(impact_owner)
		UnregisterSignal(impact_owner, COMSIG_MOVABLE_IMPACT)
		impact_owner = null
	return ..()
