/obj/item/clothing/head/mining_cap
	name = "explorer cap"
	desc = "An explorer's cap with a hardened shell and fuzzy ear flaps to keep the cold away."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/head/hats.dmi'
	icon_state = "explorercap_down"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/head/hats.dmi'
	inhand_icon_state = null
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor_type = /datum/armor/hooded_explorer
	dog_fashion = /datum/dog_fashion/head/ushanka
	hair_mask = /datum/hair_mask/standard_hat_middle
	/// Tracks the status of the ear flaps
	var/earflaps = TRUE
	/// Sprite visible when the ushanka flaps are folded up.
	var/upsprite = "explorercap_up"
	/// Sprite visible when the ushanka flaps are folded down.
	var/downsprite = "explorercap_down"

/obj/item/clothing/head/mining_cap/attack_self(mob/user)
	if(earflaps)
		icon_state = upsprite
		to_chat(user, span_notice("You raise the ear flaps on [src]]."))
	else
		icon_state = downsprite
		to_chat(user, span_notice("You lower the ear flaps on [src]]."))
	earflaps = !earflaps
