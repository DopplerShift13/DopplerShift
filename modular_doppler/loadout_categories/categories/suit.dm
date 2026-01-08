/datum/loadout_category/suit
	category_name = "Suit"
	category_ui_icon = FA_ICON_VEST
	type_to_generate = /datum/loadout_item/suit
	tab_order = /datum/loadout_category/neck::tab_order + 1
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/suit/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/suit/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/suit/other_loadout_items = list()
	for(var/datum/loadout_item/suit/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/*
*	LOADOUT ITEM DATUMS FOR THE (EXO/OUTER)SUIT SLOT
*/

/datum/loadout_item/suit
	abstract_type = /datum/loadout_item/suit

/datum/loadout_item/suit/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE) // don't bother storing in backpack, can't fit
	if(initial(outfit_important_for_life.suit))
		return TRUE

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.suit)
			LAZYADD(outfit.backpack_contents, outfit.suit)
		outfit.suit = item_path
	else
		outfit.suit = item_path

/**
 * COATS
 */
/datum/loadout_item/suit/coat
	group = "Coats"
	abstract_type = /datum/loadout_item/suit/coat

/datum/loadout_item/suit/coat/warm_coat
	name = "Warm Coat"
	item_path = /obj/item/clothing/suit/warm_coat

/datum/loadout_item/suit/coat/fur_coat
	name = "Rugged Fur Coat"
	item_path = /obj/item/clothing/suit/jacket/doppler/fur_coat

/datum/loadout_item/suit/coat/jacket_fancy
	name = "Fancy Fur Coat (Colorable)"
	item_path = /obj/item/clothing/suit/jacket/fancy

/datum/loadout_item/suit/coat/wrap_coat
	name = "Wrap Coat"
	item_path = /obj/item/clothing/suit/jacket/doppler/wrap_coat

/datum/loadout_item/suit/coat/chokha
	name = "Chokha Coat"
	item_path = /obj/item/clothing/suit/jacket/doppler/chokha

/datum/loadout_item/suit/coat/red_coat
	name = "Trenchcoat (Marsian PLA)"
	item_path = /obj/item/clothing/suit/jacket/doppler/red_trench

/datum/loadout_item/suit/coat/detective_black
	name = "Trenchcoat (Noir)"
	item_path = /obj/item/clothing/suit/toggle/jacket/det_trench/noir

/datum/loadout_item/suit/coat/detective_brown
	name = "Trenchcoat"
	item_path = /obj/item/clothing/suit/toggle/jacket/det_trench

/datum/loadout_item/suit/coat/frontier
	name = "Trenchcoat (Frontier)"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist

/datum/loadout_item/suit/coat/qm_jacket
	name = "Quartermaster's Overcoat"
	item_path = /obj/item/clothing/suit/jacket/quartermaster
	restricted_roles = list(JOB_QUARTERMASTER)

/datum/loadout_item/suit/coat/ethereal_raincoat
	name = "Ethereal Raincoat"
	item_path = /obj/item/clothing/suit/hooded/ethereal_raincoat

/datum/loadout_item/suit/coat/tmc
	name = "TMC Coat"
	item_path = /obj/item/clothing/suit/costume/tmc

/datum/loadout_item/suit/coat/pg
	name = "PG Coat"
	item_path = /obj/item/clothing/suit/costume/pg

/datum/loadout_item/suit/coat/soviet
	name = "Soviet Coat"
	item_path = /obj/item/clothing/suit/costume/soviet

/datum/loadout_item/suit/coat/yuri
	name = "Yuri Coat"
	item_path = /obj/item/clothing/suit/costume/yuri

/datum/loadout_item/suit/coat/coat_med
	name = "Winter Coat (Medical)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical

/datum/loadout_item/suit/coat/coat_paramedic
	name = "Winter Coat (Medical, Paramedic)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical/paramedic

/datum/loadout_item/suit/coat/coat_security
	name = "Winter Coat (Security)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/security

/datum/loadout_item/suit/coat/coat_robotics
	name = "Winter Coat (Science, Robotics)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science/robotics

/datum/loadout_item/suit/coat/coat_sci
	name = "Winter Coat (Science)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science

/datum/loadout_item/suit/coat/coat_eng
	name = "Winter Coat (Engineering)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering

/datum/loadout_item/suit/coat/coat_atmos
	name = "Winter Coat (Engineering, Atmospherics)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos

/datum/loadout_item/suit/coat/coat_hydro
	name = "Winter Coat (Service, Hydroponics)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/hydro

/datum/loadout_item/suit/coat/coat_cargo
	name = "Winter Coat (Cargo)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/cargo

/datum/loadout_item/suit/coat/coat_miner
	name = "Winter Coat (Cargo, Mining)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/miner

/datum/loadout_item/suit/coat/winter_coat
	name = "Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/coat/winter_coat_greyscale
	name = "Winter Coat (Colorable)"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/coat/cargo_coat
	name = "Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat

/datum/loadout_item/suit/coat/cargo_coat_fancy
	name = "Fancy Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat/fancy

/datum/loadout_item/suit/coat/cargo_coat_high_vis
	name = "High-vis Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat/high_vis

/datum/loadout_item/suit/coat/cargo_coat_chore
	name = "Chore Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat/chore

/datum/loadout_item/suit/coat/cargo_coat_shearling
	name = "Shearling Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat/cargo_shearling

/datum/loadout_item/suit/coat/cargo_coat_great
	name = "Great Coat (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/cargo_coat/cargo_greatcoat


/**
 * SUIT JACKETS
 */
/datum/loadout_item/suit/suit_jacket
	group = "Suit Jackets"
	abstract_type = /datum/loadout_item/suit/suit_jacket

/datum/loadout_item/suit/suit_jacket/detective_black_short
	name = "Suit Jacket (Noir)"
	item_path = /obj/item/clothing/suit/jacket/det_suit/noir

/datum/loadout_item/suit/suit_jacket/detective_brown_short
	name = "Suit Jacket (Brown)"
	item_path = /obj/item/clothing/suit/jacket/det_suit

/datum/loadout_item/suit/suit_jacket/recolorable
	name = "Formal Suit Jacket (Colorable)"
	item_path = /obj/item/clothing/suit/toggle/lawyer/greyscale

/datum/loadout_item/suit/suit_jacket/black_suit_jacket
	name = "Formal Suit Jacket (Black)"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/suit_jacket/blue_suit_jacket
	name = "Formal Suit Jacket (Blue)"
	item_path = /obj/item/clothing/suit/toggle/lawyer

/datum/loadout_item/suit/suit_jacket/purple_suit_jacket
	name = "Formal Suit Jacket (Purple)"
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/loadout_item/suit/suit_jacket/long_suit_jacket
	name = "Long Suit Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/long_suit_jacket

/datum/loadout_item/suit/suit_jacket/short_suit_jacket
	name = "Short Suit Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/short_suit_jacket

/datum/loadout_item/suit/suit_jacket/its_pronounced_stow_ic_not_stoike
	name = "Disco Blazer"
	item_path = /obj/item/clothing/suit/jacket/det_suit/disco

/**
 * JACKETS
 */
/datum/loadout_item/suit/jacket
	group = "Jackets"
	abstract_type = /datum/loadout_item/suit/jacket

/datum/loadout_item/suit/jacket/mining_jacket
	name = "Explorer Jacket (Cargo, Mining)"
	item_path = /obj/item/clothing/suit/armor/vest/miningjacket

/datum/loadout_item/suit/jacket/frontier_short
	name = "Frontier Jacket"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist/short

/datum/loadout_item/suit/jacket/frontier_med
	name = "Frontier Jacket (Medical)"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist/medical

/datum/loadout_item/suit/jacket/kim_possible
	name = "Aerostatic Bomber Jacket"
	item_path = /obj/item/clothing/suit/jacket/det_suit/kim

/datum/loadout_item/suit/jacket/bomber_jacket
	name = "Bomber Jacket"
	item_path = /obj/item/clothing/suit/jacket/bomber

/datum/loadout_item/suit/jacket/military_jacket
	name = "Military Jacket"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/jacket/puffer_jacket
	name = "Puffer Jacket"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/jacket/leather_jacket/biker
	name = "Biker Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather/biker

/datum/loadout_item/suit/jacket/big_jacket
	name = "Alpha Atelier Pilot Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/big_jacket

/datum/loadout_item/suit/jacket/field_jacket
	name = "Field Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/field_jacket

/datum/loadout_item/suit/jacket/tan_field_jacket
	name = "Field Jacket (Tan)"
	item_path = /obj/item/clothing/suit/jacket/doppler/field_jacket/tan

/datum/loadout_item/suit/jacket/leather_jacket
	name = "Leather Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/jacket/leather_hoodie
	name = "Leather Jacket with Hoodie"
	item_path = /obj/item/clothing/suit/hooded/doppler/leather_hoodie

/datum/loadout_item/suit/jacket/da_gacket
	name = "Crop-Top Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/gacket

/datum/loadout_item/suit/jacket/jacket_sweater
	name = "Sweater Jacket (Colorable)"
	item_path = /obj/item/clothing/suit/toggle/jacket/sweater

/datum/loadout_item/suit/jacket/jacket_oversized
	name = "Oversized Jacket (Colorable)"
	item_path = /obj/item/clothing/suit/jacket/oversized

/datum/loadout_item/suit/jacket/bad_for_school
	name = "Bad for School Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/bad_for_school

/datum/loadout_item/suit/jacket/departmental_jacket
	name = "Work Jacket"
	item_path = /obj/item/clothing/suit/jacket/doppler/departmental_jacket

/datum/loadout_item/suit/jacket/engi_dep_jacket
	name = "Department Jacket (Engineering)"
	item_path = /obj/item/clothing/suit/jacket/doppler/departmental_jacket/engi

/datum/loadout_item/suit/jacket/med_dep_jacket
	name = "Department Jacket (Medical)"
	item_path = /obj/item/clothing/suit/jacket/doppler/departmental_jacket/med

/datum/loadout_item/suit/jacket/cargo_dep_jacket
	name = "Department Jacket (Cargo)"
	item_path = /obj/item/clothing/suit/jacket/doppler/departmental_jacket/supply

/datum/loadout_item/suit/jacket/sec_dep_jacket_red
	name = "Department Jacket (Security)"
	item_path = /obj/item/clothing/suit/jacket/doppler/departmental_jacket/sec/red

/datum/loadout_item/suit/jacket/peacekeeper_jacket
	name = "Peacekeeper Jacket (Security)"
	item_path = /obj/item/clothing/suit/jacket/doppler/peacekeeper_jacket

/datum/loadout_item/suit/jacket/peacekeeper_jacket_badged
	name = "Peacekeeper Jacket (Security, Badged)"
	item_path = /obj/item/clothing/suit/jacket/doppler/peacekeeper_jacket/badged

/**
 * HOODIES
 */
/datum/loadout_item/suit/hoodies
	group = "Hoodies"
	abstract_type = /datum/loadout_item/suit/hoodies

/datum/loadout_item/suit/hoodies/crop_cold_hoodie
	name = "Cropped Cold Shoulder Hoodie"
	item_path = /obj/item/clothing/suit/hooded/crop_cold_hoodie

/datum/loadout_item/suit/hoodies/big_hoodie
	name = "Big Hoodie"
	item_path = /obj/item/clothing/suit/hooded/big_hoodie

/datum/loadout_item/suit/hoodies/twee_hoodie
	name = "Disconcertingly Twee Hoodie"
	item_path = /obj/item/clothing/suit/hooded/twee_hoodie

/datum/loadout_item/suit/hoodies/deckers
	name = "Deckers Hoodie"
	item_path = /obj/item/clothing/suit/costume/deckers


/**
 * LABCOATS
 */
/datum/loadout_item/suit/lab
	group = "Labcoats"
	abstract_type = /datum/loadout_item/suit/lab

/datum/loadout_item/suit/lab/labcoat
	name = "Labcoat (White)"
	item_path = /obj/item/clothing/suit/toggle/labcoat

/datum/loadout_item/suit/lab/labcoat_green
	name = "Labcoat (Green)"
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad

/datum/loadout_item/suit/lab/lalune_labcoat
	name = "Sleeveless Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/lalunevest

/datum/loadout_item/suit/lab/labocat_medical
	name = "Medical Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/medical

/datum/loadout_item/suit/lab/high_vis_labcoat
	name = "High-Vis Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/high_vis


/**
 * TOPS
 */
/datum/loadout_item/suit/top
	group = "Tops"
	abstract_type = /datum/loadout_item/suit/top

/datum/loadout_item/suit/top/hawaiian_shirt
	name = "Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/costume/hawaiian

/datum/loadout_item/suit/top/lizard_halftop_tan
	name = "Tizirian Halftop (Tan)"
	item_path = /obj/item/clothing/suit/lizard_halftop

/datum/loadout_item/suit/top/lizard_halftop_white
	name = "Tizirian Halftop (White)"
	item_path = /obj/item/clothing/suit/lizard_halftop/white

/datum/loadout_item/suit/top/lizard_halftop_black
	name = "Tizirian Halftop (Black)"
	item_path = /obj/item/clothing/suit/lizard_halftop/black

/datum/loadout_item/suit/top/wellwornshirt
	name = "Well-worn Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt

/datum/loadout_item/suit/top/wellworn_graphicshirt
	name = "Well-worn Graphic Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/graphic

/datum/loadout_item/suit/top/ianshirt
	name = "Well-worn Ian Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/graphic/ian

/datum/loadout_item/suit/top/wornoutshirt
	name = "Worn-out Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout

/datum/loadout_item/suit/top/wornout_graphicshirt
	name = "Worn-out Graphic Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic

/datum/loadout_item/suit/top/wornout_ianshirt
	name = "Worn-out Ian Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic/ian

/datum/loadout_item/suit/top/messyshirt
	name = "Messy Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy

/datum/loadout_item/suit/top/messy_graphicshirt
	name = "Messy Graphic Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic

/datum/loadout_item/suit/top/messy_ianshirt
	name = "Messy Ian Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/ian

/**
 * ARMOR
 */
/datum/loadout_item/suit/armor
	group = "Armor"
	abstract_type = /datum/loadout_item/suit/armor

/datum/loadout_item/suit/armor/tajaran_plate
	name = "Tajaran Plate"
	item_path = /obj/item/clothing/suit/armor/tajaran

/datum/loadout_item/suit/armor/tajaran_high_plate
	name = "Tajaran High Plate"
	item_path = /obj/item/clothing/suit/armor/tajaran/gold

/datum/loadout_item/suit/armor/vulpkanin_skirmisher
	name = "Vulpkanin Skirmisher Armor"
	item_path = /obj/item/clothing/suit/armor/vulp

/datum/loadout_item/suit/armor/tizirian_breast
	name = "Tizirian Breastplate"
	item_path = /obj/item/clothing/suit/armor/lizard

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/suit/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/suit/misc

/datum/loadout_item/suit/misc/recolorable_overalls
	name = "Overalls (Colorable)"
	item_path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/misc/mantella
	name = "Mothic Mantella"
	item_path = /obj/item/clothing/suit/mothcoat/winter

/datum/loadout_item/suit/misc/dressing
	name = "Regal Dressing (Tajaran)"
	item_path = /obj/item/clothing/suit/tajaran_dressing

/datum/loadout_item/suit/misc/suspenders
	name = "Suspenders (Colorable)"
	item_path = /obj/item/clothing/suit/toggle/suspenders

/datum/loadout_item/suit/misc/puffer_vest
	name = "Puffer Vest"
	item_path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/misc/dagger_mantle
	name = "'Dagger' Designer Mantle"
	item_path = /obj/item/clothing/suit/dagger_mantle
