
/datum/power/thaumaturge_root
	name = "Thaumaturge Root"
	desc = "RAW, AWESOME MAGICAL POTENTIAL, UNREFINED CODE. ALL WAITING TO BE SHAPED INTO AN AWESOME POWER. That is to say, you are not meant to see this and should report this to a dev."

	abstract_parent_type = /datum/power/thaumaturge_root
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
	/// If TRUE, thaumaturge actions use the default charges system.
	var/charge_mechanics = TRUE
	/// If TRUE, affinity can be gained from equipped/held items.
	var/affinity_benefits_from_items = TRUE
