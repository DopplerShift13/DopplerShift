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
		for(var/x in subtypesof(/datum/power))
			var/datum/power/pow = x
			var/name = initial(pow.name)
			options[src.has_power(pow) ? "[name] (Remove)" : "[name] (Add)"] = pow
		var/result = input(usr, "Choose power to add/remove","Power Mod") as null|anything in sort_list(options)
		if(result)
			if(result == "Clear")
				for(var/datum/power/p in powers)
					remove_power(p.type)
			else
				var/T = options[result]
				if(has_power(T))
					remove_power(T)
				else
					add_power(T)

// Checks if a power is on the selected target
/mob/living/carbon/human/proc/has_power(powertype)
	for(var/datum/power/power in powers)
		if(power.type == powertype)
			return TRUE
	return FALSE

// Adds a power by calling the power subsystem.
/mob/living/carbon/human/proc/add_power(datum/power/powertype, power_transfer = FALSE, client/override_client, unique = TRUE)
	if(has_power(powertype))
		return FALSE
	var/pname = initial(powertype.name)
	if(!SSpowers || !SSpowers.powers[pname])
		return FALSE
	var/datum/power/power = new powertype()
	if(power.add_to_holder(new_holder = src, power_transfer = power_transfer, client_source = override_client, unique = unique))
		return TRUE
	qdel(power)
	return FALSE

// Removes a power.
/mob/living/carbon/human/proc/remove_power(powertype)
	for(var/datum/power/power in powers)
		if(power.type == powertype)
			qdel(power)
			return TRUE
	return FALSE
