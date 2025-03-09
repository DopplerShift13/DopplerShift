// 12 gauge shotgun shells just not the tg ones

/obj/item/ammo_casing/lethal_s12gauge
	name = "12 gauge pelletshot shell"
	desc = "A shell loaded with large pellets that make a terrible cone of lead when fired."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "buckshell"
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/projectile/bullet/lethal_s12gauge
	pellets = 7
	variance = 40

/obj/projectile/bullet/lethal_s12gauge
	name = "12 gauge pellet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	icon_state = "shortbullet"
	damage = 7
	damage_falloff_tile = -0.25
	range = 12

// 12 Gauge flechettes

/obj/item/ammo_casing/lethal_s12gauge/flechette
	name = "12 gauge flechette shell"
	desc = "A shell loaded with a cone of needle-like projectiles that penetrate armor."
	icon_state = "dartshell"
	projectile_type = /obj/projectile/bullet/lethal_s12gauge/flechette
	pellets = 7
	variance = 40

/obj/projectile/bullet/lethal_s12gauge/flechette
	name = "12 gauge flechette"
	icon_state = "bullet"
	damage = 6
	armour_penetration = 50
	damage_falloff_tile = -0.2

// 12 Gauge shrapnel

/obj/item/ammo_casing/lethal_s12gauge/shrapnel
	name = "12 gauge shrapnel shell"
	desc = "A shell loaded with various sharp and unpleasant things that cut anything they crash into."
	icon_state = "shotshrapnel"
	projectile_type = /obj/projectile/bullet/lethal_s12gauge/shrapnel
	pellets = 7
	variance = 40

/obj/projectile/bullet/lethal_s12gauge/shrapnel
	name = "12 gauge shrapnel"
	icon_state = "shortbullet"
	damage = 6
	damage_falloff_tile = -0.2
	sharpness = SHARP_EDGED

// 12 Gauge ECM cans

/obj/item/ammo_casing/lethal_s12gauge/ecm_can
	name = "12 gauge ECM chaff shell"
	desc = "A shell loaded with three small cans that dispense ECM chaff as they fly."
	icon_state = "ecmshot"
	projectile_type = /obj/projectile/bullet/lethal_s12gauge/ecm_can
	pellets = 3
	variance = 20

/obj/projectile/bullet/lethal_s12gauge/ecm_can
	name = "12 gauge ECM canister"
	icon_state = "bigshot"
	damage = 10

/obj/projectile/bullet/lethal_s12gauge/ecm_can/Move()
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		new /obj/effect/particle_effect/fluid/smoke/ecm(location)

// 12 gauge slug

/obj/item/ammo_casing/lethal_s12gauge/slug
	name = "12 gauge slug"
	desc = "A solid metal slug that fits neatly into a standard 12 gauge hull."
	icon_state = "slugshell"
	projectile_type = /obj/projectile/bullet/lethal_s12gauge/slug
	pellets = 1
	variance = 3

/obj/projectile/bullet/lethal_s12gauge/slug
	name = "12 gauge slug"
	icon_state = "bullet"
	damage = 50
	damage_falloff_tile = -3

// 12 gauge AP slug

/obj/item/ammo_casing/lethal_s12gauge/slug/penetration
	name = "12 gauge AP slug"
	desc = "A solid metal slug that fits neatly into a standard 12 gauge hull. This one is made to fight armor."
	icon_state = "apshell"
	projectile_type = /obj/projectile/bullet/lethal_s12gauge/slug/penetration
	variance = 7

/obj/projectile/bullet/lethal_s12gauge/slug/penetration
	damage = 40
	armour_penetration = 25
	damage_falloff_tile = -2
