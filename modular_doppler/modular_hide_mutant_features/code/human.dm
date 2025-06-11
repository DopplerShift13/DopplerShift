//	This DMI holds our radial icons for the 'hide mutant parts' verb
#define HIDING_RADIAL_DMI 'modular_doppler/modular_hide_mutant_features/icons/radial.dmi'

/mob/living/carbon/human/proc/mutant_part_visibility(quick_toggle, re_do)
	// The parts our particular user can choose
	var/list/available_selection
	// The total list of parts choosable
	var/static/list/total_selection = list(
		ORGAN_SLOT_EXTERNAL_HORNS = "horns",
		ORGAN_SLOT_EARS = "ears",
		ORGAN_SLOT_EXTERNAL_WINGS = "wings",
		ORGAN_SLOT_EXTERNAL_TAIL = "tail",
		ORGAN_SLOT_EXTERNAL_ANTENNAE = "moth_antennae",
		ORGAN_SLOT_EXTERNAL_SPINES = "spines",
	)

	// Stat check
	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't do this right now..."))
		return

	// Only show the 'reveal all' button if we are already hiding something
	if(try_hide_mutant_parts)
		LAZYOR(available_selection, "reveal all")
	// Lets build our parts list
	for(var/organ_slot in total_selection)
		if(get_organ_slot(organ_slot))
			LAZYOR(available_selection, total_selection[organ_slot])

	// If this proc is called with the 'quick_toggle' flag, we skip the rest
	if(quick_toggle)
		if("reveal all" in available_selection)
			LAZYNULL(try_hide_mutant_parts)
		else
			for(var/part in available_selection)
				LAZYOR(try_hide_mutant_parts, part)
		update_body_parts()
		return

	// Dont open the radial automatically just for one button
	if(re_do && (length(available_selection) == 1))
		return
	// If 'reveal all' is our only option just do it
	if(!re_do && (("reveal all" in available_selection) && (length(available_selection) == 1)))
		LAZYNULL(try_hide_mutant_parts)
		update_body_parts()
		return

	// Radial rendering
	var/list/choices = list()
	for(var/choice in available_selection)
		var/datum/radial_menu_choice/option = new
		var/image/part_image = image(icon = HIDING_RADIAL_DMI, icon_state = choice)

		option.image = part_image
		if(choice in try_hide_mutant_parts)
			part_image.underlays += image(icon = HIDING_RADIAL_DMI, icon_state = "module_unable")
		choices[choice] = option
	// Radial choices
	sort_list(choices)
	var/pick = show_radial_menu(usr, src, choices, custom_check = FALSE, tooltips = TRUE)
	if(!pick)
		return

	// Choice to action
	if(pick == "reveal all")
		to_chat(usr, span_notice("You are no longer trying to hide your mutant parts."))
		LAZYNULL(try_hide_mutant_parts)
		update_body_parts()
		return

	else if(pick in try_hide_mutant_parts)
		to_chat(usr, span_notice("You are no longer trying to hide your [pick]."))
		LAZYREMOVE(try_hide_mutant_parts, pick)
	else
		to_chat(usr, span_notice("You are now trying to hide your [pick]."))
		LAZYOR(try_hide_mutant_parts, pick)
	update_body_parts()
	// automatically re-do the menu after making a selection
	mutant_part_visibility(re_do = TRUE)

#undef HIDING_RADIAL_DMI
