/obj/item/storage/box/cloningboards

/obj/item/storage/box/cloningboards/PopulateContents()
	var/static/items_inside = list(
		/obj/item/circuitboard/computer/experimental_cloner = 1,
		/obj/item/circuitboard/machine/experimental_cloner_scanner = 1,
		/obj/item/circuitboard/machine/experimental_cloner = 1,
		/obj/item/paper/fluff/ruins/exp_cloning/manual = 1,
	)
	generate_items_inside(items_inside,src)
