/obj/item/food/fishmeat/printed
	name = "printed fish fillet"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/printed
	name = "printed meat"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/printed/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/printed, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/steak/plain/printed
	name = "printed steak"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/rawcrab/printed
	name = "imitation crab meat"
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/chicken/printed
	name = "printed chicken meat"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/chicken/printed/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken/printed, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe? (no this is chicken)

/obj/item/food/meat/steak/chicken/printed
	name = "printed chicken steak"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/pig/printed
	name = "printed raw pork"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/meat/slab/pig/printed/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/pig/printed, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/steak/plain/pig/printed
	name = "printed pork chop"
	icon = 'modular_doppler/colony_fabricator/icons/food.dmi'
	starting_reagent_purity = 0.3

/obj/item/food/egg/printed
	name = "synthetic egg"
	starting_reagent_purity = 0.3
