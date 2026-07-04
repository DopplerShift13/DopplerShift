/area/shuttle/insertion_vehicle
	name = "Response Corps Insertion Vehicle"

/obj/docking_port/mobile/insertion_vehicle
	name = "response corps insertion vehicle"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	dir = WEST
	port_direction = NORTH
	preferred_direction = EAST
	shuttle_id = "parc_insertion_vehicle"

/obj/machinery/computer/shuttle/insertion_vehicle
	name = "insertion vehicle console"
	desc = "A wall-mounted control console that directs the insertion vehicle."
	shuttleId = "parc_insertion_vehicle"
	possible_destinations = "ferry_away;parc_insertion_vehicle_custom;whiteship_home;syndicate_nw"
	req_access = list(ACCESS_CENT_GENERAL)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "pod_off"
	light_color = LIGHT_COLOR_BLUE
	density = FALSE
	icon_keyboard = null
	icon_screen = "pod_on"
	var/allow_silicons = FALSE
	var/allow_emag = FALSE

/obj/machinery/computer/shuttle/insertion_vehicle/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(!allow_emag)
		balloon_alert(user, "firewall too powerful!")
		return FALSE
	return ..()

/obj/machinery/computer/shuttle/insertion_vehicle/attack_ai()
	return allow_silicons ? ..() : FALSE

/obj/machinery/computer/shuttle/insertion_vehicle/attack_robot()
	return allow_silicons ? ..() : FALSE

/obj/machinery/computer/camera_advanced/shuttle_docker/insertion_vehicle
	name = "insertion vehicle navigation computer"
	desc = "Used to designate a precise transit location for the insertion vehicle."
	shuttleId = "parc_insertion_vehicle"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "parc_insertion_vehicle_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)
	whitelist_turfs = list(/turf/open/space, /turf/open/floor/plating, /turf/open/lava, /turf/closed/mineral, /turf/open/openspace, /turf/open/misc)
	see_hidden = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
