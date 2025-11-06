/obj/item/circuitboard/machine/plasma_mini_turbine
	name = "Plasma Micro-Turbine"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/stirling_generator
	needs_anchored = FALSE
	req_components = list(
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 2,
		/obj/item/stack/sheet/mineral/titanium = 2,
		/obj/item/stack/cable_coil = 5,
	)

// Plasma microturbine, pump in specifically gaseous plasma which will be consumed in small amounts to make a lot of power
/obj/machinery/power/stirling_generator
	name = "plasma micro-turbine"
	desc = "A compact turbine engine that consumes small amounts of plasma gas in order to produce a large \
		amount of power, in exchange for outputting a waste gas from the process out at freezing temperatures. \
		You should absolutely not stick your hand into the exposed fan blades out of the top."
	icon = 'modular_doppler/colony_fabricator/icons/stirling_generator/big_generator.dmi'
	icon_state = "stirling"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/plasma_mini_turbine
	max_integrity = 300
	armor_type = /datum/armor/unary_thermomachine
	set_dir_on_move = FALSE
	can_change_cable_layer = TRUE
	/// Reference to the datum connector we're using to interface with the pipe network
	var/datum/gas_machine_connector/connected_chamber
	/// Maximum power output from this machine
	var/max_power_output = 50 KILO WATTS
	/// How much power the generator is currently making
	var/current_power_generation
	/// Our looping fan sound that we play when turned on
	var/datum/looping_sound/ore_thumper_fan/soundloop
	/// What power level are we working at, multiplies fuel usage
	var/power_level = 1

/obj/machinery/power/stirling_generator/Initialize(mapload)
	. = ..()
	soundloop = new(src, FALSE)
	connected_chamber = new(loc, src, dir, CELL_VOLUME * 0.5)
	connect_to_network()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)
	// This is just to make sure our atmos connection spawns facing the right way
	setDir(dir)

/obj/machinery/power/stirling_generator/examine(mob/user)
	. = ..()
	. += span_notice("You can use a <b>wrench</b> with <b>Left-Click</b> to rotate the generator.")
	. += span_notice("It needs <b>plasma gas</b> through it's input pipe in order to work.")
	. += span_notice("It will output <b>freezing helium</b> while running, which needs to be dealt with.")
	. += span_notice("It is currently generating <b>[display_power(current_power_generation, convert = FALSE)]</b> of power.")

/obj/machinery/power/stirling_generator/Destroy()
	QDEL_NULL(connected_chamber)
	return ..()

/obj/machinery/power/stirling_generator/RefreshParts()
	. = ..()
	max_power_output = initial(max_power_output)
	power_level = 1
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_level = capacitor.tier
		max_power_output *= (capacitor.tier / 2)

/obj/machinery/power/stirling_generator/process_atmos()
	if(!powernet)
		connect_to_network()
		if(!powernet)
			return
	var/turf/our_turf = get_turf(src)
	var/datum/gas_mixture/plasma_inlet = connected_chamber.gas_connector.airs[1]
	if(!QUANTIZE(plasma_inlet.total_moles())) //Don't transfer if there's no gas
		current_power_generation = 0
		return
	if(!plasma_inlet.has_gas(/datum/gas/plasma, 2 * power_level))
		current_power_generation = 0
		return
	plasma_inlet.remove_specific(/datum/gas/plasma, 1 * power_level)
	var/turf/where_we_spawn_air = get_turf(src)
	where_we_spawn_air.atmos_spawn_air("helium=[1 * power_level];TEMP=193")
	current_power_generation = max_power_output

/obj/machinery/power/stirling_generator/process()
	add_avail(power_to_energy(current_power_generation))
	var/new_icon_state = (current_power_generation ? "stirling_on" : "stirling")
	icon_state = new_icon_state
	if(soundloop.is_active() && !current_power_generation)
		soundloop.stop()
	else if(!soundloop.is_active() && current_power_generation)
		soundloop.start()

/obj/machinery/power/stirling_generator/wrench_act(mob/living/user, obj/item/tool)
	return default_change_direction_wrench(user, tool)

/obj/machinery/power/stirling_generator/default_change_direction_wrench(mob/user, obj/item/wrench)
	if(wrench.tool_behaviour != TOOL_WRENCH)
		return FALSE
	wrench.play_tool_sound(src, 50)
	setDir(turn(dir,-90))
	to_chat(user, span_notice("You rotate [src]."))
	SEND_SIGNAL(src, COMSIG_MACHINERY_DEFAULT_ROTATE_WRENCH, user, wrench)
	return TRUE

/obj/machinery/power/stirling_generator/Destroy()
	QDEL_NULL(connected_chamber)
	return ..()
