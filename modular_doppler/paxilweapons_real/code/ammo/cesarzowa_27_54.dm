// .27-54 Cesarzowa
// Small caliber pistol round meant to be fired out of something that shoots real quick like

/obj/item/ammo_casing/c27_54cesarzowa
	name = ".27-54 Cesarzowa casing"
	desc = "A purple-bodied caseless cartridge home to a small projectile with a fine point."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "27-54cesarzowa"
	caliber = CALIBER_CESARZOWA
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa

/obj/item/ammo_casing/c27_54cesarzowa/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c27_54cesarzowa
	name = ".27 bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 20
	armour_penetration = 30
	wound_bonus = -30
	bare_wound_bonus = -10

// .27 tracer

/obj/item/ammo_casing/c27_54cesarzowa/tracer
	name = ".27-54 Cesarzowa casing"
	desc = "A purple-bodied caseless cartridge home to a small projectile with a fine point. \
		This one has a yellow tracer painted on the tip."
	icon_state = "27-54cesarzowa_trac"
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa/tracer

/obj/projectile/bullet/c27_54cesarzowa/tracer
	name = ".27 tracer"
	icon_state = "yellowtrac"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_BRIGHT_YELLOW

/obj/projectile/bullet/c27_54cesarzowa/tracer/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay

// .27 ultrakill rounds (hollowpoints are lame anyways)

/obj/item/ammo_casing/c27_54cesarzowa/ultrakill
	name = ".27-54 Cesarzowa ultrakill casing"
	desc = "A purple-bodied caseless cartridge home to a small projectile with a fine point. \
		Ultrakill rounds are made to ultra-kill anyone who was foolish enough to not bring armor today."
	icon_state = "27-54cesarzowa_alt"
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa/ultrakill

/obj/projectile/bullet/c27_54cesarzowa/ultrakill
	damage = 30
	weak_against_armour = TRUE
	wound_bonus = -25
	bare_wound_bonus = -5
