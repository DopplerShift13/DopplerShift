// Walls

/turf/closed/wall/crag_concrete
	name = "eclogiticrete wall"
	desc = "A solid block of eclogiticrete, the color makes you think of the dust on Crag's surface. They were probably made of the same thing."
	icon = 'icons/_smooth_doppler/turfs/closed/concrete.dmi'
	icon_state = "concrete-0"
	base_icon_state = "concrete"
	hardness = 60
	slicing_duration = 5 SECONDS
	sheet_type = /obj/item/stack/sheet/crag_concrete
	sheet_amount = 1

/turf/closed/wall/crag_concrete/deconstruction_hints(mob/user)
	return span_notice("It could be broken apart with a <b>mining tool</b>.")

/turf/closed/wall/crag_concrete/try_decon(obj/item/tool, mob/user)
	if(tool.tool_behaviour != TOOL_MINING)
		return FALSE
	user.balloon_alert_to_viewers("breaking...")
	Shake(1, 1, 1 SECONDS)
	if(tool.use_tool(src, user, slicing_duration, volume=100))
		if(iswallturf(src))
			to_chat(user, span_notice("You break down [src]."))
			dismantle_wall()
		return TRUE
	return FALSE

/turf/closed/wall/crag_concrete/dismantle_wall(devastated = FALSE, explode = FALSE)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
		var/newgirder = break_wall()
		if(newgirder)
			transfer_fingerprints_to(newgirder)
	for(var/obj/object in src.contents)
		if(istype(object, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/poster = object
			INVOKE_ASYNC(poster, TYPE_PROC_REF(/obj/structure/sign/poster, roll_and_drop), src)
	if(decon_type)
		ChangeTurf(decon_type, flags = CHANGETURF_INHERIT_AIR)
	else
		ScrapeAway()
	QUEUE_SMOOTH_NEIGHBORS(src)

// Floors

/obj/item/stack/tile/crag_concrete
	name = "eclogiticrete panels"
	singular_name = "eclogiticrete panel"
	desc = "Ready-to-lay eclogiticrete panels, perfect for cheap landing pads and runways."
	icon = 'modular_doppler/mapping/crag_outpost/icons/items.dmi'
	icon_state = "concrete_tile"
	turf_type = /turf/open/floor/iron/crag_concrete
	merge_type = /obj/item/stack/tile/crag_concrete
	tile_reskin_types = list(
		/obj/item/stack/tile/crag_concrete,
		/obj/item/stack/tile/crag_concrete/smooth,
	)

/turf/open/floor/iron/crag_concrete
	name = "eclogiticrete tiles"
	icon = 'modular_doppler/mapping/crag_outpost/icons/floor.dmi'
	icon_state = "tiled_concrete"
	floor_tile = /obj/item/stack/tile/crag_concrete
	rust_resistance = RUST_RESISTANCE_REINFORCED

/obj/item/stack/tile/crag_concrete/smooth
	name = "eclogiticrete flooring"
	singular_name = "eclogiticrete flooring"
	desc = "Ready-to-lay eclogiticrete flooring, perfect for parking lots in front of waffle canteens."
	icon_state = "concrete_smooth"
	turf_type = /turf/open/floor/iron/crag_concrete/smooth

/turf/open/floor/iron/crag_concrete/smooth
	name = "eclogiticrete flooring"
	icon = 'icons/_smooth_doppler/turfs/open/concrete.dmi'
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CRAG_CONCRETE + SMOOTH_GROUP_OPEN_FLOOR
	canSmoothWith = SMOOTH_GROUP_CRAG_CONCRETE
	floor_tile = /obj/item/stack/tile/crag_concrete
