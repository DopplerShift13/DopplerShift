/datum/loadout_category/glasses
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/glasses/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/glasses/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/datum/loadout_item/glasses/other_loadout_items = list()
	for(var/datum/loadout_item/glasses/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/**
 * PRESCRIPTION GLASSES
 */
/datum/loadout_item/glasses/prescription
	group = "Prescription Glasses"
	abstract_type = /datum/loadout_item/glasses/prescription

/datum/loadout_item/glasses/prescription/regular
	name = "Prescription Glasses"
	item_path = /obj/item/clothing/glasses/regular

/datum/loadout_item/glasses/prescription/circle_glasses
	name = "Prescription Glasses (Circle)"
	item_path = /obj/item/clothing/glasses/regular/circle

/datum/loadout_item/glasses/prescription/hipster_glasses
	name = "Prescription Glasses (Hipster)"
	item_path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_item/glasses/prescription/jamjar
	name = "Prescription Glasses (Jamjar)"
	item_path = /obj/item/clothing/glasses/regular/jamjar

/datum/loadout_item/glasses/prescription/thin
	name = "Prescription Glasses (Thin)"
	item_path = /obj/item/clothing/glasses/regular/thin

/datum/loadout_item/glasses/prescription/kim
	name = "Prescription Glasses (Binoclard)"
	item_path = /obj/item/clothing/glasses/regular/kim

/datum/loadout_item/glasses/prescription/monocle
	name = "Prescription Monocle"
	item_path = /obj/item/clothing/glasses/monocle

/**
 * HUD GLASSES
 */
/datum/loadout_item/glasses/hud
	group = "HUDs"
	abstract_type = /datum/loadout_item/glasses/hud

/datum/loadout_item/glasses/hud/retinal_projector
	name = "Retinal Projector (None)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector

/datum/loadout_item/glasses/hud/retinal_projector_meson
	name = "Retinal Projector (Meson)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/meson

/datum/loadout_item/glasses/hud/retinal_projector_health
	name = "Retinal Projector (Medical)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/health

/datum/loadout_item/glasses/hud/retinal_projector_security
	name = "Retinal Projector (Security)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/security

/datum/loadout_item/glasses/hud/retinal_projector_diagnostic
	name = "Retinal Projector (Diagnostics)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/diagnostic

/datum/loadout_item/glasses/hud/retinal_projector_diagnostic
	name = "Retinal Projector (Science)"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/science

/datum/loadout_item/glasses/hud/aviator
	name = "Aviators (None)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator

/datum/loadout_item/glasses/hud/aviator_meson
	name = "Aviators (Meson)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/meson

/datum/loadout_item/glasses/hud/aviator_health
	name = "Aviators (Medical)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/health

/datum/loadout_item/glasses/hud/aviator_security
	name = "Aviators (Security)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/security

/datum/loadout_item/glasses/hud/aviator_diagnostic
	name = "Aviators (Diagnostics)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/diagnostic

/datum/loadout_item/glasses/hud/aviator_science
	name = "Aviators (Science)"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/science

/datum/loadout_item/glasses/hud/hud_eyepatch_meson
	name = "HUD Eyepatch (Meson)"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/meson

/datum/loadout_item/glasses/hud/hud_eyepatch_med
	name = "HUD Eyepatch (Medical)"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/med

/datum/loadout_item/glasses/hud/hud_eyepatch_sec
	name = "HUD Eyepatch (Security)"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/sec

/datum/loadout_item/glasses/hud/hud_eyepatch_diagnostic
	name = "HUD Eyepatch (Diagnostics)"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/diagnostic

/datum/loadout_item/glasses/hud/hud_eyepatch_sci
	name = "HUD Eyepatch (Science)"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/sci

/datum/loadout_item/glasses/hud/mining_goggles
	name = "Explorer Goggles (Meson)"
	item_path = /obj/item/clothing/glasses/mining_meson

/**
 * HUD GLASSES (Take in other huds)
 */
/datum/loadout_item/glasses/hud/stealing
	abstract_type = /datum/loadout_item/glasses/hud/stealing

/datum/loadout_item/glasses/hud/stealing/get_item_information()
	. = ..()
	.[FA_ICON_LINK] = "Takes in other glasses!"

/datum/loadout_item/glasses/hud/stealing/techno_visor
	name = "Techno-Visor"
	item_path = /obj/item/clothing/glasses/techno_visor

/datum/loadout_item/glasses/hud/stealing/holo_infohud
	name = "Holographic Infohud"
	item_path = /obj/item/clothing/glasses/tajaran_hud

/datum/loadout_item/glasses/hud/stealing/solid_infohud
	name = "Solid Infohud"
	item_path = /obj/item/clothing/glasses/lizard_hud

/**
 * BLINDFOLDS/EYEPATCHES
 */
/datum/loadout_item/glasses/blinding
	group = "Blinding Covers"
	abstract_type = /datum/loadout_item/glasses/blinding

/datum/loadout_item/glasses/blinding/black_blindfold
	name = "Blindfold (Black)"
	item_path = /obj/item/clothing/glasses/blindfold

/datum/loadout_item/glasses/blinding/fake_blindfold
	name = "Blindfold (Black, Fake)"
	item_path = /obj/item/clothing/glasses/trickblindfold

/datum/loadout_item/glasses/blinding/eyepatch
	name = "Eyepatch (Black)"
	item_path = /obj/item/clothing/glasses/eyepatch

/datum/loadout_item/glasses/blinding/white_eyepatch
	name = "Eyepatch (White)"
	item_path = /obj/item/clothing/glasses/eyepatch/white

/datum/loadout_item/glasses/blinding/medical_eyepatch
	name = "Eyepatch (Medical)"
	item_path = /obj/item/clothing/glasses/eyepatch/medical

/datum/loadout_item/glasses/blinding/eyewrap
	name = "Eyepatch (Wrap)"
	item_path = /obj/item/clothing/glasses/eyepatch/wrap

/**
 * OTHER
 */
/datum/loadout_item/glasses/other
	group = "Uncategorized"
	abstract_type = /datum/loadout_item/glasses/other

/datum/loadout_item/glasses/other/cold_glasses
	name = "Cold Glasses"
	item_path = /obj/item/clothing/glasses/cold

/datum/loadout_item/glasses/other/heat_glasses
	name = "Heat Glasses"
	item_path = /obj/item/clothing/glasses/heat

/datum/loadout_item/glasses/other/orange_glasses
	name = "Orange Glasses"
	item_path = /obj/item/clothing/glasses/orange

/datum/loadout_item/glasses/other/red_glasses
	name = "Red Glasses"
	item_path = /obj/item/clothing/glasses/red

/datum/loadout_item/glasses/other/welding
	name = "Welding Goggles"
	item_path = /obj/item/clothing/glasses/welding

/datum/loadout_item/glasses/other/osisunglasses
	name = "O.S.I. Sunglasses"
	item_path = /obj/item/clothing/glasses/osi
