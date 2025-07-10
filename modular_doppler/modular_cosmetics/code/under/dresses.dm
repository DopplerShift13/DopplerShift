/obj/item/clothing/under/dress/doppler
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/dresses.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/dresses.dmi'

/obj/item/clothing/under/dress/doppler/pentagram
	name = "pentagram strapped dress"
	desc = "A soft dress with straps designed to rest as a pentragram. Isn't this against NT's whole \"Authorized Religion\" stuff?"
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/pentagram"
	post_init_icon_state = "dress_pentagram"
	body_parts_covered = CHEST|GROIN|LEGS
	greyscale_config = /datum/greyscale_config/pentagram_dress
	greyscale_config_worn = /datum/greyscale_config/pentagram_dress/worn
	greyscale_colors = "#403c46"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/doppler/strapless
	name = "strapless dress"
	desc = "Typical formal wear with no straps, instead opting to be tied at the waist. Most likely will need constant adjustments."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/strapless"
	post_init_icon_state = "dress_strapless"
	body_parts_covered = CHEST|GROIN|LEGS
	greyscale_config = /datum/greyscale_config/strapless_dress
	greyscale_config_worn = /datum/greyscale_config/strapless_dress/worn
	greyscale_colors = "#cc0000#5f5f5f"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/doppler/giant_scarf
	name = "giant scarf"
	desc = "An absurdly massive scarf, worn as the main article of clothing over the body. Ironically, not very suitable for the cold."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/giant_scarf"
	post_init_icon_state = "giant_scarf"
	body_parts_covered = CHEST|GROIN|LEGS
	greyscale_config = /datum/greyscale_config/giant_scarf
	greyscale_config_worn = /datum/greyscale_config/giant_scarf/worn
	greyscale_colors = "#EEEEEE"
	female_sprite_flags = NO_FEMALE_UNIFORM
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/dress/doppler/flower
	name = "flower dress"
	desc = "Lovely dress. Colored like the autumn leaves."
	icon_state = "flower_dress"
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/under/dress/doppler/pinktutu
	name = "pink tutu"
	desc = "A fluffy pink tutu."
	icon_state = "pinktutu"

/obj/item/clothing/under/maid_costume
	name = "maid costume"
	desc = "Maid in China."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/maid_costume"
	post_init_icon_state = "maid_costume"
	greyscale_config = /datum/greyscale_config/maid_costume
	greyscale_config_worn = /datum/greyscale_config/maid_costume/worn
	greyscale_colors = "#7b9ab5#edf9ff"
	flags_1 = IS_PLAYER_COLORABLE_1

/*
*	LUNAR AND JAPANESE CLOTHES
*/

/obj/item/clothing/under/dress/doppler/qipao
	name = "qipao"
	desc = "A qipao, traditionally worn in ancient Earth China by women during social events and lunar new years."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/qipao"
	post_init_icon_state = "qipao"
	body_parts_covered = CHEST|GROIN|LEGS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b"
	greyscale_config = /datum/greyscale_config/lunar_japanese
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/dress/doppler/qipao/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/dress/doppler/qipao/customtrim
	icon_state = "/obj/item/clothing/under/dress/doppler/qipao/customtrim"
	greyscale_colors = "#2b2b2b#ffce5b"
	greyscale_config = /datum/greyscale_config/lunar_japanese/bicol
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/bicol/worn

/obj/item/clothing/under/dress/doppler/qipao/customtrim/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/bicol/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/bicol/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/dress/doppler/cheongsam
	name = "cheongsam"
	desc = "A cheongsam, traditionally worn in ancient Earth China by men during social events and lunar new years."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/cheongsam"
	post_init_icon_state = "cheongsam"
	body_parts_covered = CHEST|GROIN|LEGS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b#353535"
	greyscale_config = /datum/greyscale_config/lunar_japanese/bicol
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/bicol/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/dress/doppler/cheongsam/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/bicol/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/bicol/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/dress/doppler/cheongsam/customtrim
	icon_state = "/obj/item/clothing/under/dress/doppler/cheongsam/customtrim"
	greyscale_colors = "#2b2b2b#ffce5b#353535"
	greyscale_config = /datum/greyscale_config/lunar_japanese/tricol
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/tricol/worn

/obj/item/clothing/under/dress/doppler/cheongsam/customtrim/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/tricol/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/tricol/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/dress/doppler/yukata
	name = "yukata"
	desc = "A traditional ancient Earth Japanese yukata, typically worn in casual settings."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/doppler/yukata"
	post_init_icon_state = "yukata"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b#666666"
	greyscale_config = /datum/greyscale_config/lunar_japanese/bicol
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/bicol/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/dress/doppler/yukata/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/bicol/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/bicol/worn/digi
	set_greyscale(colors = greyscale_colors)

/// GAGS-IFIED TG LUNAR/JAPANESE CLOTHES

/obj/item/clothing/under/costume/yukata
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/costume.dmi',
	BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/dresses_digi.dmi')

/obj/item/clothing/under/costume/yukata/greyscale
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/yukata/greyscale"
	post_init_icon_state = "yukata1"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#333333#AAAAAA#AA0000"
	greyscale_config = /datum/greyscale_config/lunar_japanese/tg
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/tg/worn

/obj/item/clothing/under/costume/yukata/greyscale/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/tg/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/tg/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/costume/yukata/green/greyscale
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/yukata/green/greyscale"
	post_init_icon_state = "yukata2"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#333333#AAAAAA#AA0000#AA0000"
	greyscale_config = /datum/greyscale_config/lunar_japanese/tg/decorated
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/tg/decorated/worn

/obj/item/clothing/under/costume/yukata/green/greyscale/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/tg/decorated/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/tg/decorated/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/costume/yukata/white/greyscale
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/yukata/white/greyscale"
	post_init_icon_state = "yukata3"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#AAAAAA#0066AA#0066AA#00AAFF"
	greyscale_config = /datum/greyscale_config/lunar_japanese/tg/decorated
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/tg/decorated/worn

/obj/item/clothing/under/costume/yukata/white/greyscale/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/tg/decorated/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/tg/decorated/worn/digi
	set_greyscale(colors = greyscale_colors)

/obj/item/clothing/under/costume/kimono
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/costume.dmi',
	BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/dresses_digi.dmi')

/obj/item/clothing/under/costume/kimono/greyscale
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/kimono/greyscale"
	post_init_icon_state = "kimono1"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#333333#AAAAAA#AA0000"
	greyscale_config = /datum/greyscale_config/lunar_japanese/tg
	greyscale_config_worn = /datum/greyscale_config/lunar_japanese/tg/worn

/obj/item/clothing/under/costume/kimono/greyscale/Initialize(mapload)
	. = ..()
	greyscale_config_worn_bodyshapes = list()
	greyscale_config_worn_bodyshapes["[BODYSHAPE_HUMANOID]"] = /datum/greyscale_config/lunar_japanese/tg/worn
	greyscale_config_worn_bodyshapes["[BODYSHAPE_DIGITIGRADE]"] = /datum/greyscale_config/lunar_japanese/tg/worn/digi
	set_greyscale(colors = greyscale_colors)
