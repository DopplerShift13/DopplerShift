// often clothing is purchased as part of a set, like a suit or costume, so we do this by packaging stuff together in a container like a box or garment bag
// this way we can let people take costumes or complex outfits without messy loadout situations

// phantom costume set

/obj/item/storage/bag/phantom_costume
	name = "\improper Phantom the Weasel costume pack"
	desc = ""
	icon = 'modular_doppler/modular_cosmetics/icons/obj/clothing_packs.dmi'
	icon_state = "phantom_costume"
	storage_type = /datum/storage/bag/garment

/obj/item/storage/bag/phantom_costume/PopulateContents()
	. = ..()
	new /obj/item/clothing/head/phantom_head
	new /obj/item/clothing/under/phantom_costume
	new /obj/item/clothing/gloves/phantom_gloves
	new /obj/item/clothing/shoes/phantom_shoes
