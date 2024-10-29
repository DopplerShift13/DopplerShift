/// Base fantasystation organic floor types, like mats and whatnot, basetype is dried grass

/turf/open/floor/fantasy_organic
	name = "grass floor mat"
	desc = "A woven mat made of dried grass. Can be cut apart with a knife."
	icon = 'icons/obj/fantasystation_obj/floors/grassmat.dmi'
	icon_state = "grassmat-0"
	base_icon_state = "grassmat"
	baseturfs = /turf/baseturf_bottom // These shouldnt be map placed ever but just in case
	floor_tile = null
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SGROUP_GRASS_MAT
	canSmoothWith = SGROUP_GRASS_MAT
	flags_1 = NONE
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	/// What we make when we're torn up
	var/obj/torn_up_result = /obj/item/fantasy_cut_grass

/turf/open/floor/fantasy_organic/broken_states()
	return

/turf/open/floor/fantasy_organic/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/open/floor/fantasy_organic/attackby(obj/item/object, mob/living/user, params)
	if(object.tool_behaviour == TOOL_KNIFE)
		if(!do_after(user, 3 SECONDS, src))
			return
		playsound(src, 'sound/items/weapons/bladeslice.ogg', 50, TRUE)
		new torn_up_result(src)
		src.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	else
		return ..()

/// Reed mats

/turf/open/floor/fantasy_organic/reed
	name = "reed floor mat"
	desc = "A woven mat made of river reeds. Can be cut apart with a knife."
	icon = 'icons/obj/fantasystation_obj/floors/reedmat.dmi'
	icon_state = "reedmat-0"
	base_icon_state = "reedmat"
	torn_up_result = /obj/item/fantasy_cut_cattail
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SGROUP_REED_MAT
	canSmoothWith = SGROUP_REED_MAT

/// Brick floors

/turf/open/floor/fantasy_brick
	name = "ceramic brick floor"
	desc = "A neat arrangement of bricks to make a passable floor, can be pried up with a knife."
	icon = 'icons/obj/fantasystation_obj/floors/bricks.dmi'
	icon_state = "claybricks"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	flags_1 = NONE
	floor_tile = null
	/// What we make when we're torn up
	var/obj/torn_up_result = /obj/item/fantasy_cut_grass

/turf/open/floor/fantasy_brick/broken_states()
	return

/turf/open/floor/fantasy_brick/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/open/floor/fantasy_brick/attackby(obj/item/object, mob/living/user, params)
	if(object.tool_behaviour == TOOL_KNIFE)
		if(!do_after(user, 3 SECONDS, src))
			return
		playsound(src, SFX_ROCK_TAP, 50, TRUE)
		new torn_up_result(src)
		src.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	else
		return ..()
