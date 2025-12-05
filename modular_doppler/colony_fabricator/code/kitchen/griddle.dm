/obj/item/circuitboard/machine/table_griddle
	name = "Tabletop Griddle"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/griddle/frontier_tabletop
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = FALSE

/obj/machinery/griddle/frontier_tabletop
	name = "tabletop griddle"
	desc = "A griddle made to be compact enough to sit on top of your tables, instead of \
		forcing you to drag a full size kitchen griddle wherever you want to cook."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "griddletable_off"
	variant = "table" // Note, stops it from trying to randomize sprites
	pass_flags_self = LETPASSTHROW
	pass_flags = PASSTABLE
	circuit = /obj/item/circuitboard/machine/table_griddle
	// Lines up perfectly with tables when anchored on them
	anchored_tabletop_offset = 1

/obj/machinery/griddle/frontier_tabletop/unanchored
	anchored = FALSE
