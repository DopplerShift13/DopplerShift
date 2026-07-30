//	grocery packs intended to simplify procuring marsian groceries and to offer them at a small discount
//	for the purposes of encouraging chefs to do the otherwise somewhat difficult Marsian cuisine

/datum/orderable_item/milk_eggs/marsian_produce
	name = "Marsian Produce Pack"
	purchase_path = /obj/item/storage/box/marsian_produce
	cost_per_order = 80

/datum/orderable_item/milk_eggs/marsian_goods
	name = "Marsian Goods Pack"
	purchase_path = /obj/item/storage/box/marsian_goods
	cost_per_order = 80

/datum/orderable_item/milk_eggs/marsian_meats
	name = "Marsian Meats Pack"
	purchase_path = /obj/item/storage/box/marsian_meats
	cost_per_order = 80

// a cargo pack containing all of the above

/datum/supply_pack/organic/marsian_supply
	name = "Marsian Supply Box"
	desc = "A whole case of groceries popular on the Red Planet. Finally, some real food."
	cost = CARGO_CRATE_VALUE * 1.4
	contains = list(
		/obj/item/storage/box/marsian_produce,
		/obj/item/storage/box/marsian_goods,
		/obj/item/storage/box/marsian_meats,
	)
	crate_name = "\improper Marsian Supply box"
	crate_type = /obj/structure/closet/crate/cardboard/marsian
	test_ignored = TRUE
