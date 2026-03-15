/obj/structure/mineral_door/manual_colony_door/shuttle
	name = "manual exterior airlock"
	desc = "A manually operated airlock for the exteriors of ships, sized just enough to crawl through in zero gravity."
	icon = 'modular_doppler/shipbreaking/icons/doors.dmi'
	icon_state = "exterior"
	armor_type = /datum/armor/machinery_door
	disassembled_type = /obj/structure/hull_plating/airlock

/obj/structure/mineral_door/manual_colony_door/shuttle/welder_act(mob/living/user, obj/item/tool) //override if the door is supposed to be flammable.
	if(user.combat_mode)
		return
	balloon_alert(user, "cutting...")
	if(!tool.use_tool(src, user, 3 SECONDS, amount = 1, volume=50))
		return TRUE
	deconstruct(TRUE)
	return TRUE

/obj/structure/mineral_door/manual_colony_door/shuttle/wrench_act(mob/living/user, obj/item/tool)
	return

/obj/structure/mineral_door/manual_colony_door/shuttle/examine(mob/user)
	. = ..()
	. += span_notice("You can cut this free with a welding tool of some kind.")

/obj/structure/hull_plating/airlock
	name = "disconnected exterior airlock"
	desc = "A manually operated airlock for the exteriors of ships, this one looks to be disconnected from the frame."
	icon = 'modular_doppler/shipbreaking/icons/doors.dmi'
	icon_state = "exterior_free"
	armor_type = /datum/armor/machinery_door
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.75,
	)
	/// What kind of thing do we make when welded back down
	var/obj/reconnect_type = /obj/structure/mineral_door/manual_colony_door/shuttle

/obj/structure/hull_plating/airlock/examine(mob/user)
	. = ..()
	. += span_notice("You can secure this again with a welding tool of some kind.")

/obj/structure/hull_plating/airlock/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return
	balloon_alert(user, "securing...")
	if(!tool.use_tool(src, user, 3 SECONDS, amount = 1, volume=50))
		return TRUE
	new reconnect_type(get_turf(src))
	qdel(src)
	return TRUE

/obj/structure/mineral_door/manual_colony_door/shuttle/interior
	name = "manual interior airlock"
	desc = "A manually operated airlock for the exteriors of ships, walkable and quicker to open than heavier airlocks."
	icon_state = "interior"
	disassembled_type = /obj/structure/hull_plating/airlock/interior
	manual_actuation_delay = 0.25 SECONDS

/obj/structure/hull_plating/airlock/interior
	name = "disconnected interior airlock"
	desc = "A manually operated airlock for the interiors of ships, this one looks to be disconnected from the frame."
	icon_state = "interior_free"
	reconnect_type = /obj/structure/mineral_door/manual_colony_door/shuttle/interior

/obj/structure/shuttle_access_panel
	name = "maintenance panel"
	desc = "A maintenance panel used for access to crawlspaces and engines in ships, has to be cut from the frame."
	icon = 'modular_doppler/shipbreaking/icons/doors.dmi'
	icon_state = "access"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	max_integrity = 150
	armor_type = /datum/armor/machinery_door
	/// What does this unweld into
	var/obj/disassembled_type = /obj/structure/hull_plating/airlock/access_panel

/obj/structure/shuttle_access_panel/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return
	balloon_alert(user, "cutting...")
	if(!tool.use_tool(src, user, 3 SECONDS, amount = 1, volume=50))
		return TRUE
	new disassembled_type(get_turf(src))
	qdel(src)
	return TRUE

/obj/structure/hull_plating/airlock/access_panel
	name = "disconnected maintenance panel"
	desc = "A maintenance panel used for access to crawlspaces and engines in ships, this one has been cut from the frame."
	icon_state = "access_free"
	reconnect_type = /obj/structure/mineral_door/manual_colony_door/shuttle/interior
