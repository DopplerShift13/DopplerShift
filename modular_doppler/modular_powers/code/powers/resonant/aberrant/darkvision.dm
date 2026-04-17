// Lets you see in the dark. Duh.
/datum/power/aberrant/darkvision
	name = "Darkvision"
	desc = "Your eyes see perfectly in the dark; but your vision gains a blue-ish hue to it."
	security_record_text = "Subject sees perfectly in the dark."
	mob_trait = TRAIT_TRUE_NIGHT_VISION

	value = 3
	required_powers = list(/datum/power/aberrant_root/beastial, /datum/power/aberrant_root/monstrous)
	required_allow_any = TRUE

	/// Saves if we apply the cutoffs for darkvision.
	var/eye_color_cutoffs_applied = FALSE

/datum/power/aberrant/darkvision/add()
	var/obj/item/organ/eyes/eyes = power_holder.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes && isnull(eyes.color_cutoffs)) // we apply a vision tint but only if our current eyes dont apply it
		eyes.color_cutoffs = list(25, 15, 35)
		eye_color_cutoffs_applied = TRUE
	power_holder.update_sight()

/datum/power/aberrant/darkvision/remove()
	var/obj/item/organ/eyes/eyes = power_holder.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes && eye_color_cutoffs_applied)
		eyes.color_cutoffs = null
		eye_color_cutoffs_applied = FALSE
	power_holder.update_sight()
