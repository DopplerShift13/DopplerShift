/turf/open/water/vintage
	name = "shallow water"
	desc = "A pool of water, is it a pond? Is it a river? I don't know, you're the one looking at it, you tell me."
	icon = 'icons/turf/fantasystation/water.dmi'
	icon_state = "water"
	baseturfs = /turf/open/water/vintage
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	immerse_overlay_color = "#247296"

/turf/open/water/vintage/deep
	name = "deep water"
	desc = "Water that is both much too deep and with much too strong of a current to safely pass. If you had a ship of some kind however..."
	icon_state = "deepwater"
	baseturfs = /turf/open/water/vintage/deep
	immerse_overlay_color = "#247296"

/turf/open/water/vintage/deep/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	// If the thing is an abstract object, do we really need to worry about it?
	if(arrived.invisibility == INVISIBILITY_ABSTRACT)
		return
	// If they are buckled to something, then they are either on a boat or buckled to a mob, which will get repelled anyways
	if(ismob(arrived))
		var/mob/arriving_mob = arrived
		if(arriving_mob.buckled)
			return
	// If the arrived thing is allowed to pass water, then we're not worried about throwing them away
	if(HAS_TRAIT(arrived, TRAIT_DEEP_WATER_PASSER))
		return
	// If they fail the above, however....
	var/atom/throw_target = get_edge_target_turf(arrived, get_dir(src, old_loc))
	if(isliving(arrived))
		to_chat(arrived, span_userdanger("The fierce currents wash you away!"))
	playsound(src, 'sound/effects/submerge.ogg', 50, TRUE)
	arrived.throw_at(throw_target, 1, 2)
	arrived.forceMove(old_loc) // Safety measure (DIAGONAL MOVEMENT!!!)

/turf/open/water/vintage/swamp
	name = "murky water"
	desc = "Gnarly green water that you can barely see through. It's likely there's a million different bugs and parasites in this, but you'd win, right?"
	icon_state = "swamp"
	baseturfs = /turf/open/water/vintage/swamp
	immerse_overlay_color = "#547e64"
