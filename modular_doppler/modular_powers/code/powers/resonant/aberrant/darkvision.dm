// Lets you see in the dark. Duh.
/datum/power/aberrant/darkvision
	name = "Darkvision"
	desc = "Your eyes see perfectly in the dark; but your vision gains a colored tint. This color is customizeable."
	security_record_text = "Subject sees perfectly in the dark."
	mob_trait = TRAIT_TRUE_NIGHT_VISION

	value = 3
	required_powers = list(/datum/power/aberrant_root/beastial, /datum/power/aberrant_root/monstrous)
	required_allow_any = TRUE

	/// Saves if we apply the cutoffs for darkvision.
	var/eye_color_cutoffs_applied = FALSE
	/// Default red cutoff for darkvision tint.
	var/default_cutoff_red = 25
	/// Default green cutoff for darkvision tint.
	var/default_cutoff_green = 15
	/// Default blue cutoff for darkvision tint.
	var/default_cutoff_blue = 35

/datum/power_constant_data/darkvision
	associated_typepath = /datum/power/aberrant/darkvision
	customization_options = list(
		/datum/preference/numeric/darkvision_cutoff/red,
		/datum/preference/numeric/darkvision_cutoff/green,
		/datum/preference/numeric/darkvision_cutoff/blue
	)

/datum/power/aberrant/darkvision/add(client/client_source)
	// Gets the chosen values.
	var/cutoff_red_choice = client_source?.prefs?.read_preference(/datum/preference/numeric/darkvision_cutoff/red)
	var/cutoff_green_choice = client_source?.prefs?.read_preference(/datum/preference/numeric/darkvision_cutoff/green)
	var/cutoff_blue_choice = client_source?.prefs?.read_preference(/datum/preference/numeric/darkvision_cutoff/blue)

	// If prefs aren't set (aka power was given without it being in target prefs) we default to the default values, otherwise we take the choice values.
	var/darkvision_cutoff_red = isnull(cutoff_red_choice) ? default_cutoff_red : cutoff_red_choice
	var/darkvision_cutoff_green = isnull(cutoff_green_choice) ? default_cutoff_green : cutoff_green_choice
	var/darkvision_cutoff_blue = isnull(cutoff_blue_choice) ? default_cutoff_blue : cutoff_blue_choice

	var/obj/item/organ/eyes/eyes = power_holder.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes && isnull(eyes.color_cutoffs)) // we apply a vision tint but only if our current eyes dont apply it
		eyes.color_cutoffs = list(darkvision_cutoff_red, darkvision_cutoff_green, darkvision_cutoff_blue)
		eye_color_cutoffs_applied = TRUE
	power_holder.update_sight()

/datum/power/aberrant/darkvision/remove()
	var/obj/item/organ/eyes/eyes = power_holder.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes && eye_color_cutoffs_applied)
		eyes.color_cutoffs = null
		eye_color_cutoffs_applied = FALSE
	power_holder.update_sight()

/datum/preference/numeric/darkvision_cutoff
	abstract_type = /datum/preference/numeric/darkvision_cutoff
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER

	minimum = 0
	maximum = 50
	step = 1

/datum/preference/numeric/darkvision_cutoff/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/numeric/darkvision_cutoff/red
	savefile_key = "darkvision_cutoff_red"

/datum/preference/numeric/darkvision_cutoff/red/create_default_value()
	return 25

/datum/preference/numeric/darkvision_cutoff/green
	savefile_key = "darkvision_cutoff_green"

/datum/preference/numeric/darkvision_cutoff/green/create_default_value()
	return 15

/datum/preference/numeric/darkvision_cutoff/blue
	savefile_key = "darkvision_cutoff_blue"

/datum/preference/numeric/darkvision_cutoff/blue/create_default_value()
	return 35
