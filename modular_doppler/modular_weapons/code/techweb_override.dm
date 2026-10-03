// for injecting modular weapons, ammo, etc into the techweb without nonmodular edits.

/datum/techweb_node/basic_arms/New()
	design_ids |= list(
		"c585naraka",
		"c25euro",
		"61stingball",
		"defenseur_mag",
		"defenseur_mag_match",
		"defenseur_mag_rubber",
	)
	return ..()

/datum/techweb_node/riot_supression/New()
	design_ids |= list(
		"platillo",
	)
	return ..()

// renders scattershells inaccessible because their current techweb availability + materials availability combined with their power is a bit much
/datum/design/lasershell
	build_type = null


// removes this design from any player accessible lathe in favor of a modularly added shield gauntlet
/datum/design/tele_shield
	build_type = null
