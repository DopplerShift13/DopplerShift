/obj/machinery/computer/salvage_bay_controller
	name = "salvage bay control console"
	desc = "A bulky and old looking terminal that looks like it was dug straight out of the bottom of the ship's \
		databanks. Likely to be from the very early concept stages of the Dark Locations type ships, where resources \
		would be obtained through recycling the many old pioneer vessels scattered through the system. While planetary \
		extraction was deemed easier, the designs and systems still work, and the system is still filled with old ships \
		sitting mothballed in orbits all over."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/personal_shuttle_order
	light_color = COLOR_BRIGHT_ORANGE
	/// Are we currently spawning a shuttle? Prevents multiple shuttles trying to spawn and land on each other at once
	var/bay_occupied
	/// The docking clamp machine we are linked to
	var/obj/machinery/docking_clamp/clamp
	/// The types of shuttle templates we can call
	var/list/valid_shuttle_templates = list(
		/datum/map_template/shuttle/personal_buyable/ferries,
	)
	/// List of the subtypes for map templates we can buy, DO NOT SET DIRECTLY, USE VALID SHUTTLE TEMPLATES FOR DIFFERENT SELECTIONS
	var/list/valid_shuttle_templates_subtypes = list()
	/// Assoc list of every shuttle that can be purchased from the choice list, includes name and price and whatnot, filled on init of the console
	var/list/scrap_list = list()
	/// The currently selected shuttle map template
	var/datum/map_template/shuttle/personal_buyable/selected_template

/obj/machinery/computer/salvage_bay_controller/post_machine_initialize()
	. = ..()
	try_and_fill_shopping_list()

/// Links a docking clamp to this console
/obj/machinery/computer/salvage_bay_controller/proc/link_docking_clamp(new_clamp)
	if(clamp)
		clamp.controller = null
	clamp = new_clamp
	clamp.controller = src

/// Delinks ourselves from the clamp we're linked to
/obj/machinery/computer/salvage_bay_controller/proc/delink_clamp()
	if(!clamp)
		return // ?? how
	clamp = null

/// Fills the shopping list with names and templates
/obj/machinery/computer/salvage_bay_controller/proc/try_and_fill_shopping_list()
	if(!length(valid_shuttle_templates))
		message_admins("HEY!!! [src] had nothing in its valid shuttle templates list, this is wrong or you just spawned the basetype!!")
		return
	if(length(valid_shuttle_templates_subtypes))
		message_admins("For some reason, [src] already had a filled valid_shuttle_templates_subtypes, this may or may not be a bug.")
		return
	for(var/datum/template as anything in valid_shuttle_templates)
		var/list/subtypes_of_template = subtypesof(template)
		for(var/datum/sub_template as anything in subtypes_of_template)
			var/datum/map_template/shuttle/new_shuttle_template = new sub_template()
			valid_shuttle_templates_subtypes.Add(new_shuttle_template)
	// If there's no ships, going through the rest of this stuff is pointless
	if(!length(valid_shuttle_templates_subtypes))
		message_admins("HEY!!! [src] has nothing in its valid_shuttle_templates_subtypes list, this is either wrong or you just spawned the basetype of the console!!")
		return
	// If we already have a shopping list, we don't need to worry about it
	if(length(shopping_list))
		return
	for(var/datum/map_template/shuttle/personal_buyable/shuttle_template as anything in valid_shuttle_templates_subtypes)
		if(!shuttle_template.personal_shuttle_type || !shuttle_template.name || !shuttle_template.personal_shuttle_size || !shuttle_template.credit_cost)
			message_admins("HEY!!! [src] just tried to add a personal shuttle template to its shopping list that was missing information! Template in question: [shuttle_template.type]")
			continue
		var/final_shuttle_name = "[shuttle_template.personal_shuttle_type] - [shuttle_template.name] - [shuttle_template.personal_shuttle_size] - COST: [shuttle_template.credit_cost]cr"
		shopping_list[final_shuttle_name] = shuttle_template
	if(!length(shopping_list))
		message_admins("HEY!!! [src] has nothing in its shuttle shopping list, this is either wrong or you just spawned the basetype of the console!!")
		return
	sort_list(shopping_list)

#define PERSONAL_SHUTTLE_CONSOLE_SHOPPING_LIST "Shopping List"
#define PERSONAL_SHUTTLE_CONSOLE_SELECTION_DETAILS "Selection Details"

#define PERSONAL_SHUTTLE_CONSOLE_PURCHASE_SHUTTLE "Purchase"
#define PERSONAL_SHUTTLE_CONSOLE_CLEAR_SELECTION "Clear Selection"

/obj/machinery/computer/salvage_bay_controller/interact(mob/user)
	. = ..()
	if(!can_interact(user))
		return
	if(!our_docking_port)
		balloon_alert(user, "no linked docking port")
		return
	if(!length(shopping_list))
		balloon_alert(user, "no ships available")
		return

	var/menu_option = tgui_alert(user, , "Personal Shuttle Order Console", list(PERSONAL_SHUTTLE_CONSOLE_SHOPPING_LIST, PERSONAL_SHUTTLE_CONSOLE_SELECTION_DETAILS))
	if(!menu_option)
		balloon_alert(user, "no selection made")
		return

	switch(menu_option)
		if(PERSONAL_SHUTTLE_CONSOLE_SHOPPING_LIST)
			var/new_template = tgui_input_list(user, "Choose Shuttle Template", "Personal Shuttle Order Console", shopping_list)
			if(!new_template)
				balloon_alert(user, "no selection made")
				return
			selected_template = shopping_list[new_template]
			balloon_alert_to_viewers("new shuttle selection made")
		if(PERSONAL_SHUTTLE_CONSOLE_SELECTION_DETAILS)
			if(!selected_template)
				balloon_alert(user, "no selected shuttle")
				return
			/// Temporarily holds what the selected template was at the time of the menu opening, to prevent accidental baits and switches
			var/datum/map_template/shuttle/personal_buyable/cached_selected_template = selected_template
			var/shuttle_details_option = tgui_alert( \
				user, \
				"[cached_selected_template.name] - COST: [cached_selected_template.credit_cost]cr - [cached_selected_template.description]", \
				"Personal Shuttle Order Console", \
				list(PERSONAL_SHUTTLE_CONSOLE_PURCHASE_SHUTTLE, PERSONAL_SHUTTLE_CONSOLE_CLEAR_SELECTION) \
			)
			if(!shuttle_details_option)
				balloon_alert(user, "no selection made")
				return

			switch(shuttle_details_option)
				if(PERSONAL_SHUTTLE_CONSOLE_PURCHASE_SHUTTLE)
					// Just to be safe, again
					if(!cached_selected_template)
						balloon_alert(user, "no selected shuttle")
						return

					try_and_buy_that_shuttle(user, cached_selected_template)
				if(PERSONAL_SHUTTLE_CONSOLE_CLEAR_SELECTION)
					balloon_alert(user, "selection cleared")
					selected_template = null

#undef PERSONAL_SHUTTLE_CONSOLE_SHOPPING_LIST
#undef PERSONAL_SHUTTLE_CONSOLE_SELECTION_DETAILS

#undef PERSONAL_SHUTTLE_CONSOLE_PURCHASE_SHUTTLE
#undef PERSONAL_SHUTTLE_CONSOLE_CLEAR_SELECTION

/// Tries to buy the given shuttle template using the given user's money, if so, spawns the shuttle and sends it to our linked dock
/obj/machinery/computer/salvage_bay_controller/proc/try_and_buy_that_shuttle(mob/living/carbon/user, datum/map_template/shuttle/personal_buyable/selected_ship_template)
	if(!our_docking_port)
		balloon_alert(user, "no linked docking port")
		return
	if(our_docking_port.get_docked())
		balloon_alert(user, "docking port blocked")
		return
	if(spawning_shuttle)
		balloon_alert(user, "shuttle en route")
		return
	if(attempt_charge(src, user, selected_ship_template.credit_cost) & COMPONENT_OBJ_CANCEL_CHARGE)
		balloon_alert(user, "payment failed")
		return
	playsound(src, 'sound/effects/cashregister.ogg', 40, TRUE)
	spawning_shuttle = TRUE
	// If successful, returns the mobile docking port
	var/obj/docking_port/mobile/loaded_port = SSshuttle.action_load(selected_ship_template, our_docking_port, FALSE)
	if(loaded_port)
		message_admins("[user] loaded [loaded_port] with a shuttle order console.")
		say("Shuttle purchase successful.")
	else
		message_admins("[user] tried to load a ship template ([selected_ship_template]) but it failed for some reason, they should have been refunded the cost")
		say("Shuttle purchase failed, cost of ship refunded.")
		new /obj/item/holochip(drop_location(src), selected_ship_template.credit_cost)
	spawning_shuttle = FALSE
