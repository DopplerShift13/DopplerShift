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
	return ..()

/obj/vehicle/ridden/mounted_turret/Exited(atom/movable/gone, direction)
	if(gone == stored_gun)
		stored_gun.set_anchored(FALSE)
		unregister_gun()
	return ..()

/// Registers the gun to the turret for various effects
/obj/vehicle/ridden/mounted_turret/proc/register_gun(obj/item/gun/new_gun)
	stored_gun = new_gun
	stored_gun.set_anchored(TRUE)
	modify_max_integrity(stored_gun.max_integrity)
	update_integrity(stored_gun.get_integrity())
	RegisterSignal(stored_gun, COMSIG_GUN_TRY_FIRE, PROC_REF(check_if_in_arc))
	stored_gun.post_mounted_registry(src)

/// Unregisters the gun from the turret for various effects
/obj/vehicle/ridden/mounted_turret/proc/unregister_gun()
	stored_gun.mounted_unregistry()
	stored_gun = null

/// Checks if the current target is in the firing arc of the turret
/obj/vehicle/ridden/mounted_turret/proc/check_if_in_arc(mob/living/user, obj/item/gun/the_gun_in_question, atom/target, flag, params)
	SIGNAL_HANDLER
	if(!acceptable_dir(dir, get_dir(src, target)))
		return COMPONENT_CANCEL_GUN_FIRE

/// Checks if the target is within 180 degrees of your view
/obj/vehicle/ridden/mounted_turret/proc/acceptable_dir(our_dir, target_dir)
	switch(our_dir)
		if(NORTH)
			if(target_dir == NORTHWEST || target_dir == NORTH || target_dir == NORTHEAST)
				return TRUE
			else
				return FALSE
		if(SOUTH)
			if(target_dir == SOUTHWEST || target_dir == SOUTH || target_dir == SOUTHEAST)
				return TRUE
			else
				return FALSE
		if(EAST)
			if(target_dir == NORTHEAST || target_dir == EAST || target_dir == SOUTHEAST)
				return TRUE
			else
				return FALSE
		if(WEST)
			if(target_dir == NORTHWEST || target_dir == WEST || target_dir == SOUTHWEST)
				return TRUE
			else
				return FALSE
	return FALSE // How did we get here ??

/obj/vehicle/ridden/mounted_turret/welder_act(mob/living/user, obj/item/tool)
	..()
	if(user.combat_mode)
		return FALSE
	if(!tool.tool_start_check(user, amount = 1))
		return TRUE
	balloon_alert(user, "repairing...")
	if(tool.use_tool(src, user, 10, volume = 50))
		update_integrity(get_integrity() + (max_integrity / 5)) // 1/5 of integrity per repair
		icon_state = initial(icon_state)
		desc = initial(desc)
	return TRUE

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

/obj/item/gun
	/// If this gun is a part of a mounted turret, refers to that turret
	var/obj/vehicle/ridden/mounted_turret/turret_location

/// If a gun should have special behavior when registered as part of a mounted turret
/obj/item/gun/proc/post_mounted_registry(obj/vehicle/ridden/mounted_turret/turret)
	return

/// If a gun should have special behavior when unregistered as part of a mounted turret
/obj/item/gun/proc/mounted_unregistry()
	return
