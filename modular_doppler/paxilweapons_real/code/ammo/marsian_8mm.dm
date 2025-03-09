// 8mm Marsian, a high velocity sniper round

/obj/item/ammo_casing/c8marsian
	name = "8mm Marsian casing"
	desc = "A high-precision target round first produced on Mars, which has spread to popularity in many precision rifles around the galaxy."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "martian"
	caliber = CALIBER_8MMMARSIAN
	projectile_type = /obj/projectile/bullet/c8marsian

/obj/projectile/bullet/c8marsian
	name = "8mm bullet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	damage = 50
	wound_bonus = 10
	bare_wound_bonus = 20
	speed = 2.5

// Marsian but it flies even faster, but does less damage

/obj/item/ammo_casing/c8marsian/shockwave
	name = "8mm Marsian shockwave casing"
	desc = "A high-precision target round first produced on Mars, which has spread to popularity in many precision rifles around the galaxy. \
		This one is overloaded with powder and given a much more aerodynamic projectile shape to fly at insane speeds. \
		These modifications have a negative impact on actual damage done to target."
	icon_state = "martian_tungsten"
	projectile_type = /obj/projectile/bullet/c8marsian/shockwave

/obj/projectile/bullet/c8marsian/shockwave
	damage = 40
	speed = 3

// Marsian AP, has armor piercing and slightly less damage, but has some

/obj/item/ammo_casing/c8marsian/piercing
	name = "8mm Marsian piercing casing"
	desc = "A high-precision target round first produced on Mars, which has spread to popularity in many precision rifles around the galaxy. \
		The projectile has been modified to better pierce armor, however this introduces deviation in the round's flight path."
	icon_state = "martian_superfrag"
	projectile_type = /obj/projectile/bullet/c8marsian/piercing
	variance = 5

/obj/projectile/bullet/c8marsian/piercing
	damage = 50
	armour_penetration = 30
	spread = 5
	damage_falloff_tile = -1
	speed = 0.6
