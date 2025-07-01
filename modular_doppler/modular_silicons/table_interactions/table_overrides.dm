
// Tables need a slightly fancier (more scuffed) custom implementation.
/obj/structure/table/attack_robot(mob/living/user, list/modifiers)
	if(isnull(user.pulling))
		return ..()
	if(get_dist(user, src) > 1)
		return

	if(is_flipped)
		return
	if(isliving(user.pulling))
		// Skip to table placing code instead.
		attack_hand(user, modifiers)
		return

	// For things that can pass tables,
	// we need our own implementation for pixel placement.
	user.Move_Pulled(src)
	if(user.pulling.loc != loc)
		return
	if(isitem(user.pulling))
		pixelplace_pulled_item(user.pulling, modifiers)
	user.visible_message(span_notice("[user] places [user.pulling] onto [src]."),
		span_notice("You place [user.pulling] onto [src]."))
	user.stop_pulling()

/obj/structure/table/proc/pixelplace_pulled_item(obj/item/placed_item, list/modifiers)
	// Undo our throw rotation.
	placed_item.undo_messy()

	// Items are centered by default, but we move them if click ICON_X and ICON_Y are available
	placed_item.pixel_x = base_pixel_x
	placed_item.pixel_y = base_pixel_y
	if(LAZYACCESS(modifiers, ICON_X) && LAZYACCESS(modifiers, ICON_Y))
		// Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		placed_item.pixel_x += clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X*0.5), ICON_SIZE_X*0.5)
		placed_item.pixel_y += clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(ICON_SIZE_Y*0.5), ICON_SIZE_Y*0.5)

// I just think it'd be really funny if robots could flip tables.
/obj/structure/table/attack_robot_secondary(mob/living/user, list/modifiers)
	if(!Adjacent(user))
		return ..()
	return attack_hand_secondary(user, modifiers)
