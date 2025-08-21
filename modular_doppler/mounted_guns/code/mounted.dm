/obj/vehicle/ridden/mounted_turret
	name = "mounted gun basetype"
	desc = "If you see this then bad things are happening."
	icon = 'modular_doppler/mounted_guns/icons/drive.dmi'
	icon_state = "turret_oops"
	anchored = TRUE
	canmove = FALSE
	/// The gun stored inside of the turret
	var/obj/item/gun/stored_gun
	/// Does this spawn with a gun, for mapload
	var/obj/item/gun/mapload_gun

/obj/vehicle/ridden/mounted_turret/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/complicated_rotation, ROTATION_IGNORE_ANCHORED, 1 SECONDS, 'sound/items/tools/ratchet.ogg')
	AddElement(/datum/element/ridable_turret, /datum/component/riding/vehicle/mounted_turret)
	if(mapload_gun)
		var/new_gun = new mapload_gun(src)
		register_gun(new_gun)

/obj/vehicle/ridden/mounted_turret/Destroy(force)
	stored_gun.forceMove(drop_location())
	stored_gun = null
	return ..()

/// Registers the gun to turn the turret on firing
/obj/vehicle/ridden/mounted_turret/proc/register_gun(obj/item/gun/new_gun)
	stored_gun = new_gun
	RegisterSignal(stored_gun, COMSIG_GUN_TRY_FIRE, PROC_REF(check_if_in_arc))

/// Checks if the current target is in the firing arc of the turret
/obj/vehicle/ridden/mounted_turret/proc/check_if_in_arc(mob/living/user, obj/item/gun/the_gun_in_question, atom/target, flag, params)
	SIGNAL_HANDLER
	if(dir != (get_dir(src, target)))
		return COMPONENT_CANCEL_GUN_FIRE

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
