/*
* machined shot for the tiziran gauss rifle
*/

/obj/item/ammo_casing/bolt_slug
	name = "machined slug"
	desc = "A solid lathe turned slug of ferrous alloy, ready to be shunted through a hot coil wrap and deep into something or \
	someone unfortunate."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "machined_bolt"
	caliber = CALIBER_BOLT_THROWER
	projectile_type = /obj/projectile/bullet/bolt_slug
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/bolt_slug

/obj/item/ammo_casing/bolt_slug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/bolt_slug
	name = "machined slug"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "yellowtrac"
	damage = 50
	armour_penetration = 20
	wound_falloff_tile = 0

/obj/item/ammo_box/magazine/ammo_stack/bolt_slug
	name = "machined slugs"
	desc = "A stack of machined slugs."
	caliber = CALIBER_BOLT_THROWER
	ammo_type = /obj/item/ammo_casing/bolt_slug
	max_ammo = 10
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/bolt_slug/full
	start_empty = FALSE

/*
*	because it's a gauss gun, you can technically throw just about anything down the barrel, like a fistful of shot.
*/

/obj/item/ammo_casing/bolt_slug/shot
	name = "fistful of bearings"
	desc = "A fist-sized bushel of spheroid ferrous metal. These tend to bang up the barrels on the \
	coilguns, but their effectiveness means they get used anyway."
	icon_state = "bolt_shot"
	projectile_type = /obj/projectile/bullet/bolt_slug/shot
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/bolt_shot
	pellets = 6
	variance = 15
	randomspread = TRUE

/obj/projectile/bullet/bolt_slug/shot
	name = "machined bearing"
	damage = 8
	armour_penetration = 15
	wound_bonus = -10
	wound_falloff_tile = 0

/obj/item/ammo_box/magazine/ammo_stack/bolt_shot
	name = "a whole lot of fistfuls of bearings"
	desc = "A veritable pouchful of machined spheres waiting to become ammunition."
	caliber = CALIBER_BOLT_THROWER
	ammo_type = /obj/item/ammo_casing/bolt_slug/shot
	max_ammo = 10
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/bolt_shot/full
	start_empty = FALSE
