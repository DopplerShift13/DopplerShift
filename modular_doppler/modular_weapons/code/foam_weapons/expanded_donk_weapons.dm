// additional foam weapons for having fun with your friends! WARNING: may harm your friends

//overrides riot dart stamina damage

/obj/projectile/bullet/foam_dart/riot
	stamina = 15

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
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))
	AddElement(/datum/element/update_icon_updates_onmob)

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

//puts the toys in the toy vendor

/obj/machinery/vending/toyliberationstation
	products_doppler = list(
		/obj/item/gun/ballistic/revolver/toy = 8,
		/obj/item/gun/ballistic/rifle/boltaction/donkrifle/toy = 8,
		/obj/item/restraints/handcuffs/donk = 8,
	)
