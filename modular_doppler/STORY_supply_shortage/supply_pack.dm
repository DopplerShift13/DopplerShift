/// Returns a list of non-abstract supply packs.
/proc/get_usable_supply_packs()
	RETURN_TYPE(/list)

	var/list/packs = list()

	for (var/datum/supply_pack/iter_path as anything in subtypesof(/datum/supply_pack))
		if (iter_path::abstract_type == iter_path)
			continue
		packs += iter_path

	return packs

/// Returns the assoc list of stringified supply pack typepaths to their price mult.
/proc/get_price_mults()
	RETURN_TYPE(/list)

	return CONFIG_GET(keyed_list/supply_shortages)

// If this proc returns -1, the item is wholly unavailable.
/// Returns the actual price mult of the supply pack. If -1, the item is completely unavailable. Use get_cost() for actual price calculations.
/datum/supply_pack/proc/get_shortage_price_mult()
	var/mult = get_price_mults()["[type]"]
	if (isnull(mult))
		return 1
	return mult

/// Returns TRUE if our shortage price mult is -1.
/datum/supply_pack/proc/is_unavailable()
	return get_shortage_price_mult() == -1

/datum/supply_pack/get_cost()
	. = ..()

	if (!is_unavailable())
		. *= get_shortage_price_mult()
