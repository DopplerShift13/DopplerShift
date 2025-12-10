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
	needs_anchored = FALSE

/obj/machinery/biogenerator/organic_printer
	name = "organic materials printer"
	desc = "A complex recycler and chemical plant combined into one convenient box in order to turn \
		waste biomatter like leftover food and plants, into different organic materials like plastics."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	circuit = /obj/item/circuitboard/machine/organic_printer
	show_categories = list(
		ORGANICS_PRINTER_CLOTHES,
		ORGANICS_PRINTER_GEAR,
		ORGANICS_PRINTER_MATERIALS,
		ORGANICS_PRINTER_SEEDS,
		ORGANICS_PRINTER_FOOD,
		ORGANICS_PRINTER_MEDICAL,
	)

/obj/machinery/biogenerator/organic_printer/Initialize(mapload)
	. = ..()
	if(!GLOB.autounlock_techwebs[/datum/techweb/autounlocking/organic_printer])
		GLOB.autounlock_techwebs[/datum/techweb/autounlocking/organic_printer] = new /datum/techweb/autounlocking/organic_printer
	stored_research = GLOB.autounlock_techwebs[/datum/techweb/autounlocking/organic_printer]

/datum/design/organic_printer

/datum/techweb/autounlocking/organic_printer
	allowed_buildtypes = NONE

/datum/techweb/autounlocking/New()
	. = ..()
	for(var/id in SSresearch.techweb_designs)
		var/datum/design/design = SSresearch.techweb_designs[id]
		if(!istype(design, /datum/design/organic_printer))
			continue
		if(RND_CATEGORY_INITIAL in design.category)
			add_design_by_id(id)
		if(RND_CATEGORY_HACKED in design.category)
			add_design_by_id(id, add_to = hacked_designs)
