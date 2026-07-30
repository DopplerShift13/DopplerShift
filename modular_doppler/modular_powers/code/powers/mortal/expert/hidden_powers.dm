/datum/power/expert/hidden_powers
	name = "Hidden Powers"
	desc = "Your capabilities were never put on paper, for one reason or another. Your powers are not visible in the security records.\
	\n If you have False Power, it will be the only preserved record of your powers."
	value = 3
	/// Tracks each power's original security-record visibility so we can restore it on remove.
	var/list/original_visibility = list()

/datum/power/expert/hidden_powers/add(client/client_source)
	apply_hidden_visibility()

/datum/power/expert/hidden_powers/remove()
	restore_hidden_visibility()

/// Applies the hidden flag to all powers; in essence hiding them all.
/datum/power/expert/hidden_powers/proc/apply_hidden_visibility()
	if(!power_holder)
		return

	for(var/datum/power/power_instance as anything in power_holder.powers)
		if(!(power_instance in original_visibility))
			original_visibility[power_instance] = power_instance.include_in_security_records

		if(istype(power_instance, /datum/power/expert/false_power)) // false power explicitly stays visible
			power_instance.include_in_security_records = TRUE
		else
			power_instance.include_in_security_records = FALSE

	power_holder.refresh_security_power_records()

/// Undoes the visibility changes from hidden powers
/datum/power/expert/hidden_powers/proc/restore_hidden_visibility()
	if(!power_holder)
		original_visibility.Cut()
		return

	for(var/datum/power/power_instance as anything in original_visibility)
		if(QDELETED(power_instance))
			continue
		power_instance.include_in_security_records = original_visibility[power_instance]

	original_visibility.Cut()
	power_holder.refresh_security_power_records()
