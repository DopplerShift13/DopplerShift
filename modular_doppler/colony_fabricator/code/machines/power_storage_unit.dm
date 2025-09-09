/obj/machinery/power/smes/battery_pack
	name = "stationary battery"
	desc = "An about table-height block of power storage, commonly seen in low storage high output power applications. \
		Smaller units such as these tend to have a respectively <b>smaller energy storage</b>, though also are capable of \
		<b>higher maximum output</b> than some larger units. Most commonly seen being used not for their ability to store \
		power, but rather for use in regulating power input and output."
	icon = 'modular_doppler/colony_fabricator/icons/power_storage_unit/small_battery.dmi'
	input_level_max = 200 KILO WATTS
	output_level_max = 200 KILO WATTS
	circuit = null

	/// Typepath for the batteries we use to hold our charge, spawned on init.
	var/spawned_battery_type = /obj/item/stock_parts/power_store/battery/empty
	/// The amount of batteries we spawn inside of us on init.
	var/spawned_battery_amount = 5

/obj/machinery/power/smes/battery_pack/Initialize(mapload)
	initialize_batteries() // Must be done before parent init, so parent can charge the cells.
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/// Initialize our internal batteries.
/obj/machinery/power/smes/battery_pack/proc/initialize_batteries()
	for(var/_ in 1 to spawned_battery_amount)
		var/obj/item/stock_parts/power_store/spawned_cell = new spawned_battery_type(src)
		LAZYADD(component_parts, spawned_cell)
		total_capacity += spawned_cell.max_charge()

/obj/machinery/power/smes/battery_pack/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	if(screwdriver.tool_behaviour != TOOL_SCREWDRIVER)
		return FALSE

	screwdriver.play_tool_sound(src, 50)
	toggle_panel_open()
	if(panel_open)
		icon_state = icon_state_open
		to_chat(user, span_notice("You open the maintenance hatch of [src]."))
	else
		icon_state = icon_state_closed
		to_chat(user, span_notice("You close the maintenance hatch of [src]."))
	return TRUE

// We don't care about the parts updates because we don't want them to change
/obj/machinery/power/smes/battery_pack/RefreshParts()
	return

// We also don't need to bother with fuddling with charging power cells, there are none to remove
/obj/machinery/power/smes/battery_pack/on_deconstruction()
	return

// Automatically set themselves to be completely charged on init
/obj/machinery/power/smes/battery_pack/precharged
	charge = 5 * STANDARD_BATTERY_CHARGE


// Item for creating the small battery and carrying it around
/obj/item/flatpacked_machine/station_battery
	name = "flat-packed stationary battery"
	desc = /obj/machinery/power/smes/battery_pack::desc
	icon_state = "battery_small_packed"
	type_to_deploy = /obj/machinery/power/smes/battery_pack
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)


// Larger station batteries, hold more but have less in/output
/obj/machinery/power/smes/battery_pack/large
	name = "large stationary battery"
	desc = "A massive block of power storage, commonly seen in high storage low output power applications. \
		Larger units such as these tend to have a respectively <b>larger energy storage</b>, though only capable of \
		<b>low maximum output</b> compared to smaller units. Most commonly seen as large backup batteries, or simply \
		for large power storage where throughput is not a concern."
	icon = 'modular_doppler/colony_fabricator/icons/power_storage_unit/large_battery.dmi'
	input_level_max = 50 KILO WATTS
	output_level_max = 50 KILO WATTS
	spawned_battery_type = /obj/item/stock_parts/power_store/battery/super

// Automatically set themselves to be completely charged on init
/obj/machinery/power/smes/battery_pack/large/precharged
	charge = 100 * STANDARD_BATTERY_CHARGE


/obj/item/flatpacked_machine/large_station_battery
	name = "flat-packed large stationary battery"
	desc = /obj/machinery/power/smes/battery_pack/large::desc
	icon_state = "battery_large_packed"
	type_to_deploy = /obj/machinery/power/smes/battery_pack/large
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 12,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
	)
