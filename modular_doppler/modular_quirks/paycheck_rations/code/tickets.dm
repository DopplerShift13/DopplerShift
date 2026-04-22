/obj/item/paper/paperslip/ration_ticket
	name = "meal ticket"
	desc = "A small, coppery chip that slots neatly into slots on supply consoles. \"Food\" is printed on the ticket in many different languages."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/tickets.dmi'
	icon_state = "ticket_food"
	default_raw_text = "Redeem this ticket in the nearest supply console to receive benefits."
	color = COLOR_CARGO_BROWN
	show_written_words = FALSE
	/// The finalized list of items we send once the ticket is used, don't define here, the procs will do it
	var/list/items_we_deliver = list()

/obj/item/paper/paperslip/ration_ticket/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/computer/cargo))
		return try_to_make_ration_order_list(interacting_with, user)
	return ..()

/obj/item/paper/paperslip/ration_ticket/proc/try_to_make_ration_order_list(obj/machinery/computer/cargo/supply_console_used, mob/living/user)
	if(!supply_console_used.is_operational)
		supply_console_used.balloon_alert(user, "not operational")
		return ITEM_INTERACT_BLOCKING
	forceMove(supply_console_used)
	playsound(supply_console_used, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
	// List of diet options
	var/list/radial_diet_options = list(
		"Standard Diet" = image(icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/menu_icons.dmi', icon_state = "4ca"),
		"Tizirian Diet" = image(icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/menu_icons.dmi', icon_state = "tiziria"),
	)
	var/diet_choice = show_radial_menu(user, supply_console_used, radial_diet_options, require_near = TRUE)
	if(!diet_choice)
		supply_console_used.balloon_alert(user, "no selection made")
		forceMove(drop_location(supply_console_used))
		playsound(supply_console_used, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
		return ITEM_INTERACT_BLOCKING
	switch(diet_choice)
		if("Standard Diet")
			var/humies_aspics = list(
				/obj/item/food/aspic/vegetable_soup,
				/obj/item/food/aspic/miso,
				/obj/item/food/aspic/beet,
			)
			items_we_deliver += pick(humies_aspics)
			items_we_deliver += /obj/item/reagent_containers/applicator/pill/tea_brick
			items_we_deliver += /obj/item/food/breadslice/hardtack
			items_we_deliver += /obj/item/food/breadslice/hardtack
			items_we_deliver += /obj/item/food/breadslice/hardtack
			items_we_deliver += /obj/item/food/cheese/firm_cheese_slice/bigger
			items_we_deliver += /obj/item/reagent_containers/cup/glass/waterbottle/large
		if("Tizirian Diet")
			var/lizard_aspics = list(
				/obj/item/food/aspic/miso,
				/obj/item/food/aspic/black_broth,
				/obj/item/food/aspic/satsuma,
			)
			items_we_deliver += pick(lizard_aspics)
			items_we_deliver += /obj/item/reagent_containers/applicator/pill/tea_brick/mushroom
			items_we_deliver += /obj/item/food/breadslice/roottack
			items_we_deliver += /obj/item/food/breadslice/roottack
			items_we_deliver += /obj/item/food/headcheese_slice
			items_we_deliver += /obj/item/food/headcheese_slice
			items_we_deliver += /obj/item/reagent_containers/cup/glass/waterbottle/large
	make_the_actual_order(supply_console_used, user)
	return ITEM_INTERACT_SUCCESS

/// Takes the list of things to deliver and puts it into a cargo order
/obj/item/paper/paperslip/ration_ticket/proc/make_the_actual_order(obj/machinery/computer/cargo/supply_console_used, mob/user)
	var/datum/supply_pack/custom/ration_pack/ration_pack = new(
		purchaser = user, \
		cost = 0, \
		contains = items_we_deliver,
	)
	var/datum/supply_order/new_order = new(
		pack = ration_pack,
		orderer = user,
		orderer_rank = "Ration Ticket",
		orderer_ckey = user.ckey,
		reason = "",
		paying_account = null,
		department_destination = null,
		coupon = null,
		charge_on_purchase = FALSE,
		manifest_can_fail = FALSE,
		can_be_cancelled = FALSE,
	)
	supply_console_used.say("Ration order placed! It will arrive on the next cargo shuttle!")
	SSshuttle.shopping_list += new_order
	qdel(src)

/datum/supply_pack/custom/ration_pack
	name = "rations order"
	crate_name = "ration delivery crate"
	access = list()
	crate_type = /obj/structure/closet/crate/cardboard

/datum/supply_pack/custom/ration_pack/New(purchaser, cost, list/contains)
	. = ..()
	name = "[purchaser]'s Rations Order"
	crate_name = "[purchaser]'s ration delivery crate"
	src.cost = cost
	src.contains = contains
