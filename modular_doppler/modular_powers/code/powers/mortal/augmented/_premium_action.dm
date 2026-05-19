// Custom actions for premium augments, meant to show the progress bar with quality wear.
/datum/action/item_action/organ_action/premium
	name = "Premium Augment"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_mod_border"

	/// The border overlay. This is declared seperately so active_overlay can swap with it.
	var/base_overlay_icon_state
	/// The special border overlay if the abiltiy is in an 'active' state
	var/active_overlay_icon_state = "bg_spell_border_active_blue"

	/// Reference to the premium component datum
	var/datum/component/premium_augment/premium_component
	/// Overlay that shows the % of quality ontop of the action button.
	var/mutable_appearance/quality_overlay
	/// Defers action button creation until hud exists.
	var/pending_hud_grant = FALSE

/datum/action/item_action/organ_action/premium/New(Target)
	..()
	if(active_overlay_icon_state)
		base_overlay_icon_state ||= overlay_icon_state
	var/obj/item/organ/organ_target = target
	premium_component = organ_target?.premium_component
	premium_component?.register_quality_action(src)
	update_quality_overlay()

/datum/action/item_action/organ_action/premium/Destroy()
	premium_component?.unregister_quality_action(src)
	return ..()

/datum/action/item_action/organ_action/premium/Grant(mob/grant_to)
	. = ..()
	if(!premium_component)
		var/obj/item/organ/organ_target = target
		premium_component = organ_target?.premium_component
	premium_component?.register_quality_action(src)
	update_arm_label()
	addtimer(CALLBACK(src, PROC_REF(update_quality_overlay)), 1) // Adresses a bug that the percentage is not visible at round start.

// We have to delay giving the action because we communicate with the button, and this causes runtimes at roundstart. We use signalers to delay it until the huds there.
/datum/action/item_action/organ_action/premium/GiveAction(mob/viewer)
	if(!viewer)
		return
	if(!viewer.hud_used)
		// Still grant the action even without a HUD so unit tests and headless mobs pass.
		LAZYOR(viewer.actions, src)
		if(!pending_hud_grant)
			pending_hud_grant = TRUE
			RegisterSignal(viewer, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created), override = TRUE)
		return
	if(pending_hud_grant)
		pending_hud_grant = FALSE
		UnregisterSignal(viewer, COMSIG_MOB_HUD_CREATED)
	return ..()

/// Waits until the HUD is created to then give the action, largely to properly render the percentage overlay.
/datum/action/item_action/organ_action/premium/proc/on_hud_created(mob/source)
	SIGNAL_HANDLER
	GiveAction(source)

/// Updates the text label to differentiate between left and right arm.
/datum/action/item_action/organ_action/premium/proc/update_arm_label()
	if(!istype(src, /datum/action/item_action/organ_action/premium/use))
		return
	var/obj/item/organ/organ_target = target
	if(!organ_target)
		return
	name = "Toggle [organ_target.name][arm_side_suffix(organ_target)]"
	build_all_button_icons(UPDATE_BUTTON_NAME | UPDATE_BUTTON_ICON | UPDATE_BUTTON_OVERLAY)

/datum/action/item_action/organ_action/premium/Remove(mob/remove_from)
	if(remove_from)
		UnregisterSignal(remove_from, COMSIG_MOB_HUD_CREATED)
	pending_hud_grant = FALSE
	return ..()

/datum/action/item_action/organ_action/premium/IsAvailable(feedback = FALSE)
	. = ..()
	if(!premium_component)
		var/obj/item/organ/organ_target = target
		premium_component = organ_target?.premium_component
	return .

/// Applies the maptext on the button indicating quality.
/datum/action/item_action/organ_action/premium/proc/update_quality_overlay()
	var/atom/movable/ui_element = get_atom_moveable()
	if(!ui_element || !premium_component)
		return
	ui_element.cut_overlay(quality_overlay)
	quality_overlay = new/mutable_appearance
	quality_overlay.plane = ABOVE_HUD_PLANE
	quality_overlay.maptext_width = 32
	quality_overlay.maptext_height = 16
	quality_overlay.maptext_x = 4
	quality_overlay.maptext_y = 0
	var/percent = clamp(round(premium_component.quality), 0, 100)
	quality_overlay.maptext = MAPTEXT("<span style='text-align:left; color:#ffffff;'>[percent]%</span>")
	ui_element.add_overlay(quality_overlay)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Gets the button that is tied to the action.
/datum/action/item_action/organ_action/premium/proc/get_atom_moveable()
	for(var/datum/hud/hud_instance as anything in viewers)
		var/atom/movable/screen/movable/action_button/action_button_instance = viewers[hud_instance]
		if(istype(action_button_instance, /atom/movable/screen/movable/action_button))
			return action_button_instance

/datum/action/item_action/organ_action/premium/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(active_overlay_icon_state)
		overlay_icon_state = is_action_active(current_button) ? active_overlay_icon_state : base_overlay_icon_state
	. = ..()
	return .

// Override to determine if an augment is currently active or not.
/datum/action/item_action/organ_action/premium/is_action_active(atom/movable/screen/movable/action_button/current_button)
	var/obj/item/organ/organ_target = target
	return organ_target?.is_action_active() || FALSE

/datum/action/item_action/organ_action/premium/use
	name = "Toggle Premium Augment"

/datum/action/item_action/organ_action/premium/use/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Toggle [organ_target.name][arm_side_suffix(organ_target)]"

/// Adds a suffix to left and right arm actions since you can have two actions and it might get confusing.
/datum/action/item_action/organ_action/premium/proc/arm_side_suffix(obj/item/organ/organ_target)
	if(!istype(organ_target, /obj/item/organ/cyberimp/arm))
		return ""
	if(organ_target.zone == BODY_ZONE_L_ARM)
		return " (Left)"
	if(organ_target.zone == BODY_ZONE_R_ARM)
		return " (Right)"
	return ""

/datum/action/item_action/organ_action/premium/use/do_effect(trigger_flags)
	var/obj/item/organ/organ_target = target
	if(!organ_target)
		return FALSE
	organ_target.use_action()
	build_all_button_icons(UPDATE_BUTTON_OVERLAY | UPDATE_BUTTON_STATUS)
	return TRUE
