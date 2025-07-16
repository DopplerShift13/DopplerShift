/obj/item/ammo_casing/c34nb
	name = ".34 NB casing"
	desc = "Large casings underloaded to prevent breaching through station walls."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "34nb"
	caliber = CALIBER_34NB
	projectile_type = /obj/projectile/bullet/c34nb
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c34nb

/obj/projectile/bullet/c34nb
	name = ".34 bullet"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "bullet"
	damage = 40
	spread = 3
	wound_bonus = -10
	exposed_wound_bonus = 10

/obj/item/ammo_casing/c34nb/special
	name = ".34 NB special casing"
	desc = "Precision engineered .34 NB casings made to cause as much collateral damage as possible. \
		To the target? No, to everyone else standing around."
	icon_state = "34nbalt"
	projectile_type = /obj/projectile/bullet/c34nb/special

/obj/projectile/bullet/c34nb/special
	damage = 40
	spread = 5
	ricochets_max = 4
	ricochet_chance = 75
	ricochet_auto_aim_angle = 10
	ricochet_auto_aim_range = 3
	wound_bonus = -20
	exposed_wound_bonus = 10
	embed_type = /datum/embedding/bullet/c38
	embed_falloff_tile = -4

/obj/item/ammo_casing/c34nb/rubber
	name = ".34 NB squash casing"
	desc = ".34 NB with a soft outer shell and nearly hollow internal. Used in place of rubber, as \
		rubber had a tendency to deform in awful manners within the barrel."
	icon_state = "34nbcop"
	projectile_type = /obj/projectile/bullet/c34nb/rubber

/obj/projectile/bullet/c34nb/rubber
	name = ".34 squash bullet"
	damage = 20
	stamina = 30
	spread = 3
	wound_bonus = -10
	exposed_wound_bonus = 10
	speed = 0.9
