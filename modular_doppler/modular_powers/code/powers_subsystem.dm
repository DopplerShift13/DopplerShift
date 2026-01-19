
// Both of these lists are shifted to glob so they are generated at world start instead of risking players doing preference stuff before the subsystem inits.
GLOBAL_LIST_INIT_TYPED(powers_blacklist, /list/datum/power, list(
	list(/datum/power/item_power/thaumaturge_root, /datum/power/enigmatist_root)
))

GLOBAL_LIST_INIT(powers_requirements_list, generate_powers_requirements_list())

GLOBAL_LIST_INIT(powers_inverse_requirements_list, generate_powers_inverse_requirements_list())

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

/datum/controller/subsystem/processing/powers/proc/setup_powers()
	// Sort by priority from Root to Advanced, and then by name
	var/list/powers_list = sort_list(subtypesof(/datum/power), GLOBAL_PROC_REF(cmp_powers_asc))

	for(var/datum/power/power_type as anything in powers_list)
		if(initial(power_type.abstract_parent_type) == power_type)
			continue
		powers[initial(power_type.name)] = power_type

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

	message_admins("assign_powers FIRST -<br>powers_by_priority: [powers_by_priority]<br>bad_power: [bad_power]")

	if(bad_power)
		applied_client.prefs.save_character()

	message_admins("assign_powers SECOND -<br>power_priorities: [power_priorities]")

	for(var/power_priority in power_priorities)
		var/list/priority_powers = powers_by_priority[power_priority]
		message_admins("assign_powers THIRD(LOOP) -<br>power_priority: [power_priority]<br>priority_powers: [priority_powers]")
		if(isnull(priority_powers))
			continue
		for(var/whatever in priority_powers)
			message_admins("assign_powers 3-4(LOOP) -<br>whatever: [whatever]")
		for(var/datum/power/power_type as anything in priority_powers)
			message_admins("assign_powers FOURTH(LOOP) -<br>power_type: [power_type]<br>priority_powers: [priority_powers]")
			if(!user.add_archetype_power(power_type, override_client = applied_client))
				continue
			SSblackbox.record_feedback("tally", "powers_taken", 1, "[power_type.name]")

/// Takes a list of power names,
/// and returns a new list of powers that would be valid.
/// If no changes need to be made, will return the same list.
/// Expects all power names to be unique, but makes no other expectations.
/datum/controller/subsystem/processing/powers/proc/filter_invalid_powers(list/powers_to_check)
	var/current_balance = 0
	var/current_archetype
	var/list/intermediary_powers = list()

	var/maximum_balance = MAXIMUM_POWER_POINTS
	var/list/all_powers = get_powers()

	// TODO: work out how to filter powers missing their requirements.
	// This could be higher priorities, but could also be at the same priority level.
	// TODO: work out how to filter for going over the balance cap without introducing major issues.
	// Like ideally we remove the advanced ones first.
	// Maybe we just make a web of requirements at init?
	// Maybe we can substitute priorities with this web...?

	// Validate whether directed graph is connected!
	// Construct https://www.geeksforgeeks.org/dsa/check-if-a-directed-graph-is-connected-or-not/
	// pick a random power, then do depth first search both ways
	// Do the same thing when picking a thing to remove for balance stuff
	// Fuck we can have multiple root powers.

	// Okay so, collect root powers on our first go through.
	// THEN depth first search from each root power.
	// Then copy over all the seen ones that have their requirements.
	// FUCK what if there's a power that depends on two root powers.

	// First discard multiple base paths and incompatible powers
	for(var/power_name in powers_to_check)
		var/datum/power/power_type = all_powers[power_name]
		if(!ispath(power_type))
			continue

		// Make sure we only have one overarching archetype.
		if(isnull(current_archetype))
			current_archetype = power_type.archetype
		else if(current_archetype != power_type.archetype)
			continue // Mismatched archetype, discard.

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

		for(var/datum/power/req_type as anything in required)
			if(!selected_types[req_type])
				LAZYADD(powers_removed, "[power_name]\" requires [req_type], which was not present.")
				return list()

	// Everything is fine = return as normal
	if(intermediary_powers.len == powers_to_check.len)
		return powers_to_check
	return intermediary_powers


	/** TODO: ALL THE REST OF THIS

		var/value = initial(power_type.value)
		if(value > 0)
			if (max_positive_quirks >= 0 && positive_quirks.len == max_positive_quirks)
				continue

			positive_quirks[quirk_name] = value

		current_balance += value
		new_powers += quirk_name

	if (points_enabled && balance > 0)
		var/balance_left_to_remove = balance

		for (var/positive_quirk in positive_quirks)
			var/value = positive_quirks[positive_quirk]
			balance_left_to_remove -= value
			new_quirks -= positive_quirk

			if (balance_left_to_remove <= 0)
				break

	// It is guaranteed that if no quirks are invalid, you can simply check through `==`
	if (new_quirks.len == quirks.len)
		return quirks

	return new_quirks
	 */
