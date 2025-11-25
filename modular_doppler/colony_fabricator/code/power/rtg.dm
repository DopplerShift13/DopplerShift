/obj/item/circuitboard/machine/colony_rtg
	name = "Radioisotope Thermoelectric Generator"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/rtg/portable
	req_components = list(
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/sheet/mineral/uranium = 3,
	)

/obj/machinery/power/rtg/portable
	name = "radioisotope thermoelectric generator"
	desc = "The ultimate in 'middle of nowhere' power generation. \
		This type emits radiation, however it is weak enough to be blocked by simple shielding \
		like metal girders. Produces more power than some other RTG designs."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	circuit = /obj/item/circuitboard/machine/colony_rtg
	power_gen = 2 KILO WATTS

/obj/machinery/power/rtg/portable/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/radioactive, threshold = RAD_VERY_LIGHT_INSULATION, minimum_exposure_time = NEBULA_RADIATION_MINIMUM_EXPOSURE_TIME)
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/machinery/power/rtg/portable/RefreshParts()
	. = ..()
	power_gen = initial(power_gen)
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_gen += (0.5 KILO WATTS) * capacitor.tier // 2.5 KW is the default
