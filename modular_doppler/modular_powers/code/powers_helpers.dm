
/proc/cmp_powers_asc(datum/power/first_power, datum/power/second_power)
	var/first_priority_val = SSpowers.power_priorities.Find(first_power.priority)
	var/second_priority_val = SSpowers.power_priorities.Find(second_power.priority)
	var/a_sign = SIGN(first_priority_val)
	var/b_sign = SIGN(second_priority_val)

	var/a_name = first_power::name
	var/b_name = second_power::name

	if(a_sign != b_sign)
		return a_sign - b_sign
	else
		return sorttext(b_name, a_name)