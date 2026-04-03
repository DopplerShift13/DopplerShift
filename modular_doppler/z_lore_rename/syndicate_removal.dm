
/**
 * === SYNDICATE FLAVOR OVERRIDES ===
 * This file includes all modular overrides for removing mentions of the syndicate.
 * Each sub-category should have a comment explaining it.
 */


/**
 * SYNDICATE COMMS AGENT
 * This is replaced by people contracted by the EDL.
 */

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/icemoon
	name = "Icemoon Echoes-Dark-Locations Agent"
	prompt_name = "Echoes-Dark-Locations crewman"
	you_are_text = "You are an EDL crewman, assigned in an underground secret listening post close to your rival-sister-ship's facility."
	flavour_text = "9LP has unjustly supplanted your crew as the 'flagship' Port Authority crew for this region. Monitor enemy activity as best you can, and try to keep a low profile. Use the communication equipment to provide support to any field agents, and sow disinformation to throw the Promenade crew off your trail and disrupt their productivity."
	important_text = "Do NOT let the Promenade sieze the outpost and recover evidence of our tampering for Port Authority inspection; A small scuttling charge has been provided."


/**
 * SYNDICATE COMMS
 * These are replaced with either generic explanations,
 * or references to the Curfew and Sundown / Undisclosed Location.
 * EDIT KEY: CNS_RADIO
 */

/obj/item/encryptionkey/syndicate
	name = "full-spectrum encryption key"
	desc = "A special encryption key for a radio headset, allowing one to listen to all of the 9LP's standard frequencies. \
		As an added bonus, this comes with the Undisclosed Location's temporary encryption key as well."

/datum/uplink_item/device_tools/encryptionkey
	name = "Full-Spectrum Encryption Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to all the 9LP's department channels. \
		In addition, it allows you to talk on the Undisclosed Location's temporary encrypted channel with others that share the same key. \
		Finally, this key also protects your headset from radio jammers."


/obj/item/implant/radio/syndicate
	desc = "An implant injected into the body, allowing one to listen to all of the 9LP's standard frequencies, \
		in addition to allowing temporary use of the Undisclosed Location's frequency. \
		Used just like a regular headset, but can be disabled to use external headsets normally and to avoid detection."

/obj/item/implanter/radio/syndicate
	name = "implanter (internal full-spectrum radio)"

/obj/item/storage/box/syndie_kit/imp_radio
	name = "full-spectrum radio implant box"

/datum/uplink_item/implants/radio
	name = "Internal Full-Spectrum Radio Implant"
	desc = "An implant injected into the body, allowing one to listen to all of the 9LP's standard frequencies, \
		in addition to allowing temporary use of the Undisclosed Location's frequency. \
		Used just like a regular headset, but can be disabled to use external headsets normally and to avoid detection."


/obj/item/radio/headset/syndicate/alt
	name = "full-spectrum headset"
	desc = "A special headset equipped with a key that allows listening in on all the 9LP's standard frequencies. \
		Protects ears from flashbangs."
