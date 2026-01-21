/obj/item/circuitboard/machine/amenity_autolathe
	name = "Microlathe"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/autolathe/colony_amenities
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/datum/techweb/autounlocking/amenitylathe
	allowed_buildtypes = AMENITY_LATHE

/obj/machinery/autolathe/colony_amenities
	name = "microlathe"
	desc = "An all-in-one recycler and tool maker, creating anything from pots and plates, to batteries and filters."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	circuit = /obj/item/circuitboard/machine/amenity_autolathe

/obj/machinery/autolathe/colony_amenities/Initialize(mapload)
	. = ..()
	if(!GLOB.autounlock_techwebs[/datum/techweb/autounlocking/amenitylathe])
		GLOB.autounlock_techwebs[/datum/techweb/autounlocking/amenitylathe] = new /datum/techweb/autounlocking/amenitylathe
	stored_research = GLOB.autounlock_techwebs[/datum/techweb/autounlocking/amenitylathe]

/obj/machinery/autolathe/colony_amenities/AfterMaterialInsert(container, obj/item/item_inserted, last_inserted_id, mats_consumed, amount_inserted, atom/context)
	return

/obj/machinery/autolathe/colony_amenities/finalize_build()
	. = ..()
	flick("autolathe_finish_print", src)
