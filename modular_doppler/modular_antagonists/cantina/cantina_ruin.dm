
/datum/map_template/ruin/space/doppler/undisclosed_location
	name = "The Undisclosed Location"
	prefix = "_maps/doppler/cantina/"
	id = "cantina"
	description = "A popular bar for seedier types in the local Sector"
	suffix = "badguyzone.dmm"
	cost = 0
	always_place = TRUE

/turf/closed/mineral/strong/red
	name = "Strong Ferrous Rock"
	color = "#D46D59"

/area/ruin/space/has_grav/powered/undisclosed_location
	name = "Undisclosed Location"
	flags_1 = null

/mob/living/basic/stoat/cantina
	name = "Fernet"
	desc = "The Curfew and Sundown's pet stoat, rescued by one of the regulars from a terrible, shocking fate."
	gender = MALE

/obj/structure/fluff/cantinasign
	name = "Curfew & Sundown bar sign"
	desc = "The Curfew and Sundown's iconic holotube signage affixed to an ill-maintained EVA lattice."
	icon = 'modular_doppler/modular_antagonists/cantina/barsign.dmi'
	icon_state = "cantina"
	layer = 5
	pixel_x = -32
	pixel_y = 32

/obj/structure/fluff/cantinasign/damaged
	desc = "The Curfew and Sundown's iconic holotube signage affixed to an ill-maintained EVA lattice. It's visibly taking age, the once well-hidden cables are showing some slack while the holotubes keep flickering."
	icon_state = "cantinadamaged"
