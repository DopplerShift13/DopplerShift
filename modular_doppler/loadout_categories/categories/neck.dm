/datum/loadout_category/neck
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/neck/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/neck/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/neck/other_loadout_items = list()
	for(var/datum/loadout_item/neck/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/**
 * CAPES/CLOAKS
 */
/datum/loadout_item/neck/cape
	group = "Capes/Cloaks"
	abstract_type = /datum/loadout_item/neck/cape

/datum/loadout_item/neck/cape/colonial_cloak
	name = "Colonial Cloak"
	item_path = /obj/item/clothing/neck/cloak/colonial

/datum/loadout_item/neck/cape/robe_cape
	name = "Cape (Robe)"
	item_path = /obj/item/clothing/neck/robe_cape

/datum/loadout_item/neck/cape/long_cape
	name = "Cape (Long)"
	item_path = /obj/item/clothing/neck/long_cape

/datum/loadout_item/neck/cape/wide_cape
	name = "Cape (Wide)"
	item_path = /obj/item/clothing/neck/wide_cape

/datum/loadout_item/neck/cape/vulp_cape
	name = "Skirmisher's Cape (Vulpkanin)"
	item_path = /obj/item/clothing/neck/vulp_cape

/datum/loadout_item/neck/cape/vulp_medic_cape
	name = "Medic's Cape (Vulpkanin)"
	item_path = /obj/item/clothing/neck/vulp_cape/med

/datum/loadout_item/neck/cape/capelet
	name = "Capelet"
	item_path = /obj/item/clothing/neck/capelet

/datum/loadout_item/neck/cape/half_cape
	name = "Cape (Half)"
	item_path = /obj/item/clothing/neck/half_cape

/datum/loadout_item/neck/cape/lizard_cape_hand
	name = "Hand's Cape (Tizirian)"
	item_path = /obj/item/clothing/neck/lizard_cape

/datum/loadout_item/neck/cape/lizard_cape_med
	name = "Scaler's Cape (Tizirian)"
	item_path = /obj/item/clothing/neck/lizard_cape/med

/datum/loadout_item/neck/cape/lizard_cape_claw
	name = "Claw's Cape (Tizirian)"
	item_path = /obj/item/clothing/neck/lizard_cape/spec

/datum/loadout_item/neck/cape/taj_cape_holder
	name = "Holder's Cape (Tajaran)"
	item_path = /obj/item/clothing/neck/tajaran_cape

/datum/loadout_item/neck/cape/taj_cape_medic
	name = "Healer's Cape (Tajaran)"
	item_path = /obj/item/clothing/neck/tajaran_cape/med

/datum/loadout_item/neck/cape/vatcloak
	name = "Vatcloak (Vulpkanin)"
	item_path = /obj/item/clothing/neck/vulp_cloak

/datum/loadout_item/neck/cape/hazard_mantle
	name = "Hazard Mantle (Dark)"
	item_path = /obj/item/clothing/neck/doppler_mantle

/datum/loadout_item/neck/cape/hazard_mantle_light
	name = "Hazard Mantle (Light)"
	item_path = /obj/item/clothing/neck/doppler_mantle/light

/datum/loadout_item/neck/cape/mantle
	name = "Mantle (Colorable)"
	item_path = /obj/item/clothing/neck/mantle/recolorable

/**
 * SCARVES
 */
/datum/loadout_item/neck/scarf
	group = "Scarves"
	abstract_type = /datum/loadout_item/neck/scarf

/datum/loadout_item/neck/scarf/ranger_poncho
	name = "Poncho (Ranger)"
	item_path = /obj/item/clothing/neck/ranger_poncho

/datum/loadout_item/neck/scarf/patterned_poncho
	name = "Poncho (Patterned, Colorable)"
	item_path = /obj/item/clothing/neck/patterned_poncho

/datum/loadout_item/neck/scarf/basic_poncho
	name = "Poncho (Basic, Colorable)"
	item_path = /obj/item/clothing/neck/basic_poncho

/datum/loadout_item/neck/scarf/face_scarf
	name = "Face Scarf"
	item_path = /obj/item/clothing/neck/face_scarf

/datum/loadout_item/neck/scarf/scarf_greyscale
	name = "Scarf (Colorable)"
	item_path = /obj/item/clothing/neck/scarf

/datum/loadout_item/neck/scarf/greyscale_large
	name = "Scarf (Large, Colorable)"
	item_path = /obj/item/clothing/neck/large_scarf

/datum/loadout_item/neck/scarf/greyscale_larger
	name = "Scarf (Larger, Colorable)"
	item_path = /obj/item/clothing/neck/infinity_scarf

/**
 * COLLARS
 */
/datum/loadout_item/neck/collar
	group = "Collars"
	abstract_type = /datum/loadout_item/neck/collar

/datum/loadout_item/neck/collar/collar
	name = "Thin Collar"
	item_path = /obj/item/clothing/neck/fashion_collar

/datum/loadout_item/neck/collar/thick_collar
	name = "Thick Collar"
	item_path = /obj/item/clothing/neck/fashion_collar/thick

/datum/loadout_item/neck/collar/spike_collar
	name = "Spiked Collar"
	item_path = /obj/item/clothing/neck/fashion_collar/spike

/datum/loadout_item/neck/collar/bell_collar
	name = "Bell Collar"
	item_path = /obj/item/clothing/neck/fashion_collar/bell

/datum/loadout_item/neck/collar/cow_collar
	name = "Cowbell Collar"
	item_path = /obj/item/clothing/neck/fashion_collar/cow

/datum/loadout_item/neck/collar/cross_collar
	name = "Cross Collar"
	item_path = /obj/item/clothing/neck/fashion_collar/cross

/datum/loadout_item/neck/collar/holocollar
	name = "Holocollar"
	item_path = /obj/item/clothing/neck/fashion_collar/holo

/**
 * TIES
 */
/datum/loadout_item/neck/tie
	group = "Ties"
	abstract_type = /datum/loadout_item/neck/tie

/datum/loadout_item/neck/tie/bowtie
	name = "Bowtie (Colorable)"
	item_path = /obj/item/clothing/neck/bowtie

/datum/loadout_item/neck/tie/necktie
	name = "Necktie (Colorable)"
	item_path = /obj/item/clothing/neck/tie

/datum/loadout_item/neck/tie/necktie_disco
	name = "Necktie (Ugly)"
	item_path = /obj/item/clothing/neck/tie/horrible

/datum/loadout_item/neck/tie/necktie_loose
	name = "Necktie (Loose)"
	item_path = /obj/item/clothing/neck/tie/detective

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/neck/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/neck/misc

/datum/loadout_item/neck/misc/broadcast_camera_arm
	name = "Broadcast Camera Arm"
	item_path = /obj/item/broadcast_camera/mining
