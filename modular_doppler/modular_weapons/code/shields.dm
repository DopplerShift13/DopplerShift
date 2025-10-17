/*
*	a special riot shield for support security that comes with a move to help them hold the line
*/

/obj/item/shield/escarabajo
	name = "\improper PA-3S Escarabajo riot shield"	//it means beetle
	desc = "A monocoque skin of plasma-infused titanium with a broad reinforced viewport. Operators describe the experience of watching rounds bounce off the \
	viewport as upsetting, by paraphrase."
	icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	icon_state = "escarabajo"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/shields_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/shields_righthand.dmi'
	inhand_icon_state = "escarabajo"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/shields.dmi'
	worn_icon_state = "escarabajo"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	armor_type = /datum/armor/item_shield/riot
	shield_break_leftover = /obj/item/escarabajo_broken
	item_flags = IMMUTABLE_SLOW
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE

/obj/item/shield/escarabajo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/obj/item/shield/escarabajo/proc/on_wield(obj/item/source, mob/user)
	source.block_chance = 70
	user.add_movespeed_modifier(/datum/movespeed_modifier/escarabajo_slammed)
	inhand_icon_state = "escarabajo_slammed"
	playsound(src, 'sound/items/handling/shield/plastic_shield_drop.ogg', 75, TRUE)
	new /obj/effect/temp_visual/mook_dust(get_turf(src))

/obj/item/shield/escarabajo/proc/on_unwield(obj/item/source, mob/user)
	source.block_chance = 50
	user.remove_movespeed_modifier(/datum/movespeed_modifier/escarabajo_slammed)
	playsound(src, 'sound/items/handling/shield/plastic_shield_pick_up.ogg', 75, TRUE)
	inhand_icon_state = "escarabajo"

/datum/movespeed_modifier/escarabajo_slammed
	multiplicative_slowdown = 2

// since this is a unique loadout defining item it drops a repairable but otherwise junk item instead of a metal sheet or whatever

/obj/item/escarabajo_broken
	name = "shattered Escarabajo shield"
	desc = "The shattered remains of a PA-3S riot shield."
	icon = 'modular_doppler/modular_weapons/icons/obj/shield.dmi'
	icon_state = "escarabajo_shattered"
	w_class = WEIGHT_CLASS_GIGANTIC // to best visually communicate when a shield is broken, the broken ones just drop on the floor and have to be dragged away
