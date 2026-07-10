
/**
 * The curse that once haunted this land is no more.
 * Handles most TGUI interactions, send largely constant data (except for Augmented, snowflake mechanics.) and handles a few of the powers handoffs.
 */

/datum/preference_middleware/powers
	action_delegations = list(
		"give_power" = PROC_REF(give_power),
		"remove_power" = PROC_REF(remove_power),
		"set_augment_arm" = PROC_REF(set_augment_arm),
	)

/datum/preference_middleware/powers/post_set_preference(mob/user, preference, value)
	preferences.sanitize_powers()

/datum/preference_middleware/powers/get_constant_data()
	var/list/data = list()
	var/list/power_paths = build_empty_power_path_map()

	// Iterates all powers and build the power entries for all of them.
	for(var/power_name in SSpowers.powers)
		var/datum/power/power_type = SSpowers.powers[power_name]
		var/path_key = get_power_path_key(power_type.path)
		if(!path_key)
			continue

		power_paths[path_key] += list(build_power_constant_entry(power_type))

	data["power_paths"] = power_paths
	data["total_power_points"] = MAXIMUM_POWER_POINTS
	return data

/datum/preference_middleware/powers/get_ui_data(mob/user)
	var/list/data = list()
	var/list/power_state_paths = build_empty_power_path_map()

	var/current_points = 0
	for(var/power_name in preferences.all_powers)
		var/datum/power/power_type = SSpowers.powers[power_name]
		if(!ispath(power_type)) // Something is here that shouldn't be here.
			preferences.nuke_powers_prefs("Invalid power entry detected while building powers UI: [power_name]")
			return data
		current_points += power_type.value

	var/datum/species/mob_species = preferences.read_preference(/datum/preference/choiced/species)

	for(var/power_name in SSpowers.powers)
		var/datum/power/power_type = SSpowers.powers[power_name]

		var/has_given_power = (power_name in preferences.all_powers)
		var/species_allowed = is_species_appropriate(power_type, mob_species)

		// TODO: GRAY OUT powers you:
		// Don't have the requirements for.
		// Have powers building upon.
		// Have an incompatible power for.
		// ^ must touch tgui to set a new state/colour for this shit

		var/locked_in = FALSE
		if(has_given_power)
			if(get_requiring_power(power_type))
				locked_in = TRUE
		else
			if(!species_allowed || get_incompatible_power(power_type) || length(get_required_power(power_type)) || would_exceed_path_limit(power_type))
				locked_in = TRUE

		var/state
		if(has_given_power)
			state = "bad"
		else if(locked_in || ((power_type.value + current_points) > MAXIMUM_POWER_POINTS))
			state = "transparent"
		else
			state = "good"

		var/final_list = list(list(
				"name" = power_type.name,
				"has_power" = has_given_power,
				"state" = state,
				"augment" = build_power_runtime_augment_info(power_type, preferences),
			))

		var/path_key = get_power_path_key(power_type.path)
		if(path_key)
			power_state_paths[path_key] += final_list

	data["power_state_paths"] = power_state_paths
	data["power_points"] = current_points

	return data

/// Builds a map of all currently available power paths.
/datum/preference_middleware/powers/proc/build_empty_power_path_map()
	return list(
		"thaumaturge" = list(),
		"enigmatist" = list(),
		"theologist" = list(),
		"psyker" = list(),
		"cultivator" = list(),
		"aberrant" = list(),
		"imbued" = list(),
		"warfighter" = list(),
		"expert" = list(),
		"augmented" = list(),
		"irregular" = list(),
	)

/// Gets the relevant key for the power path baesd on the given deifne.
/datum/preference_middleware/powers/proc/get_power_path_key(power_path)
	switch(power_path)
		if(POWER_PATH_THAUMATURGE)
			return "thaumaturge"
		if(POWER_PATH_ENIGMATIST)
			return "enigmatist"
		if(POWER_PATH_THEOLOGIST)
			return "theologist"
		if(POWER_PATH_PSYKER)
			return "psyker"
		if(POWER_PATH_CULTIVATOR)
			return "cultivator"
		if(POWER_PATH_ABERRANT)
			return "aberrant"
		if(POWER_PATH_IMBUED)
			return "imbued"
		if(POWER_PATH_WARFIGHTER)
			return "warfighter"
		if(POWER_PATH_EXPERT)
			return "expert"
		if(POWER_PATH_AUGMENTED)
			return "augmented"
		if(POWER_PATH_IRREGULAR)
			return "irregular"
	return null

/// Here for now as the sole and only exception. Irregular is the only one that gets to bypass path limit: you need VERY GOOD excuses to allow powers to do so, since it muddies up path choices.
/// Irregular also has niche-only powers to counteract that.
/datum/preference_middleware/powers/proc/is_path_limit_exempt(datum/power/power_type)
	return power_type.path == POWER_PATH_IRREGULAR

/// Builds a constant entry for powers to be referenced at later points.
/datum/preference_middleware/powers/proc/build_power_constant_entry(datum/power/power_type)
	var/powertype
	var/rootpower = null

	if(power_type.priority == POWER_PRIORITY_ROOT)
		powertype = "crown"
	else
		powertype = ""
		rootpower = power_type.archetype

	var/datum/power_constant_data/constant_data = GLOB.all_power_constant_data[power_type]
	var/list/customization_options = constant_data?.get_customization_data()
	var/action_icon = null
	var/action_icon_state = null

	// Sets the icon to be the menu icon.
	if(power_type.menu_icon)
		action_icon = "[power_type.menu_icon]"
	if(power_type.menu_icon_state)
		action_icon_state = "[power_type.menu_icon_state]"

	// If there is no menu icon set, falls back to action path icons.
	if((isnull(action_icon) || isnull(action_icon_state)) && power_type.action_path)
		var/initial_action_icon = initial(power_type.action_path.button_icon)
		var/initial_action_icon_state = initial(power_type.action_path.button_icon_state)
		if(isnull(action_icon) && initial_action_icon)
			action_icon = "[initial_action_icon]"
		if(isnull(action_icon_state) && initial_action_icon_state)
			action_icon_state = "[initial_action_icon_state]"

	// If it is augmented and ther eis no icon, fall back to yoinking the icons from the attached augment.
	if((isnull(action_icon) || isnull(action_icon_state)) && ispath(power_type, /datum/power/augmented))
		var/datum/power/augmented/augmented_power_type = power_type
		var/obj/item/organ/augment_path = initial(augmented_power_type.augment)
		if(augment_path)
			var/initial_augment_icon = initial(augment_path.icon)
			var/initial_augment_icon_state = initial(augment_path.icon_state)
			if(isnull(action_icon) && initial_augment_icon)
				action_icon = "[initial_augment_icon]"
			if(isnull(action_icon_state) && initial_augment_icon_state)
				action_icon_state = "[initial_augment_icon_state]"

	return list(
		"description" = power_type.desc,
		"name" = power_type.name,
		"cost" = power_type.value,
		"magic_flags" = build_power_magic_flags(power_type),
		"powertype" = powertype,
		"rootpower" = rootpower,
		"required_powers" = get_required_power_names(power_type),
		"required_allow_any" = power_type.required_allow_any,
		"required_allow_subtypes" = power_type.required_allow_subtypes,
		"action_icon" = action_icon,
		"action_icon_state" = action_icon_state,
		"augment" = build_power_constant_augment_info(power_type),
		"customizable" = constant_data?.is_customizable(),
		"customization_options" = customization_options,
	)

/// Builds the list of anti-magic interaction tags the UI should show for a power.
/datum/preference_middleware/powers/proc/build_power_magic_flags(datum/power/power_type)
	var/power_magic_flags = initial(power_type.magic_flags)
	var/list/final_magic_flags = list()
	if(power_magic_flags & POWER_MAGIC_UNHOLY)
		final_magic_flags += "unholy"
	if(power_magic_flags & POWER_MAGIC_MENTAL)
		final_magic_flags += "mental"
	if(power_magic_flags & POWER_MAGIC_SCRYING)
		final_magic_flags += "scrying"
	if(power_magic_flags & POWER_MAGIC_STANDARD)
		final_magic_flags += "magical"
	return final_magic_flags

/// Gets the name of any power that requires another.
/datum/preference_middleware/powers/proc/get_required_power_names(datum/power/power_type)
	var/list/required_power_types = GLOB.powers_requirements_list[power_type]
	var/list/required_power_names = list()
	if(length(required_power_types))
		for(var/datum/power/required_power_type as anything in required_power_types)
			var/required_power_name = required_power_type.name
			if(length(required_power_name) >= 9 && lowertext(copytext(required_power_name, 1, 10)) == "abstract ")
				required_power_name = copytext(required_power_name, 10)
			required_power_names += required_power_name
	return required_power_names

/// Builds the constant augment info specifically for augments and their ANNOYING ARM SNOWFLAKING.
/datum/preference_middleware/powers/proc/build_power_constant_augment_info(datum/power/power_type)
	if(ispath(power_type, /datum/power/augmented))
		var/datum/power/augmented/power_instance = new power_type
		var/augment_location = power_instance.get_augment_location_label()
		var/is_arm_augment = (augment_location == "Arms")
		qdel(power_instance)
		return list(
			"location" = augment_location,
			"is_arm" = is_arm_augment,
		)
	return null

/// Snowflake proc to allow Augments to have their own selectable arm section in the UI.
/datum/preference_middleware/powers/proc/build_power_runtime_augment_info(
	datum/power/power_type,
	datum/preferences/preferences
)
	// Snowflake code for Augments: expose only runtime arm assignment state.
	var/augment_assignment
	var/arm_left_blocked
	var/arm_right_blocked
	if(ispath(power_type, /datum/power/augmented))
		var/datum/power/augmented/power_instance = new power_type
		var/augment_location = power_instance.get_augment_location_label()
		var/is_arm_augment = (augment_location == "Arms")
		qdel(power_instance)
		if(is_arm_augment)
			var/augment_left = preferences.read_preference(/datum/preference/choiced/augment_left)
			var/augment_right = preferences.read_preference(/datum/preference/choiced/augment_right)
			arm_left_blocked = (augment_left && augment_left != AUGMENTED_NO_AUGMENT && augment_left != power_type.name)
			arm_right_blocked = (augment_right && augment_right != AUGMENTED_NO_AUGMENT && augment_right != power_type.name)
			if(augment_left == power_type.name && augment_right == power_type.name)
				augment_assignment = "Both"
			else if(augment_left == power_type.name)
				augment_assignment = "Left"
			else if(augment_right == power_type.name)
				augment_assignment = "Right"
		return list(
			"assignment" = augment_assignment,
			"left_blocked" = arm_left_blocked,
			"right_blocked" = arm_right_blocked,
		)
	return null

/**
 * Gives a power to a character using the params list provided by tgui.
 * Runs through multiple checks to ensure that the power can be learned.
 */
/datum/preference_middleware/powers/proc/give_power(list/params, mob/user)
	var/power_name = params["power_name"]
	var/datum/power/power_type = SSpowers.powers[power_name]
	if(isnull(preferences.all_powers))
		preferences.all_powers = list()

	if(isnull(power_type))
		return FALSE // Not a power.

	if(power_name in preferences.all_powers)
		return FALSE // Already have this power.

	// Cehcks against the species blacklist.
	var/datum/species/mob_species = preferences.read_preference(/datum/preference/choiced/species)
	if(!is_species_appropriate(power_type, mob_species))
		to_chat(user, span_boldwarning("[power_name] is not available to your species!"))
		return FALSE

	// Make sure we don't exceed 2 distinct paths.
	if(length(preferences.all_powers) && !is_path_limit_exempt(power_type))
		var/list/unique_paths = list()
		// Collect the distinct paths the player already has
		for(var/power_key in preferences.all_powers)
			var/datum/power/existing_power = SSpowers.powers[power_key]
			if(!existing_power)
				continue
			if(is_path_limit_exempt(existing_power))
				continue
			unique_paths[existing_power.path] = TRUE
		// If the new power's path isn't already present, it would add a new path
		if(!(power_type.path in unique_paths) && length(unique_paths) >= 2)
			to_chat(user, span_boldwarning("You can only have powers from two paths!"))
			return FALSE

	// Make sure we have the required powers.
	var/list/missing_required_powers = get_required_power(power_type)
	if(length(missing_required_powers))
		var/list/required_names = list()
		for(var/datum/power/required_option as anything in missing_required_powers)
			required_names += required_option.name
		if(power_type.required_allow_any)
			to_chat(user, span_boldwarning("[power_name] requires any of: [english_list(required_names)]!"))
		else
			to_chat(user, span_boldwarning("[power_name] requires: [english_list(required_names)]!"))
		return FALSE

	// Make sure we don't select an incompatible power.
	var/datum/power/incompatible_power_type = get_incompatible_power(power_type)
	if(incompatible_power_type)
		to_chat(user, span_boldwarning("[power_name] is incompatible with [incompatible_power_type.name]!"))
		return FALSE

	// Make sure we don't go over our point cap.
	var/point_balance = power_type.value
	for(var/existing_power_name in preferences.all_powers)
		var/datum/power/existing_power_type = SSpowers.powers[existing_power_name]
		point_balance += existing_power_type.value
	if(point_balance > MAXIMUM_POWER_POINTS)
		to_chat(user, span_boldwarning("[power_name] costs too much!"))
		return FALSE

	// Augmented specific validation.
	if(!validate_augment(power_type, power_name, user))
		return FALSE

	preferences.all_powers += power_name
	return TRUE

/// If a power is able to be selected for the mob's species.
/datum/preference_middleware/powers/proc/is_species_appropriate(datum/power/power_type, datum/species/mob_species)
	if(isnull(mob_species))
		return TRUE
	// Gets the power from the power_species_restriction global list if its in there.
	var/list/species_restrictions = GLOB.powers_species_restrictions[power_type]
	if(!islist(species_restrictions)) // not in there? cool skip this step.
		return TRUE
	var/list/species_blacklist = species_restrictions["list"]
	var/is_whitelist = species_restrictions["whitelist"]
	if(!islist(species_blacklist) || !species_blacklist.len)
		return TRUE
	var/is_listed = (mob_species in species_blacklist)
	// whitelist inverts
	if(is_whitelist)
		return is_listed
	// if its in there, yes/no.
	return !is_listed

/// A lot of validation specifically for augmented, given they're very snowflakey in their restrictions.
/datum/preference_middleware/powers/proc/validate_augment(datum/power/power_type, power_name, mob/user)
	if(!ispath(power_type, /datum/power/augmented))
		return TRUE

	var/datum/power/augmented/power_instance = new power_type
	var/augment_location = power_instance.get_augment_location_label()
	qdel(power_instance)
	if(augment_location == "Arms") // Arm augment validation + auto-assign missing arm.
		var/augment_left = preferences.read_preference(/datum/preference/choiced/augment_left)
		var/augment_right = preferences.read_preference(/datum/preference/choiced/augment_right)
		var/left_taken = (augment_left && augment_left != AUGMENTED_NO_AUGMENT && augment_left != power_name)
		var/right_taken = (augment_right && augment_right != AUGMENTED_NO_AUGMENT && augment_right != power_name)
		if(left_taken && right_taken)
			to_chat(user, span_boldwarning("Both arms already have augments assigned."))
			return FALSE
		if(!right_taken)
			to_chat(user, span_notice("[power_name] will be assigned to your right arm."))
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], power_name)
		else if(!left_taken)
			to_chat(user, span_notice("[power_name] will be assigned to your left arm."))
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], power_name)
	else // Non-arm validation; just goes off of slots and looks if there's any others.
		var/obj/item/organ/new_augment_path = initial(power_instance.augment)
		if(new_augment_path)
			var/new_slot = initial(new_augment_path.slot)
			for(var/existing_power_name in preferences.all_powers)
				var/datum/power/augmented/existing_power_type = SSpowers.powers[existing_power_name]
				if(!ispath(existing_power_type, /datum/power/augmented))
					continue
				var/obj/item/organ/existing_augment_path = initial(existing_power_type.augment)
				if(!existing_augment_path)
					continue
				var/existing_slot = initial(existing_augment_path.slot)
				if(existing_slot && existing_slot == new_slot)
					to_chat(user, span_boldwarning("[power_name] conflicts with [existing_power_name] (same organ slot)."))
					return FALSE

	return TRUE

/**
 * Remove Power
 *
 * Removes a power from a character using the params list provided by tgui.
 */
/datum/preference_middleware/powers/proc/remove_power(list/params, mob/user)
	var/power_name = params["power_name"]
	var/datum/power/power_type = SSpowers.powers[power_name]
	if(isnull(preferences.all_powers))
		preferences.all_powers = list()
		return FALSE // We don't have any powers.

	if(isnull(power_type))
		return FALSE // Not a power.

	if(!(power_name in preferences.all_powers))
		return FALSE // We don't have this power.

	// Make sure none of our other powers need this power.

	var/datum/power/requiring_power_type = get_requiring_power(power_type)
	if(requiring_power_type)
		to_chat(user, span_boldwarning("[power_name] is needed by [requiring_power_type.name]!"))
		return FALSE

	preferences.all_powers -= power_name
	if(ispath(power_type, /datum/power/augmented))
		var/augment_left = preferences.read_preference(/datum/preference/choiced/augment_left)
		var/augment_right = preferences.read_preference(/datum/preference/choiced/augment_right)
		if(augment_left == power_name)
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], AUGMENTED_NO_AUGMENT)
		if(augment_right == power_name)
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], AUGMENTED_NO_AUGMENT)
	return TRUE

/**
 * Assign an arm augment to left/right/both for the global arm loadout.
 */
/datum/preference_middleware/powers/proc/set_augment_arm(list/params, mob/user)
	var/power_name = params["power_name"]
	var/side = params["side"]
	var/datum/power/power_type = SSpowers.powers[power_name]
	if(isnull(power_type))
		return FALSE
	if(!(power_name in preferences.all_powers))
		to_chat(user, span_boldwarning("You must learn [power_name] before assigning it to an arm."))
		return FALSE
	if(!ispath(power_type, /datum/power/augmented))
		return FALSE

	// Verify arm augment
	var/datum/power/augmented/power_instance = new power_type
	var/augment_location = power_instance.get_augment_location_label()
	qdel(power_instance)
	if(augment_location != "Arms")
		to_chat(user, span_boldwarning("[power_name] is not an arm augment."))
		return FALSE

	var/augment_left = preferences.read_preference(/datum/preference/choiced/augment_left)
	var/augment_right = preferences.read_preference(/datum/preference/choiced/augment_right)
	var/left_blocked = (augment_left && augment_left != AUGMENTED_NO_AUGMENT && augment_left != power_name)
	var/right_blocked = (augment_right && augment_right != AUGMENTED_NO_AUGMENT && augment_right != power_name)

	var/side_lower = lowertext(side)
	if(side_lower == "left")
		if(left_blocked)
			to_chat(user, span_boldwarning("Your left arm already has an augment assigned."))
			return FALSE
		preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], power_name)
		if(augment_right == power_name)
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], AUGMENTED_NO_AUGMENT)
	else if(side_lower == "right")
		if(right_blocked)
			to_chat(user, span_boldwarning("Your right arm already has an augment assigned."))
			return FALSE
		preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], power_name)
		if(augment_left == power_name)
			preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], AUGMENTED_NO_AUGMENT)
	else if(side_lower == "both")
		if(left_blocked || right_blocked)
			to_chat(user, span_boldwarning("Both arms must be free to assign this augment to both."))
			return FALSE
		preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_left], power_name)
		preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/augment_right], power_name)
	else
		to_chat(user, span_boldwarning("Invalid arm selection."))
		return FALSE

	return TRUE

/**
 * Checks whether we are missing required powers for a given power type.
 * Returns a list of missing requirements (empty if satisfied).
 * If required_allow_any is TRUE, the list contains all valid options when none are satisfied.
 */
/datum/preference_middleware/powers/proc/get_required_power(datum/power/power_type)
	var/list/required_powers = GLOB.powers_requirements_list[power_type]
	if(!length(required_powers))
		return list()

	var/allow_any = power_type.required_allow_any
	var/allow_subtypes = power_type.required_allow_subtypes
	var/list/missing_required = list()

	// Runs through all required powers and checks if anything is missing
	for(var/datum/power/required_power_type as anything in required_powers)
		var/requirement_satisfied = FALSE
		for(var/selected_power_name in preferences.all_powers)
			var/datum/power/selected_power_type = SSpowers.powers[selected_power_name]
			if(!selected_power_type)
				continue

			// Checks if the power matches the requirements including the various ifs/buts like allow_Subtypes
			if(power_matches_requirement(selected_power_type, required_power_type, allow_subtypes))
				requirement_satisfied = TRUE
				break

		if(requirement_satisfied)
			if(allow_any)
				return list()
			continue

		if(!allow_any)
			missing_required += required_power_type

	if(allow_any)
		return required_powers

	return missing_required


/**
 * Checks whether at least one of our powers requires the given power type,
 * and returns the first one encountered if so.
 */
/datum/preference_middleware/powers/proc/get_requiring_power(datum/power/power_type)
	for(var/selected_power_name in preferences.all_powers)
		var/datum/power/requiring_power_type = SSpowers.powers[selected_power_name]
		if(!requiring_power_type || requiring_power_type == power_type)
			continue

		var/list/required_powers = GLOB.powers_requirements_list[requiring_power_type]
		if(!length(required_powers))
			continue

		for(var/datum/power/required_power_type as anything in required_powers)
			if(power_matches_requirement(power_type, required_power_type, requiring_power_type.required_allow_subtypes))
				return requiring_power_type

/**
 * Checks whether a given power type is incompatible with our selected powers,
 * and returns the first one encountered if so.
 */
/datum/preference_middleware/powers/proc/get_incompatible_power(datum/power/power_type)
	// checks for blacklist
	for(var/list/blacklist as anything in GLOB.powers_blacklist)
		if(!(power_type in blacklist))
			continue
		for(var/datum/power/other_power_type as anything in blacklist)
			if(other_power_type.name in preferences.all_powers)
				return other_power_type
	// checks for multiple roots of same path
	if(power_type.priority == POWER_PRIORITY_ROOT)
		for(var/existing_power_name in preferences.all_powers)
			var/datum/power/existing_power_type = SSpowers.powers[existing_power_name]
			if(!existing_power_type)
				continue
			if(existing_power_type.priority == POWER_PRIORITY_ROOT && existing_power_type.path == power_type.path)
				return existing_power_type

/**
 * Returns TRUE if selecting power_type would exceed the 2-path limit.
 */
/datum/preference_middleware/powers/proc/would_exceed_path_limit(datum/power/power_type)
	if(is_path_limit_exempt(power_type))
		return FALSE

	var/list/unique_paths = list()
	for(var/existing_power_name in preferences.all_powers)
		var/datum/power/existing_power_type = SSpowers.powers[existing_power_name]
		if(!existing_power_type)
			continue
		if(is_path_limit_exempt(existing_power_type))
			continue
		unique_paths[existing_power_type.path] = TRUE

	// If this power adds a third distinct path, block it.
	if(!(power_type.path in unique_paths) && length(unique_paths) >= 2)
		return TRUE

/datum/asset/simple/powers
	assets = list(
		"thaumaturgeicon.png" = 'modular_doppler/modular_powers/icons/ui/powers/thaumaturgeicon.png',
		"theologisticon.png" = 'modular_doppler/modular_powers/icons/ui/powers/theologisticon.png',
		"psykericon.png" = 'modular_doppler/modular_powers/icons/ui/powers/psykericon.png',
		"cultivatoricon.png" = 'modular_doppler/modular_powers/icons/ui/powers/cultivatoricon.png',
		"aberranticon.png" = 'modular_doppler/modular_powers/icons/ui/powers/aberranticon.png',
		"imbuedicon.png" = 'modular_doppler/modular_powers/icons/ui/powers/imbuedicon.png',
		"warfightericon.png" = 'modular_doppler/modular_powers/icons/ui/powers/warfightericon.png',
		"experticon.png" = 'modular_doppler/modular_powers/icons/ui/powers/experticon.png',
		"augmentedicon.png" = 'modular_doppler/modular_powers/icons/ui/powers/augmentedicon.png',
		"irregularicon.png" = 'modular_doppler/modular_powers/icons/ui/powers/irregularicon.png',
		"magic_standard_icon.png" = 'modular_doppler/modular_powers/icons/ui/powers/magic_standard_icon.png',
		"magic_mental_icon.png" = 'modular_doppler/modular_powers/icons/ui/powers/magic_mental_icon.png',
		"magic_scrying_icon.png" = 'modular_doppler/modular_powers/icons/ui/powers/magic_scrying_icon.png',
		"magic_unholy_icon.png" = 'modular_doppler/modular_powers/icons/ui/powers/magic_unholy_icon.png'
	)

/datum/preference_middleware/powers/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/simple/powers),
	)
