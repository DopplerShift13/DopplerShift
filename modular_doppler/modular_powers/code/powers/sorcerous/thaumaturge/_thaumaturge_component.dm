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

/datum/component/thaumaturge/Initialize(mob/living/new_attached_mob)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = new_attached_mob || parent
	apply_action_magic_flags(TRUE)

/datum/component/thaumaturge/Destroy(force)
	apply_action_magic_flags(FALSE)
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
		var/base_flags = initial(thaumaturge_action.magic_resistance_types)
		thaumaturge_action.magic_resistance_types = add_flags ? (base_flags | additional_magic_resistance_flags) : base_flags
		var/datum/power/origin_power = thaumaturge_action.origin_power
		if(!origin_power || !additional_power_magic_flags)
			continue
		var/base_power_magic_flags = initial(origin_power.magic_flags)
		origin_power.magic_flags = add_flags ? (base_power_magic_flags | additional_power_magic_flags) : base_power_magic_flags

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

