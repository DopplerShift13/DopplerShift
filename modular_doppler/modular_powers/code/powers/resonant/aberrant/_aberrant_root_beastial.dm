/datum/power/aberrant_root/beastial
	name = "Beastial Body"
	desc = "You have the traits of an animal; and with it, the apetite of one. In addition to your species normal preferences, you now like the following food based on your choice of Herbivore or Carnivore (including making it non-toxic)\
	\nHerbivore: Vegetables, Fruit & Nuts. \
	\nCarnivore: Raw, Gore, Meat, Bugs & Seafood."
	value = 2
	/// Saved preference value used for security records snapshotting.
	var/chosen_diet = "None"

/datum/power/aberrant_root/beastial/get_security_record_text()
	switch(chosen_diet)
		if("Herbivore", "Carnivore")
			return "Subject has a [LOWER_TEXT(chosen_diet)] dietary adaptation."
	return ""

/datum/power/aberrant_root/beastial/add(client/client_source)
	var/obj/item/organ/tongue/tongue = power_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	var/diet_choice = client_source?.prefs?.read_preference(/datum/preference/choiced/beastial_diet)
	if(isnull(diet_choice))
		diet_choice = "None"
	chosen_diet = diet_choice

	switch(diet_choice)
		if("Herbivore")
			tongue.liked_foodtypes |= VEGETABLES | FRUIT | NUTS
			tongue.disliked_foodtypes &= ~(VEGETABLES | FRUIT | NUTS)
			tongue.toxic_foodtypes &= ~(VEGETABLES | FRUIT | NUTS)
		if("Carnivore")
			tongue.liked_foodtypes |= RAW | GORE | MEAT | BUGS | SEAFOOD
			tongue.disliked_foodtypes &= ~(RAW | GORE | MEAT | BUGS | SEAFOOD)
			tongue.toxic_foodtypes &= ~(RAW | GORE | MEAT | BUGS | SEAFOOD)

/datum/power/aberrant_root/beastial/remove()
	var/obj/item/organ/tongue/tongue = power_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
	tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)
	tongue.toxic_foodtypes = initial(tongue.toxic_foodtypes)

// Preference choice for Beastkindred diet selection.
/datum/preference/choiced/beastial_diet
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "beastial_diet"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/beastial_diet/create_default_value()
	return "None"

/datum/preference/choiced/beastial_diet/init_possible_values()
	return list("None", "Herbivore", "Carnivore")

/datum/preference/choiced/beastial_diet/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/beastial_diet/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/beastial
	associated_typepath = /datum/power/aberrant_root/beastial
	customization_options = list(/datum/preference/choiced/beastial_diet)
