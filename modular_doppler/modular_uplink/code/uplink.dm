/datum/antagonist/traitor/cantinoid/on_gain()
	. = ..()
	uplink_handler.add_telecrystals(10)
