/obj/structure/mystery_box/guns/generate_valid_types()
	. = ..()
	valid_types |= subtypesof(/obj/effect/spawner/gambling_guns)

/obj/structure/mystery_box/tdome/generate_valid_types()
	. = ..()
	valid_types |= subtypesof(/obj/effect/spawner/gambling_guns)

// Spawners

/obj/effect/spawner/gambling_guns
	icon = 'modular_doppler/epic_loot/icons/loot_structures.dmi'
	icon_state = "ammo_box_random"
	var/list/items_to_spawn = list()
	var/random_suppressor = FALSE

/obj/effect/spawner/gambling_guns/Initialize(mapload)
	. = ..()
	lets_go_gambling()

/obj/effect/spawner/gambling_guns/proc/lets_go_gambling()
	for(var/each_item in items_to_spawn)
		for(var/i in 1 to items_to_spawn[each_item])
			new each_item(get_turf(src))
	if(random_suppressor && prob(50))
		new /obj/item/suppressor(get_turf(src))

// Now for the fun part

/obj/effect/spawner/gambling_guns/osako
	items_to_spawn = list(
		/obj/item/gun/ballistic/rifle/osako = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c25euro/full = 2,
	)

/obj/effect/spawner/gambling_guns/crash
	items_to_spawn = list(
		/obj/item/gun/ballistic/rifle/crash = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c25euro/full = 2,
	)

/obj/effect/spawner/gambling_guns/marcielle
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/marcielle = 1,
		/obj/item/ammo_box/magazine/marcielle = 2,
	)

/obj/effect/spawner/gambling_guns/marcielle_sport
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/marcielle/sport = 1,
		/obj/item/ammo_box/magazine/marcielle = 2,
	)

/obj/effect/spawner/gambling_guns/javiro
	items_to_spawn = list(
		/obj/item/gun/ballistic/revolver/c38/detective = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c6ng/full/sport = 2,
	)

/obj/effect/spawner/gambling_guns/tian
	items_to_spawn = list(
		/obj/item/gun/ballistic/marsian_super_rifle = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c585naraka/full = 2,
	)
