/*
	You can walk through persistent rifts.
*/
/datum/power/aberrant/riftwalker
	name = "Riftwalker"
	desc = "You see bluespace gateways unseen to those around you. Each station has several unique pairs of rifts that are connected that you can interact, teleporting you between them. Only you can see and interact with them.\
	\n Interacting with it while dragging someone or something will drag them along. You cannot use these rifts while silenced."
	security_record_text = "Subject can see and use special bluespace rifts, teleporting them between two specific points."
	security_threat = POWER_THREAT_MAJOR
	mob_trait = TRAIT_ABERRANT_RIFTWALKER
	value = 5 // even if it gets you into fun places, it is rng dependent and you sometimes just end up with really bad rifts.
	required_powers = list(/datum/power/aberrant_root/anomalous)

// need the mob to be instantiated to generate rifts safely.
/datum/power/aberrant/riftwalker/post_add(client/client_source)
	..()
	GLOB.riftwalker_network.generate_rifts()
