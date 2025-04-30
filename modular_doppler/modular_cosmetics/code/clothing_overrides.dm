/obj/item/clothing
	var/attachment_slot_override = NONE

/obj/item/clothing/accessory/can_attach_accessory(obj/item/clothing/clothing_item, mob/user)
	if(!attachment_slot || (clothing_item?.attachment_slot_override & attachment_slot))
		return TRUE
	return ..()

//for making rollerskates work again

/obj/item/clothing/shoes/wheelys
	supported_bodyshapes = null
	bodyshape_icon_files = null

/datum/component/riding/vehicle/scooter/skateboard/wheelys
	vehicle_move_delay = 1.5

//military webbing reskins

/obj/item/storage/belt/military
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Regular" = list(
			RESKIN_ICON_STATE = "militarywebbing",
			RESKIN_WORN_ICON_STATE = "militarywebbing"
		),
		"Alternate" = list(
			RESKIN_ICON = 'modular_doppler/modular_cosmetics/icons/obj/belt/webbing_skins.dmi',
			RESKIN_ICON_STATE = "militarywebbing2",
			RESKIN_WORN_ICON = 'modular_doppler/modular_cosmetics/icons/mob/belt/webbing_skins.dmi',
			RESKIN_WORN_ICON_STATE = "militarywebbing2"
		),
		"Evil" = list(
			RESKIN_ICON = 'modular_doppler/modular_cosmetics/icons/obj/belt/webbing_skins.dmi',
			RESKIN_ICON_STATE = "evilwebbing",
			RESKIN_WORN_ICON = 'modular_doppler/modular_cosmetics/icons/mob/belt/webbing_skins.dmi',
			RESKIN_WORN_ICON_STATE = "evilwebbing"
		)
	)
