// Prevents people from using modular computers while they're using the changing room
// Stops contact with the station
/obj/item/modular_computer/ui_interact(mob/user, datum/tgui/ui)
	if(HAS_TRAIT_FROM(user, TRAIT_FREE_GHOST, TRAIT_GHOSTROLE))
		if(ui)
			ui.close()
		balloon_alert(user, "changing room users can't use this!")
		return
	return ..()
