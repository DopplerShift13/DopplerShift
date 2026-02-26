/datum/config_entry/keyed_list/supply_shortages
	key_mode = KEY_MODE_TYPE
	value_mode = VALUE_MODE_NUM
	splitter = ","

/datum/config_entry/keyed_list/supply_shortages/validate_config_key(key)
	var/type = text2path(key)
	if (type in get_usable_supply_packs())
		return key

	log_config("ERROR: [key] is not a valid supply pack typepath.")
	return null
