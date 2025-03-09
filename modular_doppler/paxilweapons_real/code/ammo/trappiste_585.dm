// .585 Trappiste
// High caliber round used in large pistols and revolvers

/obj/item/ammo_casing/c585trappiste
	name = ".585 Trappiste casing"
	desc = "A white polymer cased high caliber round commonly used in handguns."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "585trappiste"
	caliber = CALIBER_585TRAPPISTE
	projectile_type = /obj/projectile/bullet/c585trappiste

/obj/projectile/bullet/c585trappiste
	name = ".585 Trappiste bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 40
	wound_bonus = 0

// .585 hollowpoint, made to cause nasty wounds

/obj/item/ammo_casing/c585trappiste/hollowpoint
	name = ".585 Trappiste hollowhead casing"
	desc = "A white polymer cased high caliber round with a flat tip. \
		Designed to cause as much damage on impact to fleshy targets as possible."
	icon_state = "585trappiste_alt"
	projectile_type = /obj/projectile/bullet/c585trappiste/hollowpoint

/obj/projectile/bullet/c585trappiste/hollowpoint
	damage = 45
	weak_against_armour = TRUE
	wound_bonus = 30
	bare_wound_bonus = 40
