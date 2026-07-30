/*
* random objects that don't serve any purpose or have any mechanics attached to them, they just decorate maps.
*/

/obj/structure/fluff/manhole
	name = "manhole"
	desc = "A utility access point cut into the road. The metal cover seems stuck."
	icon = 'modular_doppler/clutter_objects/icons/mapping_props.dmi'
	icon_state = "manhole"

/obj/structure/fluff/manhole/open
	name = "open manhole"
	desc = "Uh oh! Thankfully, this one is hard to fall into."
	icon_state = "manhole_open"

/obj/structure/fluff/streetlamp
	name = "streetlamp"
	desc = "An LED continues to burn away high up on its spire."
	icon = 'modular_doppler/clutter_objects/icons/64x_mapping_props.dmi'
	icon_state = "street_on"
	light_power = 1.5
	light_range = 5
	density = TRUE

/obj/structure/fluff/streetlamp/destroyed
	name = "busted streetlamp"
	desc = "A writhing morass of steel and wiring."
	icon_state = "street_dmg"
	light_power = 0.75
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
