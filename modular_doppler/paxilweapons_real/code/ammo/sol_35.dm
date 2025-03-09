// .35 Sol Short
// Pistol caliber caseless round used almost exclusively by SolFed weapons

/obj/item/ammo_casing/c35sol
	name = ".35 Sol Short casing"
	desc = "A SolFed standard caseless pistol round."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "35sol"
	caliber = CALIBER_SOL35SHORT
	projectile_type = /obj/projectile/bullet/c35sol

/obj/item/ammo_casing/c35sol/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c35sol
	name = ".35 bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 25
	wound_bonus = 10
	bare_wound_bonus = 20

// .35 Sol but with a tracer

/obj/item/ammo_casing/c35sol/tracer
	name = ".35 Sol Short tracer casing"
	desc = "A SolFed standard caseless pistol round, with a green tracer tip painted onto it."
	icon_state = "35sol_trac"
	projectile_type = /obj/projectile/bullet/c35sol/tracer

/obj/projectile/bullet/c35sol/tracer
	name = ".35 tracer"
	icon_state = "greentrac"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/projectile/bullet/c35sol/tracer/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay

// .35 superfrag, does less against armor but more without armor

/obj/item/ammo_casing/c35sol/superfrag
	name = ".35 Sol Short superfrag casing"
	desc = "A SolFed standard caseless pistol round. More effective on unarmored targets, but struggles against anything with armor."
	icon_state = "35sol_super"
	projectile_type = /obj/projectile/bullet/c35sol/superfrag

/obj/projectile/bullet/c35sol/superfrag
	weak_against_armour = TRUE
	damage = 30
	wound_bonus = 5
	bare_wound_bonus = 25

// .35 sabot, super specialist rounds for punching armor in the gut, but does very little damage as a result

/obj/item/ammo_casing/c35sol/sabot
	name = ".35 Sol Short sabot casing"
	desc = "A SolFed standard caseless pistol round. Highly effective against armor, but does little after-penetration damage."
	icon_state = "35sol_alt"
	projectile_type = /obj/projectile/bullet/c35sol/sabot

/obj/projectile/bullet/c35sol/sabot
	damage = 20
	armour_penetration = 50
	wound_bonus = 5
	bare_wound_bonus = 10
