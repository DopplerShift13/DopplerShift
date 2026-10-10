/*
	You can walk through persistent rifts.
*/
/datum/power/imbued/riftwalker
	name = "Riftwalker"
	desc = "You see bluespace rifts unseen to those around you. Each station has several unique pairs of rifts that are connected that you can interact with, teleporting you between them. Only you can see and interact with them.\
	\n Certain rifts have certain characteristics: some will be more common around teleportation devices and may link to other ones, whilst some rarer rifts may take you to less-common locations.\
	\n Interacting with it while dragging someone or something will drag them along."
	security_record_text = "Subject can see and use special bluespace rifts, teleporting them between two specific points."
	security_threat = POWER_THREAT_MAJOR
	mob_trait = TRAIT_IMBUED_RIFTWALKER
	value = 5 // even if it gets you into fun places, it is rng dependent and you sometimes just end up with really bad rifts.
	required_powers = list(/datum/power/imbued_root/anomalous)

	menu_icon = 'modular_doppler/modular_powers/icons/powers/effects.dmi'
	menu_icon_state = "riftwalker_blue"

// need the mob to be instantiated to generate rifts safely.
/datum/power/imbued/riftwalker/post_add(client/client_source)
	..()
	GLOB.riftwalker_network.generate_rifts()
	GLOB.riftwalker_network.update_rift_visibility(power_holder)

/datum/power/imbued/riftwalker/remove()
	. = ..()
	GLOB.riftwalker_network.update_rift_visibility(power_holder)
