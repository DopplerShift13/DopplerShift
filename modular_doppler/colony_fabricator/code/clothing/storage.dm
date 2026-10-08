// Backpacks

/obj/item/storage/backpack/industrial/frontier_colonist
	name = "\improper CROutfitters trekpack"
	desc = "A locally produced backpack self-described as being fit for all manners of exploration and work."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "backpack"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "backpack"

/obj/item/storage/backpack/satchel/eng/frontier_colonist
	name = "\improper NG-Tek work rated satchel"
	desc = "A ready-for-work satchel made locally in-system for the everyday laborer."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "satchel"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "satchel"

/obj/item/storage/backpack/messenger/eng/frontier_colonist
	name = "\improper NG-Tek messenger bag"
	desc = "A favourite among the brave postal workers of Crusoe's Rest, who use tough bags just like this one to deliver \
		junk mail to your precise location no matter where you live."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "messenger"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "messenger"

/obj/item/storage/backpack/duffelbag/engineering/frontier_colonist
	name = "\improper CROutfitters duffelbag"
	desc = "A large duffelbag for whatever gear couldn't fit in a regular back. Made by locals, for locals, \
		and beloved by any hard-working or adventure type you can find."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "duffel"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "duffel"

// Belts

/obj/item/storage/belt/utility/frontier_colonist
	name = "belt-mounted hip satchet"
	desc = "A hip mounted bag typically found storing tools for quick access in lieu of a bulkier toolbelt or satchel."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "harness"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	supported_bodyshapes = list(BODYSHAPE_HUMANOID)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
	)
	worn_icon_state = "harness"
	inhand_icon_state = null

/obj/item/storage/belt/utility/frontier_colonist/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 6
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	// Can hold whatever a toolbelt can + some mining equipment for convenience
	atom_storage.set_holdable(list(
		/obj/item/airlock_painter,
		/obj/item/analyzer,
		/obj/item/assembly/signaler,
		/obj/item/clothing/gloves,
		/obj/item/construction,
		/obj/item/crowbar,
		/obj/item/extinguisher/mini,
		/obj/item/flashlight,
		/obj/item/forcefield_projector,
		/obj/item/geiger_counter,
		/obj/item/holosign_creator,
		/obj/item/inducer,
		/obj/item/lightreplacer,
		/obj/item/multitool,
		/obj/item/pipe_dispenser,
		/obj/item/pipe_painter,
		/obj/item/plunger,
		/obj/item/radio,
		/obj/item/screwdriver,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/spess_knife,
		/obj/item/gps,
		/obj/item/knife,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/reagent_containers/hypospray,
		/obj/item/shovel,
		/obj/item/survivalcapsule,
		/obj/item/storage/bag/ore,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/wormhole_jaunter,
		/obj/item/resonator,
	))
