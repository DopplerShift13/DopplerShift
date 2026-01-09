/obj/item/circuitboard/machine/plasma_mini_turbine
	name = "Plasma Micro-Turbine"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/stirling_generator
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
		amount of power, in exchange for the process putting out a waste gas at freezing temperatures. \
		You should absolutely not stick your hand into the exposed fan blades out of the top."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
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
	var/datum/looping_sound/plasma_turbine_fan/soundloop
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
	register_context()

/obj/machinery/power/stirling_generator/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		return NONE
	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "Rotate clockwise"
		return CONTEXTUAL_SCREENTIP_SET
	if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "Close" : "Open"] panel"
		return CONTEXTUAL_SCREENTIP_SET
	if(panel_open && held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/power/stirling_generator/examine(mob/user)
	. = ..()
	. += span_notice("When the panel is [EXAMINE_HINT("screwed open")], you can use a [EXAMINE_HINT("wrench")] with [EXAMINE_HINT("Left-Click")] to rotate the generator.")
	. += span_notice("It needs [EXAMINE_HINT("plasma gas")] through it's input pipe in order to work.")
	. += span_notice("It will output [EXAMINE_HINT("freezing helium")] while running, which needs to be dealt with.")
	. += span_notice("It is currently generating [EXAMINE_HINT("[display_power(current_power_generation, convert = FALSE)]")] of power.")

/obj/machinery/power/stirling_generator/Destroy()
	QDEL_NULL(connected_chamber)
	QDEL_NULL(soundloop)
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
	if(!panel_open)
		balloon_alert(user, "panel closed!")
		return ITEM_INTERACT_BLOCKING
	if(!default_change_direction_wrench(user, tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/stirling_generator/screwdriver_act(mob/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		return ITEM_INTERACT_BLOCKING
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/stirling_generator/crowbar_act(mob/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS
