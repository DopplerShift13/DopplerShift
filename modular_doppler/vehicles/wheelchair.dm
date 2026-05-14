/*
*	a cooler custom fit wheelchair with better speed and gags-ability
*/

/obj/vehicle/ridden/wheelchair/ace_custom
	name = "ace custom wheelchair"
	desc = "No mere hospital equipment, this chair is built to the personal fit of its rider. \
	It's capable of much higher speed."
	icon = 'icons/map_icons/objects.dmi'
	icon_state = "/obj/vehicle/ridden/wheelchair/ace_custom"
	post_init_icon_state = "ace_custom_wheelchair"
	greyscale_colors = "#1c1c1c#3399ff#111111"
	greyscale_config = /datum/greyscale_config/ace_custom_wheelchair
	flags_1 = IS_PLAYER_COLORABLE_1
	overlay_icon = "ace_custom_wheelchair_overlay"
	delay_multiplier = 0	// did you know skilled wheelchair users can outpace olympic runners?
	foldabletype = /obj/item/wheelchair/ace_custom

/obj/vehicle/ridden/wheelchair/ace_custom/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/wheelchair/hand/ace_custom)

/obj/item/wheelchair/ace_custom
	name = "ace custom wheelchair"
	desc = "A custom-fit wheelchair, folded for stowage."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/wheelchair/ace_custom"
	post_init_icon_state = "ace_custom_wheelchair"
	greyscale_colors = "#1c1c1c#3399ff#111111"
	greyscale_config = /datum/greyscale_config/ace_custom_wheelchair_item
	flags_1 = IS_PLAYER_COLORABLE_1
	unfolded_type = /obj/vehicle/ridden/wheelchair/ace_custom

/datum/component/riding/vehicle/wheelchair/hand/ace_custom
	delay_multiplier = 2	// produces a similar speed to a running spaceman
