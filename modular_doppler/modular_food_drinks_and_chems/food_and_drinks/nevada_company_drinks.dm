/// the official drink brand of doppler shift now comes in an official, exclusive file!

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea
	name = "\improper Nevada green tea can"
	desc = "A staple item of fuel stations, bodegas, convenience stores, and checkout aisle coolers. Cheaper than water, \
	yet begging the question why."
	icon_state = "nevada_can"
	volume = 55
	list_reagents = list(/datum/reagent/consumable/icetea = 50, /datum/reagent/consumable/honey = 5)
	custom_price = PAYCHECK_LOWER

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/bottle
	name = "\improper Nevada green tea bottle"
	desc = "A resealable version of the venerable Nevada drink can. The convenience doesn't totally cancel out \
	the fact that this one is smaller and costs more."
	icon_state = "nevada_bottle"
	volume = 45
	list_reagents = list(/datum/reagent/consumable/icetea = 40, /datum/reagent/consumable/honey = 5)
	custom_price = PAYCHECK_LOWER * 1.1

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/jug
	name = "\improper Nevada green tea jug"
	desc = "Your favorite Nevada flavor, now with 385 grams of sugar!"
	icon_state = "jug"
	fill_icon = "modular_doppler/modular_food_drinks_and_chems/icons/drinks.dmi"
	volume = 300
	fill_icon_thresholds = list(0, 30, 60, 120, 180, 240, 300)
	possible_transfer_amounts = list(5, 10, 15, 30, 50, 100, 200, 300)
	list_reagents = list(/datum/reagent/consumable/icetea = 250, /datum/reagent/consumable/honey = 50)
	custom_price = PAYCHECK_LOWER * 3.5

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/blueberry
	name = "\improper Nevada Blueberry Blast™"
	desc = "A can featuring a bushel of blueberries front and center. The slogan alliterates impressively, but \
	it makes it difficult to read without cringing."
	icon_state = "nevada_blueberry"
	list_reagents = list(/datum/reagent/consumable/berryjuice/blueberry = 50, /datum/reagent/consumable/honey = 5)

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/raspberry
	name = "\improper Nevada Raspberry Rampage™"
	desc = "Red raspberry emblazoned art promises a rush of red 40 and artificial flavoring."
	icon_state = "nevada_blueberry"
	list_reagents = list(/datum/reagent/consumable/berryjuice = 50, /datum/reagent/consumable/honey = 5)

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/lemonade
	name = "\improper Nevada Lemonade can"
	desc = "Technically this has a celebrity endorsement, but the man on the can is a stranger to anyone born after \
	2375."
	icon_state = "nevada_lemonade"
	list_reagents = list(/datum/reagent/consumable/lemonade = 50, /datum/reagent/consumable/honey = 5)

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/lemonade/bottle //sorry for this path right here
	name = "\improper Nevada Lemonade bottle"
	desc = "A resealable bottle filled with refreshing Nevada lemonade."
	icon_state = "nevada_lemonade_bottle"
	volume = 45
	list_reagents = list(/datum/reagent/consumable/lemonade = 40, /datum/reagent/consumable/honey = 5)
	custom_price = PAYCHECK_LOWER * 1.1

/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/preworkout
	name = "\improper Nevada 'Sweet-Tooth' pre-Workout shake"
	desc = "How something of this viscosity fits through the mouth of a beverage can is the subject of heated debate."
	icon_state = "clown_preworkout"
	list_reagents = list(/datum/reagent/consumable/nutriment/protein = 20, /datum/reagent/consumable/milk = 30, /datum/reagent/consumable/honey = 5)
