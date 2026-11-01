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

/obj/item/clothing/neck/capelet
	name = "capelet"
	desc = "A lightweight garment to keep warm in. How quaint."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/capelet"
	post_init_icon_state = "capelet"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#6496be"
	greyscale_config = /datum/greyscale_config/capelet
	greyscale_config_worn = /datum/greyscale_config/capelet/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/flowing_cape
	name = "flowing cape"
	desc = "A very drapey and dramatic cape- the kind that flows majestically in the wind. How regal!"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/flowing_cape"
	post_init_icon_state = "flowing_cape"
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#1a1d35"
	greyscale_config = /datum/greyscale_config/flowing_cape
	greyscale_config_worn = /datum/greyscale_config/flowing_cape/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/half_cape
	name = "half cape"
	desc = "For the ambitious adventurors who want to look cool just by existing."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/half_cape"
	post_init_icon_state = "half_cape"
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#360c0c"
	greyscale_config = /datum/greyscale_config/half_cape
	greyscale_config_worn = /datum/greyscale_config/half_cape/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/patterned_poncho
	name = "patterned poncho"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/patterned_poncho"
	post_init_icon_state = "patterned_poncho"
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#beb966"
	greyscale_config = /datum/greyscale_config/patterned_poncho
	greyscale_config_worn = /datum/greyscale_config/patterned_poncho/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/basic_poncho
	name = "basic poncho"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/basic_poncho"
	post_init_icon_state = "basic_poncho"
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#beb966"
	greyscale_config = /datum/greyscale_config/basic_poncho
	greyscale_config_worn = /datum/greyscale_config/basic_poncho/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/tesharian_mantle
	name = "traveller's mantle"
	desc = "A mantle of Teshari design, the so-called traveller's mantle is often constructed of scavenged silk and fabric from the ruins of Sirisai. Generally worn in a more decorative role, above insulating clothing."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/tesharian_mantle"
	post_init_icon_state = "tesharian_mantle"
	supported_bodyshapes = list(
		BODYSHAPE_HUMANOID,
		BODYSHAPE_TESHARI
	)
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/tesharian_mantle/worn,
		BODYSHAPE_TESHARI_T = /datum/greyscale_config/tesharian_mantle/worn/teshari
	)
	greyscale_config = /datum/greyscale_config/tesharian_mantle
	greyscale_config_worn = /datum/greyscale_config/tesharian_mantle/worn
	greyscale_colors = "#ffcc00#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/posh_mantle
	name = "posh mantle"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/posh_mantle"
	post_init_icon_state = "posh_mantle"
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#700f0c#b89a4a"
	greyscale_config = /datum/greyscale_config/posh_mantle
	greyscale_config_worn = /datum/greyscale_config/posh_mantle/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

//Marsian Fashion
/obj/item/clothing/neck/cloak/shoulder_cloak_redmars
	name = "red marsian shoulder cloak"
	desc = "Normally thrown atop something else, this thick, fur-collared mantle cinches in the front\
	and provides a strictly aesthetic quality, most often burnished in colors resembling the wearer's\
	typical environments of Red Mars."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/cloak/shoulder_cloak_redmars"
	post_init_icon_state = "shoulder_cloak_redmars"
	greyscale_config = /datum/greyscale_config/shoulder_cloak_redmars
	greyscale_config_worn = /datum/greyscale_config/shoulder_cloak_redmars/worn
	greyscale_colors = "#ffffff#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1


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

/obj/item/clothing/neck/blanket_shawl
	name = "blanket shawl"
	desc = "A reliable article of clothing that keeps you warm, without weighing you down too much."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/blanket_shawl"
	post_init_icon_state = "blanket_shawl"
	greyscale_config = /datum/greyscale_config/blanket_shawl
	greyscale_config_worn = /datum/greyscale_config/blanket_shawl/worn
	greyscale_colors = "#34472e"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT


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

