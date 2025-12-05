/obj/machinery/cell_charger/emergency_solar
	name = "solar cell charger"
	desc = "Charges power cells through the power of nuclear fusion."
	icon = 'modular_doppler/colony_fabricator/icons/power/cell_charger.dmi'
	use_power = FALSE
	circuit = /obj/item/circuitboard/machine/cell_charger
	pass_flags = PASSTABLE
	charge_rate = 0.1 * STANDARD_CELL_RATE
	/// What this charger unpacks into
	var/repacked_type

/obj/machinery/cell_charger/emergency_solar/examine(mob/user)
	. = ..()
	. += span_notice("You can pack this back up with a [EXAMINE_HINT("wrench")].")
	var/area/current_area = get_area()
	if(!current_area.outdoors)
		. += span_notice("This needs to be [EXAMINE_HINT("outside")] in order to charge cells.")

/obj/machinery/cell_charger/emergency_solar/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(charging)
		return FALSE
	if(default_unfasten_wrench(user, tool))
		update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/cell_charger/emergency_solar/wrench_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	if(charging)
		return FALSE
	user.balloon_alert(user, "deconstructing...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 3 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS
	return FALSE

/obj/machinery/cell_charger_multi/on_deconstruction(disassembled)
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
	else
		if(!charging && default_deconstruction_screwdriver(user, icon_state, icon_state, new_cell))
			return
		if(default_deconstruction_crowbar(new_cell))
			return
		return ..()

/obj/machinery/cell_charger/emergency_solar/RefreshParts()
	. = ..()
	charge_rate = src::charge_rate

/obj/machinery/cell_charger/emergency_solar/process(seconds_per_tick)
	var/area/current_area = get_area()
	if(!current_area.outdoors)
		return
	return ..()

/obj/machinery/cell_charger/emergency_solar/use_energy(amount, channel, ignore_apc, force)
	return amount // It's just that easy
