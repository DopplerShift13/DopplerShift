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
	/// How long does this gun take to disassemble
	var/disassembly_time = 5 SECONDS
	/// What sound does this thing make when taken apart?
	var/disassembly_sound = 'sound/items/tools/change_jaws.ogg'
	/// Can this be disassembled easily?
	var/can_be_removed = TRUE

/obj/vehicle/ridden/mounted_turret/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/complicated_rotation, ROTATION_IGNORE_ANCHORED, 1 SECONDS, 'sound/items/tools/ratchet.ogg')
	AddElement(/datum/element/ridable_turret, /datum/component/riding/vehicle/mounted_turret)
	if(mapload_gun)
		new mapload_gun(src)

/obj/vehicle/ridden/mounted_turret/examine(mob/user)
	. = ..()
	if(stored_gun)
		. += span_notice("It has a [REF(stored_gun)] mounted.")

/obj/vehicle/ridden/mounted_turret/Destroy(force)
	stored_gun?.forceMove(drop_location())
	return ..()

/obj/vehicle/ridden/mounted_turret/Exited(atom/movable/gone, direction)
	if(gone == stored_gun)
		stored_gun.set_anchored(FALSE)
		unregister_gun()
		if(!QDESTROYING(src)) // If the gun left us and we're not already being destroyed, destroy the turret
			Destroy()
	return ..()

/// Takes the turret apart and drops the stored gun on the floor
/obj/vehicle/ridden/mounted_turret/proc/take_her_down(mob/user)
	if(!do_after(user, disassembly_time, src))
		return FALSE
	playsound(src, disassembly_sound, 50, TRUE)
	Destroy()
	return TRUE

/// Registers the gun to the turret for various effects
/obj/vehicle/ridden/mounted_turret/proc/register_gun(obj/item/gun/new_gun)
	stored_gun = new_gun
	stored_gun.set_anchored(TRUE)
	modify_max_integrity(stored_gun.max_integrity)
	update_integrity(stored_gun.get_integrity())
	RegisterSignal(stored_gun, COMSIG_GUN_TRY_FIRE, PROC_REF(check_if_in_arc))
	RegisterSignal(stored_gun, COMSIG_ATOM_UPDATE_ICON, PROC_REF(update_turret_look))
	name = stored_gun.name
	update_turret_look()
	update_appearance()

/// Unregisters the gun from the turret for various effects
/obj/vehicle/ridden/mounted_turret/proc/unregister_gun()
	UnregisterSignal(stored_gun, COMSIG_GUN_TRY_FIRE)
	UnregisterSignal(stored_gun, COMSIG_ATOM_UPDATE_ICON)
	stored_gun = null

/// Updates the look of the turret based on stats from the gun
/obj/vehicle/ridden/mounted_turret/proc/update_turret_look(obj/item/gun/source)
	if(!stored_gun)
		return
	icon_state = stored_gun.icon_state
	update_appearance()

/obj/vehicle/ridden/mounted_turret/update_overlays()
	. = ..()
	if(!stored_gun)
		return
	var/gun_state = stored_gun.icon_state
	if(!istype(stored_gun, /obj/item/gun/ballistic))
		return
	var/obj/item/gun/ballistic/ballistic = stored_gun
	if(!ballistic.show_bolt_icon)
		return
	if(ballistic.bolt_type == BOLT_TYPE_LOCKING)
		. += "[gun_state]_bolt[ballistic.bolt_locked ? "_locked" : ""]"
	if(ballistic.bolt_type == BOLT_TYPE_OPEN && ballistic.bolt_locked)
		. += "[gun_state]_bolt"
	if(ballistic.suppressed && ballistic.can_unsuppress)
		. += "[gun_state]_suppressor"
	if(!ballistic.chambered && ballistic.empty_indicator)
		. += "[gun_state]_empty"
	if(ballistic.gun_flags & TOY_FIREARM_OVERLAY)
		. += "[gun_state]_toy"
	if(!ballistic.magazine || ballistic.internal_magazine || !ballistic.mag_display)
		return
	. += "[gun_state]_mag"

/// Checks if the current target is in the firing arc of the turret
/obj/vehicle/ridden/mounted_turret/proc/check_if_in_arc(mob/living/user, obj/item/gun/the_gun_in_question, atom/target, flag, params)
	SIGNAL_HANDLER
	if(!acceptable_dir(dir, get_dir(src, target)))
		return COMPONENT_CANCEL_GUN_FIRE

/// Checks if the target is within 180 degrees of your view
/obj/vehicle/ridden/mounted_turret/proc/acceptable_dir(our_dir, target_dir)
	return (target_dir & our_dir)

/obj/vehicle/ridden/mounted_turret/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE
	if(!tool.tool_start_check(user, amount = 1))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, "repairing...")
	if(!tool.use_tool(src, user, 10, volume = 50))
		return ITEM_INTERACT_BLOCKING
	update_integrity(get_integrity() + (max_integrity / 5)) // 1/5 of integrity per repair
	balloon_alert(user, "repaired")
	return ITEM_INTERACT_SUCCESS

/obj/vehicle/ridden/mounted_turret/click_ctrl(mob/user)
	if(!can_be_removed)
		return NONE
	return take_her_down(user) ? CLICK_ACTION_SUCCESS : CLICK_ACTION_BLOCKING

/obj/vehicle/ridden/mounted_turret/attack_hand(mob/user, list/modifiers)
	stored_gun.attack_hand(user, modifiers)

/obj/vehicle/ridden/mounted_turret/attack_hand_secondary(mob/user, list/modifiers)
	stored_gun.attack_hand_secondary(user, modifiers)

/obj/vehicle/ridden/mounted_turret/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	stored_gun.item_interaction(user, tool, modifiers)

/obj/vehicle/ridden/mounted_turret/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	stored_gun.item_interaction_secondary(user, tool, modifiers)

/obj/vehicle/ridden/mounted_turret/buckle_feedback(mob/living/being_buckled, mob/buckler)
	buckler.visible_message(
		span_notice("[buckler] sits behind [src], grabbing the controls."),
		span_notice("You sit behind [src], grabbing the controls."),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		vision_distance = COMBAT_MESSAGE_RANGE,
	)

/obj/vehicle/ridden/mounted_turret/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler] lets go of [src]."),
			span_notice("You let go of [src]."),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
	else
		being_unbuckled.visible_message(
			span_warning("[unbuckler] pushes [being_unbuckled] off of[src]!"),
			span_warning("[unbuckler] pushes you off of [src]!"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
