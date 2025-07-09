/obj/item/choice_beacon/bodyguard
	name = "bodyguard equipment beacon"
	desc = "Equipment to help in the defence of your peers."
	icon_state = "sb_delivery"
	inhand_icon_state = "sb_delivery"
	company_source = "P.CAT Asset Protection Team"
	company_message = span_bold("Please enjoy your P.CAT APT's 'command bodyguard' equipment set, protect your peers well.")

/obj/item/choice_beacon/bodyguard/generate_display_names()
	var/static/list/bodyguard_item_list
	if(!bodyguard_item_list)
		bodyguard_item_list = list()
		for(var/obj/item/storage/box/bodyguard/box as anything in subtypesof(/obj/item/storage/box/bodyguard))
			bodyguard_item_list[initial(box.name)] = box
	return bodyguard_item_list


// The box options for Bodyguard
/obj/item/storage/box/bodyguard/indiscreet
	name = "The Indiscreet"
	desc = "Wear your armour loud and proud, Standard issue security armour vest and helmet, for use in sticky situations."

/obj/item/storage/box/bodyguard/indiscreet/PopulateContents()
	new /obj/item/clothing/suit/armor/vest/alt(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)

/obj/item/storage/box/bodyguard/suit
	name = "The Suit"
	desc = "A more discreet black blazer and beret for the sophisticated bodyguard."

/obj/item/storage/box/bodyguard/suit/PopulateContents()
	new /obj/item/clothing/suit/jacket/det_suit/noir(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)

/obj/item/storage/box/bodyguard/formal
	name = "The Formal"
	desc = "A formal blue and red toned shirt and beret, comes with a plain black vest just in case."

/obj/item/storage/box/bodyguard/formal/PopulateContents()
	new /obj/item/clothing/under/rank/security/officer/formal(src)
	new /obj/item/clothing/head/beret/sec/navyofficer(src)
	new /obj/item/clothing/suit/armor/vest/alt(src)


