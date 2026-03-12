/obj/effect/temp_visual/telegraphing/long_duration
	duration = 15 SECONDS

/obj/machinery/docking_clamp
	name = "salvage clamp"
	desc = "A large clamp for holding shuttles in place without using their own power."
	icon = 'icons/obj/machines/floor.dmi'
	icon_state = "mass_driver"
	use_power = NO_POWER_USE
	/// The docking port we use to connect ships with
	var/obj/docking_port/stationary/salvage_dock/docking_port
	/// The computer the clamp is linked to
	var/obj/machinery/computer/salvage_bay_controller/controller

/obj/machinery/docking_clamp/Destroy(force)
	if(controller)
		controller.delink_clamp()
	if(docking_port)
		QDEL_NULL(docking_port)
	return ..()

/obj/machinery/docking_clamp/examine(mob/user)
	. = ..()
	if(!controller)
		. += span_notice("Use a [EXAMINE_HINT("multitool")] to connect this to a [EXAMINE_HINT("salvage bay control console")] before use.")
	if(!docking_port)
		. += span_notice("Interact with the clamp to set it up for docking, otherwise it will not function.")
		. += span_notice("The clamp requires a large space in front of it, indicated by holograms on setup.")
		. += span_notice("This space is [EXAMINE_HINT("[floor(/obj/docking_port/stationary/salvage_dock::width / 2)]")] tiles to either side of the clamp, and [EXAMINE_HINT("[/obj/docking_port/stationary/salvage_dock::height]")] tiles straight out.")

/obj/machinery/docking_clamp/multitool_act(mob/living/user, obj/item/multitool/the_tool)
	if(!panel_open)
		balloon_alert(user, "panel closed!")
		return ITEM_INTERACT_BLOCKING
	the_tool.set_buffer(src)
	balloon_alert(user, "saved to multitool buffer")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/docking_clamp/wrench_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		balloon_alert(user, "panel closed!")
		return ITEM_INTERACT_BLOCKING
	if(!default_unfasten_wrench(user, tool, 4 SECONDS))
		return ITEM_INTERACT_BLOCKING
	if(!anchored)
		QDEL_NULL(docking_port)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/docking_clamp/screwdriver_act(mob/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		return ITEM_INTERACT_BLOCKING
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/docking_clamp/crowbar_act(mob/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/obj/machinery/docking_clamp/interact(mob/user)
	if(!can_interact(user))
		return
	if(!anchored)
		balloon_alert(user, "not secured!")
		return ..()
	if(docking_port)
		balloon_alert(user, "already set!")
		return ..()
	balloon_alert(user, "setting clamp")
	if(!do_after(user, 2 SECONDS, src))
		return ..()
	var/turf/dock_location = get_step(src, dir)
	var/obj/docking_port/stationary/salvage_dock/temp_docking_port = new(dock_location, dir)
	var/list/docking_turfs = temp_docking_port.return_turfs()
	var/list/dock_bounds = temp_docking_port.return_coords()
	var/list/overlappers = SSshuttle.get_dock_overlap(dock_bounds[1], dock_bounds[2], dock_bounds[3], dock_bounds[4], z)
	if(length(overlappers)) // Overlappers list contains ourself as well
		for(var/dock as anything in overlappers)
			if(dock == temp_docking_port)
				continue
			balloon_alert(user, "intersecting nearby dock")
			temp_docking_port.Destroy(TRUE)
			return ..()
	for(var/turf/checked_turf as anything in docking_turfs)
		if(checked_turf.x <= 10 || checked_turf.y <= 10 || checked_turf.x >= world.maxx - 10 || checked_turf.y >= world.maxy - 10)
			balloon_alert(user, "cannot place here")
			new /obj/effect/temp_visual/telegraphing/long_duration(checked_turf)
			temp_docking_port.Destroy(TRUE)
			return ..()
		var/area/turf_area = get_area(checked_turf)
		if(!is_space_or_openspace(checked_turf) || checked_turf.is_blocked_turf(TRUE) || !is_area_nearby_station(turf_area))
			balloon_alert(user, "dock not clear")
			new /obj/effect/temp_visual/telegraphing/long_duration(checked_turf)
			temp_docking_port.Destroy(TRUE)
			return ..()
		new /obj/effect/temp_visual/medical_holosign(checked_turf)
	docking_port = temp_docking_port
	return ..()

/obj/docking_port/stationary/salvage_dock
	name = "Salvage Dock"
	width = 31
	height = 19
	dwidth = 15

/obj/docking_port/stationary/salvage_dock/Initialize(mapload, dock_direction)
	setDir(dock_direction)
	. = ..()
