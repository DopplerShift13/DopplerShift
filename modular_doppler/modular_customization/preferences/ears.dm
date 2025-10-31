/// SSAccessories setup
/datum/controller/subsystem/accessories
	var/list/ears_list_lizard
	var/list/ears_list_dog
	var/list/ears_list_fox
	var/list/ears_list_bunny
	var/list/ears_list_mouse
	var/list/ears_list_bird
	var/list/ears_list_monkey
	var/list/ears_list_deer
	var/list/ears_list_fish
	var/list/ears_list_bug
	var/list/ears_list_humanoid
	var/list/ears_list_synthetic
	var/list/ears_list_alien
	var/list/ears_list_teshari

/datum/controller/subsystem/accessories/setup_lists()
	. = ..()
	ears_list_lizard = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/lizard)["default_sprites"] // FLAKY DEFINE: this should be using DEFAULT_SPRITE_LIST
	ears_list_dog = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/dog)["default_sprites"]
	ears_list_fox = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/fox)["default_sprites"]
	ears_list_bunny = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/bunny)["default_sprites"]
	ears_list_mouse = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/mouse)["default_sprites"]
	ears_list_bird = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/bird)["default_sprites"]
	ears_list_monkey = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/monkey)["default_sprites"]
	ears_list_deer = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/deer)["default_sprites"]
	ears_list_fish = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/fish)["default_sprites"]
	ears_list_bug = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/bug)["default_sprites"]
	ears_list_humanoid = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/humanoid)["default_sprites"]
	ears_list_synthetic = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/cybernetic)["default_sprites"]
	ears_list_alien = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/alien)["default_sprites"]
	ears_list_teshari = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears_more/teshari)["default_sprites"]

/datum/dna
	///	This variable is read by the regenerate_organs() proc to know what organ subtype to give
	var/ear_type = NO_VARIATION

/datum/species/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	if(target.dna.features[FEATURE_EARS] && can_regenerate_mutant_feature(FEATURE_EARS))
		if(target.dna.ear_type == NO_VARIATION)
			return .
		else if(target.dna.features[FEATURE_EARS] != /datum/sprite_accessory/ears/none::name && target.dna.features[FEATURE_EARS] != /datum/sprite_accessory/blank::name)
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
		target.dna.features[FEATURE_EARS] = /datum/sprite_accessory/ears/none::name

/datum/preference/choiced/ear_variation/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	return species_can_access_mutant_customization(species)

///	All current ear types to choose from
//	Cat
/datum/preference/choiced/felinid_ears
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/felinid_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE

	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == CAT)
		return TRUE
	return FALSE

/datum/preference/choiced/felinid_ears/create_default_value()
	return /datum/sprite_accessory/ears/none::name

/datum/preference/choiced/felinid_ears/apply_to_human(mob/living/carbon/human/target, value)
	..()
	if(target.dna.ear_type == CAT)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/felinid_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list[value]
	return generate_ears_icon(chosen_ears)

//	Lizard
/datum/preference/choiced/lizard_ears
	savefile_key = "feature_lizard_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/lizard_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_lizard)

/datum/preference/choiced/lizard_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == LIZARD)
		return TRUE
	return FALSE

/datum/preference/choiced/lizard_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/lizard/none::name

/datum/preference/choiced/lizard_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == LIZARD)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/lizard_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_lizard[value]
	return generate_ears_icon(chosen_ears)

//	Fox
/datum/preference/choiced/fox_ears
	savefile_key = "feature_fox_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/fox_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_fox)

/datum/preference/choiced/fox_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == FOX)
		return TRUE
	return FALSE

/datum/preference/choiced/fox_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/fox/none::name

/datum/preference/choiced/fox_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == FOX)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/fox_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_fox[value]
	return generate_ears_icon(chosen_ears)

//	Dog
/datum/preference/choiced/dog_ears
	savefile_key = "feature_dog_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/dog_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_dog)

/datum/preference/choiced/dog_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == DOG)
		return TRUE
	return FALSE

/datum/preference/choiced/dog_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/dog/none::name

/datum/preference/choiced/dog_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == DOG)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/dog_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_dog[value]
	return generate_ears_icon(chosen_ears)

//	Bunny
/datum/preference/choiced/bunny_ears
	savefile_key = "feature_bunny_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/bunny_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_bunny)

/datum/preference/choiced/bunny_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BUNNY)
		return TRUE
	return FALSE

/datum/preference/choiced/bunny_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/bunny/none::name

/datum/preference/choiced/bunny_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BUNNY)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/bunny_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_bunny[value]
	return generate_ears_icon(chosen_ears)

//	Bird
/datum/preference/choiced/bird_ears
	savefile_key = "feature_bird_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/bird_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_bird)

/datum/preference/choiced/bird_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BIRD)
		return TRUE
	return FALSE

/datum/preference/choiced/bird_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/bird/none::name

/datum/preference/choiced/bird_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BIRD)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/bird_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_bird[value]
	return generate_ears_icon(chosen_ears)

//	Mouse
/datum/preference/choiced/mouse_ears
	savefile_key = "feature_mouse_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/mouse_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_mouse)

/datum/preference/choiced/mouse_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == MOUSE)
		return TRUE
	return FALSE

/datum/preference/choiced/mouse_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/mouse/none::name

/datum/preference/choiced/mouse_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == MOUSE)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/mouse_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_mouse[value]
	return generate_ears_icon(chosen_ears)

//	Monkey
/datum/preference/choiced/monkey_ears
	savefile_key = "feature_monkey_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/monkey_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_monkey)

/datum/preference/choiced/monkey_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == MONKEY)
		return TRUE
	return FALSE

/datum/preference/choiced/monkey_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/monkey/none::name

/datum/preference/choiced/monkey_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == MONKEY)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/monkey_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_monkey[value]
	return generate_ears_icon(chosen_ears)

//	Deer
/datum/preference/choiced/deer_ears
	savefile_key = "feature_deer_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/deer_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_deer)

/datum/preference/choiced/deer_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == DEER)
		return TRUE
	return FALSE

/datum/preference/choiced/deer_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/deer/none::name

/datum/preference/choiced/deer_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == DEER)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/deer_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_deer[value]
	return generate_ears_icon(chosen_ears)

//	Fish
/datum/preference/choiced/fish_ears
	savefile_key = "feature_fish_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/fish_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_fish)

/datum/preference/choiced/fish_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == FISH)
		return TRUE
	return FALSE

/datum/preference/choiced/fish_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/fish/none::name

/datum/preference/choiced/fish_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == FISH)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/fish_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_fish[value]
	return generate_ears_icon(chosen_ears)

//	Bug
/datum/preference/choiced/bug_ears
	savefile_key = "feature_bug_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/bug_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_bug)

/datum/preference/choiced/bug_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == BUG)
		return TRUE
	return FALSE

/datum/preference/choiced/bug_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/bug/none::name

/datum/preference/choiced/bug_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == BUG)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/bug_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_bug[value]
	return generate_ears_icon(chosen_ears)

//	Humanoid
/datum/preference/choiced/humanoid_ears
	savefile_key = "feature_humanoid_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/humanoid_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_humanoid)

/datum/preference/choiced/humanoid_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == HUMANOID)
		return TRUE
	return FALSE

/datum/preference/choiced/humanoid_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/humanoid/none::name

/datum/preference/choiced/humanoid_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == HUMANOID)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/humanoid_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_humanoid[value]
	return generate_ears_icon(chosen_ears)

//	Cybernetic
/datum/preference/choiced/synthetic_ears
	savefile_key = "feature_synth_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/synthetic_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_synthetic)

/datum/preference/choiced/synthetic_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == CYBERNETIC)
		return TRUE
	return FALSE

/datum/preference/choiced/synthetic_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/cybernetic/none::name

/datum/preference/choiced/synthetic_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == CYBERNETIC)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/synthetic_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_synthetic[value]
	return generate_ears_icon(chosen_ears)

//	Alien
/datum/preference/choiced/alien_ears
	savefile_key = "feature_alien_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"

/datum/preference/choiced/alien_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_alien)

/datum/preference/choiced/alien_ears/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!species_can_access_mutant_customization(species))
		return FALSE
	var/chosen_variation = preferences.read_preference(/datum/preference/choiced/ear_variation)
	if(chosen_variation == ALIEN)
		return TRUE
	return FALSE

/datum/preference/choiced/alien_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/alien/none::name

/datum/preference/choiced/alien_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == ALIEN)
		target.dna.features[FEATURE_EARS] = value

/datum/preference/choiced/alien_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_alien[value]
	return generate_ears_icon(chosen_ears)

// Teshari
// Only available to teshari, and their only choice, because of how they work on sprites
/datum/preference/choiced/teshari_ears
	savefile_key = "feature_teshari_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CLOTHING
	relevant_external_organ = null
	should_generate_icons = TRUE
	main_feature_name = "Ears"
	priority = PREFERENCE_PRIORITY_SPECIES + 0.1

/datum/preference/choiced/teshari_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ears_list_teshari)

/datum/preference/choiced/teshari_ears/is_accessible(datum/preferences/preferences)
	. = ..()

	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if (!ispath(species, /datum/species/teshari))
		return FALSE

	return TRUE

/datum/preference/choiced/teshari_ears/species_can_access_mutant_customization(species_typepath)
	if (ispath(species_typepath, /datum/species/teshari))
		return TRUE
	return ..()

/datum/preference/choiced/teshari_ears/create_default_value()
	return /datum/sprite_accessory/ears_more/teshari/none::name

/datum/preference/choiced/teshari_ears/apply_to_human(mob/living/carbon/human/target, value)
	if(target.dna.ear_type == TESHARI)
		target.dna.features[FEATURE_EARS] = value
		target.regenerate_organs()

/datum/preference/choiced/teshari_ears/icon_for(value)
	var/datum/sprite_accessory/chosen_ears = SSaccessories.ears_list_teshari[value]
	return generate_ears_icon(chosen_ears)

GLOBAL_VAR(generic_uni_icon_ears)
GLOBAL_VAR(generic_uni_icon_ears_tesh)

/datum/preference/choiced/proc/gen_uni_icon_ears()
	var/icon = uni_icon('icons/mob/human/bodyparts_greyscale.dmi', "human_head_f")
	GLOB.generic_uni_icon_ears = icon
	return icon

/datum/preference/choiced/teshari_ears/gen_uni_icon_ears()
	var/icon = uni_icon('modular_doppler/modular_species/species_types/teshari/icons/teshari_parts_greyscale.dmi', "teshari_head_f")
	GLOB.generic_uni_icon_ears_tesh = icon
	return icon

/datum/preference/choiced/proc/get_uni_icon_ears_cached()
	RETURN_TYPE(/datum/universal_icon)

	return GLOB.generic_uni_icon_ears

/datum/preference/choiced/teshari_ears/get_uni_icon_ears_cached()
	return GLOB.generic_uni_icon_ears_tesh

/// Proc to gen that icon
//	We don't wanna copy paste this
/datum/preference/choiced/proc/generate_ears_icon(datum/sprite_accessory/sprite_accessory)
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

/datum/preference/choiced/proc/shift_ears_icon(var/datum/universal_icon/icon)
	return

/datum/preference/choiced/teshari_ears/shift_ears_icon(var/datum/universal_icon/icon)
	icon.shift(NORTH, 5)

/// Overwrite lives here
//	This is for the triple color channel
/datum/bodypart_overlay/mutant/ears
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT | EXTERNAL_BEHIND
	feature_key = FEATURE_EARS
	feature_key_sprite = FEATURE_EARS

/datum/bodypart_overlay/mutant/ears/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	draw_color = limb.owner?.dna.features[FEATURE_EARS_COLORS]
	return ..()
