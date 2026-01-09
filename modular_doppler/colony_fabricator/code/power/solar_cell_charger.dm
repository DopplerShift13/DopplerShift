/obj/machinery/cell_charger/emergency_solar
	name = "solar cell charger"
	desc = "Charges power cells through the power of nuclear fusion."
	icon = 'modular_doppler/colony_fabricator/icons/power/cell_charger.dmi'
	use_power = FALSE
	circuit = /obj/item/circuitboard/machine/cell_charger
	pass_flags = PASSTABLE
	charge_rate = 0.05 * STANDARD_CELL_RATE
	/// What this charger unpacks into
	var/repacked_type = /obj/item/flatpacked_machine/solar_charger

/obj/machinery/cell_charger/emergency_solar/examine(mob/user)
	. = ..()
	. += span_notice("You can pack this back up with a [EXAMINE_HINT("wrench")] and [EXAMINE_HINT("Right-Click")].")
	var/area/current_area = get_area(src)
	if(!current_area.outdoors)
		. += span_notice("This needs to be [EXAMINE_HINT("outside")] in order to charge cells.")

/obj/machinery/cell_charger/emergency_solar/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(charging)
		balloon_alert(user, "remove cell!")
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, "deconstructing...")
	tool.play_tool_sound(src)
	if(!tool.use_tool(src, user, 3 SECONDS))
		return ITEM_INTERACT_BLOCKING
	playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/cell_charger/emergency_solar/on_deconstruction(disassembled)
	if(disassembled)
		new repacked_type(drop_location())
	return ..()

// This changes because normal cell chargers deny you if you're in a place without an APC (outside) (where this works)
/obj/machinery/cell_charger/emergency_solar/attackby(obj/item/new_cell, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(new_cell, /obj/item/stock_parts/power_store/cell) && !panel_open)
		if(machine_stat & BROKEN)
			to_chat(user, span_warning("[src] is broken!"))
			return
		if(charging)
			to_chat(user, span_warning("There is already a cell in the charger!"))
			return
		else
			var/area/our_area = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(our_area))
				return
			if(!user.transferItemToLoc(new_cell,src))
				return
			charging = new_cell
			user.visible_message(span_notice("[user] inserts a cell into [src]."), span_notice("You insert a cell into [src]."))
			update_appearance()
		return ..()

/obj/machinery/cell_charger/emergency_solar/RefreshParts()
	. = ..()
	charge_rate = src::charge_rate

/obj/machinery/cell_charger/emergency_solar/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	return NONE

/obj/machinery/cell_charger/emergency_solar/default_deconstruction_crowbar(obj/item/crowbar, ignore_panel, custom_deconstruct)
	return NONE

/obj/machinery/cell_charger/emergency_solar/default_pry_open(obj/item/crowbar, close_after_pry, open_density, closed_density)
	return NONE

/obj/machinery/cell_charger/emergency_solar/process(seconds_per_tick)
	var/area/current_area = get_area(src)
	if(!current_area.outdoors)
		return
	return ..()

/obj/machinery/cell_charger/emergency_solar/use_energy(amount, channel, ignore_apc, force)
	return amount // It's just that easy

/obj/item/flatpacked_machine/solar_charger
	name = "solar cell charger"
	desc = /obj/machinery/cell_charger/emergency_solar::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "solar_charger"
	w_class = WEIGHT_CLASS_NORMAL
	type_to_deploy = /obj/machinery/cell_charger/emergency_solar
	deploy_time = 2 SECONDS
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
	)
