/*
	Screw the rules I have money.
*/

/datum/power/expert/rich
	name = "Rich"
	desc = "Whether through good savings, connections or just nepotism; you have way more spendable cash on hand than your peers. You start the shift with 2500 extra credits in your account."
	value = 5
	security_record_text = "Subject has access to a high amount of wealth and resources."
	// how rich are we?
	var/riches = 2500

/datum/power/expert/rich/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = power_holder
	if(!human_holder.account_id) // give it to the mob if they don't have a bank account
		var/obj/item/holochip/riches_chip = new(get_turf(human_holder), riches)
		give_item_to_holder(riches_chip, list(LOCATION_BACKPACK, LOCATION_HANDS))
		return
	var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[human_holder.account_id]"]
	account.account_balance += riches
