//	grocery boxes with Marsian ingredients

/obj/item/storage/box/marsian_produce
	name = "Flavors of Mars Produce Pack"
	desc = "A box of farm-fresh Marsian style produce. Locally grown, which means it didn't come from Mars."
	icon = 'modular_doppler/modular_cargo/icons/boxes.dmi'
	icon_state = "marsian_box"
	illustration = null

/obj/item/storage/box/marsian_produce/PopulateContents()
	for(var/i in 1 to 12)
		var/random_food = pick_weight(list(
			/obj/item/food/kimchi = 3,
			/obj/item/food/grown/pineapple = 3,
			/obj/item/food/grown/onion = 3,
			/obj/item/food/grown/cabbage = 2,
			/obj/item/food/grown/garlic = 2,
			/obj/item/food/grown/chili = 3,
			/obj/item/food/grown/potato = 3,
			/obj/item/food/grown/bell_pepper = 1,
			/obj/item/food/grown/herbs = 1,
			/obj/item/food/grown/olive = 1,
		))
		new random_food(src)

/obj/item/storage/box/marsian_goods
	name = "Flavors of Mars Goods Pack"
	desc = "A shipment of Marsian processed foods and seasonings. A must for any diasporic kitchen."
	icon = 'modular_doppler/modular_cargo/icons/boxes.dmi'
	icon_state = "marsian_box"
	illustration = null

/obj/item/storage/box/marsian_goods/PopulateContents()
	for(var/i in 1 to 12)
		var/random_food = pick_weight(list(
			/obj/item/food/kamaboko = 1,
			/obj/item/food/sambal = 1,
			/obj/item/food/spaghetti/rawnoodles = 3,
			/obj/item/food/bread/reispan = 4,
			/obj/item/food/canned/chap = 5,
			/obj/item/reagent_containers/condiment/rice = 2,
			/obj/item/reagent_containers/condiment/red_bay = 2,
			/obj/item/reagent_containers/condiment/curry_powder = 2,
			/obj/item/reagent_containers/condiment/dashi_concentrate = 2,
			/obj/item/reagent_containers/condiment/soysauce = 2,
		))
		new random_food(src)

/obj/item/storage/box/marsian_meats
	name = "Flavors of Mars Meats Pack"
	desc = "A shipment of Marsian processed foods and seasonings. A must for any diasporic kitchen."
	icon = 'modular_doppler/modular_cargo/icons/boxes.dmi'
	icon_state = "marsian_box"
	illustration = null

/obj/item/storage/box/marsian_meats/PopulateContents()
	for(var/i in 1 to 12)
		var/random_food = pick_weight(list(
			/obj/item/food/meat/slab/chicken = 1,
			/obj/item/food/meat/cutlet = 3,
			/obj/item/food/fishmeat = 1,
			/obj/item/food/fishmeat/octopus = 1,
			/obj/item/food/raw_sausage = 3,
			/obj/item/food/raw_meatball = 1,
			/obj/item/food/tofu = 2,	// :3c
		))
		new random_food(src)

// crate that holds the above for a cargo order

/obj/structure/closet/crate/cardboard/marsian
	name = "\improper Marsian shipment box"
	desc = "Brimming with swag from the red planet."
	icon = 'modular_doppler/modular_cargo/icons/crates.dmi'
	icon_state = "marsian_box"
	base_icon_state = "marsian_box"
	lid_icon = 'modular_doppler/modular_cargo/icons/crates.dmi'
	lid_icon_state = "marsian_box_open"
