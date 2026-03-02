/obj/item/clothing/suit/apron/chef/colorable_apron
	name = "apron"
	desc = "A basic apron."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/GAGS/icons/mob/suit.dmi'
	icon_state = "/obj/item/clothing/suit/apron/chef/colorable_apron"
	post_init_icon_state = "apron"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE
	greyscale_colors = "#ffffff"
	greyscale_config = /datum/greyscale_config/apron
	greyscale_config_worn = /datum/greyscale_config/apron/worn
	flags_1 = IS_PLAYER_COLORABLE_1

// Janitor
/obj/item/clothing/suit/apron/janitor_cloak
	name = "waterproof poncho"
	desc = "A transparent, waterproof cloak for your cleaning needs."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/working.dmi'
	icon_state = "janicloak"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/working.dmi'
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS

//Robotocist
/obj/item/clothing/suit/hooded/techpriest
	slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_NECK
	name = "machine dustcover"
	desc = "Cotton sheeting provides a comfortable interior under layers of woven coutil, at once capable of breathing yet holding a watertight weft. \
	Closing with magnetic clasps, it is only one of many cloaklike designs used to keep the duststorms of Red Mars out-- saving on frequent cleaning, \
	maintenance, and costly repairs for her denizens."
	icon_state = "techpriest"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/costume.dmi'
	lefthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/techpriest_l.dmi'
	righthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/techpriest_r.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/costume.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/techpriest

/obj/item/clothing/head/hooded/techpriest
	name = "machine dustcover hood"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/costume.dmi'
	lefthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/techpriest_l.dmi'
	righthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/techpriest_r.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/head.dmi'
	desc = "Cotton sheeting provides a comfortable interior under layers of woven coutil, at once capable of breathing yet holding a watertight weft. \
	Closing with magnetic clasps, it is only one of many cloaklike designs used to keep the duststorms of Red Mars out-- saving on frequent cleaning, \
	maintenance, and costly repairs for her denizens."
	icon_state = "techpriesthood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS
