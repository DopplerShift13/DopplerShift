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

// Wintercoats and Satchels and stuff

// unfortunately the basetype backpack has a sprite, so...
/obj/item/storage/backpack
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

/obj/item/gravity_harness
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/gravity_harness/icons/gravity_harness_back.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/back.dmi'
	)

/obj/item/tank/jetpack
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/back.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/back.dmi'
	)

// mods
/obj/item/mod/control/pre_equipped/loader
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/modsuit/mod_clothing.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/back.dmi'
	)

// belts

/obj/item/storage/belt/utility
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/storage/belt/medical
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/storage/belt/janitor
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)


/obj/item/storage/belt/military
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)


/obj/item/storage/belt/mining
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)


/obj/item/storage/belt/security/webbing
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)


/obj/item/storage/belt/mining
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/tank/internals/emergency_oxygen
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/back.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/storage/belt/bandolier
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/storage/belt/sheath/sabre
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)

/obj/item/storage/bag/trash
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/belt.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/belt.dmi'
	)
// ears

// the basetype has a sprite; the has_icon will remedy the overlap
/obj/item/radio/headset
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/ears.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/ears.dmi'
	)

// eyes

// yet another basetype w/ a sprite :(
/obj/item/clothing/glasses
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/eyes.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/eyes.dmi'
	)

// shoes

/obj/item/clothing/shoes/wheelys
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/feet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/feet_64.dmi'
	)

// gloves

/obj/item/clothing/gloves/captain
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

/obj/item/clothing/gloves/color/black
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

/obj/item/clothing/gloves/fingerless
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)


/obj/item/clothing/gloves/combat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

/obj/item/clothing/gloves/combat/wizard
	supported_bodyshapes = null
	bodyshape_icon_files = null

/obj/item/clothing/gloves/radio
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

/obj/item/clothing/gloves/chief_engineer
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

/obj/item/clothing/gloves/bracer
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/hands.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/hands.dmi'
	)

// head

/obj/item/clothing/head/utility/welding
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hooded/cloakhood/drake
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/helmet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hooded/explorer
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/soft
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/costume/weddingveil
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/costume.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/reagent_containers/cup/bucket
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/cone
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/helmet/alt
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/helmet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/helmet/swat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/helmet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

// i cant be assed to maintain parity between every single collectible hat so here. basetype.
/obj/item/clothing/head/collectable
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/helmet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/helmet/toggleable/riot
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/helmet.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hooded/winterhood
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/winterhood.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/hos/cap
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/hopcap
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/caphat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/centcom_cap
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/centhat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/hats/warden
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/hats.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/utility/hardhat/cakehat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/costume.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/wizard
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/wizard.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/costume/maid_headband
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/costume.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/utility/radiation
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

/obj/item/clothing/head/armor/captain
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/head/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/head.dmi'
	)

// masks

/obj/item/clothing/mask/gas
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

/obj/item/clothing/mask/joy
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

/obj/item/clothing/mask/breath
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

/obj/item/cigarette
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

/obj/item/clothing/mask/muzzle
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

/obj/item/clothing/mask/balaclava
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/mask.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/mask.dmi'
	)

// uniforms

/obj/item/clothing/under/rank/engineering
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/engineering.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

// disabled; we use custom medical clothing
/*/obj/item/clothing/under/rank/medical
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/medical.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)*/

/obj/item/clothing/under/rank/security
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/security.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/rank/rnd
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/rnd.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/rank/civilian
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/civilian.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/rank/cargo
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/cargo.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/syndicate
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/syndicate.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/costume/kilt
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/costume.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/dress/wedding_dress
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/dress.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

/obj/item/clothing/under/suit
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/under/suits.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

// suits

/obj/item/clothing/suit/hooded/cloak/drake
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/armor.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/hooded/explorer
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/armor
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/armor.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/toggle/labcoat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/labcoat.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/utility/radiation
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/utility.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/hooded/wintercoat
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/wintercoat.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/bio_suit
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/bio.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/wizrobe/tape
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/wizard.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

/obj/item/clothing/suit/costume/poncho
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/suits/costume.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/suit.dmi'
	)

// neck

/obj/item/clothing/neck/cloak
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/neck.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/neck.dmi'
	)

/obj/item/clothing/neck/tie
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/neck.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/neck.dmi'
	)

// misc

/obj/item/storage/medkit/robotic_repair
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

/obj/item/storage/medkit/frontier
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

/obj/item/storage/medkit/combat_surgeon
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

/obj/item/storage/backpack/duffelbag/deforest_medkit
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

/obj/item/storage/backpack/duffelbag/deforest_surgical
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

/obj/item/storage/backpack/duffelbag/deforest_paramedic
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/deforest_medical_items/icons/worn/worn_teshari.dmi'
	)

// accessories

/obj/item/clothing/accessory/maidapron
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/accessories.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/accessories.dmi'
	)

/obj/item/clothing/accessory/maidapron
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/accessories.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/accessories.dmi'
	)

/obj/item/clothing/accessory/talisman
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/accessories.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/accessories.dmi'
	)

/obj/item/clothing/accessory/pocketprotector
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/accessories.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/accessories.dmi'
	)

/obj/item/clothing/accessory/armband
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'icons/mob/clothing/accessories.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/accessories.dmi'
	)
