/datum/component/deployable_turret
	/// The time it takes to deploy the object
	var/deploy_time
	/// The object that gets spawned if deployed successfully
	var/obj/thing_to_be_deployed
	/// The sound to make when deployed
	var/deployment_sound
	/// If we are currently tracking someone, they will be here
	var/mob/living/carbon/mouse_tracker
	/// The icon file that the turret should be looking through for sprites
	var/turret_icon

/datum/component/deployable_turret/Initialize(deploy_time = 5 SECONDS, thing_to_be_deployed, deployment_sound, turret_icon = 'modular_doppler/mounted_guns/icons/drive.dmi')
	. = ..()
	if(!isgun(parent))
		return COMPONENT_INCOMPATIBLE

	src.deploy_time = deploy_time
	src.thing_to_be_deployed = thing_to_be_deployed
	src.deployment_sound = deployment_sound
	src.turret_icon = turret_icon

	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/// What extra you see when examining the gun
/datum/component/deployable_turret/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("<b>Ctrl-Click</b> the ground to deploy this into a stationary turret.")

/// Registers the gun to track the holder's clicks when it is picked up
/datum/component/deployable_turret/proc/on_equip(datum/source, mob/living/carbon/equipper, slot)
	SIGNAL_HANDLER
	if(!istype(equipper))
		return
	RegisterSignal(equipper, COMSIG_MOB_CLICKON, PROC_REF(check_deploy))
	mouse_tracker = equipper
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/// Unregisters signals when the gun is dropped
/datum/component/deployable_turret/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	UnregisterSignal(mouse_tracker, COMSIG_MOB_CLICKON)
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)

/// Checks on mouse actions if a turf was control clicked with this gun in hands
/datum/component/deployable_turret/proc/check_deploy(mob/living/carbon/user, atom/clicked_atom, list/modifiers)
	SIGNAL_HANDLER
	if(modifiers[RIGHT_CLICK] || modifiers[ALT_CLICK] || modifiers[SHIFT_CLICK] || !modifiers[CTRL_CLICK] || modifiers[MIDDLE_CLICK])
		return
	if(user.throw_mode || user.get_active_held_item() != parent || user.incapacitated)
		return
	if(!isturf(clicked_atom))
		return
	if(get_dist(user, clicked_atom) > 1)
		return
	INVOKE_ASYNC(src, PROC_REF(deploy), user, clicked_atom)

/// Deploys the turret and sets it up on the deploying turf
/datum/component/deployable_turret/proc/deploy(mob/living/carbon/user, turf/deploying_turf)
	user.face_atom(deploying_turf)
	if((deploying_turf.is_blocked_turf(TRUE)) || (get_turf(user) == deploying_turf))
		deploying_turf.balloon_alert(user, "can't deploy here")
		return
	if(!do_after(user, deploy_time, deploying_turf))
		return
	playsound(deploying_turf, deployment_sound, 50, TRUE)
	var/obj/vehicle/ridden/mounted_turret/deployed_turret = new thing_to_be_deployed(deploying_turf)
	deployed_turret.setDir(get_cardinal_dir(user, deployed_turret))
	deployed_turret.icon = turret_icon
	deployed_turret.update_appearance()
	var/obj/parent_obj = parent
	parent_obj.forceMove(deployed_turret)
	deployed_turret.register_gun(parent_obj)
	deployed_turret.buckle_mob(user) // Tries you make you immediately mount the gun
	return(COMSIG_MOB_CANCEL_CLICKON)
