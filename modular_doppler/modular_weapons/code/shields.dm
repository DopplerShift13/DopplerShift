/*
*	a special riot shield for support security that comes with a move to help them hold the line
*/

/obj/item/shield/escarabajo
	name = "\improper PA-3S Escarabajo riot shield"	//it means beetle
	desc = "A monocoque skin of plasma-infused titanium with a broad reinforced viewport. Operators describe the experinece of watching rounds bounce off the \
	viewport as upsetting, by paraphrase."
	icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	icon_state = "escarabajo"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/shields_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/shields_righthand.dmi'
	inhand_icon_state = "escarabajo"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/shields.dmi'
	worn_icon_state = "escarabajo"
	armor_type = /datum/armor/item_shield/riot
	shield_break_leftover = /obj/item/escarabajo_broken
	item_flags = IMMUTABLE_SLOW
	actions_types = list(/datum/action/item_action/escarabajo_slam)
	//are we slammed on the ground? this allows us to block everything from the front, but not move.
	var/slammed = FALSE

/obj/item/shield/escarabajo/ui_action_click(mob/user, actiontype)
	. = ..()
	if(!isliving(user))
		return
	if(slot)

/datum/action/item_action/escarabajo_slam
	name = "Impenetrable Defense"
	desc = "Deploy the shield to the floor, granting perfect defense from the front at the cost of total immobilization."
	button_icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	button_icon_state = "escarabajo"

/datum/action/item_action/escarabajo_slam/proc/do_effect(trigger_flags)
	. = ..()
	SIGNAL_HANDLER
	if(slammed)
		name = "Undeploy Shield"
		desc = "Raise the shield from the floor and regain mobility."
	else
		name = "Impenetrable Defense"
		desc = "Deploy the shield to the floor, granting perfect defense from the front at the cost of total immobilization."
	build_all_button_icons(UPDATE_BUTTON_NAME)

// since this is a unique loadout defining item it drops a repairable but otherwise junk item instead of a metal sheet or whatever

/obj/item/escarabajo_broken
	name = "shattered Escarabajo shield"
	desc = "The shattered remains of a PA-3S riot shield."
	icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	icon_state = "escarabajo_shattered"
	w_class = WEIGHT_CLASS_BULKY // to best visually communicate when a shield is broken, the broken ones just drop on the floor and have to be dragged away
