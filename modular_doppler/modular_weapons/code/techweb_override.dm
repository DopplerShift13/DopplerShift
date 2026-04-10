// for injecting modular weapons, ammo, etc into the techweb without nonmodular edits.

/datum/techweb_node/basic_arms/New()
	design_ids |= list(
		"c585naraka",
		"c25euro",
		"61stingball",
	)
	return ..()

/datum/techweb_node/riot_supression/New()
	design_ids |= list(
		"platillo",
	)
	return ..()
