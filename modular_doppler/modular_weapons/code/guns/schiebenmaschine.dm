/*
*	aw hell naw ikea makin guns now
*	the word "schießen" means to shoot but the word "scheiße" means to shit
*/

/obj/item/gun/ballistic/automatic/schiebenmaschine
	name = "\improper SportsCo™ 'Schießenmaschine' personal defense platform"
	desc = "A wonder of single-use plastic and physical DRM, brought to you by SportCo™ Sportings Goods Supplier. An emblazoned label admonishes against reloading \
	and another encourages recycling the frame once the integral magazine is depleted. Available in a wide range of fashion colors."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "/obj/item/gun/ballistic/automatic/schiebenmaschine"
	inhand_icon_state = "/obj/item/gun/ballistic/automatic/schiebenmaschine"
	post_init_icon_state = "schiebenmaschine"
	greyscale_config = /datum/greyscale_config/schiebenmaschine
	greyscale_config_worn = /datum/greyscale_config/schiebenmaschine_worn
	greyscale_config_inhand_left = /datum/greyscale_config/schiebenmaschine_lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/schiebenmaschine_righthand
	greyscale_colors = "#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1
	bolt_type = BOLT_TYPE_OPEN
	casing_ejector = FALSE
	show_bolt_icon = FALSE
	internal_magazine = TRUE
	tac_reloads = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/schiebenmaschine

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
	)

/obj/item/ammo_box/magazine/internal/schiebenmaschine
	name = "integrated schießenmagaschine"
	ammo_type = /obj/item/ammo_casing/sportsco3mm
	caliber = CALIBER_3MMSPORTSCO
	max_ammo = 50
