
// Conveyors let you place pulled items on attack hand natively.
/obj/machinery/conveyor/attack_robot(mob/user, modifiers)
	if(isnull(user.pulling))
		return ..()

	if(get_dist(user, src) > 1)
		return
	attack_hand(user, modifiers)


// Open turfs just need to let you move your pulled object to them.
/turf/open/attack_robot(mob/user, modifiers)
	if(isnull(user.pulling))
		return ..()

	if(get_dist(user, src) > 1)
		return
	user.Move_Pulled(src)


// Racks need their own implementation.
/obj/structure/rack/attack_robot(mob/user, modifiers)
	if(isnull(user.pulling))
		return ..()

	if(get_dist(user, src) > 1)
		return
	if(!isitem(user.pulling))
		return

	var/obj/item/pulled_item = user.pulling
	user.Move_Pulled(src)
	if(pulled_item.loc != loc)
		return
	pulled_item.undo_messy()
	pulled_item.pixel_x = base_pixel_x
	pulled_item.pixel_y = base_pixel_y
	user.visible_message(span_notice("[user] places [user.pulling] onto [src]."),
		span_notice("You place [user.pulling] onto [src]."))
	user.stop_pulling()
