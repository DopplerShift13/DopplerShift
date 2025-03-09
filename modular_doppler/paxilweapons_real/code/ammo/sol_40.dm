// .40 Sol Long
// Rifle caliber caseless ammo that kills people good

/obj/item/ammo_casing/c40sol
	name = ".40 Sol Long casing"
	desc = "A SolFed standard caseless rifle round."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "40sol"
	caliber = CALIBER_SOL40LONG
	projectile_type = /obj/projectile/bullet/c40sol

/obj/item/ammo_casing/c40sol/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c40sol
	name = ".40 bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 35
	wound_bonus = 10
	bare_wound_bonus = 20

// .40 hardcore, for fighting mfs with armor

/obj/item/ammo_casing/c40sol/hardcore
	name = ".40 Sol Long hardcore casing"
	desc = "A SolFed standard caseless rifle round. Features a hardened core to stand better against armored targets."
	icon_state = "40sol_alt"
	projectile_type = /obj/projectile/bullet/c40sol/hardcore

/obj/projectile/bullet/c40sol/hardcore
	damage = 30
	armour_penetration = 25
	wound_bonus = 0
	bare_wound_bonus = 10

// .40 tracer, light show

/obj/item/ammo_casing/c40sol/tracer
	name = ".40 Sol Long tracer casing"
	desc = "A SolFed standard caseless rifle round. The tip is painted with a green tracer."
	icon_state = "40sol_trac"
	projectile_type = /obj/projectile/bullet/c40sol/tracer

/obj/projectile/bullet/c40sol/tracer
	name = ".40 tracer"
	icon_state = "greentrac"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/projectile/bullet/c40sol/tracer/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay
