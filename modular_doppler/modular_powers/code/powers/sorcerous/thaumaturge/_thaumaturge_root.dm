
/datum/power/thaumaturge_root
	name = "Thaumaturge Root"
	desc = "RAW, AWESOME MAGICAL POTENTIAL, UNREFINED CODE. ALL WAITING TO BE SHAPED INTO AN AWESOME POWER. That is to say, you are not meant to see this and should report this to a dev."

	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THAUMATURGE
	priority = POWER_PRIORITY_ROOT

	/// Color of charges on spell actions.
	var/charges_color = "#ff69b4"
	/// What value thaumaturge actions should render on their resource overlay.
	var/resource_display_mode = THAUMATURGE_RESOURCE_DISPLAY_CHARGES
	/// Multiplier used on the display, e.g if you are using a resource to cast.
	var/resource_display_multiplier = 1

/datum/power/thaumaturge_root/grant_action(datum/action/cooldown/power/power_path)
	var/datum/action/cooldown/power/new_action = ..()
	if(!new_action)
		return FALSE
	if(istype(new_action, /datum/action/cooldown/power/thaumaturge))
		var/datum/action/cooldown/power/thaumaturge/thaum_action = new_action
		thaum_action.resource_color = charges_color
		thaum_action.resource_display_mode = resource_display_mode
		thaum_action.resource_display_multiplier = resource_display_multiplier
		thaum_action.update_charges_overlay()
	return new_action
