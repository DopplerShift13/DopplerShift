//for unusual clothing items that don't fit anywhere else

/obj/item/clothing/under/cowl_neck_shirt
	name = "cowl neck shirt and trousers"
	desc = "A fairly conventional broadcloth shirt rendered directional with a loose folded neckline in place of a \
	traditional shirt collar. Its complementary pants have eschewed belts and loops in favor of fit tabs."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	icon_state = "cowl_neck"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS
	can_adjust = FALSE

/obj/item/clothing/under/collared_shirt
	name = "collared shirt and trousers"
	desc = "This style of collared shirt has persisted now for centuries with only minor changes in styling, fit, \
	and proportion. This one is very contemporary to the times."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	icon_state = "collared_shirt"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS
	can_adjust = FALSE

/obj/item/clothing/under/pants/moto_leggings
	name = "moto leggings"
	desc = "Lab grown lambskin has been adhered to a spandex underlayer to produce a leather with considerable \
	four way stretch, allowing for a closer fit in leather pants than ever before. This style features integrated \
	kneepads."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/moto_leggings"
	post_init_icon_state = "moto_leggings"
	greyscale_config = /datum/greyscale_config/moto_leggings
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/moto_leggings/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/moto_leggings/worn/digi,
	)
	greyscale_colors = "#872c2c#780a0a"
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/pants/technyne_bottomwear
	name = "\improper TechNyne bottomwear ensemble"
	desc = "A pair of baggy shorts with a contoured waistband and weather-repellant fabrication. A pair of fitted kneepads \
	and knit baselayer leggings are included. The trio is surprisingly practical, except that it leaves the wearer with three \
	things to take off at the end of the day."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/technyne_bottomwear"
	post_init_icon_state = "tech_nyne_bottomwear"
	greyscale_config = /datum/greyscale_config/tech_nyne_bottomwear
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/tech_nyne_bottomwear/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/tech_nyne_bottomwear/worn/digi,
	)
	greyscale_colors = "#111111#5f5f5f#492222"
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/pants/megashorts
	name = "\improper JUNCO megashorts"
	desc = "A broad pair of ripstop shorts that have remained popular within Marsian skate culture for decades."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/megashorts"
	post_init_icon_state = "megashorts"
	greyscale_config = /datum/greyscale_config/megashorts
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/megashorts/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/megashorts/worn/digi,
	)
	greyscale_colors = "#5f5f5f"
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/pants/big_pants
	name = "\improper JUNCO megacargo pants"
	desc = "De riguer for techno classicists, these extreme wide leg pants come back into style every \
		now and then. This pair has generous onboard storage."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/big_pants"
	post_init_icon_state = "megacargos"
	greyscale_config = /datum/greyscale_config/megacargo_pants
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/megacargo_pants/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/megacargo_pants/worn/digi,
	)
	greyscale_colors = "#874f16#874f16"
	flags_1 = IS_PLAYER_COLORABLE_1
	alternate_worn_layer = LOW_FACEMASK_LAYER
	female_sprite_flags = NO_FEMALE_UNIFORM

/obj/item/clothing/under/pants/megajeans
	name = "\improper JUNCO megajeans"
	desc = "An ocean of denim for total encapsulation of the wearer's legs. The pockets are roomy beyond any sense \
	of practicality."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/megajeans"
	post_init_icon_state = "megajeans"
	greyscale_config = /datum/greyscale_config/megajeans
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/megajeans/worn,
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/megajeans/worn/digi,
	)
	greyscale_colors = "#2d59ac"
	flags_1 = IS_PLAYER_COLORABLE_1
	alternate_worn_layer = LOW_FACEMASK_LAYER
	female_sprite_flags = NO_FEMALE_UNIFORM

/obj/item/clothing/under/misc/gear_harness
	name = "gear harness"
	desc = "A simple, inconspicuous harness replacement for a jumpsuit."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)
	icon_state = "gear_harness"
	body_parts_covered = NONE
	attachment_slot_override = CHEST
	can_adjust = FALSE
	slot_flags = ITEM_SLOT_ICLOTHING | ITEM_SLOT_OCLOTHING
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/misc/gear_harness/Initialize(mapload)
	. = ..()
	allowed += GLOB.colonist_suit_allowed

/obj/item/clothing/under/misc/gear_harness/visible
	desc = "A loop of leather straps and metal jump rings for attaching modular storage systems."
	slot_flags = ITEM_SLOT_ICLOTHING | ITEM_SLOT_OCLOTHING | ITEM_SLOT_BELT
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/misc/gear_harness/visible"
	post_init_icon_state = "gear_harness_visible"
	greyscale_config = /datum/greyscale_config/gear_harness_visible
	greyscale_config_worn = /datum/greyscale_config/gear_harness_visible/worn
	greyscale_colors = "#292929"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/bunnysuit
	name = "bunny suit"
	desc = "Makes the wearer more attractive; even and especially men."
	icon_state = "bunnysuit"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN
	can_adjust = TRUE
	alt_covers_chest = FALSE

/obj/item/clothing/under/athletas_bodysuit
	name = "\improper ATHLETAS bodysuit"
	desc = "Hairfine threads of extruded silver-protein slurry ride from spindle to needle on a single production chain. \
	The fine jersey wicks and breathes while resisting microbial colonization."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/athletas_bodysuit"
	post_init_icon_state = "athletas_bodysuit"
	greyscale_config = /datum/greyscale_config/athletas_bodysuit
	greyscale_config_worn = /datum/greyscale_config/athletas_bodysuit/worn
	greyscale_colors = "#1c1c1c#c0c0c0"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE

/obj/item/clothing/under/bodysuit
	name = "bodysuit"
	desc = "Tightly fitting underclothes made of lycra. Toggle to switch between masc and fem variants."
	icon_state = "bodysuit"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/latexsuit
	name = "latex bodysuit"
	desc = "A form-fitting bodysuit made of a shiny latex polymer. Ages ago, it would've been a pain in the ass \
	to get into, but centuries of clothing technology have made wearing it easier than ever before. \
	Still, it takes longer to take off than an equivalent cloth garment."
	icon_state = "latexsuit_j"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	equip_sound = 'modular_doppler/modular_sounds/sound/items/latex.ogg'
	inhand_icon_state = "latexsuit"
	lefthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/miscellania_left.dmi'
	righthand_file = 'modular_doppler/modular_cosmetics/icons/mob/inhands/miscellania_right.dmi'
	strip_delay = 8 SECONDS
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE, BODYSHAPE_TAUR_SNAKE, BODYSHAPE_TAUR_HOOF, BODYSHAPE_TAUR_PAW)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania_digi.dmi',
		BODYSHAPE_TAUR_SNAKE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania_snake.dmi',
		BODYSHAPE_TAUR_HOOF_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania_hoof.dmi',
		BODYSHAPE_TAUR_PAW_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania_paw.dmi',
	)
	can_adjust = FALSE
	obj_flags = parent_type::obj_flags | INFINITE_RESKIN
	unique_reskin = list(
						"Masculine" = "latexsuit_j",
						"Feminine" = "latexsuit_d_j",
						"Masculine Half-suit" = "halflatexsuit_j",
						"Feminine Half-suit" = "halflatexsuit_d_j",
						)

//This makes the player have to sit through a 6 Second do_after when taking off the latex suit
/obj/item/clothing/under/latexsuit/can_mob_unequip(mob/user)
    if(!iscarbon(loc))
        return TRUE
    var/mob/living/carbon/human/wearer = loc
    if(wearer.w_uniform != src)
        return TRUE

    if(!do_after(user, 6 SECONDS, target = src))
        return FALSE
    return TRUE

/obj/item/clothing/under/latexsuit/gags_latexsuit
	desc = "A form-fitting bodysuit made of a multichromatic latex polymer. Ages ago, it would've been a pain in the ass \
	to get into, but centuries of clothing technology have made wearing it easier than ever before. \
	Still, it takes longer to take off than an equivalent cloth garment."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/latexsuit/gags_latexsuit"
	greyscale_config = /datum/greyscale_config/gags_latexsuit
	post_init_icon_state = "gags_latexsuit"
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_DIGITIGRADE_T = /datum/greyscale_config/gags_latexsuit/worn/digi,
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/gags_latexsuit/worn,
	)
	greyscale_colors = "#636369#636369"
	flags_1 = IS_PLAYER_COLORABLE_1
	unique_reskin = list(
						"Masculine" = "gags_latexsuit",
						"Feminine" = "gags_latexsuit_d",
						"Masculine Half-suit" = "gags_halflatexsuit",
						"Feminine Half-suit" = "gags_halflatexsuit_d",
						)

/obj/item/clothing/under/nevada_uniform
	name = "\improper Nevada Beverage Co. uniform"
	desc = "A comfortable paired set of a branded ThermoWick™ fabric henley and relaxed khaki joggers. For Nevada employees, \
	and Nevada diehards."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/under/miscellania.dmi'
	icon_state = "nevada_uniform"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/under/miscellania_digi.dmi',
	)
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS
	can_adjust = FALSE
