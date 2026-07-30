/datum/dna
	///	This variable is read by the regenerate_organs() proc to know what organ subtype to give
	var/tail_type = NO_VARIATION

/datum/species/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	if(target == null)
		return
	if(!ishuman(target))
		return

	if(can_regenerate_mutant_feature(FEATURE_TAIL_LIZARD) && target.dna.features[FEATURE_TAIL_LIZARD] != /datum/sprite_accessory/blank::name)
		var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/tail/lizard)
		replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		return .
	else if(can_regenerate_mutant_feature(FEATURE_TAIL_CAT) && target.dna.features[FEATURE_TAIL_CAT] != /datum/sprite_accessory/blank::name)
		var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/tail/cat)
		replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		return .
	else if(can_regenerate_mutant_feature(FEATURE_TAIL_MONKEY) && target.dna.features[FEATURE_TAIL_MONKEY] != /datum/sprite_accessory/blank::name)
		var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/tail/monkey)
		replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		return .
	else if(can_regenerate_mutant_feature(FEATURE_TAIL_FISH) && target.dna.features[FEATURE_TAIL_FISH] != /datum/sprite_accessory/blank::name)
		var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/tail/fish)
		replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		return .
	else if((can_regenerate_mutant_feature(FEATURE_TAIL_OTHER) && target.dna.features[FEATURE_TAIL_OTHER] != /datum/sprite_accessory/blank::name) && (target.dna.tail_type != NO_VARIATION))
		var/obj/item/organ/organ_path = text2path("/obj/item/organ/tail/[target.dna.tail_type]")
		var/obj/item/organ/replacement = SSwardrobe.provide_type(organ_path)
		replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		return .

	var/obj/item/organ/tail/old_part = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(istype(old_part))
		old_part.Remove(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		old_part.moveToNullspace()


/// Dropdown to select which tail you'll be rocking
//	This is my third attempt at writing this, which means it has to be good
/datum/preference/choiced/tail_variation
	savefile_key = "tail_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/tail_variation/create_default_value()
	return NO_VARIATION

/datum/preference/choiced/tail_variation/init_possible_values()
	return list(NO_VARIATION) + (GLOB.mutant_variations) + list(TESHARI)

/datum/preference/choiced/tail_variation/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	return TRUE

/datum/preference/choiced/tail_variation/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/tail_variation/apply_to_human(mob/living/carbon/human/target, chosen_variation)
//	Read by the regenerate_organs() proc to know what organ subtype to grant
	target.dna.tail_type = chosen_variation
//	Make a beautiful switch list to support the choices
//	Luckily for all of us, this list wont get any bigger
	switch(chosen_variation)
		if(NO_VARIATION)
			target.dna.features[FEATURE_TAIL_LIZARD] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_CAT] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_MONKEY] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_OTHER] = /datum/sprite_accessory/blank::name
		if(LIZARD)
			target.dna.features[FEATURE_TAIL_CAT] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_MONKEY] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_OTHER] = /datum/sprite_accessory/blank::name
		if(CAT)
			target.dna.features[FEATURE_TAIL_LIZARD] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_MONKEY] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_OTHER] = /datum/sprite_accessory/blank::name
		if(MONKEY)
			target.dna.features[FEATURE_TAIL_CAT] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_LIZARD] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_OTHER] = /datum/sprite_accessory/blank::name
		if(FISH)
			target.dna.features[FEATURE_TAIL_CAT] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_LIZARD] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_MONKEY] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_OTHER] = /datum/sprite_accessory/blank::name
		else
			target.dna.features[FEATURE_TAIL_LIZARD] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_CAT] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_MONKEY] = /datum/sprite_accessory/blank::name
			target.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/blank::name

///	All current tail types to choose from
//	Lizard
/datum/preference/choiced/species_feature/lizard_tail // this is an overwrite, so its missing some variables
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_LIZARD
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/lizard_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/lizard_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == LIZARD)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/lizard_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/lizard_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == LIZARD)
		target.dna.features[FEATURE_TAIL_LIZARD] = value

/datum/preference/choiced/species_feature/lizard_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Cat
/datum/preference/choiced/species_feature/tail_felinid
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_CAT
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/tail_felinid/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == CAT)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/tail_felinid/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/tail_felinid/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == CAT)
		target.dna.features[FEATURE_TAIL_CAT] = value

/datum/preference/choiced/species_feature/tail_felinid/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Dog
/datum/preference/choiced/species_feature/dog_tail
	savefile_key = "feature_dog_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_DOG
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/dog_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/dog_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == DOG)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/dog_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/dog_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == DOG)	// we will be sharing the 'tail_other' slot with multiple tail types
		target.dna.features[FEATURE_TAIL_DOG] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/dog_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Fox
/datum/preference/choiced/species_feature/fox_tail
	savefile_key = "feature_fox_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_FOX
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/fox_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/fox_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == FOX)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/fox_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/fox_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == FOX)
		target.dna.features[FEATURE_TAIL_FOX] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/fox_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Bunny
/datum/preference/choiced/species_feature/bunny_tail
	savefile_key = "feature_bunny_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_BUNNY
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bunny_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/bunny_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == BUNNY)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bunny_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bunny_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == BUNNY)
		target.dna.features[FEATURE_TAIL_BUNNY] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/bunny_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Mouse
/datum/preference/choiced/species_feature/mouse_tail
	savefile_key = "feature_mouse_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_MOUSE
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/mouse_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/mouse_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == MOUSE)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/mouse_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/mouse_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == MOUSE)
		target.dna.features[FEATURE_TAIL_MOUSE] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/mouse_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Bird
/datum/preference/choiced/species_feature/bird_tail
	savefile_key = "feature_bird_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_BIRD
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bird_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/bird_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == BIRD)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bird_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bird_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == BIRD)
		target.dna.features[FEATURE_TAIL_BIRD] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/bird_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Monkey
/datum/preference/choiced/species_feature/monkey_tail
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_MONKEY
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/monkey_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/monkey_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == MONKEY)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/monkey_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/monkey_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == MONKEY)
		target.dna.features[FEATURE_TAIL_MONKEY] = value

/datum/preference/choiced/species_feature/monkey_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Deer
/datum/preference/choiced/species_feature/deer_tail
	savefile_key = "feature_deer_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_DEER
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/deer_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/deer_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == DEER)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/deer_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/deer_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == DEER)
		target.dna.features[FEATURE_TAIL_DEER] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/deer_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Fish
/datum/preference/choiced/species_feature/fish_tail
	savefile_key = "feature_fish_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_FISH
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/fish_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/fish_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == FISH)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/fish_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/fish_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == FISH)
		target.dna.features[FEATURE_TAIL_FISH] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/fish_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Bug
/datum/preference/choiced/species_feature/bug_tail
	savefile_key = "feature_bug_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_BUG
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bug_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/bug_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == BUG)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bug_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bug_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == BUG)
		target.dna.features[FEATURE_TAIL_BUG] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/bug_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Synth
/datum/preference/choiced/species_feature/synth_tail
	savefile_key = "feature_synth_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_CYBERNETIC
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/synth_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/synth_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == CYBERNETIC)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/synth_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/synth_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == CYBERNETIC)
		target.dna.features[FEATURE_TAIL_CYBERNETIC] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/synth_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Humanoid
/datum/preference/choiced/species_feature/humanoid_tail
	savefile_key = "feature_humanoid_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_HUMANOID
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/humanoid_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/humanoid_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == HUMANOID)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/humanoid_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/humanoid_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == HUMANOID)
		target.dna.features[FEATURE_TAIL_HUMANOID] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/humanoid_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

//	Alien
/datum/preference/choiced/species_feature/alien_tail
	savefile_key = "feature_alien_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_ALIEN
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/alien_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/alien_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == ALIEN)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/alien_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/alien_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == ALIEN)
		target.dna.features[FEATURE_TAIL_ALIEN] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value

/datum/preference/choiced/species_feature/alien_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

// Teshari
/datum/preference/choiced/species_feature/teshari_tail
	savefile_key = "feature_teshari_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Tail"
	feature_key = FEATURE_TAIL_TESHARI
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/teshari_tail/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)

	if (!species_can_access_mutant_customization(species))
		return FALSE

	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/tail_variation)
	if(chosen_variation == TESHARI)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/teshari_tail/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/teshari_tail/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/teshari_tail/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.tail_type == TESHARI)
		target.dna.features[FEATURE_TAIL_TESHARI] = value
		target.dna.features[FEATURE_TAIL_OTHER] = value
		target.regenerate_organs()

/datum/preference/choiced/species_feature/teshari_tail/icon_for(value)
	var/datum/sprite_accessory/chosen_tail = get_accessory_for_value(value)
	return generate_back_icon(chosen_tail, "tail")

/// Proc to gen that icon
//	We don't wanna copy paste this
/datum/preference/choiced/species_feature/proc/generate_back_icon(datum/sprite_accessory/sprite_accessory, key)
	var/static/datum/universal_icon/body
	if (isnull(body))
		body = uni_icon('icons/mob/human/human.dmi', "human_basic", NORTH)
	var/datum/universal_icon/final_icon = body.copy()

	if(sprite_accessory.icon_state != "none")
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_RED, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND_2", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND_2", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND_3", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_BEHIND_3", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_BLUE, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		// adjacent breaker
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_RED, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ_2", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ_2", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ_3", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ_3", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_BLUE, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		// front breaker
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_RED, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT_2", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT_2", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT_3", NORTH))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_FRONT_3", NORTH)
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_BLUE, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	final_icon.crop(0, 0, 32, 32)
	final_icon.scale(32, 32)

	return final_icon

/// Overwrite lives here
//	This is for the triple color channel
/datum/bodypart_overlay/mutant/tail
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	feature_key_sprite = "tail"

/datum/bodypart_overlay/mutant/tail/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	if((sprite_datum.color_src == USE_ONE_COLOR) && length(limb.owner?.dna.features[FEATURE_TAIL_COLORS]))
		draw_color = limb.owner?.dna.features[FEATURE_TAIL_COLORS][1]
	else
		draw_color = limb.owner?.dna.features[FEATURE_TAIL_COLORS]
	return ..()
