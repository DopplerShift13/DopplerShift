// basically the stingballs from the grenade, but seperated so we can tweak numbers without also affecting said grenade

/obj/item/ammo_casing/avispa_stingball
	name = ".61 'Avispa' stingball"
	desc = "A chemical inflammatory delivered via launcher at a hundred-fifty meters per second."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "stingball"
	caliber = CALIBER_STINGBALL
	projectile_type = /obj/projectile/bullet/avispa_stingball
	ammo_stack_type = /obj/item/ammo_casing/avispa_stingball

/obj/item/ammo_box/magazine/ammo_stack/avispa_stingball
	name = "\improper fistfull of balls"	//sorry
	desc = "A stack of .61 stingballs"
	caliber = CALIBER_STINGBALL
	ammo_type = /obj/item/ammo_casing/avispa_stingball
	casing_phrasing = "ball"
	max_ammo = 12
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/avispa_stingball
	name = ".61 'Avispa' stingball"
	damage = 3
	stamina = 8
	ricochets_max = 4
	ricochet_chance = 66
	ricochet_decay_chance = 1
	ricochet_decay_damage = 0.9
	ricochet_auto_aim_angle = 10
	ricochet_auto_aim_range = 2
	ricochet_incidence_leeway = 0
	embed_falloff_tile = -2
	shrapnel_type = /obj/item/shrapnel/stingball
	embed_type = /datum/embedding/stingball
