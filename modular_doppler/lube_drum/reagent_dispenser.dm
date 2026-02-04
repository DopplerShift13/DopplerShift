/obj/structure/reagent_dispensers/lubedrum
	name = "lube drum"
	desc = "You fail to comprehend valid applications for a quantity of lube this large."
	icon = 'modular_doppler/lube_drum/chemical_tanks.dmi'
	icon_state = "lube"
	reagent_id = /datum/reagent/lube
	openable = TRUE

/obj/structure/reagent_dispensers/lubedrum/large
	name = "XXXXL lube drum"
	desc = "God lives in heaven only because he fears what he has created."
	icon_state = "lubelarge"
	tank_volume = 5000

/obj/structure/reagent_dispensers/lubedrum/evil
	name = "warning-labeled lube drum"
	desc = "The writing on the side and numerous red stripes indicate the contents of this drum are extremely dangerous."
	icon = 'modular_doppler/lube_drum/chemical_tanks.dmi'
	icon_state = "lubedanger"
	reagent_id = /datum/reagent/lube/superlube
