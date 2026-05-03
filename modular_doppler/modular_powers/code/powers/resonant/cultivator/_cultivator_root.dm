/datum/power/cultivator_root
	name = "Abstract cultivator root"
	desc = "For decades, I have honed my body, my skill. Like calligraphists have mastered the stroke of a brush, I have mastered the brush of my hand along the keyboard. \
	Lines upon lines of code created at but the single flick of the wrist. So know what is good with you; and report this abstract root."
	abstract_parent_type = /datum/power/cultivator_root

	mob_trait = TRAIT_ARCHETYPE_RESONANT
	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_CULTIVATOR
	priority = POWER_PRIORITY_ROOT

/datum/power/cultivator_root/post_add() // I'd love to run this during add but that runtimes at round start.
	if(!power_holder) // So it doesn't runtime at init
		return
	// We pass along the piety component to actually handle most of the piety stuff.
	power_holder.AddComponent(/datum/component/cultivator_energy, power_holder)
	// Passes along meditation.
	var/has_meditate = FALSE
	for(var/datum/action/action as anything in power_holder.actions)
		if(istype(action, /datum/action/cooldown/power/resonant_meditate))
			has_meditate = TRUE
			break
	if(!has_meditate)
		grant_action(/datum/action/cooldown/power/resonant_meditate)
	. = ..()

/datum/power/cultivator_root/remove()
	. = ..()
	var/mob/living/holder = power_holder
	if(!holder)
		return

	// We check for other roots of our type, in the event that admin shenanigangs gave multiple roots. Don't want to throw out the whole component when other things are still in use.
	var/has_other_root = FALSE
	for(var/datum/power/power as anything in holder.powers)
		if(istype(power, /datum/power/cultivator_root))
			has_other_root = TRUE
			break

	if(!has_other_root)
		var/tobedel = holder.GetComponent(/datum/component/cultivator_energy)
		QDEL_NULL(tobedel)
