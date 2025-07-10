/obj/item/clothing/head/bow
	name = "large bow"
	desc = "A large bow that you can place on top of your head."
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/bow"
	post_init_icon_state = "large_bow"
	greyscale_config = /datum/greyscale_config/large_bow
	greyscale_config_worn = /datum/greyscale_config/large_bow/worn
	greyscale_colors = "#7b9ab5"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/bow/small
	name = "small bow"
	desc = "A small compact bow that you can place on the side of your hair."
	icon_state = "/obj/item/clothing/head/bow/small"
	post_init_icon_state = "small_bow"
	greyscale_config = /datum/greyscale_config/small_bow
	greyscale_config_worn = /datum/greyscale_config/small_bow/worn

/obj/item/clothing/head/bow/small/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_clothes, "small_bow_t")

/obj/item/clothing/head/bow/back
	name = "back bow"
	desc = "A large bow that you can place on the back of your head."
	icon_state = "/obj/item/clothing/head/bow/back"
	post_init_icon_state = "back_bow"
	greyscale_config = /datum/greyscale_config/back_bow
	greyscale_config_worn = /datum/greyscale_config/back_bow/worn

/obj/item/clothing/head/bow/sweet
	name = "sweet bow"
	desc = "A sweet bow that you can place on the back of your head."
	icon_state = "/obj/item/clothing/head/bow/sweet"
	post_init_icon_state = "sweet_bow"
	greyscale_config = /datum/greyscale_config/sweet_bow
	greyscale_config_worn = /datum/greyscale_config/sweet_bow/worn
