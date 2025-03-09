// 12mm chinmoku, slow bullets for use with suppressed weapons

/obj/item/ammo_casing/c12chinmoku
	name = "12mm Chinmoku casing"
	desc = "A modified .40 sol long bullet, with larger projectile and less powder to make it subsonic \
		Made for use in modified sol rifle magazines."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "chinmoku"
	caliber = CALIBER_12MMCHINMOKU
	projectile_type = /obj/projectile/bullet/c12chinmoku

/obj/projectile/bullet/c12chinmoku
	name = "12mm bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 40
	spread = 2
	wound_bonus = 10
	bare_wound_bonus = 20
	damage_falloff_tile = -3
	speed = 0.9

// Chinmoku "special", with armor piercing but more damage falloff

/obj/item/ammo_casing/c12chinmoku/special
	name = "12mm Chinmoku 'special' casing"
	desc = "A modified .40 sol long bullet, with larger projectile and less powder to make it subsonic \
		Made for use in modified sol rifle magazines. \
		This is a special purpose version for the penetration of heavy armor, though it has harder damage falloff."
	icon_state = "chinmoku_special"
	projectile_type = /obj/projectile/bullet/c12chinmoku/special

/obj/projectile/bullet/c12chinmoku/special
	damage = 40
	armour_penetration = 30
	spread = 4
	damage_falloff_tile = -5

// Chinmoku tracer, the same as regular chinmoku but it looks cool as fuck in the dark

/obj/item/ammo_casing/c12chinmoku/tracer
	name = "12mm Chinmoku tracer casing"
	desc = "A modified .40 sol long bullet, with larger projectile and less powder to make it subsonic \
		Made for use in modified sol rifle magazines. \
		This one is painted with a bright green tracer at the tip."
	icon_state = "chinmoku_tracer"
	projectile_type = /obj/projectile/bullet/c12chinmoku/tracer

/obj/projectile/bullet/c12chinmoku/tracer
	name = "12mm tracer"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	icon_state = "greentrac"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/projectile/bullet/c12chinmoku/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay
