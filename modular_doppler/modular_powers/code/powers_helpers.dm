
/// Equation that sorts powers in alphabetical order, with roots in ascending order..
/proc/cmp_powers_asc(datum/power/first_power, datum/power/second_power)
	var/first_priority_val = SSpowers.power_priorities.Find(first_power.priority)
	var/second_priority_val = SSpowers.power_priorities.Find(second_power.priority)

	var/a_name = first_power::name
	var/b_name = second_power::name

	if(first_priority_val != second_priority_val)
		// Unknown priorities are always sorted after known priorities.
		if(!first_priority_val)
			return 1
		if(!second_priority_val)
			return -1
		return first_priority_val - second_priority_val

	return sorttext(b_name, a_name)
