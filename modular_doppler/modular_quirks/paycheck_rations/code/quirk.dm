/datum/quirk/item_quirk/ration_system
	name = "Ration Ticket Receiver"
	desc = "While often spread thin, the 4CA still manages to provide few basic services no matter where you are in the \
		galaxy. Working with all of its members, and even independent empires such as the Talunan, you can be gauranteed \
		a meal anywhere in civilized and even uncivilized space. The quality of the food, however, is far from a promise."
	icon = FA_ICON_DONATE
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	medical_record_text = "Has enrolled in the ration ticket program."
	value = 0
	hardcore_value = 0

/datum/quirk/item_quirk/ration_system/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(!human_holder.account_id)
		return
	var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[human_holder.account_id]"]

	var/obj/new_ticket_book = new /obj/item/storage/ration_ticket_book(get_turf(human_holder))
	give_item_to_holder(
		new_ticket_book,
		list(
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		),
	)
	account.tracked_ticket_book = WEAKREF(new_ticket_book)
	account.payday_modifier = 0.5
	to_chat(client_source.mob, span_notice("You remember to keep close hold of your ticket book, it can't be replaced if lost and all of your ration tickets are placed there!"))

// Edits to bank accounts to make the above possible

/datum/bank_account
	/// Tracks a linked ration ticket book. If we have one of these, then we'll put tickets in it every payday.
	var/datum/weakref/tracked_ticket_book

/datum/bank_account/payday(amount_of_paychecks, free = FALSE, skippable = FALSE, event = "Payday")
	. = ..()
	if(!.)
		return
	if(isnull(tracked_ticket_book))
		return
	make_ration_ticket()

/// Attempts to create a ration ticket book in the card holder's hand, and failing that, the drop location of the card
/datum/bank_account/proc/make_ration_ticket()
	if(!(SSeconomy.times_fired % 6 == 0))
		return
	if(!bank_cards.len)
		return
	var/obj/item/storage/ration_ticket_book/ticket_book = tracked_ticket_book.resolve()
	if(!ticket_book)
		tracked_ticket_book = null
		return
	var/obj/item/created_ticket
	for(var/obj/card in bank_cards)
		// We want to only make one ticket per account per payday
		if(created_ticket)
			continue
		var/ticket_to_make
		ticket_to_make = /obj/item/paper/paperslip/ration_ticket
		created_ticket = new ticket_to_make(card)
		if(!ticket_book.atom_storage.can_insert(created_ticket, messages = FALSE))
			qdel(created_ticket)
			bank_card_talk("ERROR: Ticket book full, please use existing tickets to limit waste.")
			// We can stop here, it's joever for trying to place tickets in the book this payday. You snooze you lose!
			return
		created_ticket.forceMove(ticket_book)
		bank_card_talk("A new meal ticket has been added to your ration book.")
