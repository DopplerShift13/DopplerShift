/obj/item/circuitboard/machine/organic_printer
	name = "Organic Materials Printer"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/biogenerator/organic_printer
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/machinery/biogenerator/organic_printer
	name = "organic materials printer"
	desc = "A complex recycler and chemical plant combined into one convenient box in order to turn \
		waste biomatter like leftover food and plants, into different organic materials like plastics."
	icon = 'modular_doppler/colony_fabricator/icons/biogenerator.dmi'
	circuit = /obj/item/circuitboard/machine/organic_printer
