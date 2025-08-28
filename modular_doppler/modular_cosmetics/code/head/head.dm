/obj/item/clothing/head/standalone_hood
	name = "hood"
	desc = "A hood with a bit of support around the neck so it actually stays in place, for all those times you want a hood without the coat."
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/GAGS/icons/mob/head.dmi'
	icon_state = "/obj/item/clothing/head/standalone_hood"
	post_init_icon_state = "hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS|HIDEHAIR
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#4e4a43#F1F1F1"
	greyscale_config = /datum/greyscale_config/standalone_hood
	greyscale_config_worn = /datum/greyscale_config/standalone_hood/worn

/obj/item/clothing/head/costume/papakha
	name = "papakha"
	desc = "A big wooly clump of fur designed to go on your head."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/costume.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/costume.dmi'
	icon_state = "papakha"
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

/obj/item/clothing/head/costume/papakha/white
	icon_state = "papakha_white"

/obj/item/clothing/head/hooded/winterhood
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/hoods.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/hoods.dmi'

/obj/item/clothing/head/cap_colonysec
	name = "security colonial cap"
	desc = "The day security raided your department was the most important day of your life. But for me? It was tuesday."
	icon_state = "cap_colonysec"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/sec_hats.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/sec_hats.dmi'
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Regular" = list(
			RESKIN_ICON_STATE = "cap_colonysec",
			RESKIN_WORN_ICON_STATE = "cap_colonysec"
		),
		"Alternate" = list(
			RESKIN_ICON = 'modular_doppler/modular_cosmetics/icons/obj/head/sec_hats.dmi',
			RESKIN_ICON_STATE = "cap_colonysecalt",
			RESKIN_WORN_ICON = 'modular_doppler/modular_cosmetics/icons/mob/head/sec_hats.dmi',
			RESKIN_WORN_ICON_STATE = "cap_colonysecalt"
		)
	)
	armor_type = /datum/armor/head_helmet
	strip_delay = 60

/obj/item/clothing/head/flowing_headband
	name = "flowing headband"
	desc = "A headband from across the galaxy. Said to make the impossible possible."
	icon_state = "headband_snake"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/sec_hats.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/sec_hats.dmi'
	armor_type = /datum/armor/head_helmet
	strip_delay = 60

/obj/item/clothing/head/helmet/sec/phelmet
	name = "\improper Yennika full helmet"
	desc = "A full-head helmet that requires extensive tooling and robot setups to safely don and doff, making such \
		an act impossible in usage far from home."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/hats.dmi'
	icon_state = "phelmet"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/hats.dmi'
	flags_cover = HEADCOVERSEYES|EARS_COVERED|HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF // Someone wants to be the main character
	clothing_flags = SNUG_FIT | STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)

/obj/item/clothing/head/helmet/sec/phelmet/examine(mob/user)
	. = ..()
	. += span_warning("Once you put this on, it cannot be taken off! Think carefully about what you're doing!")

/obj/item/clothing/head/helmet/sec/phelmet/equipped(mob/living/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		ADD_TRAIT(src, TRAIT_NODROP, type) // Remember, you're here forever!

/obj/item/clothing/head/helmet/sec/phelmet/click_alt(mob/user)
	flipped_visor = !flipped_visor
	if(flipped_visor)
		flags_cover &= ~HEADCOVERSMOUTH
		playsound(src, SFX_VISOR_DOWN, 20, TRUE, -1)
		balloon_alert(user, "mouth uncovered")
	else
		flags_cover |= HEADCOVERSMOUTH
		playsound(src, SFX_VISOR_UP, 20, TRUE, -1)
		balloon_alert(user, "mouth covered")
	return CLICK_ACTION_SUCCESS
