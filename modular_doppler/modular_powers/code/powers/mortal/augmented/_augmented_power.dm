/datum/power/augmented
	name = "Augmented Power"
	desc = "I never asked for this (abstract type to appear. You shouldn't be seeing this.)"

	power_flags = POWER_HUMAN_ONLY
	archetype = POWER_ARCHETYPE_MORTAL
	path = POWER_PATH_AUGMENTED
	priority = POWER_PRIORITY_BASIC
	abstract_parent_type = /datum/power/augmented

	// The augment added in the quirk.
	var/augment

	// Should the augment be disabled if they're a prisoner.
	var/disable_if_prisoner = TRUE

// Responsible for adding augments
/datum/power/augmented/add_unique(client/client_source)
	var/mob/living/carbon/carbon_holder = power_holder
	if(!augment || !power_holder)
		return
	if(disable_if_prisoner && carbon_holder.mind?.assigned_role.title == JOB_PRISONER)
		to_chat(carbon_holder, span_warning("Due to your job, the [name] power has been disabled."))
		return

	// All checks passed, time to actually give the item.
	// Yes. We do all this. Just to get people's arms. Having two is infinitely more difficult.
	var/obj/item/organ/implant = new augment()
	if(implant.zone in GLOB.arm_zones)
		var/augment_left = client_source?.prefs?.read_preference(/datum/preference/choiced/augment_left)
		var/augment_right = client_source?.prefs?.read_preference(/datum/preference/choiced/augment_right)
		var/left_match = augment_matches_pref(augment_left)
		var/right_match = augment_matches_pref(augment_right)
		if(left_match && right_match)
			var/obj/item/organ/left_implant = new augment()
			left_implant.zone = BODY_ZONE_L_ARM
			left_implant.slot = ORGAN_SLOT_LEFT_ARM_AUG
			left_implant.Insert(carbon_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

			var/obj/item/organ/right_implant = new augment()
			right_implant.zone = BODY_ZONE_R_ARM
			right_implant.slot = ORGAN_SLOT_RIGHT_ARM_AUG
			right_implant.Insert(carbon_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)
			return
		var/arm_zone = get_assigned_arm_zone(client_source)
		if(arm_zone == BODY_ZONE_L_ARM)
			implant.zone = BODY_ZONE_L_ARM
			implant.slot = ORGAN_SLOT_LEFT_ARM_AUG
		else if(arm_zone == BODY_ZONE_R_ARM)
			implant.zone = BODY_ZONE_R_ARM
			implant.slot = ORGAN_SLOT_RIGHT_ARM_AUG
	implant.Insert(carbon_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)
	return

// Used to get the location zones for augment_location_label
/datum/power/augmented/proc/get_augment_location_label()
	if(!augment)
		return null
	var/label
	var/obj/item/organ/augment_path = augment
	var/zone = initial(augment_path.zone)
	var/slot = initial(augment_path.slot)
	// I'd love if like, the weird slots like ORGAN_SLOT_BRAIN_CNS didn't return with weird strings like "brain_antistun".
	// For UX we basically tell the base slots. We might have issues wtih overlap for the misc. category in the future but uhh.
	// Just add it manually here and kick the can further down the road.
	var/slot_label = GLOB.organ_slot_labels[slot]
	if(slot_label)
		return slot_label
	if(zone in GLOB.arm_zones)
		label = "Arms"
	else if(zone in GLOB.leg_zones)
		label = "Legs"
	else if(zone == BODY_ZONE_HEAD)
		label = "Head"
	else if(zone == BODY_ZONE_CHEST)
		label = "Chest"
	else
		label = "Misc."
	return label

// Labels for organ slots used in augment UI.
// A lot of these are niche, and I've pre-populated with basically anything I think is relevant in the future (and the appendix lmao).
// If yours is missing, just add it.
GLOBAL_LIST_INIT(organ_slot_labels, list(
	ORGAN_SLOT_HUD = "Eye HUD",
	ORGAN_SLOT_EYES = "Eyes",
	ORGAN_SLOT_EARS = "Ears",
	ORGAN_SLOT_BRAIN = "Brain",
	ORGAN_SLOT_BRAIN_CEREBELLUM = "Brain (Cerebellum)",
	ORGAN_SLOT_BRAIN_CNS = "Brain (CNS)",
	ORGAN_SLOT_HEART = "Heart",
	ORGAN_SLOT_LUNGS = "Lungs",
	ORGAN_SLOT_LIVER = "Liver",
	ORGAN_SLOT_STOMACH = "Stomach",
	ORGAN_SLOT_TONGUE = "Tongue",
	ORGAN_SLOT_VOICE = "Vocal Cords",
	ORGAN_SLOT_SPINE = "Spine",
	ORGAN_SLOT_APPENDIX = "Appendix",
	ORGAN_SLOT_BREATHING_TUBE = "Breathing Tube",
	ORGAN_SLOT_HEART_AID = "Heart Aid",
	ORGAN_SLOT_STOMACH_AID = "Stomach Aid",
	ORGAN_SLOT_THRUSTERS = "Thrusters",
))

// Global list of arm augment power names for preference validation.
// ALL THIS EFFORT JUST FOR SOME ARMS.
GLOBAL_LIST_INIT(arm_augment_values, generate_arm_augment_values())

// This is to populate the global list above. It only adds augments in powers, so you can't cheat to give yourself an esword arm.
/proc/generate_arm_augment_values()
	var/list/values = list()
	for(var/datum/power/augmented/power_type as anything in subtypesof(/datum/power/augmented))
		if(initial(power_type.abstract_parent_type) == power_type)
			continue
		var/obj/item/organ/augment_path = initial(power_type.augment)
		if(!augment_path)
			continue
		var/zone = initial(augment_path.zone)
		if(zone in GLOB.arm_zones)
			values += initial(power_type.name)
	return values

// This gets the /datum/preference/choiced for left and right augments telling us which arm is where.
/datum/power/augmented/proc/get_assigned_arm_zone(client/client_source)
	if(!client_source)
		return null
	var/augment_left = client_source.prefs?.read_preference(/datum/preference/choiced/augment_left)
	var/augment_right = client_source.prefs?.read_preference(/datum/preference/choiced/augment_right)
	if(augment_left && augment_left != AUGMENTED_NO_AUGMENT && augment_matches_pref(augment_left))
		return BODY_ZONE_L_ARM
	if(augment_right && augment_right != AUGMENTED_NO_AUGMENT && augment_matches_pref(augment_right))
		return BODY_ZONE_R_ARM
	return null

// Bit of validation to make sure the augment is in fact in the user's prefs.
/datum/power/augmented/proc/augment_matches_pref(value)
	if(isnull(value) || value == AUGMENTED_NO_AUGMENT || !augment)
		return FALSE
	if(value == name)
		return TRUE
	if(istext(value) && value == "[augment]")
		return TRUE
	return FALSE

// Global arm loadout: left/right slots store the chosen augment for each arm.
/datum/preference/choiced/augment_left
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "augment_left"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/augment_left/create_default_value()
	return AUGMENTED_NO_AUGMENT

/datum/preference/choiced/augment_left/init_possible_values()
	return list(AUGMENTED_NO_AUGMENT) + GLOB.arm_augment_values

/datum/preference/choiced/augment_left/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/augment_left/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/augment_right
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "augment_right"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/augment_right/create_default_value()
	return AUGMENTED_NO_AUGMENT

/datum/preference/choiced/augment_right/init_possible_values()
	return list(AUGMENTED_NO_AUGMENT) + GLOB.arm_augment_values

/datum/preference/choiced/augment_right/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/augment_right/apply_to_human(mob/living/carbon/human/target, value)
	return
