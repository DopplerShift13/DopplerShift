// Custom actions for premium augments, meant to show the progress bar with quality wear.
/datum/action/item_action/organ_action/premium
	name = "Premium Augment"
	check_flags = AB_CHECK_CONSCIOUS

	var/datum/component/premium_augment/premium_component
	var/mutable_appearance/quality_overlay

/datum/action/item_action/organ_action/premium/New(Target)
	..()
	var/obj/item/organ/cyberimp/organ_target = target
	premium_component = organ_target?.premium_component
	premium_component?.register_quality_action(src)
	update_quality_overlay()

/datum/action/item_action/organ_action/premium/Destroy()
	premium_component?.unregister_quality_action(src)
	return ..()

/datum/action/item_action/organ_action/premium/Grant(mob/grant_to)
	. = ..()
	if(!premium_component)
		var/obj/item/organ/cyberimp/organ_target = target
		premium_component = organ_target?.premium_component
	addtimer(CALLBACK(src, PROC_REF(update_quality_overlay)), 1) // Adresses a bug that the percentage is not visible at round start.

/datum/action/item_action/organ_action/premium/IsAvailable(feedback = FALSE)
	. = ..()
	if(!premium_component)
		var/obj/item/organ/cyberimp/organ_target = target
		premium_component = organ_target?.premium_component
	return .

/datum/action/item_action/organ_action/premium/proc/update_quality_overlay()
	var/atom/movable/ui_element = get_atom_moveable()
	if(!ui_element || !premium_component)
		return
	ui_element.cut_overlay(quality_overlay)
	quality_overlay = new/mutable_appearance
	quality_overlay.maptext_width = 32
	quality_overlay.maptext_height = 16
	quality_overlay.maptext_x = 4
	quality_overlay.maptext_y = 0
	var/percent = clamp(round(premium_component.quality), 0, 100)
	quality_overlay.maptext = MAPTEXT("<span style='text-align:left; color:#ffffff;'>[percent]%</span>")
	ui_element.add_overlay(quality_overlay)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/item_action/organ_action/premium/proc/get_atom_moveable()
	for(var/datum/hud/hud_instance as anything in viewers)
		var/atom/movable/screen/movable/action_button/action_button_instance = viewers[hud_instance]
		if(istype(action_button_instance, /atom/movable/screen/movable/action_button))
			return action_button_instance

/datum/action/item_action/organ_action/premium/use
	name = "Toggle Premium Augment"

/datum/action/item_action/organ_action/premium/use/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Toggle [organ_target.name]"

/datum/action/item_action/organ_action/premium/use/do_effect(trigger_flags)
	var/obj/item/organ/cyberimp/organ_target = target
	if(!organ_target)
		return FALSE
	organ_target.use_action()
	return TRUE
