/*
 * There'll be more items with the Science update! Just, best practicing before then.
*/


/// Lets you see rifts! Doesn't let you use them, but does let you know where they are and if you want to whack them with the anomaly neutralizer.
/obj/item/clothing/glasses/riftwalker_goggles
	name = "rift goggles"
	desc = "A special pair of goggles that lets you see 'rifts', tears in bluespace that connect two distant locations. Though it does not allow you the capability to wield this power, knowing is the first part of the battle."
	icon = 'modular_doppler/modular_powers/icons/items/glasses.dmi'
	worn_icon = 'modular_doppler/modular_powers/icons/items/glasses.dmi'
	icon_state = "rift_goggles_obj"
	worn_icon_state = "rift_goggles"
	clothing_traits = list(TRAIT_IMBUED_RIFTWALKER_SIGHT_ONLY)
	glass_colour_type = /datum/client_colour/glass_colour/blue
	forced_glass_color = TRUE
	actions_types = list(/datum/action/item_action/toggle_rift_vision)

/// Toggles the blue lens colour and the sight needed to see and interact with rifts.
/obj/item/clothing/glasses/riftwalker_goggles/proc/toggle_rift_vision(mob/living/user)
	if(user.get_slot_by_item(src) != ITEM_SLOT_EYES)
		return FALSE

	if(glass_colour_type)
		change_glass_color(null)
		detach_clothing_traits(TRAIT_IMBUED_RIFTWALKER_SIGHT_ONLY)
		user.balloon_alert(user, "rift vision disabled")
	else
		change_glass_color(initial(glass_colour_type))
		attach_clothing_traits(TRAIT_IMBUED_RIFTWALKER_SIGHT_ONLY)
		GLOB.riftwalker_network.generate_rifts()
		user.balloon_alert(user, "rift vision enabled")

	GLOB.riftwalker_network.update_rift_visibility(user)
	return TRUE

/// If there's no riftwalkers we generate rifts, just so it doesn't feel awkward seeing none.
/obj/item/clothing/glasses/riftwalker_goggles/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_EYES && glass_colour_type)
		GLOB.riftwalker_network.generate_rifts()
	GLOB.riftwalker_network.update_rift_visibility(user)

/obj/item/clothing/glasses/riftwalker_goggles/dropped(mob/living/user)
	. = ..()
	if(user)
		GLOB.riftwalker_network.update_rift_visibility(user)

/// Action to turn on/off the vision.
/datum/action/item_action/toggle_rift_vision
	name = "Toggle Rift Vision"

/datum/action/item_action/toggle_rift_vision/do_effect(trigger_flags)
	if(!istype(target, /obj/item/clothing/glasses/riftwalker_goggles) || !isliving(owner))
		return FALSE
	var/obj/item/clothing/glasses/riftwalker_goggles/rift_goggles = target
	var/toggled = rift_goggles.toggle_rift_vision(owner)
	// makes the button properly regenerate when its on
	if(toggled)
		build_all_button_icons(UPDATE_BUTTON_BACKGROUND, TRUE)
	return toggled

/datum/action/item_action/toggle_rift_vision/is_action_active(atom/movable/screen/movable/action_button/current_button)
	var/obj/item/clothing/glasses/riftwalker_goggles/rift_goggles = target
	return rift_goggles?.glass_colour_type

/// Protolathe design
/datum/design/riftwalker_goggles
	name = "Rift Goggles"
	desc = "A special set of goggles that let you see bluespace rifts. Does not let you enter rifts, but does let you use items (such as anomaly neutralizers) on it."
	id = "riftwalker_goggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/riftwalker_goggles
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/// Temp node that I'll expand later with the science updoot, but gets it into the techweb for people to print.
/datum/techweb_node/rift_research
	id = "rift_research"
	display_name = "Rift Research"
	description = "Study of the large-scale advent of bluespace distortions known as 'rifts'."
	starting_node = TRUE
	design_ids = list("riftwalker_goggles")
