/obj/item/doppler_turret_offhand
	name = "gun controls"
	icon = 'modular_doppler/mounted_guns/icons/drive.dmi'
	icon_state = "drive"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT | DROPDEL | NOBLUDGEON
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/rider
	var/obj/vehicle/ridden/mounted_turret/turret
	var/selfdeleting = FALSE

/obj/item/doppler_turret_offhand/dropped()
	selfdeleting = TRUE
	. = ..()

/obj/item/doppler_turret_offhand/equipped()
	if(loc != rider && loc != turret)
		selfdeleting = TRUE
		qdel(src)
	. = ..()

/obj/item/doppler_turret_offhand/Destroy()
	var/atom/movable/AM = turret
	if(selfdeleting)
		if(rider in AM.buckled_mobs)
			AM.unbuckle_mob(rider)
	. = ..()

/obj/item/doppler_turret_offhand/attack_self(mob/user, modifiers)
	turret.stored_gun?.attack_self(user, modifiers)

/obj/item/doppler_turret_offhand/attack_self_secondary(mob/user, modifiers)
	turret.stored_gun?.attack_self_secondary(user, modifiers)

/obj/item/doppler_turret_offhand/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	turret.stored_gun?.item_interaction(user, tool, modifiers)

/obj/item/doppler_turret_offhand/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	turret.stored_gun?.item_interaction_secondary(user, tool, modifiers)

/obj/item/doppler_turret_offhand/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	turret.setDir(get_cardinal_dir(src, interacting_with))
	turret.stored_gun?.interact_with_atom(interacting_with, user, modifiers)

/obj/item/doppler_turret_offhand/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	turret.setDir(get_cardinal_dir(src, interacting_with))
	turret.stored_gun?.interact_with_atom_secondary(interacting_with, user, modifiers)

/obj/item/doppler_turret_offhand/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	turret.setDir(get_cardinal_dir(src, interacting_with))
	turret.stored_gun?.ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/doppler_turret_offhand/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	turret.setDir(get_cardinal_dir(src, interacting_with))
	turret.stored_gun?.ranged_interact_with_atom_secondary(interacting_with, user, modifiers)

/obj/item/doppler_turret_offhand/attack_hand(mob/user, list/modifiers)
	turret.stored_gun?.attack_hand(user, modifiers)

/obj/item/doppler_turret_offhand/attack_hand_secondary(mob/user, list/modifiers)
	turret.stored_gun?.attack_hand_secondary(user, modifiers)

/obj/item/doppler_turret_offhand/click_alt(mob/user)
	turret.stored_gun?.click_alt(user)

/obj/item/doppler_turret_offhand/click_alt_secondary(mob/user)
	turret.stored_gun?.click_alt_secondary(user)

/obj/item/doppler_turret_offhand/item_ctrl_click(mob/user)
	turret.stored_gun?.item_ctrl_click(user)

/obj/item/doppler_turret_offhand/click_ctrl_shift(mob/user)
	turret.stored_gun?.click_ctrl_shift(user)

/obj/item/doppler_turret_offhand/base_ranged_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	turret.stored_gun?.base_ranged_item_interaction(user, tool, modifiers)
	return ..()
