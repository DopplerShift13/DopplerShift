
// File for base TG suit item overrides,
// for adding pockets or neckslotability.

// We give all jackets neckslotability and basic pockets, and override individually when we want jumbo pockets or no pockets.

/obj/item/clothing/suit/jacket
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/jacket/bomber
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/curator
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/fancy
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/letterman_syndie
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/miljacket
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/oversized
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/quartermaster
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo


// Apply pockets to toggleable suit jacket too.

/obj/item/clothing/suit/toggle/jacket
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/toggle/jacket/trenchcoat
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/toggle/jacket/det_trench
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo


// suit/toggle objects are basically deprecated but there's a few desirable sprites. we override individually
// because otherwise we would put pockets on suspenders

/obj/item/clothing/suit/toggle/cargo_tech
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/toggle/chef
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/toggle/labcoat
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/toggle/lawyer
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo


// some wintercoats come with pretty significant armor, so we only give them pockets and not neckslots to stave off a meta

/obj/item/clothing/suit/hooded/wintercoat
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo


// most costumes don't have pockets, but neckslotability is probably fine.

/obj/item/clothing/suit/costume
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK


// Misc suit items for which it makes sense to have pockets.

// Overalls should also have pockets.

/obj/item/clothing/suit/atmos_overalls
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/apron/overalls
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

// Coat-likes that should thus also have pockets.

/obj/item/clothing/suit/costume/dracula
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/costume/drfreeze_coat
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/costume/gothcoat
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/costume/pirate
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/costume/soviet
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/costume/yuri
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

// jacket-likes that should thus also have pockets.

/obj/item/clothing/suit/costume/deckers
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/costume/pg
	pocket_storage_type = /datum/storage/pockets/jacket

/obj/item/clothing/suit/costume/tmc
	pocket_storage_type = /datum/storage/pockets/jacket
