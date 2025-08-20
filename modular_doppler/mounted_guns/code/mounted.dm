/obj/vehicle/ridden/mounted_turret
	name = "mounted gun basetype"
	desc = "If you see this then bad things are happening."
	icon = 'modular_doppler/mounted_guns/icons/drive.dmi'
	icon_state = "turret_oops"
	anchored = TRUE

/obj/vehicle/ridden/mounted_turret/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable_turret, /datum/component/riding/vehicle/mounted_turret)
