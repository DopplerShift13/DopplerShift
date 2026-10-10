/obj/item/clothing/head/utility/headlights
	name = "head lamp"
	desc = "A flashlight, but stuck to your forehead instead. Genius! How have we never before thought of such a thing?"
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	icon_state = "headlamp"
	inhand_icon_state = null
	body_parts_covered = NONE
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
	)

/obj/item/clothing/head/utility/headlights/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		light_overlay = "light", \
	)

/obj/item/clothing/head/soft/frontier_colonist
	name = "jungle workmen's cap"
	desc = "A heavily starched cap with a brim and short ear flaps typical in the New Gibraltar jungle style. \
		An orange pin is stuck through the front, a callback to colony roughneck tradition of delineating job roles \
		through coloured pins on their otherwise similar uniforms."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "cap"
	inhand_icon_state = null
	soft_type = "cap"
	soft_suffix = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi',
	)
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "cap"
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/soft/frontier_colonist/flip(mob/user)
	return // nah mate

/obj/item/clothing/head/soft/frontier_colonist/medic
	name = "jungle medic's cap"
	desc = "A heavily starched cap with a brim and short ear flaps typical in the New Gibraltar jungle style. \
		A turquoise pin is stuck through the front, a callback to colony roughneck tradition of delineating job roles \
		through coloured pins on their otherwise similar uniforms."
	icon_state = "cap_medical"
	soft_type = "cap_medical"
	worn_icon_state = "cap_medical"

/obj/item/clothing/head/frontier_colonist_helmet
	name = "\improper NG-Tek padded helmet"
	desc = "A soft helmet with thick padded ridges along the top, meant for the hard working maintenance workers on New Gibraltar \
		who often have to work in confined colony infrastructure."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "tanker"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "tanker"
	inhand_icon_state = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi',
	)
	armor_type = /datum/armor/colonist_armor
	resistance_flags = NONE
	flags_inv = 0
	clothing_flags = SNUG_FIT
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/frontier_colonist_helmet/hardhat
	name = "thermoset hardhat"
	desc = "A bowl-shaped hardhat made of modern thermoset organic plastics, meaning that it will not deform due to heat once manufactured. \
		Due to the precious nature of most hardened metals, and ease of production of modern thermoset plastics, the translucent orange \
		material has taken over much of industrial protection wear."
	icon_state = "hardhat"
	worn_icon_state = "hardhat"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/frontier_headscarf
	name = "frontier headscarf"
	desc = "A casual wrapping of fabric to keep the sunlight off your head, or just for style."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	icon_state = "/obj/item/clothing/head/frontier_headscarf"
	inhand_icon_state = null
	post_init_icon_state = "colony_headscarf"
	greyscale_colors = "#62846e#62846e#444444"
	greyscale_config = /datum/greyscale_config/colony_headscarf
	greyscale_config_worn = /datum/greyscale_config/colony_headscarf/worn
	inhand_icon_state = null
	hair_mask = /datum/hair_mask/standard_hat_middle
	flags_1 = IS_PLAYER_COLORABLE_1
