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
	damage_falloff_tile = -0.4

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

// Magazines

/obj/item/ammo_box/magazine/yanao
	name = "\improper yanao belt box (.34)"
	desc = "A large belt box for the yanao machine gun, holds 50 rounds of .34 NB."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "yanao_box"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c34nb
	caliber = CALIBER_34NB
	max_ammo = 50
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/yanao/spawns_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/yanao/kill_everyone
	name = "\improper yanao belt box (.34 Special)"
	ammo_type = /obj/item/ammo_casing/c34nb/special

/obj/item/ammo_box/magazine/marcielle
	name = "\improper Marcielle magazine (.34)"
	desc = "A short magazine for the Marcielle rifles, holds five rounds."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "marcielle_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c34nb
	caliber = CALIBER_34NB
	max_ammo = 5

/obj/item/ammo_box/magazine/marcielle/special
	name = "\improper Marcielle magazine (.34 Special)"
	ammo_type = /obj/item/ammo_casing/c34nb/special

/obj/item/ammo_box/magazine/marcielle/squash
	name = "\improper Marcielle magazine (.34 Squash)"
	ammo_type = /obj/item/ammo_casing/c34nb/rubber

/obj/item/ammo_box/magazine/marcielle/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/sabine
	name = "\improper Sabine magazine (.34)"
	desc = "An eight round magazine for the NW-Sabine carabina, fitted with a special locking mechanism to stop people like you \
		from trying to put them into a Marcielle. It won't fit. Don't try."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "sabine_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c34nb
	caliber = CALIBER_34NB
	max_ammo = 8

/obj/item/ammo_box/magazine/sabine/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/sabine/special
	name = "\improper Sabine magazine (.34 Special)"
	ammo_type = /obj/item/ammo_casing/c34nb/special

/obj/item/ammo_box/magazine/sabine/squash
	name = "\improper Sabine magazine (.34 Squash)"
	ammo_type = /obj/item/ammo_casing/c34nb/rubber
