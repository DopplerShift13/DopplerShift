/obj/machinery/vending/imported/nevada_iced_tea
	name = "Nevada Lifetyle Vendor"
	desc = "More than just the cheapest beverage at the konbeni, Nevada Beverage Limited has branched \
	out into a totalizing lifestyle brand. Caps, shirts, pants, shoes, and yes, even beverages can be \
	purchased at this machine."
	icon_state = "nevada_vendor"
	panel_type = "panel_nevada"
	light_mask = "nevada_vendor-light-mask"
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	product_slogans = "I love tall boys!;Naturally refreshing!;Get it by the jug!"
	product_categories = list(
		list(
			"name" = "Beverages",
			"icon" = "champagne-glasses",
			"products" = list(
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea = 10,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/bottle = 5,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/jug = 3,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/blueberry = 8,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/raspberry = 8,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/lemonade = 8,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/lemonade/bottle = 3,
				/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/preworkout = 3,
			),
		),
		list(
			"name" = "Merch",
			"icon" = "shirt",
			"products" = list(
				/obj/item/clothing/under/nevada_uniform = 8,
				/obj/item/clothing/shoes/nevada_kicks = 8,
				/obj/item/clothing/head/nevada_cap = 8,
			),
		),
	)
