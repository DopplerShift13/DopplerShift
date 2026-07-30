/datum/dna
	///	This variable is read by the regenerate_organs() proc to know what organ subtype to give
	var/ear_type = NO_VARIATION

/datum/species/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	if(target.dna.features[FEATURE_EARS] && can_regenerate_mutant_feature(FEATURE_EARS))
		if(target.dna.ear_type == NO_VARIATION)
			return .
		else if(target.dna.features[FEATURE_EARS] != /datum/sprite_accessory/blank::name)
			var/obj/item/organ/organ_path = text2path("/obj/item/organ/ears/[target.dna.ear_type]")
			var/obj/item/organ/replacement = SSwardrobe.provide_type(organ_path)
			replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
			return .

/// Dropdown to select which ears you'll be rocking
/datum/preference/choiced/ear_variation
	savefile_key = "ear_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/ear_variation/create_default_value()
	return NO_VARIATION

/datum/preference/choiced/ear_variation/init_possible_values()
	return list(NO_VARIATION) + (GLOB.mutant_variations)

/datum/preference/choiced/ear_variation/apply_to_human(mob/living/carbon/human/target, chosen_variation)
	target.dna.ear_type = chosen_variation
	if(chosen_variation == NO_VARIATION)
		target.dna.features[FEATURE_EARS] = /datum/sprite_accessory/blank::name

/datum/preference/choiced/ear_variation/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	return species_can_access_mutant_customization(species)

///	All current ear types to choose from
//	Cat
/datum/preference/choiced/species_feature/felinid_ears
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/felinid_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE

	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == CAT)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/felinid_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/felinid_ears/apply_to_human(mob/living/carbon/human/target, value)
	..()
	if(target.dna.ear_type == CAT)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/felinid_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Lizard
/datum/preference/choiced/species_feature/lizard_ears
	savefile_key = "feature_lizard_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_LIZARD
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/lizard_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == LIZARD)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/lizard_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/lizard_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == LIZARD)
		target.dna.features[FEATURE_EARS_LIZARD] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/lizard_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Fox
/datum/preference/choiced/species_feature/fox_ears
	savefile_key = "feature_fox_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_FOX
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/fox_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == FOX)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/fox_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/fox_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == FOX)
		target.dna.features[FEATURE_EARS_FOX] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/fox_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Dog
/datum/preference/choiced/species_feature/dog_ears
	savefile_key = "feature_dog_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_DOG
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/dog_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == DOG)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/dog_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/dog_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == DOG)
		target.dna.features[FEATURE_EARS_DOG] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/dog_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Bunny
/datum/preference/choiced/species_feature/bunny_ears
	savefile_key = "feature_bunny_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_BUNNY
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bunny_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BUNNY)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bunny_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bunny_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BUNNY)
		target.dna.features[FEATURE_EARS_BUNNY] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/bunny_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Bird
/datum/preference/choiced/species_feature/bird_ears
	savefile_key = "feature_bird_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_BIRD
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bird_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BIRD)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bird_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bird_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BIRD)
		target.dna.features[FEATURE_EARS_BIRD] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/bird_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Mouse
/datum/preference/choiced/species_feature/mouse_ears
	savefile_key = "feature_mouse_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_MOUSE
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/mouse_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == MOUSE)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/mouse_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/mouse_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == MOUSE)
		target.dna.features[FEATURE_EARS_MOUSE] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/mouse_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Monkey
/datum/preference/choiced/species_feature/monkey_ears
	savefile_key = "feature_monkey_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_MONKEY
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/monkey_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == MONKEY)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/monkey_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/monkey_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == MONKEY)
		target.dna.features[FEATURE_EARS_MONKEY] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/monkey_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Deer
/datum/preference/choiced/species_feature/deer_ears
	savefile_key = "feature_deer_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_DEER
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/deer_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == DEER)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/deer_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/deer_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == DEER)
		target.dna.features[FEATURE_EARS_DEER] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/deer_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Fish
/datum/preference/choiced/species_feature/fish_ears
	savefile_key = "feature_fish_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_FISH
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/fish_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == FISH)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/fish_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/fish_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == FISH)
		target.dna.features[FEATURE_EARS_FISH] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/fish_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Bug
/datum/preference/choiced/species_feature/bug_ears
	savefile_key = "feature_bug_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_BUG
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/bug_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BUG)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/bug_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/bug_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BUG)
		target.dna.features[FEATURE_EARS_BUG] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/bug_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Humanoid
/datum/preference/choiced/species_feature/humanoid_ears
	savefile_key = "feature_humanoid_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_HUMANOID
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/humanoid_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == HUMANOID)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/humanoid_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/humanoid_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == HUMANOID)
		target.dna.features[FEATURE_EARS_HUMANOID] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/humanoid_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Cybernetic
/datum/preference/choiced/species_feature/synthetic_ears
	savefile_key = "feature_synth_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_CYBERNETIC
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/synthetic_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == CYBERNETIC)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/synthetic_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/synthetic_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == CYBERNETIC)
		target.dna.features[FEATURE_EARS_CYBERNETIC] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/synthetic_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

//	Alien
/datum/preference/choiced/species_feature/alien_ears
	savefile_key = "feature_alien_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	feature_key = FEATURE_EARS_ALIEN
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species_feature/alien_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == ALIEN)
		return TRUE
	return FALSE

/datum/preference/choiced/species_feature/alien_ears/create_default_value()
	return /datum/sprite_accessory/blank::name

/datum/preference/choiced/species_feature/alien_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == ALIEN)
		target.dna.features[FEATURE_EARS_ALIEN] = value
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/species_feature/alien_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

// Teshari
// Only available to teshari, and their only choice, because of how they work on sprites
/datum/preference/choiced/species_feature/teshari_ears
	savefile_key = "feature_teshari_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	priority = PREFERENCE_PRIORITY_BODYPARTS
	feature_key = FEATURE_EARS_TESHARI

/datum/preference/choiced/species_feature/teshari_ears/is_accessible(datum/preferences/preferences)
	. = ..()

	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!ispath(species, /datum/species/teshari))
		return FALSE

	return TRUE

/datum/preference/choiced/species_feature/teshari_ears/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/species_feature/teshari_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/teshari/regular::name

/datum/preference/choiced/species_feature/teshari_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == TESHARI)
		target.dna.features[FEATURE_EARS_TESHARI] = value
		target.dna.features[FEATURE_EARS] = value
		target.regenerate_organs()

/datum/preference/choiced/species_feature/teshari_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = get_accessory_for_value(value)
	return generate_ears_icon(chosen_ears)

GLOBAL_VAR(generic_uni_icon_ears)
GLOBAL_VAR(generic_uni_icon_ears_tesh)

/datum/preference/choiced/species_feature/proc/gen_uni_icon_ears()
	var/icon = uni_icon('icons/mob/human/bodyparts_greyscale.dmi', "human_head_f")
	GLOB.generic_uni_icon_ears = icon
	return icon

/datum/preference/choiced/species_feature/teshari_ears/gen_uni_icon_ears()
	var/icon = uni_icon('modular_doppler/modular_species/species_types/teshari/icons/teshari_parts_greyscale.dmi', "teshari_head_f")
	GLOB.generic_uni_icon_ears_tesh = icon
	return icon

/datum/preference/choiced/species_feature/proc/get_uni_icon_ears_cached()
	RETURN_TYPE(/datum/universal_icon)

	return GLOB.generic_uni_icon_ears

/datum/preference/choiced/species_feature/teshari_ears/get_uni_icon_ears_cached()
	return GLOB.generic_uni_icon_ears_tesh

/// Proc to gen that icon
//	We don't wanna copy paste this
/datum/preference/choiced/species_feature/proc/generate_ears_icon(datum/sprite_accessory/sprite_accessory)
	var/datum/universal_icon/body = get_uni_icon_ears_cached()
	if (isnull(body))
		body = gen_uni_icon_ears()
	var/datum/universal_icon/final_icon = body.copy()

	if(sprite_accessory.icon_state != "none")
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_RED, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ_2"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ_2")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ_3"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_ADJ_3")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_BLUE, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		// front breaker
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_RED, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT_2"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT_2")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT_3"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_ears_[sprite_accessory.icon_state]_FRONT_3")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_BLUE, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	shift_ears_icon(final_icon)
	final_icon.crop(11, 20, 23, 32)
	final_icon.scale(32, 32)

	return final_icon

/datum/preference/choiced/species_feature/proc/shift_ears_icon(var/datum/universal_icon/icon)
	return

/datum/preference/choiced/species_feature/teshari_ears/shift_ears_icon(var/datum/universal_icon/icon)
	icon.shift(NORTH, 5)

/// Overwrite lives here
//	This is for the triple color channel
/datum/bodypart_overlay/mutant/ears
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT | EXTERNAL_BEHIND
	feature_key = FEATURE_EARS
	feature_key_sprite = FEATURE_EARS
	special_feature_key = FEATURE_EARS

/datum/bodypart_overlay/mutant/ears/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	draw_color = limb.owner?.dna.features[FEATURE_EARS_COLORS]
	return ..()
