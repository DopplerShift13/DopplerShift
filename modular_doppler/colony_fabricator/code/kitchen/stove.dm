/obj/item/circuitboard/machine/burner_plate
	name = "Burner Plate"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/burner_plate
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = TRUE

/obj/machinery/burner_plate
	name = "burner plate"
	desc = "A small tabletop plate for heating things in containers. You could use it for a lab, if you were a square, \
		but out here we're making <b>SOUP</b>."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "stove"
	base_icon_state = "stove"
	density = FALSE
	pass_flags = PASSTABLE
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/burner_plate
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.8

/obj/machinery/burner_plate/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/soup_pot/lizard/mapload_container
	if(mapload)
		mapload_container = new(loc)
	AddComponent(/datum/component/stove, container_x = 0, container_y = 8, spawn_container = mapload_container)

// Pot
/obj/item/reagent_containers/cup/soup_pot/lizard
	name = "copper soup pot"
	desc = "A stout soup designed to mix and cook all kinds of Tizirian soup."
	icon = 'modular_doppler/colony_fabricator/icons/items.dmi'
	volume = 150
	possible_transfer_amounts = list(20, 50, 100, 150)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5) // WE were LIED TO
	max_ingredients = 18
