/obj/structure/chair/beanbag
	name = "beanbag chair"
	desc = "A lofty plush sack of polyfill. Comfortable to sit on until you get very old."
	icon = 'icons/map_icons/objects.dmi'
	icon_state = "/obj/structure/chair/beanbag"
	post_init_icon_state = "beanbag"
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)	// made entirely of polyester
	buildstacktype = /datum/material/plastic
	item_chair = /obj/item/chair/beanbag
	resistance_flags = FLAMMABLE
	max_integrity = 70
	fishing_modifier = -10
	greyscale_config = /datum/greyscale_config/beanbag_chair
	greyscale_colors = "#73a061"

/obj/item/chair/beanbag
	name = "beanbag chair"
	desc = "A lofty plush sack of polyfill. Comfortable to sit on until you get very old."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/chair/beanbag"
	inhand_icon_state = "beanbag"
	post_init_icon_state = "beanbag"
	max_integrity = 70
	origin_type = /obj/structure/chair/beanbag
	greyscale_config = /datum/greyscale_config/beanbag_chair
	greyscale_config_inhand_left = /datum/greyscale_config/beanbag_chair/lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/beanbag_chair/righthand
	greyscale_colors = "#73a061"
	flags_1 = IS_PLAYER_COLORABLE_1
