/obj/item/circuitboard/machine/colony_wind_turbine
	name = "Wind Turbine"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/colony_wind_turbine
	req_components = list(
		/datum/stock_part/capacitor = 1,
	)

/obj/machinery/power/colony_wind_turbine
	name = "miniature wind turbine"
	desc = "A post with two special-designed vertical turbine blades attached to its sides. \
		When placed outdoors in a planet with an atmosphere, will produce a small trickle of power \
		for free. If there is a storm in the area the turbine is placed, the power production will \
		multiply significantly."
	icon = 'modular_doppler/colony_fabricator/icons/wind_turbine.dmi'
	icon_state = "turbine"
	density = TRUE
	max_integrity = 100
	idle_power_usage = 0
	anchored = TRUE
	can_change_cable_layer = FALSE
	circuit = /obj/item/circuitboard/machine/colony_wind_turbine
	layer = ABOVE_MOB_LAYER
	can_change_cable_layer = TRUE
	/// How much power the turbine makes without a storm
	var/regular_power_production = 2.5 KILO WATTS
	/// How much power the turbine makes during a storm
	var/storm_power_production = 10 KILO WATTS
	/// Is our pressure too low to function?
	var/pressure_too_low = FALSE
	/// Minimum external pressure needed to work
	var/minimum_pressure = 5

/obj/machinery/power/colony_wind_turbine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)
	connect_to_network()

/obj/machinery/power/colony_wind_turbine/examine(mob/user)
	. = ..()
	var/area/turbine_area = get_area(src)
	if(!turbine_area.outdoors)
		. += span_notice("Its must be constructed <b>outdoors</b> to function.")
	if(pressure_too_low)
		. += span_notice("There must be enough atmospheric <b>pressure</b> for the turbine to spin.")

/obj/machinery/power/colony_wind_turbine/RefreshParts()
	. = ..()
	regular_power_production = initial(regular_power_production)
	storm_power_production = initial(storm_power_production)
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		regular_power_production += 1 KILO WATTS * (capacitor.tier - 1)
		storm_power_production += 1 KILO WATTS * (capacitor.tier - 1)

/obj/machinery/power/colony_wind_turbine/process()
	var/area/our_current_area = get_area(src)
	if(!our_current_area.outdoors)
		icon_state = "turbine"
		add_avail(0)
		return
	var/turf/our_turf = get_turf(src)
	var/datum/gas_mixture/environment = our_turf.return_air()
	if(environment.return_pressure() < minimum_pressure)
		pressure_too_low = TRUE
		icon_state = "turbine"
		add_avail(0)
		return
	pressure_too_low = FALSE
	var/storming_out = FALSE
	var/datum/weather/weather_we_track
	for(var/datum/weather/possible_weather in SSweather.processing)
		if((our_turf.z in possible_weather.impacted_z_levels) || (our_current_area in possible_weather.impacted_areas))
			weather_we_track = possible_weather
			break
	if(weather_we_track)
		if(!(weather_we_track.stage == END_STAGE))
			storming_out = TRUE
	add_avail(power_to_energy(storming_out ? storm_power_production : regular_power_production))
	var/new_icon_state = (storming_out ? "turbine_storm" : "turbine_normal")
	icon_state = new_icon_state

/obj/machinery/power/colony_wind_turbine/screwdriver_act(mob/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		return ITEM_INTERACT_BLOCKING
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/colony_wind_turbine/crowbar_act(mob/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS
