/// Medical bay suits go here
//	Just the hospital gown for now
/obj/item/clothing/suit/toggle/labcoat/hospitalgown //Intended to keep patients modest while still allowing for surgeries
	name = "hospital gown"
	desc = "A complicated drapery with an assortment of velcros and strings, designed to keep a patient modest during medical stay and surgeries."
	icon_state = "hgown"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi'
	toggle_noun = "drapes"
	body_parts_covered = NONE
	armor_type = /datum/armor/none
	equip_delay_other = 8

/obj/item/clothing/suit/toggle/labcoat/lalunevest
	name = "sleeveless buttoned coat"
	desc = "A fashionable jacket bearing the La Lune insignia on the inside. It appears similar to a labcoat in design and materials, though the tag warns against it being a replacement for such."
	icon_state = "labcoat_lalunevest"
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/medical
	name = "medical labcoat"
	desc = "A suit that protects against minor chemical spills. This one is greener than you'd typically expect."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi'
	icon_state = "labcoat_med"

/obj/item/clothing/suit/toggle/labcoat/medical/unbuttoned
	name = "unbuttoned medical labcoat"
	desc = "Someone has taken to the task of cutting the top few buttons off this labcoat. It's particularly slutty in just the way you'd expect."
	icon_state = "labcoat_opentop"

/obj/item/clothing/suit/toggle/labcoat/high_vis
	name = "high-vis labcoat"
	desc = "A neon jacket piped with retroreflective strips and ample pocket room. This style is common for forensicists and field medical researchers."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/suit/labcoat.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/suit/labcoat.dmi'
	icon_state = "labcoat_highvis"
	blood_overlay_type = "armor"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/high_vis/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/suit/toggle/labcoat/fancy
	name = "Greyscale Fancy Labcoat"
	desc = "Throughout the test of determination, many have sought after such a fancy labcoat, one that was filled with many colors and wears."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy"
	post_init_icon_state = "fancy_labcoat"
	abstract_type = /obj/item/clothing/suit/toggle/labcoat/fancy
	supported_bodyshapes = null
	bodyshape_icon_files = null
	autogen_clothing_config = null
	greyscale_config_worn_bodyshapes = list(
		BODYSHAPE_HUMANOID_T = /datum/greyscale_config/fancy_labcoat/worn,
		BODYSHAPE_TESHARI_T = /datum/greyscale_config/fancy_labcoat/worn/teshari
	)
	greyscale_config = /datum/greyscale_config/fancy_labcoat
	greyscale_config_worn = /datum/greyscale_config/fancy_labcoat/worn
	greyscale_colors = "#EEEEEE#4A77A1"
	gets_cropped_on_taurs = FALSE
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/labcoat/fancy/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/xeno

/obj/item/clothing/suit/toggle/labcoat/fancy/rd
	name = "research directors labcoat"
	desc = "A somewhat premium labcoat for certified Research Directors. It has an extra plastic-latex lining on the outside for more protection from chemical and viral hazards."
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy/rd"
	greyscale_colors = "#620B73#EEEEEE"
	armor_type = /datum/armor/jacket_research_director

/obj/item/clothing/suit/toggle/labcoat/fancy/regular
	name = "doctor's labcoat"
	desc = "A somewhat premium labcoat for doctors and researchers."
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy/regular"
	greyscale_colors = "#EEEEEE#1D7D09"

/obj/item/clothing/suit/toggle/labcoat/fancy/pharmacist
	name = "pharmacist's labcoat"
	desc = "A somewhat premium labcoat for chemistry which protects the wearer from acid spills."
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy/pharmacist"
	greyscale_colors = "#EEEEEE#E6935C"

/obj/item/clothing/suit/toggle/labcoat/fancy/geneticist
	name = "geneticist's labcoat"
	desc = "A somewhat premium labcoat for geneticists."
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy/geneticist"
	greyscale_colors = "#EEEEEE#7497C0"

/obj/item/clothing/suit/toggle/labcoat/fancy/roboticist
	name = "roboticist's labcoat"
	desc = "A somewhat premium labcoat for roboticists."
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/fancy/roboticist"
	greyscale_colors = "#2F2E31#A52F29"
