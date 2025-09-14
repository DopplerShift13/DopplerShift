/obj/item/clothing/glasses/mining_meson
	name = "explorer goggles"
	desc = "Protects the eyes from blowing snow and dust. Has built-in meson scanners."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/eyes/mining.dmi'
	icon_state = "snowgogs"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/eyes/mining.dmi'
	inhand_icon_state = null
	clothing_traits = list(TRAIT_MADNESS_IMMUNE)
	actions_types = list(/datum/action/item_action/toggle)
	flags_cover = GLASSESCOVERSEYES
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5)
	vision_flags = SEE_TURFS
	color_cutoffs = list(15, 15, 5)
	resistance_flags = FIRE_PROOF
	glass_colour_type = /datum/client_colour/glass_colour/yellow

/obj/item/clothing/glasses/mining_meson/attack_self(mob/living/user)
	adjust_visor(user)

/obj/item/clothing/glasses/mining_meson/adjust_visor(mob/user)
	. = ..()
	if(up)
		color_cutoffs = null
	else
		color_cutoffs = list(15, 15, 5)
	user.update_sight()

/obj/item/clothing/glasses/mining_meson/update_icon_state()
	. = ..()
	worn_icon_state = "[initial(icon_state)][up ? "-up" : ""]"

/obj/item/clothing/glasses/mining_meson/up/Initialize(mapload)
	. = ..()
	visor_toggling()

/obj/item/clothing/glasses/meson/night
	icon = 'modular_doppler/modular_cosmetics/icons/obj/eyes/mining.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/eyes/mining.dmi'
	glass_colour_type = /datum/client_colour/glass_colour/blue
