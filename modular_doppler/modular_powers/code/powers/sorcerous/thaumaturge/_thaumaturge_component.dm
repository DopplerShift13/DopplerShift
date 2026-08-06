/datum/component/thaumaturge
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The mob we're attached to is always `parent`.
	var/mob/living/attached_mob

	/// If TRUE, thaumaturge actions use the default charges system.
	var/charge_mechanics = TRUE
	/// If TRUE, affinity can be gained from equipped/held items.
	var/affinity_benefits_from_items = TRUE
	/// Color of charges/resource text on thaumaturge actions.
	var/charges_color = "#ffffff"
	/// What value thaumaturge actions should render on their resource overlay.
	var/resource_display_mode = THAUMATURGE_RESOURCE_DISPLAY_CHARGES
	/// Multiplier used on the display, e.g if you are using a resource to cast.
	var/resource_display_multiplier = 1
	/// Extra flags applied to thaumaturge action anti-magic checks while this component exists.
	var/additional_magic_resistance_flags = NONE
	/// Optional action button background override applied to owned thaumaturge powers.
	var/action_background_icon_state_override

/datum/component/thaumaturge/Initialize(mob/living/new_attached_mob)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = new_attached_mob || parent
	RegisterSignal(attached_mob, COMSIG_MOB_GRANTED_ACTION, PROC_REF(on_owner_action_granted))
	apply_action_magic_flags(TRUE)
	apply_action_background_override(TRUE)

/datum/component/thaumaturge/Destroy(force)
	if(attached_mob)
		UnregisterSignal(attached_mob, COMSIG_MOB_GRANTED_ACTION)
	apply_action_magic_flags(FALSE)
	apply_action_background_override(FALSE)
	return ..()

/// Adds additional antimagic flags to existing powers. Mostly use for hemomancy being UNHOLY.
/datum/component/thaumaturge/proc/apply_action_magic_flags(add_flags = TRUE)
	if(!attached_mob || !additional_magic_resistance_flags)
		return
	var/additional_power_magic_flags = convert_magic_resistance_flags_to_power_flags(additional_magic_resistance_flags)
	for(var/datum/action/action as anything in attached_mob.actions)
		var/datum/action/cooldown/power/thaumaturge/thaumaturge_action = action
		if(!istype(thaumaturge_action))
			continue
		var/datum/power/origin_power = thaumaturge_action.origin_power
		if(!origin_power || !additional_power_magic_flags)
			continue
		var/base_power_magic_flags = initial(origin_power.magic_flags)
		origin_power.magic_flags = add_flags ? (base_power_magic_flags | additional_power_magic_flags) : base_power_magic_flags
		thaumaturge_action.sync_magic_resistance_types_from_power()

/// Applies an optional action button background override to owned thaumaturge powers.
/datum/component/thaumaturge/proc/apply_action_background_override(apply_override = TRUE)
	if(!attached_mob || !action_background_icon_state_override)
		return
	for(var/datum/action/action as anything in attached_mob.actions)
		var/datum/action/cooldown/power/thaumaturge/thaumaturge_action = action
		if(!istype(thaumaturge_action))
			continue
		thaumaturge_action.background_icon_state = apply_override ? action_background_icon_state_override : initial(thaumaturge_action.background_icon_state)
		thaumaturge_action.build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/// Applies current component-based action overrides to newly granted thaumaturge actions so that they inherit component behavior as well.
/datum/component/thaumaturge/proc/on_owner_action_granted(mob/living/source, datum/action/granted_action)
	SIGNAL_HANDLER

	var/datum/action/cooldown/power/thaumaturge/thaumaturge_action = granted_action
	if(!istype(thaumaturge_action))
		return

	if(additional_magic_resistance_flags)
		var/additional_power_magic_flags = convert_magic_resistance_flags_to_power_flags(additional_magic_resistance_flags)
		var/datum/power/origin_power = thaumaturge_action.origin_power
		if(origin_power && additional_power_magic_flags)
			var/base_power_magic_flags = initial(origin_power.magic_flags)
			origin_power.magic_flags = base_power_magic_flags | additional_power_magic_flags
		thaumaturge_action.sync_magic_resistance_types_from_power()

	if(action_background_icon_state_override)
		thaumaturge_action.background_icon_state = action_background_icon_state_override
		thaumaturge_action.build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/// Converts action anti-magic resistance flags into preference-menu power magic tags.
/datum/component/thaumaturge/proc/convert_magic_resistance_flags_to_power_flags(magic_resistance_flags)
	var/power_magic_flags = NONE
	if(magic_resistance_flags & MAGIC_RESISTANCE_HOLY)
		power_magic_flags |= POWER_MAGIC_UNHOLY
	if(magic_resistance_flags & MAGIC_RESISTANCE_MIND)
		power_magic_flags |= POWER_MAGIC_MENTAL
	if(magic_resistance_flags & MAGIC_RESISTANCE)
		power_magic_flags |= POWER_MAGIC_STANDARD
	return power_magic_flags
