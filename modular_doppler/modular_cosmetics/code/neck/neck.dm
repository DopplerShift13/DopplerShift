//////////////////
//CAPES & CLOAKS//
//////////////////

/obj/item/clothing/neck/robe_cape
	name = "robe cape"
	desc = "A comfortable northern-style cape, draped down your back and held around your neck with a brooch. Reminds you of a sort of robe."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/robe_cape"
	post_init_icon_state = "robe_cape"
	greyscale_config = /datum/greyscale_config/robe_cape
	greyscale_config_worn = /datum/greyscale_config/robe_cape/worn
	greyscale_colors = "#867361"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/long_cape
	name = "long cape"
	desc = "A graceful cloak that carefully surrounds your body."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/long_cape"
	post_init_icon_state = "long_cape"
	greyscale_config = /datum/greyscale_config/long_cape
	greyscale_config_worn = /datum/greyscale_config/long_cape/worn
	greyscale_colors = "#867361#4d433d#b2a69c#b2a69c"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/long_cape/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "cape")

/obj/item/clothing/neck/wide_cape
	name = "wide cape"
	desc = "A proud, broad-shouldered cloak with which you can protect the honor of your back."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/wide_cape"
	post_init_icon_state = "wide_cape"
	greyscale_config = /datum/greyscale_config/wide_cape
	greyscale_config_worn = /datum/greyscale_config/wide_cape/worn
	greyscale_colors = "#867361#4d433d#b2a69c"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/ranger_poncho
	name = "ranger poncho"
	desc = "Aim for the Heart, Ramon."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/ranger_poncho"
	post_init_icon_state = "ranger_poncho"
	greyscale_config = /datum/greyscale_config/ranger_poncho
	greyscale_config_worn = /datum/greyscale_config/ranger_poncho/worn
	greyscale_colors = "#917A57#858585"
	flags_1 = IS_PLAYER_COLORABLE_1
	heat_protection = CHEST

/obj/item/clothing/neck/ranger_poncho/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "poncho")

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/face_scarf
	name = "face scarf"
	desc = "A warm looking scarf that you can easily put around your face."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/face_scarf"
	post_init_icon_state = "face_scarf"
	greyscale_config = /datum/greyscale_config/face_scarf
	greyscale_config_worn = /datum/greyscale_config/face_scarf/worn
	greyscale_colors = "#a52424"
	flags_1 = IS_PLAYER_COLORABLE_1
	flags_inv = HIDEFACIALHAIR

/obj/item/clothing/neck/face_scarf/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "scarf")

///////////////
//MISCELLANIA//
///////////////

/obj/item/clothing/neck/mantle/recolorable
	name = "mantle"
	desc = "A simple drape over the shoulders."
	icon = 'icons/map_icons/clothing/neck.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/GAGS/icons/mob/neck.dmi'
	icon_state = "/obj/item/clothing/neck/mantle/recolorable"
	post_init_icon_state = "mantle"
	greyscale_colors = "#ffffff"
	greyscale_config = /datum/greyscale_config/mantle
	greyscale_config_worn = /datum/greyscale_config/mantle/worn
	flags_1 = IS_PLAYER_COLORABLE_1
