
// These lists are shifted to glob so they are generated at world start instead of risking players doing preference stuff before the subsystem inits.
/// Glob Blacklist that blocks specific combinations of powers.
GLOBAL_LIST_INIT_TYPED(powers_blacklist, /list/datum/power, list(
	list(/datum/power/aberrant/shapechange_spider, /datum/power/aberrant/shapechange_wolf),
))

/// Glob list of what powers require what other powers. Format is power -> required power
GLOBAL_LIST_INIT(powers_requirements_list, generate_powers_requirements_list())

/// Glob list of the parent power that is required by certain powers. Format is required power -> power
GLOBAL_LIST_INIT(powers_inverse_requirements_list, generate_powers_inverse_requirements_list())

/// Glob list of powers that have species restrictions.
GLOBAL_LIST_INIT(powers_species_restrictions, generate_powers_species_restrictions())

/// Gets a power and all their requirements and adds it to the requirements list.
/proc/generate_powers_requirements_list()
	var/list/requirements_list = list()
	var/list/all_powers_list = subtypesof(/datum/power)

	for(var/datum/power/power_type as anything in all_powers_list)
		if(power_type.abstract_parent_type == power_type)
			continue
		var/datum/power/power_instance = new power_type
		if(!length(power_instance.required_powers))
			continue
		for(var/datum/power/required_power_type as anything in power_instance.required_powers)
			LAZYADDASSOCLIST(requirements_list, power_type, required_power_type)
		qdel(power_instance)

	return requirements_list

/// Gets a power and all their requirements and adds it to the inverted requirements list.
/// The inverted list is in essence the same table as powers_requirements_list, just with the columns inverted.
/proc/generate_powers_inverse_requirements_list()
	var/list/inverse_requirements_list = list()
	var/list/all_powers_list = subtypesof(/datum/power)

	for(var/datum/power/power_type as anything in all_powers_list)
		if(power_type.abstract_parent_type == power_type)
			continue
		var/datum/power/power_instance = new power_type
		if(!length(power_instance.required_powers))
			continue
		for(var/datum/power/required_power_type as anything in power_instance.required_powers)
			LAZYADDASSOCLIST(inverse_requirements_list, required_power_type, power_type)
		qdel(power_instance)

	return inverse_requirements_list

/// Gets all the powers that have a species blacklist.
/proc/generate_powers_species_restrictions()
	var/list/restrictions = list()
	for(var/datum/power/power_type as anything in subtypesof(/datum/power))
		if(initial(power_type.abstract_parent_type) == power_type)
			continue
		var/datum/power/power_instance = new power_type
		if(islist(power_instance.species_blacklist) && power_instance.species_blacklist.len)
			restrictions[power_type] = list(
				"list" = power_instance.species_blacklist,
				"whitelist" = power_instance.species_blacklist_is_whitelist,
			)
		qdel(power_instance)
	return restrictions


//Used to process and handle roundstart powers
// - Power strings are used for faster checking in code
// - Power datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(powers)
	name = "Powers"
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	/// Assoc. list of all roundstart power datum types; "name" = /path/
	var/list/powers = list()
	/// List of all power priorities in order.
	var/list/power_priorities = list(
		POWER_PRIORITY_ROOT,
		POWER_PRIORITY_BASIC,
		POWER_PRIORITY_ADVANCED,
	)
	/// Assoc. list of all mutually exclusive power paths. // TODO: NO LONGER TRUE
	var/static/list/power_paths = list(
		POWER_ARCHETYPE_SORCEROUS = list(
			POWER_PATH_THAUMATURGE,
			POWER_PATH_ENIGMATIST,
			POWER_PATH_THEOLOGIST,
		),
		POWER_ARCHETYPE_RESONANT = list(),
		POWER_ARCHETYPE_MORTAL = list(),
	)
	/// List of powers removed from players by the powers sanitization.
	var/list/powers_removed

/datum/controller/subsystem/processing/powers/Initialize()
	get_powers()
	return SS_INIT_SUCCESS

/// Returns the list of possible powers
/datum/controller/subsystem/processing/powers/proc/get_powers()
	RETURN_TYPE(/list)
	if(!powers.len)
		setup_powers()

	return powers

/// Calls the sorting alghorithm and sorts powers alphabetically.
/datum/controller/subsystem/processing/powers/proc/setup_powers()
	// Sort by priority from Root to Advanced, and then by name
	var/list/powers_list = sort_list(subtypesof(/datum/power), GLOBAL_PROC_REF(cmp_powers_asc))

	for(var/datum/power/power_type as anything in powers_list)
		if(initial(power_type.abstract_parent_type) == power_type)
			continue
		powers[initial(power_type.name)] = power_type

/// Assigns all powers in the player's preferences onto the mob.
/datum/controller/subsystem/processing/powers/proc/assign_powers(mob/living/user, client/applied_client)
	var/bad_power = FALSE
	var/list/powers_by_priority = list()
	for(var/power_name in applied_client.prefs.all_powers)
		var/datum/power/power_type = powers[power_name]
		if(!ispath(power_type))
			stack_trace("Invalid power \"[power_name]\" in client [applied_client.ckey] preferences")
			applied_client.prefs.all_powers -= power_name
			bad_power = TRUE
			continue
		if(!power_type.priority)
			stack_trace("Power with invalid priority \"[power_name]\" in client [applied_client.ckey] preferences")
			applied_client.prefs.all_powers -= power_name
			bad_power = TRUE
			continue
		LAZYADDASSOCLIST(powers_by_priority, power_type.priority, power_type)

	if(bad_power)
		applied_client.prefs.save_character()

	for(var/power_priority in power_priorities)
		var/list/priority_powers = powers_by_priority[power_priority]
		if(isnull(priority_powers))
			continue
		for(var/datum/power/power_type as anything in priority_powers)
			if(!user.add_archetype_power(power_type, override_client = applied_client))
				continue
			SSblackbox.record_feedback("tally", "powers_taken", 1, "[power_type.name]")

/// Takes a list of power names,
/// and returns a new list of powers that would be valid.
/// If no changes need to be made, will return the same list.
/// Expects all power names to be unique, but makes no other expectations.
/datum/controller/subsystem/processing/powers/proc/filter_invalid_powers(list/powers_to_check, client/applied_client)
	powers_removed = list()
	var/current_balance = 0
	var/maximum_balance = MAXIMUM_POWER_POINTS
	var/list/intermediary_powers = list()
	var/list/all_powers = get_powers()
	var/datum/species/mob_species = applied_client?.prefs?.read_preference(/datum/preference/choiced/species)

	// Track distinct paths we accept while filtering this batch
	var/list/unique_paths = list()

	// Track distinct roots we accept.
	var/list/root_by_path = list()

	for(var/power_name in powers_to_check)
		var/datum/power/power_type = all_powers[power_name]
		if(!ispath(power_type))
			continue

		// Checks against hte power's species blacklist.
		if(!isnull(mob_species) && !is_species_appropriate(power_type, mob_species))
			LAZYADD(powers_removed, "[power_name] is not available to your species.")
			continue

		// Checks if the power exceeds the max.
		current_balance += power_type.value
		if(current_balance > maximum_balance)
			LAZYADD(powers_removed, "Power point limit exceeded.")
			return list()

		// Make sure we only have up to two distinct paths.
		if(!(power_type.path in unique_paths))
			if(length(unique_paths) >= 2)
				continue // Third distinct path, discard.
			unique_paths[power_type.path] = TRUE

		// Block multiple root powers on the same path
		if(power_type.priority == POWER_PRIORITY_ROOT)
			if(root_by_path[power_type.path])
				continue // another root of this path already accepted
			root_by_path[power_type.path] = power_type

		// Make sure we don't have incompatible powers
		var/blacklisted = FALSE
		for(var/list/blacklist as anything in GLOB.powers_blacklist)
			if(!(power_type in blacklist))
				continue
			for(var/other_power in blacklist)
				if(other_power in intermediary_powers)
					blacklisted = TRUE
					break
			if(blacklisted)
				break
		if(blacklisted)
			continue // Incompatible, discard.

		// Succes = add power
		intermediary_powers += power_name

	// Build a set of selected power types.
	var/list/selected_types = list()
	for(var/power_name in intermediary_powers)
		var/datum/power/power_type = all_powers[power_name]
		selected_types[power_type] = TRUE

	// If ANY selected power is missing ANY requirement, nuke the entire list.
	for(var/power_name in intermediary_powers)
		var/datum/power/power_type = all_powers[power_name]
		var/list/required = GLOB.powers_requirements_list[power_type]
		if(!length(required))
			continue

		var/allow_any = power_type.required_allow_any
		var/allow_subtypes = power_type.required_allow_subtypes
		var/any_satisfied = FALSE

		for(var/datum/power/req_type as anything in required)
			// Exact requirement satisfied
			if(selected_types[req_type])
				any_satisfied = TRUE
				if(allow_any)  // check to end early if any requirements are validated and allow_any is true.
					break
				continue

			// Optional: allow subtypes
			if(allow_subtypes)
				var/required_typepath = ispath(req_type) ? req_type : req_type.type
				for(var/datum/power/selected_type as anything in selected_types)
					if(ispath(selected_type, required_typepath))
						any_satisfied = TRUE
						break

				if(any_satisfied) // check to end early if any requirements are validated and allow_any is true.
					if(allow_any)
						break
					continue

			// If we require all, any missing invalidates.
			if(!allow_any)
				LAZYADD(powers_removed, "[power_name]\" requires [req_type], which was not present.")
				return list()

		// If we require one and we don't have any.
		if(allow_any && !any_satisfied)
			LAZYADD(powers_removed, "[power_name]\" requires any of [required], none were present.")
			return list()

	// Everything is fine = return as normal
	if(intermediary_powers.len == powers_to_check.len)
		return powers_to_check
	return intermediary_powers

/// If a power is able to be selected for the mob's species.
/datum/controller/subsystem/processing/powers/proc/is_species_appropriate(datum/power/power_type, datum/species/mob_species)
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
