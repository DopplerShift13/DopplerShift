//one regular spawner with a capacity of one each, one spawner for an on cantina role with a capacity of one

/obj/effect/mob_spawn/ghost_role/human/dressing
	name = "Dressing Room"
	desc = "A lifeform stasis unit. These are nominally produced to support long haul travel or to conserve resources in \
	Deep Space installations, but they also serve a thriving secondary market for people who cannot sleep soundly."
	infinite_use = TRUE //apparently doesn't work?
	uses = 99 //Honestly protection against dressing room spam lagging the server
	prompt_name = "person using the dressing room"
	you_are_text = "You are in the dressing room."
	flavour_text = "You are in an extracanonical dressing room. Try on a new look or make sure that uniform fits before spawning in as captain!"
	role_ban = ROLE_TRAITOR //no tots in the dressing room
