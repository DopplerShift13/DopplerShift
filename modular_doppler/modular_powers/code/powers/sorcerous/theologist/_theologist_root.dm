/datum/power/theologist_root
	name = "Abstract theologist root"
	desc = "Oh noes, tell the coders!"
	abstract_parent_type = /datum/power/theologist_root

	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THEOLOGIST
	priority = POWER_PRIORITY_ROOT

/datum/power/theologist_root/revered/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// We pass along the piety power to actually handle most of the piety stuff.
	var/datum/power/theologist_piety/piety = new /datum/power/theologist_piety
	piety.add_to_holder(new_holder = power_holder)
	. = ..()
