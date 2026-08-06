/*
	You can walk through persistent rifts.
*/
/datum/power/imbued/riftwalker
	name = "Riftwalker"
	desc = "You see bluespace gateways unseen to those around you. Each station has several unique pairs of rifts that are connected that you can interact with, teleporting you between them. Only you can see and interact with them.\
	\n Interacting with it while dragging someone or something will drag them along. You cannot use these rifts while silenced."
	security_record_text = "Subject can see and use special bluespace rifts, teleporting them between two specific points."
	security_threat = POWER_THREAT_MAJOR
	mob_trait = TRAIT_IMBUED_RIFTWALKER
	value = 5 // even if it gets you into fun places, it is rng dependent and you sometimes just end up with really bad rifts.
	required_powers = list(/datum/power/imbued_root/anomalous)

	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "bluestream"

// need the mob to be instantiated to generate rifts safely.
/datum/power/imbued/riftwalker/post_add(client/client_source)
	..()
	GLOB.riftwalker_network.generate_rifts()

	// Refresh existing Riftwalker alternate appearances for this holder. Fixes a bug where sometimes players were spawning in with rifts not visible.
	for(var/datum/atom_hud/alternate_appearance/rift_hud as anything in GLOB.active_alternate_appearances)
		if(!istype(rift_hud, /datum/atom_hud/alternate_appearance/basic/riftwalker))
			continue
		rift_hud.check_hud(power_holder)
