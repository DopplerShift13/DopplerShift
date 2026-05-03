
/**
 * All the additional procs/vars we need on /mob/living for powers to function.
 */

/mob/living
	/// List of all powers we currently have.
	var/list/powers = list()

/**
 * Adds the passed power to the mob
 *
 * Arguments
 * * power_type - Power typepath to add to the mob
 * If not passed, defaults to this mob's client.
 *
 * Returns TRUE on success, FALSE on failure (already has the power, etc)
 */
/mob/living/proc/add_archetype_power(datum/power/power_type, client/override_client, add_unique = TRUE)
	if(has_archetype_power(power_type))
		return FALSE
	var/qname = initial(power_type.name)
	if(!SSpowers || !SSpowers.powers[qname])
		return FALSE
	var/datum/power/new_power = new power_type()
	if(new_power.add_to_holder(new_holder = src, client_source = override_client, unique = add_unique))
		return TRUE
	qdel(new_power)
	return FALSE

/**
 * Removes the passed power from the mob
 *
 * Arguments
 * * power_type - Power typepath to remove from to the mob
 *
 * Returns TRUE on success, FALSE on failure (power isnt there)
 */
/mob/living/proc/remove_archetype_power(power_type)
	for(var/datum/power/power in powers)
		if(power.type == power_type)
			qdel(power)
			return TRUE
	return FALSE

/**
 * Checks the existence of a power on a mob.
 *
 * Arguments
 * * power_type - Power typepath to check on the mob
 *
 * Returns TRUE if its there, FALSE if not.
 */
/mob/living/proc/has_archetype_power(power_type)
	for(var/datum/power/power in powers)
		if(power.type == power_type)
			return TRUE
	return FALSE

/**
 * Getter function for a mob's power
 *
 * Arguments:
 * * power_type - the type of the power to acquire e.g. /datum/power/some_power
 *
 * Returns the mob's power datum if the mob this is called on has the power, null on failure
 */
/mob/living/proc/get_power(power_type)
	for(var/datum/power/power in powers)
		if(power.type == power_type)
			return power
	return null

/**
 * get_power_string() is used to get a printable string of all powers this mob has.
 *
 * Arguments:
 * * security - If TRUE, uses each power's security record text. If FALSE, uses the power names.
 * * category - Which threat categories of powers should be included.
 * * include_empty_text - If FALSE, returns an empty string when no entries match.
 */
/mob/living/proc/get_power_string(security = FALSE, category = CAT_POWER_ALL, include_empty_text = TRUE)
	var/list/dat = list()
	for(var/datum/power/candidate as anything in powers)
		if(security && !candidate.include_in_security_records)
			continue

		switch(category)
			if(CAT_POWER_MINOR_THREAT)
				if(candidate.security_threat != POWER_THREAT_MINOR)
					continue
			if(CAT_POWER_MAJOR_THREAT)
				if(candidate.security_threat != POWER_THREAT_MAJOR)
					continue

		if(security)
			var/security_text = candidate.get_security_record_text()
			if(!isnull(security_text) && security_text != "")
				dat += security_text
		else
			dat += candidate.name

	if(!length(dat))
		if(!include_empty_text)
			return ""
		return security ? "No powers declared." : "None"

	return security ? dat.Join("<br>") : dat.Join(", ")

/// Compatibility helper for security record formatting.
/mob/living/proc/get_sec_power_string(category = CAT_POWER_ALL, include_empty_text = TRUE)
	return get_power_string(TRUE, category, include_empty_text)

/// Refreshes the sec records when powers are added/removed.
/mob/living/proc/refresh_security_power_records()
	var/lookup_name = name
	if(ishuman(src))
		var/mob/living/carbon/human/human_self = src
		lookup_name = human_self.real_name

	var/datum/record/crew/target = find_record(lookup_name)
	if(!target)
		return

	target.power_notes = get_sec_power_string(CAT_POWER_ALL)
	target.power_notes_minor = get_sec_power_string(CAT_POWER_MINOR_THREAT, include_empty_text = FALSE)
	target.power_notes_major = get_sec_power_string(CAT_POWER_MAJOR_THREAT, include_empty_text = FALSE)

/// Removes all powers from the mob.
/mob/living/proc/cleanse_power_datums()
	QDEL_LIST(powers)

/// Removes all powers from a mob and transfers them to the new target instead.
/mob/living/proc/transfer_power_datums(mob/living/to_mob)
	// We could be done before the client was moved or after the client was moved
	var/datum/preferences/to_pass = client || to_mob.client

	for(var/datum/power/power as anything in powers)
		power.remove_from_current_holder(power_transfer = TRUE)
		power.add_to_holder(to_mob, power_transfer = TRUE, client_source = to_pass)
