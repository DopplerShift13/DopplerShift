/datum/antagonist/traitor/cantina_regular/on_gain()
	. = ..()
	uplink_handler.add_telecrystals(10)

/datum/antagonist/traitor/cantina_bartender/on_gain()
	. = ..()
	uplink_handler.add_telecrystals(10)
