/obj/structure/closet/wardrobe/red/PopulateContents()
	var/static/items_inside = list(
		/obj/item/clothing/suit/hooded/wintercoat/security = 1,
		/obj/item/storage/backpack/security = 1,
		/obj/item/storage/backpack/satchel/sec = 1,
		/obj/item/storage/backpack/duffelbag/sec = 2,
		/obj/item/storage/backpack/messenger/sec = 1,
		/obj/item/clothing/shoes/jackboots/sec = 3,
		/obj/item/clothing/head/hats/sec_beret_doppler = 3,
		/obj/item/clothing/mask/bandana/red = 2)
	generate_items_inside(items_inside,src)
