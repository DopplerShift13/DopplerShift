// Adjusts armory spawner for disablers
// Makes them spawn the S-120 instead

/obj/effect/spawner/random/armory/disablers
	name = "cybersun carbine spawner"
	icon_state = "disabler"
	loot = list(/obj/item/gun/energy/laser/carbine/cybersun/unrestricted)
	spawn_loot_count = 3
