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

/obj/item/ammo_casing/bolt_slug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/bolt_slug
	name = "machined slug"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "yellowtrac"
	damage = 50
	armour_penetration = 20
	wound_bonus = -45
	wound_falloff_tile = 0

/obj/item/ammo_box/magazine/ammo_stack/bolt_slug
	name = "machined slugs"
	desc = "A stack of machined slugs."
	caliber = CALIBER_BOLT_THROWER
	ammo_type = /obj/item/ammo_casing/bolt_slug
	max_ammo = 4
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/bolt_slug/full
	start_empty = FALSE
