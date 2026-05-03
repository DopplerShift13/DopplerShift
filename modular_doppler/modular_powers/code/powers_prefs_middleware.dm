
/**
 * This place is a message... and part of a system of messages... pay attention to it!
 * Sending this message was important to us. We considered ourselves to be a powerful culture.
 * This place is not a place of honor... no highly esteemed deed is commemorated here... nothing valued is here.
 * What is here was dangerous and repulsive to us. This message is a warning about danger.
 * The danger is in a particular location... it increases towards a center... the center of danger is here... of a particular size and shape, and below us.
 * The danger is still present, in your time, as it was in ours.
 * The danger is to the body, and it can kill.
 * The form of the danger is an emanation of energy.
 * The danger is unleashed only if you substantially disturb this place physically. This place is best shunned and left uninhabited.
 */

/datum/preference_middleware/powers
	action_delegations = list(
		"give_power" = PROC_REF(give_power),
		"remove_power" = PROC_REF(remove_power),
		"set_augment_arm" = PROC_REF(set_augment_arm),
	)

/datum/preference_middleware/powers/get_ui_data(mob/user)
	var/list/data = list()

	var/list/thaumaturge = list()
	var/list/enigmatist = list()
	var/list/theologist = list()

	var/list/psyker = list()
	var/list/cultivator = list()
	var/list/aberrant = list()

	var/list/warfighter = list()
	var/list/expert = list()
	var/list/augmented = list()

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
		var/word
		var/color
		var/powertype
		var/rootpower = null

		if(power_type.priority == POWER_PRIORITY_ROOT)
			powertype = "crown"
		else
			powertype = ""
			rootpower = power_type.archetype

		if(has_given_power)
			word = "Forget"
			state = "bad"
			if(locked_in)
				color = "0.5"
		else
			if(locked_in || ((power_type.value + current_points) > MAXIMUM_POWER_POINTS))
				state = "transparent"
				word = "N/A"
				color = "0.5"
			else
				state = "good"
				word = "Learn"
				color = "1"

		var/augment_info = build_augment_ui_info(power_type, preferences)
		var/datum/power_constant_data/constant_data = GLOB.all_power_constant_data[power_type]
		var/list/customization_options = constant_data?.get_customization_data()

		// Gets the powers required per power and adds their names, to display when hovered over.
		var/list/required_power_types = GLOB.powers_requirements_list[power_type]
		var/list/required_power_names = list()
		if(length(required_power_types))
			for(var/datum/power/required_power_type as anything in required_power_types)
				var/required_power_name = required_power_type.name
				// Trims abstract from abstract roots.
				if(length(required_power_name) >= 9 && lowertext(copytext(required_power_name, 1, 10)) == "abstract ")
					required_power_name = copytext(required_power_name, 10)
				required_power_names += required_power_name
		// Gets special requirements such as allow any and allow subtypes
		var/required_allow_any = power_type.required_allow_any
		var/required_allow_subtypes = power_type.required_allow_subtypes

		var/final_list = list(list(
				"description" = power_type.desc,
				"name" = power_type.name,
				"cost" = power_type.value,
				"has_power" = has_given_power,
				"state" = state,
				"word" = word,
				"color" = color,
				"powertype" = powertype,
				"rootpower" = rootpower,
				"required_powers" = required_power_names,
				"required_allow_any" = required_allow_any,
				"required_allow_subtypes" = required_allow_subtypes,
				"augment" = augment_info,
				"customizable" = constant_data?.is_customizable(),
				"customization_options" = customization_options,
			))

		switch(power_type.path)
			if(POWER_PATH_THAUMATURGE)
				thaumaturge += final_list
			if(POWER_PATH_ENIGMATIST)
				enigmatist += final_list
			if(POWER_PATH_THEOLOGIST)
				theologist += final_list
			if(POWER_PATH_PSYKER)
				psyker += final_list
			if(POWER_PATH_CULTIVATOR)
				cultivator += final_list
			if(POWER_PATH_ABERRANT)
				aberrant += final_list
			if(POWER_PATH_WARFIGHTER)
				warfighter += final_list
			if(POWER_PATH_EXPERT)
				expert += final_list
			if(POWER_PATH_AUGMENTED)
				augmented += final_list


	data["total_power_points"] = MAXIMUM_POWER_POINTS
	data["thaumaturge"] = thaumaturge
	data["enigmatist"] = enigmatist
	data["theologist"] = theologist
	data["psyker"] = psyker
	data["cultivator"] = cultivator
	data["aberrant"] = aberrant
	data["warfighter"] = warfighter
	data["expert"] = expert
	data["augmented"] = augmented
	data["power_points"] = current_points

	return data

/// Snowflake proc to allow Augments to have their own selectable arm section in the UI.
/datum/preference_middleware/powers/proc/build_augment_ui_info(
	datum/power/power_type,
	datum/preferences/preferences
)
	// Snowflake code for Augments: expose arm assignment + location.
	var/augment_location
	var/is_arm_augment
	var/augment_assignment
	var/arm_left_blocked
	var/arm_right_blocked
	if(ispath(power_type, /datum/power/augmented))
		var/datum/power/augmented/power_instance = new power_type
		augment_location = power_instance.get_augment_location_label()
		is_arm_augment = (augment_location == "Arms")
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
			"location" = augment_location,
			"is_arm" = is_arm_augment,
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
	if(length(preferences.all_powers))
		var/list/unique_paths = list()
		// Collect the distinct paths the player already has
		for(var/power_key in preferences.all_powers)
			var/datum/power/existing_power = SSpowers.powers[power_key]
			if(!existing_power)
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

	for(var/datum/power/required_power_type as anything in required_powers)
		var/required_power_name = required_power_type.name

		// Exact requirement satisfied
		if(required_power_name in preferences.all_powers)
			if(allow_any)
				return list()
			continue

		// Optional: allow subtypes, decided by the power we're trying to learn
		if(allow_subtypes)
			var/required_typepath = ispath(required_power_type) ? required_power_type : required_power_type.type
			var/found_subtype = FALSE

			for(var/selected_power_name in preferences.all_powers)
				var/datum/power/selected_power_type = SSpowers.powers[selected_power_name]
				if(!selected_power_type)
					continue

				if(ispath(selected_power_type.type, required_typepath))
					found_subtype = TRUE
					break

			if(found_subtype)
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
	var/list/powers_requiring_this = GLOB.powers_inverse_requirements_list[power_type]
	if(!length(powers_requiring_this))
		return
	for(var/datum/power/requiring_power_type as anything in powers_requiring_this)
		if(requiring_power_type.name in preferences.all_powers)
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
	var/list/unique_paths = list()
	for(var/existing_power_name in preferences.all_powers)
		var/datum/power/existing_power_type = SSpowers.powers[existing_power_name]
		if(!existing_power_type)
			continue
		unique_paths[existing_power_type.path] = TRUE

	// If this power adds a third distinct path, block it.
	if(!(power_type.path in unique_paths) && length(unique_paths) >= 2)
		return TRUE

/datum/asset/simple/powers
	assets = list(
		"gear.png" = 'modular_doppler/modular_powers/icons/ui/powers/gear.png',
		"heart.png" = 'modular_doppler/modular_powers/icons/ui/powers/heart.png',
		"seal.png" = 'modular_doppler/modular_powers/icons/ui/powers/seal.png'
	)

/datum/preference_middleware/powers/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/simple/powers),
	)
