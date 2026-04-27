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

/obj/machinery/power/floodlight/lavalamp
	name = "lava lamp"
	desc = "A lamp whose bulb is used to warm a bottle of liquid medium and paraffin until the wax begins to dance. \
	The narrow circular base and coke-bottle shape echo Brâncuși in a schlocky kind of way."
	icon = 'modular_doppler/modular_items/icons/furniture.dmi'
	icon_state = "lavalamp"
	light_color = LIGHT_COLOR_LAVA
	light_power = 1

// breaks the screwdriver act because taking the light tube out turns this into a normal floodlight frame as hardcoded upstream
/obj/machinery/power/floodlight/lavalamp/screwdriver_act(mob/living/user, obj/item/tool)
	return

/obj/structure/punching_bag/scratching_post
	name = "scratching post"
	desc = "Some rope secured around a wooden post, for cats and catmodders to sharpen their claws on."
	icon = 'modular_doppler/modular_items/icons/furniture.dmi'
	icon_state = "scratching_post"
	density = TRUE
