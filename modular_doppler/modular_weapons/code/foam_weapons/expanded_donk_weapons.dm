// additional foam weapons for having fun with your friends! WARNING: may harm your friends

//overrides riot dart stamina damage

/obj/projectile/bullet/foam_dart/riot
	stamina = 15

//bouncing darts :3c these can be spammed out of the lmg, so they're way weaker than det's match grade ricochetwise

/obj/item/ammo_casing/foam_dart/riot/match
	name = "match grade foam dart"
	desc = "The blown foam projectile actually has a lot of variance in terms of material ratios and projectile \
	mass, which has created a demand for carefully matched rounds. Such ammunition carries a price premium even \
	and in spite of the apparent slop intrinsic to foam projectile ballistics."
	projectile_type = /obj/projectile/bullet/foam_dart/riot/match

/obj/projectile/bullet/foam_dart/riot/match
	stamina = 10
	ricochets_max = 2
	ricochet_chance = 80
	ricochet_auto_aim_range = 3
	shrapnel_type = /obj/item/shrapnel/riot_dart

/obj/item/shrapnel/riot_dart
	name = "foam shrapnel"
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.25)
	weak_against_armour = TRUE
	icon_state = "tiny"
	sharpness = NONE

/obj/item/ammo_box/foambox/riot/match
	ammo_type = /obj/item/ammo_casing/foam_dart/riot/match


//gives the melee toys some stamina damage and block.

/obj/item/toy/sword
	damtype = STAMINA
	var/active_force = 15
	var/active_throwforce = 15
	block_chance = 15

/obj/item/toy/sword/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = active_force, \
		throwforce_on = active_throwforce, \
		throw_speed_on = throw_speed, \
		hitsound_on = hitsound, \
		clumsy_check = FALSE, \
		inhand_icon_change = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform), override = TRUE)
	AddElement(/datum/element/update_icon_updates_onmob)

	var/static/list/tool_behaviors = list(
		TOOL_SCREWDRIVER = list(
			SCREENTIP_CONTEXT_LMB = "Change blade color"
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/toy/foamblade
	force = 15
	damtype = STAMINA
	block_chance = 15

/obj/item/dualsaber/toy
	two_hand_force = 15
	damtype = STAMINA
	block_chance = 30

/obj/item/toy/katana
	force = 15
	damtype = STAMINA
	block_chance = 15

/obj/item/toy/toy_dagger
	force = 15
	damtype = STAMINA
	block_chance = 15

//some new foam guns with existing sprites for drip purposes

/obj/item/gun/ballistic/revolver/toy
	name = "Donk Co. Foam Revolver"
	desc = "A surprisingly good facisimile of a real revolver, except that the weight of the plastic \
	makes it harder to spin."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/toy
	force = 0
	throwforce = 0
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	weapon_weight = WEAPON_LIGHT
	gun_flags = NOT_A_REAL_GUN

/obj/item/ammo_box/magazine/internal/cylinder/toy
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM

/obj/item/gun/ballistic/rifle/boltaction/donkrifle/toy
	name = "Donk Co. Foam Jezail"
	desc = "An impractically long plastic rifle popular, but it's received a second life as an armature for \
	making cosplay weapons."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/toy
	force = 0
	throwforce = 0
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = NOT_A_REAL_GUN

/obj/item/ammo_box/magazine/internal/boltaction/toy
	ammo_type = /obj/item/ammo_casing/foam_dart
	caliber = CALIBER_FOAM

//plastic cuffs that are easy to snap

/obj/item/restraints/handcuffs/donk
	name = "\improper Donk Co. DonkCuffs"
	desc = "Innumerable product design hours went into making this bite into the wrist in a manner \
	just like the real thing."
	icon = 'modular_doppler/modular_weapons/code/foam_weapons/donkcuffs.dmi'
	icon_state = "donk_cuffs"
	obj_flags = null
	custom_materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 2)
	breakouttime = 10 SECONDS

//riot nade

/obj/item/grenade/toy
	name = "dartbang"
	desc = "The plastic shell conceals a surprisingly weighty core. A warning label cast into the hull \
	recommends eye protection."
	icon_state = "frag"
	shrapnel_type = /obj/projectile/bullet/foam_dart/riot/match
	shrapnel_radius = 5

//puts the toys in the toy vendor

/obj/machinery/vending/toyliberationstation
	products_doppler = list(
		/obj/item/gun/ballistic/revolver/toy = 8,
		/obj/item/gun/ballistic/rifle/boltaction/donkrifle/toy = 8,
		/obj/item/restraints/handcuffs/donk = 8,
	)
	premium_doppler = list(
		/obj/item/ammo_box/foambox/riot/match = 8,
		/obj/item/grenade/toy = 8,
	)
