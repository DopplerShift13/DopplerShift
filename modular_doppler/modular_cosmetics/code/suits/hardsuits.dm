
/obj/item/clothing/suit/space/pirate/tiziran
	name = "\improper Tiziran EVA suit"
	desc = "An EVA rated suit designed for Tiziran physiology. Its broad availability makes it a popular choice even beyond its issue to \
	Imperial operators."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/spacesuit.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/spacesuit.dmi'
	icon_state = "tiziran_raider"
	worn_icon_state = "tiziran_raider"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(
		/obj/item/gun,
		/obj/item/melee,
		/obj/item/restraints/handcuffs,
		/obj/item/tank/internals,
		/obj/item/tank/jetpack,
		)
	armor_type = /datum/armor/tiziran_raider
	cell = /obj/item/stock_parts/power_store/cell/super
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/spacesuit.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/mob/suit/spacesuit_digi.dmi',
		)

/obj/item/clothing/suit/space/pirate/tiziran/red
	icon_state = "tiziran_raider_red"
	worn_icon_state = "tiziran_raider_red"

/obj/item/clothing/suit/space/pirate/tiziran/yellow
	icon_state = "tiziran_raider_yellow"
	worn_icon_state = "tiziran_raider_yellow"

/datum/armor/tiziran_raider
	melee = 40
	bullet = 50
	laser = 30
	energy = 40
	bomb = 35
	bio = 40
	fire = 75
	acid = 90
	wound = 20
