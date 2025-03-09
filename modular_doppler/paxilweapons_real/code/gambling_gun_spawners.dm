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

/obj/effect/spawner/gambling_guns/bobr
	items_to_spawn = list(
		/obj/item/gun/ballistic/revolver/shotgun_revolver = 1,
		/obj/item/ammo_casing/lethal_s12gauge/ecm_can = 8,
		/obj/item/ammo_casing/lethal_s12gauge/shrapnel = 4,
	)

/obj/effect/spawner/gambling_guns/boxer
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/xhihao_smg = 1,
		/obj/item/ammo_box/magazine/c585trappiste_pistol = 2,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/cawil
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_rifle = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle = 2,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/cawil_evil
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_rifle/evil = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/eland
	items_to_spawn = list(
		/obj/item/gun/ballistic/revolver/sol = 1,
		/obj/item/ammo_casing/c35sol/superfrag = 8,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/signalis
	items_to_spawn = list(
		/obj/item/gun/ballistic/marsian_super_rifle = 1,
		/obj/item/ammo_casing/c8marsian/shockwave = 2,
		/obj/item/ammo_casing/c8marsian = 4,
	)

/obj/effect/spawner/gambling_guns/gwiazda
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/pistol/plasma_marksman = 1,
		/obj/item/ammo_box/magazine/recharge/plasma_battery = 1,
	)

/obj/effect/spawner/gambling_guns/pulse
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/karim = 1,
		/obj/item/ammo_box/magazine/karim = 1,
	)

/obj/effect/spawner/gambling_guns/kiboko
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_grenade_launcher = 1,
	)

/obj/effect/spawner/gambling_guns/kiboko_evil
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_grenade_launcher/evil = 1,
	)

/obj/effect/spawner/gambling_guns/lanca
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/lanca = 1,
		/obj/item/ammo_box/magazine/lanca = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/mavu
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/pistol/sol = 1,
		/obj/item/ammo_box/magazine/c35sol_pistol = 2,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/mavu_evil
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/pistol/sol/evil = 1,
		/obj/item/ammo_box/magazine/c35sol_pistol/stendo = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/miecz
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/miecz = 1,
		/obj/item/ammo_box/magazine/miecz = 2,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/nomi
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/nomi_shotgun = 1,
		/obj/item/ammo_box/magazine/c12nomi = 1,
	)

/obj/effect/spawner/gambling_guns/sako
	items_to_spawn = list(
		/obj/item/gun/ballistic/rifle/osako = 1,
		/obj/item/ammo_casing/strilka310/tracer = 10,
	)

/obj/effect/spawner/gambling_guns/sako_scope
	items_to_spawn = list(
		/obj/item/gun/ballistic/rifle/osako/scoped = 1,
		/obj/item/ammo_casing/strilka310/kedown = 5,
	)

/obj/effect/spawner/gambling_guns/qarad
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_rifle/machinegun = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/ramu
	items_to_spawn = list(
		/obj/item/gun/ballistic/shotgun/ramu = 1,
		/obj/item/ammo_casing/s6gauge/flashbang = 6,
		/obj/item/ammo_casing/s6gauge/longshot = 3,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/ransu
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman = 1,
		/obj/item/ammo_box/magazine/c8marsian = 1,
	)

/obj/effect/spawner/gambling_guns/renny
	items_to_spawn = list(
		/obj/item/gun/ballistic/shotgun/riot/sol = 1,
		/obj/item/ammo_casing/lethal_s12gauge/shrapnel = 8,
		/obj/item/ammo_casing/lethal_s12gauge/ecm_can = 4,
		/obj/item/ammo_casing/lethal_s12gauge/slug = 4,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/renny_evil
	items_to_spawn = list(
		/obj/item/gun/ballistic/shotgun/riot/sol/evil = 1,
		/obj/item/ammo_casing/lethal_s12gauge/flechette = 8,
		/obj/item/ammo_casing/lethal_s12gauge/ecm_can = 4,
		/obj/item/ammo_casing/lethal_s12gauge/slug/penetration = 4,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/seiba
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/seiba_smg = 1,
		/obj/item/ammo_box/magazine/miecz = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/sindano
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/sol_smg = 1,
		/obj/item/ammo_box/magazine/c35sol_pistol/stendo = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/skild_diff
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/pistol/trappiste = 1,
		/obj/item/ammo_box/magazine/c585trappiste_pistol = 1,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/smartgun
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/smartgun = 1,
		/obj/item/ammo_box/magazine/smartgun = 1,
	)

/obj/effect/spawner/gambling_guns/takbok
	items_to_spawn = list(
		/obj/item/gun/ballistic/revolver/takbok = 1,
		/obj/item/ammo_casing/c585trappiste/hollowpoint = 4,
		/obj/item/ammo_casing/c585trappiste = 6,
	)
	random_suppressor = TRUE

/obj/effect/spawner/gambling_guns/yari
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/suppressed_rifle = 1,
		/obj/item/ammo_box/magazine/c12chinmoku = 2,
	)

/obj/effect/spawner/gambling_guns/zom
	items_to_spawn = list(
		/obj/item/gun/ballistic/automatic/pistol/weevil = 1,
		/obj/item/ammo_box/magazine/miecz = 1,
	)
	random_suppressor = TRUE
