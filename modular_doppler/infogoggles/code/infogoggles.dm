/obj/item/clothing/glasses/infogoggles
	name = "info goggles"
	desc = "wip"
	icon = 'modular_doppler/infogoggles/icons/goggles.dmi'
	icon_state = "default-g"
	worn_icon = 'modular_doppler/infogoggles/icons/goggles_worn.dmi'
	actions_types = list(/datum/action/item_action/toggle)
	worn_icon_state = "default-g"
	flags_cover = GLASSESCOVERSEYES
	obj_flags = UNIQUE_RENAME | INFINITE_RESKIN
	pickup_sound = SFX_GOGGLES_PICKUP
	drop_sound = SFX_GOGGLES_DROP
	equip_sound = SFX_GOGGLES_EQUIP
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Default" = list(
			RESKIN_ICON_STATE = "default-g",
			RESKIN_WORN_ICON_STATE = "default-g",
		),
		"Supply Orange" = list(
			RESKIN_ICON_STATE = "supply_orange-g",
			RESKIN_WORN_ICON_STATE = "supply_orange-g",
		),
		"Electrician Yellow" = list(
			RESKIN_ICON_STATE = "electrician_yellow-g",
			RESKIN_WORN_ICON_STATE = "electrician_yellow",
		),
		"Nightvision Green" = list(
			RESKIN_ICON_STATE = "nightvision_green-g",
			RESKIN_WORN_ICON_STATE = "nightvision_green-g",
		),
		"Azure Blue" = list(
			RESKIN_ICON_STATE = "azure_blue-g",
			RESKIN_WORN_ICON_STATE = "azure_blue-g",
		),
		"Royal Purple" = list(
			RESKIN_ICON_STATE = "royal_purple-g",
			RESKIN_WORN_ICON_STATE = "royal_purple-g",
		),
		"Madness Red" = list(
			RESKIN_ICON_STATE = "madness_red-g",
			RESKIN_WORN_ICON_STATE = "madness_red-g",
		),
	)

/obj/item/clothing/glasses/infogoggles/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/glasses_stats_thief)

/obj/item/clothing/glasses/infogoggles/change_glass_color(new_color_type)
	if(glass_colour_type)
		RemoveElement(/datum/element/wearable_client_colour, glass_colour_type, ITEM_SLOT_EYES, forced = forced_glass_color, comsig_toggle = COMSIG_CLICK_CTRL)
	glass_colour_type = new_color_type
	if(glass_colour_type)
		AddElement(/datum/element/wearable_client_colour, glass_colour_type, ITEM_SLOT_EYES, forced = forced_glass_color, comsig_toggle = COMSIG_CLICK_CTRL)

/obj/item/clothing/glasses/infogoggles/attack_self(mob/living/user)
	adjust_visor(user)

/obj/item/clothing/glasses/infogoggles/adjust_visor(mob/user)
	. = ..()

/obj/item/clothing/glasses/infogoggles/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	worn_icon_state = "[initial(worn_icon_state)][up ? "up" : ""]"

/obj/item/clothing/glasses/infogoggles/up/Initialize(mapload)
	. = ..()
	visor_toggling()
