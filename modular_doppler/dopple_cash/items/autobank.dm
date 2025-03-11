// THE ATM
// my oldest friend. my most ancient enemy.

/obj/machinery/autobank
	name = "banking terminal"
	desc = "An automatic teller machine, or ATM, connected to the Port Authority Neglible-Loss Transaction Yard, or PANTRY. Capable of dispensing physical currency."
	icon = 'modular_doppler/dopple_cash/icons/atm.dmi'
	icon_state = "atm"
	anchored = TRUE
	density = TRUE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION
	light_power = 0.7
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	// current user's bank card
	var/obj/item/card/id/inserted_scan_id
	// currently loaded bank account
	var/datum/bank_account/synced_bank_account
	// account balance
	var/balance = 0
	// amount of credits withdrawn
	var/withdrawn_credits = 0

/obj/machinery/autobank/Initialize(mapload)
	. = ..()
	synced_bank_account = null

/obj/machinery/autobank/examine(mob/user)
	. = ..()

	. += span_engradio("You could <b>examine closer</b> for more information about banking services...")

/obj/machinery/autobank/examine_more(mob/user)
	. = ..()

	. += span_notice("Most <b>outdated or non-standard galactic currencies</b> can be converted into <b>Libre</b> by inserting them into the machine.")

/obj/machinery/autobank/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		set_light(0)
		return
	set_light(1.5, 0.7, "#d6c631") // golden light

/obj/machinery/autobank/attackby(obj/item/weapon, mob/user, params)
	var/value = 0
	if(isidcard(weapon))
		if(id_insert(user, weapon, inserted_scan_id))
			inserted_scan_id = weapon
			return TRUE
	else if(istype(weapon, /obj/item/libre))
		var/obj/item/libre/inserted_cash = weapon
		value = inserted_cash.value
	else if(istype(weapon, /obj/item/holochip))
		var/obj/item/holochip/inserted_holochip = weapon
		value = inserted_holochip.credits
	else if(istype(weapon, /obj/item/stack/spacecash))
		var/obj/item/stack/spacecash/inserted_cash = weapon
		value = inserted_cash.value * inserted_cash.amount
	else if(istype(weapon, /obj/item/coin))
		var/obj/item/coin/inserted_coin = weapon
		value = inserted_coin.value
	if(value)
		if(synced_bank_account)
			synced_bank_account.adjust_money(value)
			say("Libre deposited! Your account now holds [synced_bank_account.account_balance] libre.")
			playsound(src, 'sound/effects/cashregister.ogg', 50, TRUE)
			qdel(weapon)
		else
			say("No account loaded! Please present an identification string.")
			playsound(src, 'sound/machines/uplink/uplinkerror.ogg', 50, TRUE)
		return
	return ..()

/obj/machinery/autobank/ui_data(mob/user)
	. = list()

	synced_bank_account = inserted_scan_id?.registered_account
	balance = inserted_scan_id?.registered_account?.account_balance

	var/list/data = list()
	data["current_balance"] = synced_bank_account?.account_balance
	data["withdrawal_amount"] = 0

	return data

/obj/machinery/autobank/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!anchored)
		return
	if(!ui)
		ui = new(user, src, "AutoBank", name)
		ui.open()

/obj/machinery/autobank/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// we have no card to take money from
	if(isnull(synced_bank_account))
		say("No usable account number on file. If you believe this to be in error, please contact 7-001-0451 at extension '9' for customer service!")
		return

	switch(action)
		if("withdraw")
			var/dosh_taken = text2num(params["totalcreds"])
			if(dosh_taken <= balance)
				synced_bank_account.adjust_money(-dosh_taken)
				say("Libre withdrawal complete! Have a great day!")
				spawn_libre(dosh_taken, drop_location())
				playsound(src, 'sound/effects/cashregister.ogg', 50, TRUE)
			else
				say("Unable to complete transaction.")
				playsound(src, 'sound/machines/uplink/uplinkerror.ogg', 50, TRUE)
			. = TRUE

/obj/machinery/autobank/proc/id_insert(mob/user, obj/item/inserting_item, obj/item/target) //stolen from the bounty pad
	var/obj/item/card/id/card_to_insert = inserting_item
	var/holder_item = FALSE

	if(!isidcard(card_to_insert))
		card_to_insert = inserting_item.RemoveID()
		holder_item = TRUE

	if(!card_to_insert || !user.transferItemToLoc(card_to_insert, src))
		return FALSE

	if(target)
		if(holder_item && inserting_item.InsertID(target))
			playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
		else
			id_eject(user, target)

	user.visible_message(span_notice("[user] inserts \the [card_to_insert] into \the [src]."),
						span_notice("You insert \the [card_to_insert] into \the [src]."))
	playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
	ui_interact(user)
	return TRUE

/obj/machinery/autobank/click_alt(mob/user)
	id_eject(user, inserted_scan_id)
	return CLICK_ACTION_SUCCESS

/obj/machinery/autobank/proc/id_eject(mob/user, obj/target)
	if(!target)
		to_chat(user, span_warning("That slot is empty!"))
		return FALSE
	else
		target.forceMove(drop_location())
		if(!issilicon(user) && Adjacent(user))
			user.put_in_hands(target)
		user.visible_message(span_notice("[user] gets \the [target] from \the [src]."), \
							span_notice("You get \the [target] from \the [src]."))
		playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
		inserted_scan_id = null
		return TRUE

//colony fab
/obj/item/flatpacked_machine/atm
	name = "banking terminal parts kit"
	icon = 'modular_doppler/dopple_cash/icons/atm.dmi'
	icon_state = "flatpacked_atm"
	type_to_deploy = /obj/machinery/autobank
	deploy_time = 2 SECONDS
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5,
	)

// wall-mounted version for mapping

/obj/machinery/autobank/wallmount
	name = "autobank terminal"
	icon = 'modular_doppler/dopple_cash/icons/atm.dmi'
	icon_state = "atm_wall"
	circuit = null
	anchored = TRUE
	density = FALSE
	var/repacked_type = /obj/item/wallframe/atm_wallmount

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/autobank/wallmount, 29)

/obj/machinery/autobank/wallmount/default_unfasten_wrench(mob/user, obj/item/wrench/tool, time)
	user.balloon_alert(user, "deconstructing...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 1 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
		return

/obj/machinery/autobank/wallmount/on_deconstruction(disassembled)
	if(disassembled)
		new repacked_type(drop_location())

/obj/machinery/autobank/wallmount/default_deconstruction_crowbar()
	return

// Deployable version; engineering or service design?

/obj/item/wallframe/atm_wallmount
	name = "unmounted atm wall-mount"
	desc = "Turn any home into a bodega with this portable ATM!"
	icon = 'modular_doppler/dopple_cash/icons/atm.dmi'
	icon_state = "atm_wall_off"
	w_class = WEIGHT_CLASS_NORMAL
	result_path = /obj/machinery/autobank/wallmount
	pixel_shift = 29
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT ,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)
