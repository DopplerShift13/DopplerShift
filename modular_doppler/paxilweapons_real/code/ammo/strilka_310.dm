// .310 Strilka
// Large rifle round that makes things explode good at long range

/obj/item/ammo_casing/strilka310
	name = ".310 Strilka casing"
	desc = "A .310 Strilka casing. A tall block of red compressed powder with a small bullet visible inside from the tip."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "310casing"
	caliber = CALIBER_STRILKA310
	projectile_type = /obj/projectile/bullet/strilka310

/obj/projectile/bullet/strilka310
	name = ".310 bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 60
	armour_penetration = 10
	wound_bonus = -45
	wound_falloff_tile = 0

// .310 Tracer

/obj/item/ammo_casing/strilka310/tracer
	name = ".310 Strilka tracer casing"
	desc = "A .310 Strilka casing. A tall block of red compressed powder with a small bullet visible inside from the tip. \
		A yellow tracer is painted on it."
	icon_state = "310casing_trac"
	projectile_type = /obj/projectile/bullet/strilka310/tracer

/obj/projectile/bullet/strilka310/tracer
	name = ".310 tracer"
	icon_state = "yellowtrac"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_BRIGHT_YELLOW

/obj/projectile/bullet/strilka310/tracer/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay

// .310 piercing (can go through things)

/obj/item/ammo_casing/strilka310/piercing
	name = ".310 Strilka piercing casing"
	desc = "A .310 Strilka casing. A tall block of red compressed powder with a small bullet visible inside from the tip. \
		This one is hardened with advanced materials to pierce a significant amount of anything it hits."
	icon_state = "310casing_alt"
	projectile_type = /obj/projectile/bullet/strilka310/piercing

/obj/projectile/bullet/strilka310/piercing
	damage = 45
	armour_penetration = 40
	wound_bonus = -50
	max_pierces = 2
	projectile_piercing = PASSMOB|PASSGRILLE|PASSMACHINE|PASSSTRUCTURE|PASSDOORS|PASSFLAPS|PASSVEHICLE|PASSWINDOW

// .310 Kedown, it bounces off of stuff

/obj/item/ammo_casing/strilka310/kedown
	name = ".310 Strilka 'Kedown' casing"
	desc = "A .310 Strilka casing. A tall block of red compressed powder with a small bullet visible inside from the tip. \
		The name 'Kedown' comes from the sound it makes when it bounces off of walls, which it will do often."
	icon_state = "310casing_super"
	projectile_type = /obj/projectile/bullet/strilka310/kedown

/obj/projectile/bullet/strilka310/kedown
	damage = 50
	armour_penetration = 30
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_auto_aim_range = 1
	ricochet_incidence_leeway = 75
