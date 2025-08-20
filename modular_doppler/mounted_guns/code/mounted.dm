/obj/vehicle/ridden/mounted_turret
	name = "mounted gun basetype"
	desc = "If you see this then bad things are happening."
	icon = 'modular_doppler/mounted_guns/icons/drive.dmi'
	icon_state = "turret_oops"
	anchored = TRUE
	/// The gun stored inside of the turret
	var/obj/item/gun/stored_gun
	/// Does this spawn with a gun, for mapload
	var/obj/item/gun/mapload_gun

/obj/vehicle/ridden/mounted_turret/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable_turret, /datum/component/riding/vehicle/mounted_turret)
	if(mapload_gun)
		stored_gun = new mapload_gun(src)

/obj/vehicle/ridden/mounted_turret/debug_marcielle
	name = "mounted gun basetype with marcielle"
	mapload_gun = /obj/item/gun/ballistic/automatic/marcielle/sport

/obj/vehicle/ridden/mounted_turret/debug_wt550
	name = "mounted gun basetype with autorifle"
	mapload_gun = /obj/item/gun/ballistic/automatic/wt550

/obj/vehicle/ridden/mounted_turret/debug_shotgun
	name = "mounted gun basetype with shotgun"
	mapload_gun = /obj/item/gun/ballistic/shotgun/riot

/obj/vehicle/ridden/mounted_turret/debug_laser
	name = "mounted gun basetype with laser"
	mapload_gun = /obj/item/gun/energy/laser/captain
