/*
 We hook into the process normally located in human.dm for adding verbs.
 This is all extremely similar to how quirks does it.
*/

// Adds it to the list of dropdowns
/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_MOD_POWERS, "Add/Remove Powers")

// Adds the actual verb that gets executed when selected.
/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MOD_POWERS])
		if(!check_rights(R_SPAWN))
			return
		var/list/options = list("Clear"="Clear")
		for(var/listedpower in subtypesof(/datum/power))
			var/datum/power/power = listedpower
			var/name = initial(power.name)
			options[src.has_power(power) ? "[name] (Remove)" : "[name] (Add)"] = power
		var/result = input(usr, "Choose power to add/remove","Power Mod") as null|anything in sort_list(options)
		if(result)
			if(result == "Clear")
				for(var/datum/power/toberemoved in powers)
					remove_power(toberemoved.type)
			else
				var/chosen = options[result]
				if(has_power(chosen))
					remove_power(chosen)
				else
					var/include_in_security_records = (alert(usr, "Also include this power in security records?", "Power Mod", "No", "Yes") == "Yes")
					add_power(chosen, include_in_security_records = include_in_security_records)

// Checks if a power is on the selected target
/mob/living/carbon/proc/has_power(powertype)
	for(var/datum/power/power in powers)
		if(power.type == powertype)
			return TRUE
	return FALSE

// Adds a power by calling the power subsystem.
/mob/living/carbon/proc/add_power(datum/power/powertype, power_transfer = FALSE, client/override_client, unique = TRUE, include_in_security_records = TRUE)
	if(has_power(powertype))
		return FALSE
	var/pname = initial(powertype.name)
	if(!SSpowers || !SSpowers.powers[pname])
		return FALSE
	var/datum/power/power = new powertype()
	power.include_in_security_records = include_in_security_records
	if(!power.add_to_holder(new_holder = src, power_transfer = power_transfer, client_source = override_client, unique = unique))
		qdel(power)
		return FALSE
	refresh_security_power_records()
	return TRUE

// Removes a power.
/mob/living/carbon/proc/remove_power(powertype)
	for(var/datum/power/power in powers)
		if(power.type != powertype)
			continue
		qdel(power)
		refresh_security_power_records()
		return TRUE
	return FALSE
