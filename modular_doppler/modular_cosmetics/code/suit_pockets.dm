/*(:`--..___...-''``-._             |`. _       this module allows us to to add pockets to garments we make either with an individualized \
  	```--...--.      . `-..__      .`/   _\   / var or by making a child of an item that already has that var attached. it's intended for \
            	`\     '       ```--`.    />    suit slot clothes!
            	: :   :               `:`-'
            	 `.:.  `.._--...___     ``--...__
                	``--..,)       ```----....__,)  this ascii cat was credited to Felix Lee!*/


// The pockets themselves.

/datum/storage/pockets/jacket
	max_slots = 2
	max_total_storage = 5
	click_alt_open = FALSE

/datum/storage/pockets/jacket/jumbo
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 3
	max_total_storage = 6

// Allow us to set a storage type for any suit item.

/obj/item/clothing/suit
	/// What storage type to use for this suit, if any.
	var/pocket_storage_type

/obj/item/clothing/suit/Initialize(mapload)
	. = ..()
	if(pocket_storage_type)
		create_storage(storage_type = pocket_storage_type)
