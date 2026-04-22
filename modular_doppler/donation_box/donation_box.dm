/obj/structure/closet/crate/donation
	name = "donation box"
	desc = "A steel crate, modified into a donation box via a small slot on the top. Allows insertion of items without allowing removal."
	icon = 'modular_doppler/donation_box/icons/donation_box.dmi'
	icon_state = "donation_box"
	base_icon_state = "donation_box"

/obj/structure/closet/crate/donation/secure
	name = "secure donation box"
	desc = "A steel crate, modified into a donation box via a small slot on the top. Allows insertion of items without allowing removal."
	icon = 'modular_doppler/donation_box/icons/donation_box.dmi'
	icon_state = "securedonation_box"
	base_icon_state = "securedonation_box"
	secure = TRUE
	card_reader_installed = TRUE

/obj/structure/closet/crate/donation/examine(mob/user)
	. = ..()

	. += span_smallnotice("When closed, you can [EXAMINE_HINT("Right-Click")] with an item to place it in the box, if able.")

/obj/structure/closet/crate/donation/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (opened)
		return NONE
	if (user.combat_mode)
		return NONE
	if (!LAZYACCESS(modifiers, RIGHT_CLICK))
		return NONE
	if (!insertion_allowed(tool))
		balloon_alert(user, "can't fit it in!")
		return NONE

	user.balloon_alert_to_viewers("inserts [tool]", "inserted [tool]")
	user.visible_message(
		span_notice("[user] inserts [tool] into the small slot on [src]."),
		span_notice("You insert [tool] into the small slot on [src].")
	)

	if (insert(tool))
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/donation_box_kit
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "plasticbox"
	name = "donation kit"
	desc = "Contains a folded donation box, with an access lock and a few tools inside."

/obj/item/donation_box_kit/attack_self(mob/user, modifiers)
	user.balloon_alert_to_viewers("deploying...")
	if (!do_after(user, 3 SECONDS, src))
		return FALSE
	var/obj/structure/closet/crate/donation/secure/box = new /obj/structure/closet/crate/donation/secure(get_turf(user))
	new /obj/item/hand_labeler(box)
	playsound(src, 'sound/machines/terminal/terminal_eject.ogg', 70, TRUE)
	qdel(src)

	return TRUE

