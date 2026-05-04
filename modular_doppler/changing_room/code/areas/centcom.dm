/area/centcom/changing_room
	name = "Changing Room Dreamscape"
	area_flags = parent_type::area_flags | NO_DEATH_MESSAGE
	mood_bonus = 25
	mood_message = "I think I'm dreaming..."

/area/centcom/changing_room/LateInitialize()
	. = ..()
	for(var/obj/machinery/light/light as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(!istype(get_area(light), src))
			continue
		light.fix()
		CHECK_TICK
