GLOBAL_LIST_INIT(blacklisted_salvage_removal_types, typecacheof(list(
		/mob/living,
		/obj/effect/mob_spawn,
		/obj/item/disk/nuclear,
		/obj/item/hilbertshotel,
		/obj/machinery/nuclearbomb,
		/obj/narsie,
		/obj/structure/blob,
		/obj/structure/guardian_beacon,
		/obj/tear_in_reality,
	)))

// Circuit and RND

/obj/item/circuitboard/computer/salvage_computer
	name = "Salvage Bay Controller"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/salvage_bay_controller

/datum/design/board/salvage_computer
	name = "Salvage Bay Controller"
	desc = "A bulky and old looking terminal that looks like it was dug straight out of the bottom of the ship's \
		databanks. Likely to be from the very early concept stages of the Dark Locations type ships, where resources \
		would be obtained through recycling the many old pioneer vessels scattered through the system."
	id = "salvage_computer"
	build_path = /obj/machinery/computer/salvage_bay_controller
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/techweb_node/mining/New()
	design_ids += list(
		"salvage_computer",
	)
	return ..()

// Everything else

/obj/machinery/computer/salvage_bay_controller
	name = "salvage bay control console"
	desc = "A bulky and old looking terminal that looks like it was dug straight out of the bottom of the ship's \
		databanks. Likely to be from the very early concept stages of the Dark Locations type ships, where resources \
		would be obtained through recycling the many old pioneer vessels scattered through the system."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/personal_shuttle_order
	light_color = COLOR_BRIGHT_ORANGE
	/// Are we currently spawning a shuttle? Prevents multiple shuttles trying to spawn and land on each other at once
	var/bay_occupied = null
	/// The docking clamp machine we are linked to
	var/obj/machinery/docking_clamp/clamp
	/// The types of shuttle templates we can call
	var/list/valid_shuttle_templates = list()
	/// List of the subtypes for map templates we can buy, DO NOT SET DIRECTLY, USE VALID SHUTTLE TEMPLATES FOR DIFFERENT SELECTIONS
	var/list/valid_shuttle_templates_subtypes = list()
	/// Assoc list of every shuttle that can be purchased from the choice list, includes name and price and whatnot, filled on init of the console
	var/list/scrap_list = list()
	/// The currently selected shuttle map template
	var/datum/map_template/shuttle/personal_buyable/selected_template
	/// Message when the shuttle can't be cleared due to an illegal item being present
	var/blacklist_hit_message = "To prevent equipment loss and accidents: live organisms, human remains, \
		classified nuclear weaponry, unstable eigenstates, or machinery housing any form of \
		artificial intelligence cannot be present when salvage is discarded."

/obj/machinery/computer/salvage_bay_controller/post_machine_initialize()
	. = ..()
	try_and_fill_shopping_list()

/obj/machinery/computer/salvage_bay_controller/examine(mob/user)
	. = ..()
	if(!clamp)
		. += span_notice("Connect to a [EXAMINE_HINT("salvage clamp")] by using a [EXAMINE_HINT("multitool")] \
			on the clamp then connecting it to this console.")

/obj/machinery/computer/salvage_bay_controller/multitool_act(mob/living/user, obj/item/multitool/the_tool)
	if(!the_tool.buffer)
		return ITEM_INTERACT_FAILURE
	link_docking_clamp(the_tool.buffer)
	balloon_alert(user, "linked to clamp")
	return ITEM_INTERACT_SUCCESS

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
		valid_shuttle_templates = subtypesof(/datum/map_template/shuttle/salvage_scrap)
	if(length(valid_shuttle_templates_subtypes))
		message_admins("For some reason, [src] already had a filled valid_shuttle_templates_subtypes, this may or may not be a bug.")
		return
	for(var/datum/map_template/shuttle/salvage_scrap/template as anything in valid_shuttle_templates)
		if(!template.shows_up_as_salvage)
			continue
		valid_shuttle_templates_subtypes.Add(template) // This makes the var a lie bog off

/// Loads specifically "Scrappie" the training shuttle
#define SALVAGE_CONSOLE_TRAINING "Training Ship"
/// Loads a new shuttle into the linked salvage bay if the bay is clear
#define SALVAGE_CONSOLE_NEW_SHUTTLE "New Salvage"
/// Clears the bay of any shuttle currently inside of it
#define SALVAGE_CONSOLE_CLEAR_BAY "Clear Bay"

/obj/machinery/computer/salvage_bay_controller/interact(mob/user)
	. = ..()
	if(!can_interact(user))
		return
	if(!clamp)
		say("No linked docking clamp detected, re-link and try again later.")
		return
	if(!clamp?.docking_port)
		say("Linked salvage clamp currently inactive, please engage before operation.")
		return
	if(!length(valid_shuttle_templates_subtypes))
		say("No salvageable ships are available, please reference your local administrator.")
		return

	var/menu_option = tgui_input_list(user, "Salvage Bay Action", "Salvage Bay Control Console", list(SALVAGE_CONSOLE_NEW_SHUTTLE, SALVAGE_CONSOLE_CLEAR_BAY))
	if(!menu_option)
		balloon_alert(user, "no selection")
		return

	switch(menu_option)
		if(SALVAGE_CONSOLE_CLEAR_BAY)
			if(!bay_occupied)
				say("No salvage to clear, dock already empty.")
				return
			say("You are about to release savage clamps and clear the bay, proceed?")
			var/clear_bay_confirm = tgui_alert(user, "Bay cannot be cleared if critical equipment or personnel are present, confirm?", "Salvage Bay Clear Confirmation", list("Confirm", "Cancel"))
			if(!clear_bay_confirm || clear_bay_confirm == "Cancel")
				say("Cancelling release of salvage clamps, proceed with work.")
				return
			var/obj/docking_port/mobile/salvage/docked_salvage = clamp.docking_port.get_docked()
			if(!docked_salvage.check_blacklist())
				say(blacklist_hit_message)
				return
			docked_salvage.jumpToNullSpace()
			say("Dock clearing, keep clear of moving clamps to prevent injury.")
			bay_occupied = FALSE
		if(SALVAGE_CONSOLE_NEW_SHUTTLE, SALVAGE_CONSOLE_TRAINING)
			if(!clamp?.docking_port)
				say("Connection to salvage clamp lost, please check equipment and try again later.")
				return
			var/datum/map_template/shuttle/salvage_template
			if(menu_option == SALVAGE_CONSOLE_NEW_SHUTTLE)
				salvage_template = pick(valid_shuttle_templates_subtypes)
			else
				salvage_template = /datum/map_template/shuttle/salvage_scrap/scrappie
			if(!salvage_template)
				say("No salvageable ships are available, please reference your local administrator.")
				return
			if(bay_occupied)
				say("Bay already occupied, or currently retrieving salvage, please wait.")
				return
			if(clamp.check_for_clear_bay())
				say("Please ensure salvage bay is clear of work crew before collecting salvage.")
				return
			bay_occupied = TRUE
			salvage_template = new salvage_template()
			var/obj/docking_port/mobile/loaded_port = SSshuttle.action_load(salvage_template, clamp.docking_port, FALSE)
			if(loaded_port)
				say("Salvage clamps retrieving ship now, please stand clear of the work bay.")
				make_salvage_ticket(salvage_template)
			else
				message_admins("[user] tried to load a salvage template ([salvage_template]) but it failed for some reason, this should not happen!")
				say("Failed to retrieve ship for salvage, please try again later.")
				bay_occupied = FALSE

#undef SALVAGE_CONSOLE_TRAINING
#undef SALVAGE_CONSOLE_NEW_SHUTTLE
#undef SALVAGE_CONSOLE_CLEAR_BAY

/// Makes a little half-sheet ticket with information about the ship that just got pulled in, scoreboard, scoreboard!
/obj/machinery/computer/salvage_bay_controller/proc/make_salvage_ticket(datum/map_template/shuttle/salvage_scrap/template)
	playsound(src, 'sound/machines/printer.ogg', 50, vary = FALSE)
	var/obj/item/paper/paperslip/new_ticket = new(drop_location())
	new_ticket.name = "salvage receipt - [template.prior_name]"
	// Makes the actual text on the paper
	var/list/ticket_contents
	ticket_contents += "<h1><table bgcolor=\"darkgoldenrod\" width=\"100%\"><th><div align=\"center\"><font color=\"white\">Salvage Ticket</font></div></th></table></h1>"
	ticket_contents += "<hr />"
	ticket_contents += "<p><strong>Ship details:</strong></p>"
	ticket_contents += "<p>Designation - [template.prior_name]<br>"
	ticket_contents += "Prior Owner - [template.prior_owner_datum.owner_name]<br>"
	ticket_contents += "Operation History from [template.prior_date]:<br>"
	ticket_contents += "[template.prior_usage]</p>"
	ticket_contents += "<hr />"
	ticket_contents += "<p>Ship Class - [template.ship_class]</p><br>"
	ticket_contents += "<p>Detected Hazards:</p>"
	if(!length(template.ship_hazards))
		ticket_contents += "No hazards were detected, continue with caution.<br>"
	else
		for(var/hazard as anything in template.ship_hazards)
			ticket_contents += "- [hazard]<br>"
	ticket_contents += "<hr />"
	ticket_contents += "<p><font color=\"grey\">Signature or stamp confirms receipt of salvage ownership, and that any and all contents of the salvage are the direct responsibility of all signees.</font></p>"
	ticket_contents += "<p>\[___________________________________\]</p>"
	ticket_contents += "<p>\[___________________________________\]</p>"
	ticket_contents += "<p>\[___________________________________\]</p>"
	// Just to break it up a little
	new_ticket.color = COLOR_BEIGE
	new_ticket.add_raw_text(ticket_contents)
	new_ticket.update_appearance()

