/obj/item/circuitboard/machine/burner_plate
	name = "Burner Plate"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/burner_plate
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = FALSE

/obj/machinery/burner_plate
	name = "burner plate"
	desc = "A small tabletop plate for heating things in containers. You could use it for a lab, if you were a square, \
		but out here we're making <b>SOUP</b>."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "stove"
	base_icon_state = "stove"
	density = FALSE
	pass_flags = PASSTABLE
	anchored_tabletop_offset = 3
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/burner_plate
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.8

/obj/machinery/burner_plate/unanchored
	anchored = FALSE

/obj/machinery/burner_plate/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/soup_pot/lizard/mapload_container
	if(mapload)
		mapload_container = new(loc)
	AddComponent(/datum/component/stove, container_x = 0, container_y = 8, spawn_container = mapload_container)

/obj/machinery/burner_plate/wrench_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		balloon_alert(user, "panel closed!")
		return ITEM_INTERACT_BLOCKING
	if(!default_unfasten_wrench(user, tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/obj/machinery/burner_plate/screwdriver_act(mob/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		return ITEM_INTERACT_BLOCKING
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/burner_plate/crowbar_act(mob/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS
