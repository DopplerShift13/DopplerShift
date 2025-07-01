
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

	user.Move_Pulled(src)
	if(user.pulling.loc != loc)
		return
	if(isitem(user.pulling))
		var/obj/item/pulled_item = user.pulling
		pulled_item.undo_messy()
	user.visible_message(span_notice("[user] places [user.pulling] onto [src]."),
		span_notice("You place [user.pulling] onto [src]."))
	user.stop_pulling()
