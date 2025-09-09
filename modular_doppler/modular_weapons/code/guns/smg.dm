/obj/item/gun/ballistic/automatic/wt550
	name = "\improper Sindaryo PDW"
	desc = "The high tech PDW that no man wishes to be the maintainer of, lest they be cursed to \
		ill fated attempts to fix the laser ammo display when it inevitably breaks."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "sindaryo"

/obj/item/gun/ballistic/automatic/wt550/add_bayonet_point()
	return

// Magazines

/obj/item/ammo_box/magazine/wt550m9
	name = "\improper Sindaryo magazine (6mm)"
	desc = "A magazine specifically for use with the Sindaryo PDW."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	ammo_band_icon = null
	ammo_band_color = null
	ammo_type = /obj/item/ammo_casing/c6ng
	caliber = CALIBER_6MMGIBRALTAR
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	max_ammo = 14

/obj/item/ammo_box/magazine/wt550m9/wtap
	name = "\improper Sindaryo magazine (6mm Ultrasport)"
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	MAGAZINE_TYPE_ARMORPIERCE
	ammo_type = /obj/item/ammo_casing/c6ng/match

/obj/item/ammo_box/magazine/wt550m9/wtic
	name = "\improper Sindaryo magazine (6mm Rubber)"
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	MAGAZINE_TYPE_INCENDIARY
	ammo_type = /obj/item/ammo_casing/c6ng/rubber

// RND designs

/datum/design/mag_autorifle
	name = "Sindaryo Magazine (6mm) (Lethal)"
	desc = "A 14 round magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/datum/design/mag_autorifle/ap_mag
	name = "Sindaryo Ultrasport Magazine (6mm Ultrasport) (Lethal)"
	desc = "A 14 round match grade magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 6)

/datum/design/mag_autorifle/ic_mag
	name = "Sindaryo Rubber Magazine (4.6x30mm Rubber) (Less Lethal)"
	desc = "A 14 round rubber magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)

/*
*	aw hell naw ikea makin guns now
*	the word "schießen" means to shoot but the word "scheiße" means to shit
*/

/obj/item/gun/ballistic/automatic/schiebenmaschine
	name = "\improper SportsCo™ 'Schießenmaschine' personal defense platform"
	desc = "A wonder of single-use plastic and physical DRM, brought to you by SportsCo™ Sportings Goods Supplies. An emblazoned label admonishes against reloading \
	and another encourages recycling the frame once the integral magazine is depleted. Available in a wide range of fashion colors."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/gun/ballistic/automatic/schiebenmaschine"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "schiebenmaschine"
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	inhand_icon_state = "schiebenmaschine"
	post_init_icon_state = "schiebenmaschine"
	greyscale_config = /datum/greyscale_config/schiebenmaschine
	greyscale_config_worn = /datum/greyscale_config/schiebenmaschine_worn
	greyscale_config_inhand_left = /datum/greyscale_config/schiebenmaschine_lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/schiebenmaschine_righthand
	greyscale_colors = "#bb2222" //randomized on init but we need this for mapping icons and stuff
	unique_reskin_changes_base_icon_state = FALSE
	can_suppress = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1
	bolt_type = BOLT_TYPE_OPEN
	casing_ejector = FALSE
	show_bolt_icon = FALSE
	internal_magazine = TRUE
	tac_reloads = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/schiebenmaschine
	custom_price = PAYCHECK_CREW * 5

/obj/item/gun/ballistic/automatic/schiebenmaschine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.3 SECONDS)
	greyscale_colors = pick(
		"#418dab",
		"#fb7cc7",
		"#bb2222",
		"#2b4f2c",
		"#c8ca36",
		"#393938",
		"#cf7f0c",
		"#1c1c1c",
		"#ffffff",
	)

/obj/item/gun/ballistic/automatic/schiebenmaschine/load_gun(obj/item/ammo, mob/living/user)
	balloon_alert(user, "bolt is sealed!")
	return

/obj/item/ammo_box/magazine/schiebenmaschine
	name = "integrated schießenmagaschine"
	ammo_type = /obj/item/ammo_casing/sportsco3mm
	caliber = CALIBER_3MMSPORTSCO
	max_ammo = 30
