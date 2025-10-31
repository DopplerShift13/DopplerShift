/obj/item
	/// TODO doc
	var/list/autogen_clothing_config
	var/list/autogen_clothing_config_skirt
	/// TODO doc
	var/list/species_clothing_color_coords = null

/obj/item/storage/backpack
	species_clothing_color_coords = list(list(BACK_COLORPIXEL_X_1, BACK_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/backpack)

/obj/item/clothing/glasses
	species_clothing_color_coords = list(list(GLASSES_COLORPIXEL_X_1, GLASSES_COLORPIXEL_Y_1), list(GLASSES_COLORPIXEL_X_2, GLASSES_COLORPIXEL_Y_2))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/glasses)

/obj/item/clothing/gloves
	species_clothing_color_coords = list(list(GLOVES_COLORPIXEL_X_1, GLOVES_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/gloves)

/obj/item/clothing/neck
	species_clothing_color_coords = list(list(SCARF_COLORPIXEL_X_1, SCARF_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/scarf)

/obj/item/clothing/neck/cloak
	species_clothing_color_coords = list(list(CLOAK_COLORPIXEL_X_1, CLOAK_COLORPIXEL_Y_1), list(CLOAK_COLORPIXEL_X_2, CLOAK_COLORPIXEL_Y_2))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/cloak)

/obj/item/clothing/neck/mantle
	species_clothing_color_coords = list(list(MANTLE_COLORPIXEL_X_1, MANTLE_COLORPIXEL_Y_1), list(MANTLE_COLORPIXEL_X_2, MANTLE_COLORPIXEL_Y_2))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/mantle)

/obj/item/clothing/neck/tie
	species_clothing_color_coords = list(list(TIE_COLORPIXEL_X_1, TIE_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/tie)

/obj/item/clothing/shoes
	species_clothing_color_coords = list(list(SHOES_COLORPIXEL_X_1, SHOES_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/shoes)

/obj/item/clothing/suit
	species_clothing_color_coords = list(list(COAT_COLORPIXEL_X_1, COAT_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/coat)

/obj/item/clothing/suit/wizrobe
	species_clothing_color_coords = list(list(THICKROBE_COLORPIXEL_X_1, THICKROBE_COLORPIXEL_Y_1), list(THICKROBE_COLORPIXEL_X_2, THICKROBE_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(THICKROBE_COLORPIXEL_X_4, THICKROBE_COLORPIXEL_Y_4), list(THICKROBE_COLORPIXEL_X_5, THICKROBE_COLORPIXEL_Y_5), list(THICKROBE_COLORPIXEL_X_6, THICKROBE_COLORPIXEL_Y_6))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/thickrobe/wiz)

/obj/item/clothing/suit/jacket/trenchcoat
	species_clothing_color_coords = list(list(LONGCOAT_COLORPIXEL_X_1, LONGCOAT_COLORPIXEL_Y_1), list(THICKROBE_COLORPIXEL_X_2, THICKROBE_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(LONGCOAT_COLORPIXEL_X_4, LONGCOAT_COLORPIXEL_Y_4))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/thickrobe/longcoat)

/obj/item/clothing/suit/jacket
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/thickrobe/jacket)

/obj/item/clothing/suit/armor
	species_clothing_color_coords = list(list(ARMOR_COLORPIXEL_X_1, ARMOR_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/armor)

/obj/item/clothing/suit/space
	species_clothing_color_coords = list(list(SPACESUIT_COLORPIXEL_X_1, SPACESUIT_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/spacesuit)

/obj/item/clothing/suit/mod
	species_clothing_color_coords = list(list(MODSUIT_COLORPIXEL_X_1, MODSUIT_COLORPIXEL_Y_1), list(MODSUIT_COLORPIXEL_X_2, MODSUIT_COLORPIXEL_Y_2), list(MODSUIT_COLORPIXEL_X_3, MODSUIT_COLORPIXEL_Y_3))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/hardsuit)

/obj/item/clothing/under
	species_clothing_color_coords = list(list(UNDER_COLORPIXEL_X_1, UNDER_COLORPIXEL_Y_1), list(UNDER_COLORPIXEL_X_2, UNDER_COLORPIXEL_Y_2), list(UNDER_COLORPIXEL_X_3, UNDER_COLORPIXEL_Y_3))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/under)
	autogen_clothing_config_skirt = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/under_skirt)

/obj/item/mod/control
	species_clothing_color_coords = list(list(MODCONTROL_COLORPIXEL_X_1, MODCONTROL_COLORPIXEL_Y_1))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/modcontrol)

///GAGS below here

/obj/item/clothing/under/color
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/jumpsuit/worn/teshari)

/obj/item/clothing/under/color/jumpskirt
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/jumpsuit/worn/teshari)

/obj/item/clothing/shoes/sneakers
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/sneakers/worn/teshari)

/obj/item/clothing/shoes/sneakers/orange
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/sneakers_orange/worn/teshari)

/obj/item/clothing/head/collectable/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/collectable/flatcap
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/frenchberet
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/flatcap
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/caphat/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/beret/badge
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/hats/hos/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/sec
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/science/fancy
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/science/rd
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/durathread
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/centcom_formal
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/militia
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/sec/navywarden
	//autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge_fancy/worn/teshari)
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/medical
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/engi
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/atmos
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/cargo/qm
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/hopcap/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/blueshield
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/flatcap
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/frenchberet
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret/worn/teshari)

/obj/item/clothing/head/beret/sec/navywarden/syndicate
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/nanotrasen_consultant/beret
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/sec/peacekeeper/armadyne
	//autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge_fancy/worn/teshari)
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/head/beret/sec/peacekeeper
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/beret_badge/worn/teshari)

/obj/item/clothing/neck/ranger_poncho
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/ranger_poncho/worn/teshari)

/obj/item/clothing/under/dress/skirt/plaid
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/plaidskirt/worn/teshari)

/obj/item/clothing/under/dress/sundress
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/sundress/worn/teshari)

/obj/item/clothing/neck/scarf
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/scarf/worn/teshari)

/obj/item/clothing/suit/toggle/suspenders
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/suspenders/worn/teshari)

// Unique clothing here

/obj/item/clothing/suit/kimjacket
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/thickrobe/jacket)

/obj/item/clothing/suit/discoblazer
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	autogen_clothing_config = list(SPECIES_TESHARI = /datum/greyscale_config/teshari/thickrobe/jacket)

// Wintercoats and Satchels

/obj/item/storage/backpack/satchel
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/back/backpack.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/back.dmi'
	)

/obj/item/storage/backpack/duffelbag
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/back/backpack.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/back.dmi'
	)

/obj/item/clothing/suit/hooded/wintercoat/equipped(mob/living/user, slot)
	if(isteshari(user))
		var/datum/component/toggle_attached_clothing/component = GetComponent(/datum/component/toggle_attached_clothing)
		component.undeployed_overlay = null
	. = ..()

