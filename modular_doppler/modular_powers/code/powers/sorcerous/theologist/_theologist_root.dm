/datum/power/theologist_root
	name = "Abstract theologist root"
	desc = "Some spend most of their life looking for the holy grail, the root of life, yggdrasil and all those things. This is the root. Of the healer powers. So you're getting close? \
	Present this to the developers for the next hint in your quest. Because you're not actually meant to have this."
	abstract_parent_type = /datum/power/theologist_root

	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THEOLOGIST
	priority = POWER_PRIORITY_ROOT

/datum/power/theologist_root/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// We pass along the piety component to actually handle most of the piety stuff.
	power_holder.AddComponent(/datum/component/theologist_piety, power_holder)
	. = ..()
