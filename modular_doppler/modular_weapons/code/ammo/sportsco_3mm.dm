

/obj/item/ammo_casing/sportsco3mm
	name = "3mm Sportsco™ casing"
	desc = "A highly refined caseless round with an unusually small projectile. The remarkably high muzzle velocity hits harder \
	than expected, but penetration is lousy."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "3mm"
	caliber = CALIBER_3MMSPORTSCO
	projectile_type = /obj/projectile/bullet/sportsco3mm

/obj/item/ammo_casing/sportsco3mm/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/sportsco3mm
	name = "3mm Sportsco™ bullet"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "shortbullet"
	damage = 10
	speed = 1.6
	ricochets_max = 1
	ricochet_chance = 25
	ricochet_auto_aim_angle = 10
	ricochet_auto_aim_range = 3
	wound_bonus = -20
	exposed_wound_bonus = 0
	embed_type = /datum/embedding/bullet/c38
	embed_falloff_tile = -4
