/datum/antagonist/traitor/cantina/on_gain()
	. = ..()
	uplink_handler.add_telecrystals(10)
