
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

/mob/living/proc/remove_archetype_power(power_type)
	for(var/datum/power/power in powers)
		if(power.type == power_type)
			qdel(power)
			return TRUE
	return FALSE

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

/mob/living/proc/cleanse_power_datums()
	QDEL_LIST(powers)

/mob/living/proc/transfer_power_datums(mob/living/to_mob)
	// We could be done before the client was moved or after the client was moved
	var/datum/preferences/to_pass = client || to_mob.client

	for(var/datum/power/power as anything in powers)
		power.remove_from_current_holder(power_transfer = TRUE)
		power.add_to_holder(to_mob, power_transfer = TRUE, client_source = to_pass)
