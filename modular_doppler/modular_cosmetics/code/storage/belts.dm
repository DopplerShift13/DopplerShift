/obj/item/storage/belt/fannypack/custom
	name = "fannypack"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/storage/belt/fannypack/custom"
	post_init_icon_state = "fannypack"
	worn_icon_state = "fannypack"
	greyscale_colors = "#FF0000"
	greyscale_config = /datum/greyscale_config/fannypack
	greyscale_config_worn = /datum/greyscale_config/fannypack/worn
	flags_1 = IS_PLAYER_COLORABLE_1

// MODULAR EDIT: adjusting size to make it more useful
/obj/item/storage/belt/fannypack/Initialize(mapload)
	. = ..()
	//atom_storage.max_slots = 3
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/item/storage/belt/mining
	icon = 'modular_doppler/modular_cosmetics/icons/obj/storage/mining.dmi'
	icon_state = "explorer1"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/storage/mining.dmi'
	worn_icon_state = "explorer1"

/obj/item/storage/belt/mining/Initialize(mapload)
	. = ..()
	atom_storage.can_hold |= list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
	)

/obj/item/storage/belt/mining/alt
	icon = 'modular_doppler/modular_cosmetics/icons/obj/storage/mining.dmi'
	icon_state = "explorer2"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/storage/mining.dmi'
	worn_icon_state = "explorer2"
