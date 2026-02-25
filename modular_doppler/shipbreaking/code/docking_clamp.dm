/obj/effect/temp_visual/telegraphing/long_duration
	duration = 10 SECONDS

/obj/machinery/docking_clamp
	name = "docking clamp"
	desc = "A large clamp for holding shuttles in place without using their own power."
	icon = 'icons/obj/machines/floor.dmi'
	icon_state = "mass_driver"
	/// The docking port we use to connect ships with
	var/obj/docking_port/stationary/docking_port
	/// The computer the clamp is linked to
	var/obj/machinery/computer/salvage_bay_controller/controller

/obj/machinery/docking_clamp/Destroy(force)
	if(controller)
		controller.delink_clamp()
	if(docking_port)
		QDEL_NULL(docking_port)
	return ..()

/obj/machinery/docking_clamp/interact(mob/user)
	. = ..()
	if(!can_interact(user))
		return
	if(docking_port)
		balloon_alert(user, "already set!")
		return
	ballon_alert(user, "setting clamp")
	if(!do_after(user, 2 SECONDS, src))
		return
	var/turf/dock_location = get_step(src, dir)
	docking_port = new(dock_location)
	var/list/docking_turfs = docking_port.return_turfs
	var/list/dock_bounds = docking_port.return_coords
	var/list/overlappers = SSshuttle.get_dock_overlap(dock_bounds[1], dock_bounds[2], dock_bounds[3], dock_bounds[4], z)
	if(length(overlappers))
		balloon_alert("intersecting nearby dock")
		QDEL_NULL(docking_port)
		return
	for(var/turf/checked_turf as anything in docking_turfs)
		if(checked_turf.x <= 10 || checked_turf.y <= 10 || checked_turf.x >= world.maxx - 10 || checked_turf.y >= world.maxy - 10)
			balloon_alert("cannot place here")
			new /obj/effect/temp_visual/telegraphing/long_duration(checked_turf)
			QDEL_NULL(docking_port)
			return
		var/area/turf_area = get_area(checked_turf)
		if(!is_space_or_openspace(turf_area) || checked_turf.is_blocked_turf(TRUE))
			balloon_alert("dock not clear")
			new /obj/effect/temp_visual/telegraphing/long_duration(checked_turf)
			QDEL_NULL(docking_port)
			return
		new /obj/effect/temp_visual/medical_holosign(checked_turf)
