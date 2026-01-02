/datum/loadout_category/pocket
	max_allowed = MAX_ALLOWED_MISC_ITEMS

// Because plushes have a second desc var that needs to be updated
/obj/item/toy/plush/on_loadout_custom_described()
	normal_desc = desc

//CATEGORIES
/**
 * EQUIPMENT
 */
/datum/loadout_item/pocket_items/equipment
	group = "Equipment/Tools"
	abstract_type = /datum/loadout_item/pocket_items/equipment/

/datum/loadout_item/pocket_items/equipment/london
	name = "Knife (Hunting)"
	item_path = /obj/item/knife/hunting

/datum/loadout_item/pocket_items/equipment/london_two
	name = "Knife (Survival)"
	item_path = /obj/item/knife/combat/survival

/datum/loadout_item/pocket_items/equipment/swisstool
	name = "Knife (Utility)"
	item_path = /obj/item/spess_knife

/datum/loadout_item/pocket_items/equipment/etool
	name = "Entrenching Tool"
	item_path = /obj/item/trench_tool

/datum/loadout_item/pocket_items/equipment/cheaplighter
	name = "Lighter (Cheap)"
	item_path = /obj/item/lighter/greyscale

/datum/loadout_item/pocket_items/equipment/lighter
	name = "Lighter (Zippo)"
	item_path = /obj/item/lighter

/datum/loadout_item/pocket_items/equipment/mini_extinguisher
	name = "Mini Fire Extinguisher"
	item_path = /obj/item/extinguisher/mini

/datum/loadout_item/pocket_items/equipment/binoculars
	name = "Binoculars"
	item_path = /obj/item/binoculars

/datum/loadout_item/pocket_items/equipment/ahabs_spear
	name = "Ahab's Spear Retool Kit"
	item_path = /obj/item/crusher_trophy/retool_kit/ahab
	restricted_roles = list(JOB_SHAFT_MINER)

/datum/loadout_item/pocket_items/equipment/crusher_retool_kit
	name = "Crusher Retool Kit"
	item_path = /obj/item/crusher_trophy/retool_kit
	restricted_roles = list(JOB_SHAFT_MINER)

/datum/loadout_item/pocket_items/equipment/generic_suit_strap
	name = "Equipment Strap (Generic)"
	item_path = /obj/item/job_equipment_strap

/datum/loadout_item/pocket_items/equipment/service_suit_strap
	name = "Equipment Strap (Service)"
	item_path = /obj/item/job_equipment_strap/service

/datum/loadout_item/pocket_items/equipment/medical_suit_strap
	name = "Equipment Strap (Medical)"
	item_path = /obj/item/job_equipment_strap/medical

/datum/loadout_item/pocket_items/equipment/engineering_suit_strap
	name = "Equipment Strap (Engineering)"
	item_path = /obj/item/job_equipment_strap/engineering

/datum/loadout_item/pocket_items/equipment/science_suit_strap
	name = "Equipment Strap (Science)"
	item_path = /obj/item/job_equipment_strap/science

/datum/loadout_item/pocket_items/equipment/supply_suit_strap
	name = "Equipment Strap (Supply)"
	item_path = /obj/item/job_equipment_strap/supply

/datum/loadout_item/pocket_items/equipment/security_suit_strap
	name = "Equipment Strap (Security)"
	item_path = /obj/item/job_equipment_strap/security

/**
 * STORAGE
 */
/datum/loadout_item/pocket_items/storage
	group = "Storage"
	abstract_type = /datum/loadout_item/pocket_items/storage

/datum/loadout_item/pocket_items/storage/injector_case
	name = "Autoinjector Case"
	item_path = /obj/item/storage/epic_loot_medpen_case

/datum/loadout_item/pocket_items/storage/docs_case
	name = "Documents Case"
	item_path = /obj/item/storage/epic_loot_docs_case

/datum/loadout_item/pocket_items/storage/org_case
	name = "Organizational Pouch"
	item_path = /obj/item/storage/epic_loot_org_pouch

/datum/loadout_item/pocket_items/storage/pocket_medpens_evil
	name = "Colonial Medipen Pouch"
	item_path = /obj/item/storage/pouch/cin_medipens

/datum/loadout_item/pocket_items/storage/wallet
	name = "Wallet"
	item_path = /obj/item/storage/wallet

// We add our wallet manually, later, so no need to put it in any outfits.
/datum/loadout_item/pocket_items/storage/wallet/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only)
	return FALSE

// We didn't spawn any item yet, so nothing to call here.
/datum/loadout_item/pocket_items/storage/wallet/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	return FALSE

// We add our wallet at the very end of character initialization (after quirks, etc) to ensure the backpack / their ID is all set by now.
/datum/loadout_item/pocket_items/storage/wallet/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	var/obj/item/card/id/advanced/id_card = equipper.get_item_by_slot(ITEM_SLOT_ID)
	if(istype(id_card, /obj/item/storage/wallet))
		return

	var/obj/item/storage/wallet/wallet = new(equipper)
	if(istype(id_card))
		equipper.temporarilyRemoveItemFromInventory(id_card, force = TRUE)
		equipper.equip_to_slot_if_possible(wallet, ITEM_SLOT_ID, initial = TRUE)
		id_card.forceMove(wallet)

		if(equipper.back)
			var/list/backpack_stuff = equipper.back.atom_storage?.return_inv(FALSE)
			for(var/obj/item/thing in backpack_stuff)
				if(wallet.contents.len >= 3)
					break
				if(thing.w_class <= WEIGHT_CLASS_SMALL)
					wallet.atom_storage.attempt_insert(src, thing, equipper, TRUE, FALSE)
	else
		if(!equipper.equip_to_storage(wallet, ITEM_SLOT_BACK, indirect_action = TRUE))
			wallet.forceMove(equipper.drop_location())


/**
 * TECH
 */
/datum/loadout_item/pocket_items/tech
	group = "Tech"
	abstract_type = /datum/loadout_item/pocket_items/tech/

/datum/loadout_item/pocket_items/tech/mod_painter
	name = "MOD Paint Kit"
	item_path = /obj/item/mod/paint

/datum/loadout_item/pocket_items/tech/super_disk
	name = "Bootleg Computer Programs Disk"
	item_path = /obj/item/computer_disk/all_of_them

/datum/loadout_item/pocket_items/tech/holodisk
	name = "Holodisk"
	item_path = /obj/item/disk/holodisk

/datum/loadout_item/pocket_items/tech/paicard
	name = "Personal AI Device"
	item_path = /obj/item/pai_card

/datum/loadout_item/pocket_items/tech/tapeplayer
	name = "Universal Recorder"
	item_path = /obj/item/taperecorder

/datum/loadout_item/pocket_items/tech/tape
	name = "Spare Cassette Tape"
	item_path = /obj/item/tape/random

/datum/loadout_item/pocket_items/tech/pacification_chip
	name = "Meditative Assistance pacification skillchip"
	item_path = /obj/item/skillchip/pacification

/datum/loadout_item/pocket_items/tech/shock_collar
	name = "Shock collar"
	item_path = /obj/item/electropack/shockcollar

/datum/loadout_item/pocket_items/tech/borg_me_dogtag
	name = "Pre-Approved Cyborg Candidate Dogtag"
	item_path = /obj/item/clothing/accessory/dogtag/borg_ready

//Dogtag Code
/datum/loadout_item/pocket_items/tech/borg_me_dogtag/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	// We're hooking this datum to add an extra bit of flavor to the dogtag - a pregenerated medical record
	if(!visuals_only && !isdummy(equipper))
		RegisterSignal(equipper, COMSIG_HUMAN_CHARACTER_SETUP_FINISHED, PROC_REF(apply_after_setup), override = TRUE)
	return NONE

/datum/loadout_item/pocket_items/tech/borg_me_dogtag/proc/apply_after_setup(mob/living/carbon/human/source, ...)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_HUMAN_CHARACTER_SETUP_FINISHED)
	var/datum/record/crew/record = find_record(source.real_name)
	record?.medical_notes += new /datum/medical_note("Central Command", "Patient is a registered brain donor for Robotics research.", null)

/datum/loadout_item/pocket_items/tech/power_cell
	name = "Standard Power Cell"
	item_path = /obj/item/stock_parts/power_store/cell/crap

/datum/loadout_item/pocket_items/tech/pda_neko
	name = "PDA (Neko)"
	item_path = /obj/item/modular_computer/pda/cat

/datum/loadout_item/pocket_items/tech/pda_g3
	name = "PDA (G3)"
	item_path = /obj/item/modular_computer/pda/g3

/datum/loadout_item/pocket_items/tech/pda_rugged
	name = "PDA (Rugged)"
	item_path = /obj/item/modular_computer/pda/rugged

/datum/loadout_item/pocket_items/tech/pda_slimline
	name = "PDA (Slimline)"
	item_path = /obj/item/modular_computer/pda/slimline

/datum/loadout_item/pocket_items/tech/pda_ultraslim
	name = "PDA (Ultraslim)"
	item_path = /obj/item/modular_computer/pda/ultraslim

/**
 * HEALTH
 */
/datum/loadout_item/pocket_items/health
	group = "Health"
	abstract_type = /datum/loadout_item/pocket_items/health

/datum/loadout_item/pocket_items/health/gum_pack_moth
	name = "Pack of Activin 12 Hour Medicated Gum"
	item_path = /obj/item/storage/box/gum/wake_up

/datum/loadout_item/pocket_items/health/painkillers
	name = "Amollin Pill Bottle"
	item_path = /obj/item/storage/pill_bottle/painkiller

/datum/loadout_item/pocket_items/health/drugs_happy
	name = "Prescription Stimulant Bottle"
	item_path = /obj/item/storage/pill_bottle/prescription_stimulant

/datum/loadout_item/pocket_items/health/civil_defense
	name = "Civil Defense Med-kit"
	item_path = /obj/item/storage/medkit/civil_defense/stocked

/datum/loadout_item/pocket_items/health/medkit
	name = "First-Aid Kit"
	item_path = /obj/item/storage/medkit/regular

/datum/loadout_item/pocket_items/health/pocket_medkit
	name = "Colonial First Aid Kit"
	item_path = /obj/item/storage/pouch/cin_medkit

/**
 * RECREATIONAL
 */
/datum/loadout_item/pocket_items/recreational
	group = "Recreational"
	abstract_type = /datum/loadout_item/pocket_items/recreational

/datum/loadout_item/pocket_items/recreational/multipen
	name = "Pen (Multicolored)"
	item_path = /obj/item/pen/fourcolor

/datum/loadout_item/pocket_items/recreational/fountainpen
	name = "Pen (Fancy)"
	item_path = /obj/item/pen/fountain

/datum/loadout_item/pocket_items/recreational/newspaper
	name = "Newspaper"
	item_path = /obj/item/newspaper

/datum/loadout_item/pocket_items/recreational/clipboard
	name = "Clipboard"
	item_path = /obj/item/clipboard

/datum/loadout_item/pocket_items/recreational/folder
	name = "Folder"
	item_path = /obj/item/folder

/datum/loadout_item/pocket_items/recreational/card_binder
	name = "Card Binder"
	item_path = /obj/item/storage/card_binder

/datum/loadout_item/pocket_items/recreational/card_deck
	name = "Card Deck (Playing)"
	item_path = /obj/item/toy/cards/deck

/datum/loadout_item/pocket_items/recreational/kotahi_deck
	name = "Card Deck (Kotahi)"
	item_path = /obj/item/toy/cards/deck/kotahi

/datum/loadout_item/pocket_items/recreational/wizoff_deck
	name = "Card Deck (Wizoff)"
	item_path = /obj/item/toy/cards/deck/wizoff

/datum/loadout_item/pocket_items/recreational/dice_bag
	name = "Dice Bag"
	item_path = /obj/item/storage/dice

/datum/loadout_item/pocket_items/recreational/d1
	name = "D1"
	item_path = /obj/item/dice/d1

/datum/loadout_item/pocket_items/recreational/d2
	name = "D2"
	item_path = /obj/item/dice/d2

/datum/loadout_item/pocket_items/recreational/d4
	name = "D4"
	item_path = /obj/item/dice/d4

/datum/loadout_item/pocket_items/recreational/d6
	name = "D6"
	item_path = /obj/item/dice/d6

/datum/loadout_item/pocket_items/recreational/d6_ebony
	name = "D6 (Ebony)"
	item_path = /obj/item/dice/d6/ebony

/datum/loadout_item/pocket_items/recreational/d6_space
	name = "D6 (Space)"
	item_path = /obj/item/dice/d6/space

/datum/loadout_item/pocket_items/recreational/d8
	name = "D8"
	item_path = /obj/item/dice/d8

/datum/loadout_item/pocket_items/recreational/d10
	name = "D10"
	item_path = /obj/item/dice/d10

/datum/loadout_item/pocket_items/recreational/d12
	name = "D12"
	item_path = /obj/item/dice/d12

/datum/loadout_item/pocket_items/recreational/d20
	name = "D20"
	item_path = /obj/item/dice/d20

/datum/loadout_item/pocket_items/recreational/d100
	name = "D100"
	item_path = /obj/item/dice/d100

/datum/loadout_item/pocket_items/recreational/d00
	name = "D00"
	item_path = /obj/item/dice/d00

/**
 * COSMETICS
 */
/datum/loadout_item/pocket_items/cosmetics
	group = "Cosmetics"
	abstract_type = /datum/loadout_item/pocket_items/cosmetics

/datum/loadout_item/pocket_items/cosmetics/lipstick_green
	name = "Lipstick (Green)"
	item_path = /obj/item/lipstick/green

/datum/loadout_item/pocket_items/cosmetics/lipstick_white
	name = "Lipstick (White)"
	item_path = /obj/item/lipstick/white

/datum/loadout_item/pocket_items/cosmetics/lipstick_blue
	name = "Lipstick (Blue)"
	item_path = /obj/item/lipstick/blue

/datum/loadout_item/pocket_items/cosmetics/lipstick_black
	name = "Lipstick (Black)"
	item_path = /obj/item/lipstick/black

/datum/loadout_item/pocket_items/cosmetics/lipstick_jade
	name = "Lipstick (Jade)"
	item_path = /obj/item/lipstick/jade

/datum/loadout_item/pocket_items/cosmetics/lipstick_purple
	name = "Lipstick (Purple)"
	item_path = /obj/item/lipstick/purple

/datum/loadout_item/pocket_items/cosmetics/dye
	name = "Hair Dye"
	item_path = /obj/item/dyespray

/datum/loadout_item/pocket_items/cosmetics/lipstick
	name = "Lipstick (Colorable)"
	item_path = /obj/item/lipstick

//Lipstick Code
/datum/loadout_item/pocket_items/cosmetics/lipstick/get_item_information()
	. = ..()
	.[FA_ICON_PALETTE] = "Recolorable"

/datum/loadout_item/pocket_items/cosmetics/lipstick/on_equip_item(
	obj/item/lipstick/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only,
)
	. = ..()
	var/picked_style = style_to_style(preference_list[item_path]?[INFO_LAYER])
	var/picked_color = preference_list[item_path]?[INFO_GREYSCALE] || /obj/item/lipstick::lipstick_color
	if(istype(equipped_item)) // can be null for visuals_only
		equipped_item.style = picked_style
		equipped_item.lipstick_color = picked_color
	equipper.update_lips(picked_style, picked_color)

/// Converts style (readable) to style (internal)
/datum/loadout_item/pocket_items/cosmetics/lipstick/proc/style_to_style(style)
	switch(style)
		if(UPPER_LIP)
			return "lipstick_upper"
		if(LOWER_LIP)
			return "lipstick_lower"
	return "lipstick"

/datum/loadout_item/pocket_items/cosmetics/lipstick/get_ui_buttons()
	. = ..()
	UNTYPED_LIST_ADD(., list(
		"label" = "Style",
		"act_key" = "select_lipstick_style",
		"button_icon" = FA_ICON_ARROWS_ROTATE,
		"active_key" = INFO_LAYER,
	))
	UNTYPED_LIST_ADD(., list(
		"label" = "Color",
		"act_key" = "select_lipstick_color",
		"button_icon" = FA_ICON_PALETTE,
		"active_key" = INFO_GREYSCALE,
	))

	return .

/datum/loadout_item/pocket_items/cosmetics/lipstick/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action, params)
	switch(action)
		if("select_lipstick_style")
			var/list/their_loadout = manager.preferences.read_preference(/datum/preference/loadout)
			var/old_style = their_loadout?[item_path]?[INFO_LAYER] || MIDDLE_LIP
			var/chosen = tgui_input_list(user, "Pick a lipstick style. (This determines where it sits on your sprite.)", "Pick a style", list(UPPER_LIP, MIDDLE_LIP, LOWER_LIP), old_style)
			their_loadout = manager.preferences.read_preference(/datum/preference/loadout) // after sleep: sanity check
			if(their_loadout?[item_path]) // Validate they still have it equipped
				their_loadout[item_path][INFO_LAYER] = chosen
				manager.preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], their_loadout)
			return TRUE // Update UI

		if("select_lipstick_color")
			var/list/their_loadout = manager.preferences.read_preference(/datum/preference/loadout)
			var/old_color = their_loadout?[item_path]?[INFO_GREYSCALE] || /obj/item/lipstick::lipstick_color
			var/chosen = input(user, "Pick a lipstick color.", "Pick a color", old_color) as color|null
			their_loadout = manager.preferences.read_preference(/datum/preference/loadout) // after sleep: sanity check
			if(their_loadout?[item_path]) // Validate they still have it equipped
				their_loadout[item_path][INFO_GREYSCALE] = chosen
				manager.preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], their_loadout)
			return TRUE // Update UI

	return ..()

/**
 * DRINKS/FOOD
 */
/datum/loadout_item/pocket_items/drinks_food
	group = "Drinks/Food"
	abstract_type = /datum/loadout_item/pocket_items/drinks_food

/datum/loadout_item/pocket_items/drinks_food/gum_pack
	name = "Pack of Gum"
	item_path = /obj/item/storage/box/gum

/datum/loadout_item/pocket_items/drinks_food/flask
	name = "Flask"
	item_path = /obj/item/reagent_containers/cup/glass/flask

/datum/loadout_item/pocket_items/drinks_food/gromitmug
	name = "Mug (Gromit)"
	item_path = /obj/item/reagent_containers/cup/glass/mug/gromitmug

/datum/loadout_item/pocket_items/drinks_food/mug_nt
	name = "Mug (Nanotrasen)"
	item_path = /obj/item/reagent_containers/cup/glass/mug/nanotrasen

/datum/loadout_item/pocket_items/drinks_food/britcup
	name = "Mug (British Flag)"
	item_path = /obj/item/reagent_containers/cup/glass/mug/britcup

/datum/loadout_item/pocket_items/drinks_food/moth_mre
	name = "Mothic Rations Pack"
	item_path = /obj/item/storage/box/mothic_rations

/datum/loadout_item/pocket_items/drinks_food/six_beer
	name = "Six-Pack (Beer)"
	item_path = /obj/item/storage/cans/sixbeer

/datum/loadout_item/pocket_items/drinks_food/six_soda
	name = "Six-Pack (Soda)"
	item_path = /obj/item/storage/cans/sixsoda

/datum/loadout_item/pocket_items/drinks_food/lollipop
	name = "Lollipop"
	item_path = /obj/item/food/lollipop


/**
 * DRUGS
 */
/datum/loadout_item/pocket_items/drugs
	group = "Drugs"
	abstract_type = /datum/loadout_item/pocket_items/drugs

/datum/loadout_item/pocket_items/drugs/gum_pack_nicotine
	name = "Pack of Nicotine Gum"
	item_path = /obj/item/storage/box/gum/nicotine

/datum/loadout_item/pocket_items/drugs/gum_pack_hp
	name = "Pack of HP+ Gum"
	item_path = /obj/item/storage/box/gum/happiness

/datum/loadout_item/pocket_items/drugs/cigarettes
	name = "Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes

/datum/loadout_item/pocket_items/drugs/cigar //smoking is bad mkay
	name = "Cigar"
	item_path = /obj/item/cigarette/cigar

/datum/loadout_item/pocket_items/drugs/drugs_blastoff
	name = "bLaSToFF Ampoule"
	item_path = /obj/item/reagent_containers/cup/blastoff_ampoule

/datum/loadout_item/pocket_items/drugs/drugs_sandy
	name = "T-WITCH Vial"
	item_path = /obj/item/reagent_containers/hypospray/medipen/deforest/twitch

/datum/loadout_item/pocket_items/drugs/drugs_kronkus
	name = "Kronkus Vine Seeds"
	item_path = /obj/item/seeds/kronkus

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/pocket_items/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/pocket_items/misc

/datum/loadout_item/pocket_items/misc/rag
	name = "Rag"
	item_path = /obj/item/rag

/datum/loadout_item/pocket_items/misc/whistle
	name = "Whistle"
	item_path = /obj/item/clothing/mask/whistle

/datum/loadout_item/pocket_items/misc/soap
	name = "Bar of Soap"
	item_path = /obj/item/soap/deluxe

/datum/loadout_item/pocket_items/misc/poster
	name = "Poster (Contraband)"
	item_path = /obj/item/poster/random_contraband

/datum/loadout_item/pocket_items/misc/poster_pinup
	name = "Poster (Pinup)"
	item_path = /obj/item/poster/random_contraband/pinup
