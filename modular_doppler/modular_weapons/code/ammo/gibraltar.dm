/obj/item/ammo_casing/c6ng
	name = "6mm NG casing"
	desc = "6mm New Gibraltar, a small round for small weapons."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "6mm"
	caliber = CALIBER_6MMGIBRALTAR
	projectile_type = /obj/projectile/bullet/c6ng
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c6ng

/obj/projectile/bullet/c6ng
	name = "6mm bullet"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "shortbullet"
	damage = 25
	speed = 1.4
	ricochets_max = 2
	ricochet_chance = 50
	ricochet_auto_aim_angle = 10
	ricochet_auto_aim_range = 3
	wound_bonus = -20
	exposed_wound_bonus = 10
	embed_type = /datum/embedding/bullet/c38
	embed_falloff_tile = -4

/obj/item/ammo_casing/c6ng/match
	name = "6mm NG ultrasport casing"
	desc = "Competition grade 6mm New Gibraltar, now when you miss, it absolutely is your fault this time!"
	icon_state = "6mmalt"
	projectile_type = /obj/projectile/bullet/c6ng/match

/obj/projectile/bullet/c6ng/match
	name = "6mm bullet"
	ricochets_max = 4
	ricochet_chance = 100
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 50
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1

/obj/item/ammo_casing/c6ng/rubber
	name = "6mm NG rubber casing"
	desc = "Not so lethal 6mm New Gibraltar."
	projectile_type = /obj/projectile/bullet/c6ng/match/bouncy

/obj/projectile/bullet/c6ng/match/bouncy
	name = "6mm rubber bullet" // You can tell what kinda bullet this is when it hits you, I assure you
	damage = 10
	stamina = 30
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.8
	shrapnel_type = null
	sharpness = NONE
	embed_type = null
