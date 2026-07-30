/*
* non-drivable (for now?) car statics for maps
* originally from tgmc via cm, used with permission
*/

/obj/structure/prop_vehicle
	name = "smashed hatchback"
	desc = "A smart, practical sedan once. It's just a smouldering husk of twisted plasteel and gnarled fibreglass now."
	icon = 'modular_doppler/clutter_objects/icons/clutter_cars.dmi'
	icon_state = "busted_hatchback"
	bound_height = 32
	bound_width = 64
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 400

/obj/structure/prop_vehicle/red
	name = "obliterated hatchback"
	icon_state = "busted_hatchback_red"

/obj/structure/prop_vehicle/cop
	name = "pulverized police car"
	desc = "The wrecked remnants of a wasted stack of taxpayer bills."
	icon_state = "busted_cop_car"

/obj/structure/prop_vehicle/taxi
	name = "annihilated taxi"
	desc = "The twisted remains of a once stalwart service vehicle."
	icon_state = "busted_taxi"

/obj/structure/prop_vehicle/pizza_van
	name = "\improper Pizza Galaxy delivery van"
	desc = "Actually, this isn't the original Pizza Galaxy. See, the original Pizza Galaxy was opened on Mars in 2356, and was featured in \
	the classic of Marsian cinema, which was titled 'A Game of Death' on release but also got bootleg drops as 'Final Fight! Enter The Dragon's Lair!' \
	especially in the Plutonian market. It's where the characters order from when they're plotting the final battle, been a legend ever since. Anyway, this \
	spot was just named in homage to it. Pizza's still pretty good."
	icon_state = "box_van_pizza"
