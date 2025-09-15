/*
*	a special riot shield for support security that comes with a move to help them hold the line
*/

/obj/item/shield/escarabajo
	name = "\improper P3-A Escarabajo riot shield"	//it means beetle
	desc = "A triumphant r"
	icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	icon_state = "escarabajo"
	lefthand_file = ''
	righthand_file = ''
	inhand_icon_state = ""
	worn_icon = ''
	worn_icon_state = ""
	armor_type = /datum/armor/item_shield/riot
	shield_break_leftover = /obj/item/escarabajo/broken
	item_flags = IMMUTABLE_SLOW

// since this is a unique loadout defining item it drops a repairable but otherwise junk item instead of a metal sheet or whatever

/obj/item/escarabajo/broken
	name = "shattered Escarabajo shield"
	desc = ""
	icon = ''
	icon_state = ""
	righthand_file = ''
	lefthand_file = ''
	inhand_icon_state = ""
