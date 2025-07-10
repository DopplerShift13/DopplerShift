/obj/item/ammo_casing/c25euro
	name = ".25 europa casing"
	desc = "The inclusion of europa within the name is, in fact, complete false advertising. \
		The round is much too small to be used against anything there."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "25euro"
	caliber = CALIBER_25EUROPA
	projectile_type = /obj/projectile/bullet/c25euro
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c25euro

/obj/projectile/bullet/c25euro
	name = ".25 bullet"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "bullet"
	damage = 35
	wound_bonus = -10
	exposed_wound_bonus = 10
	speed = 1.5

/obj/item/ammo_casing/c25euro/tracer
	name = ".25 europa hunter casing"
	desc = "The inclusion of europa within the name is, in fact, complete false advertising. \
		The round is much too small to be used against anything there. This is a special made \
		hunting round built to do as much damage as possible to the flesh of beasts."
	icon_state = "25euroalt"
	projectile_type = /obj/projectile/bullet/c25euro/tracer

/obj/projectile/bullet/c25euro/tracer
	name = ".25 tracer"
	icon_state = "greentrac"
	damage = 25
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_ELECTRIC_GREEN
	/// How much the damage is multiplied by when we hit a mob with the correct biotype
	var/biotype_damage_multiplier = 5
	/// What biotype we look for
	var/biotype_we_look_for = MOB_BEAST

/obj/projectile/bullet/c25euro/tracer/on_hit(atom/target, blocked, pierce_hit)
	if(ismineralturf(target))
		var/turf/closed/mineral/mineral_turf = target
		mineral_turf.gets_drilled(firer, FALSE)
		if(range > 0)
			return BULLET_ACT_FORCE_PIERCE
		return ..()
	if(!isliving(target) || (damage > initial(damage)))
		return ..()
	var/mob/living/target_mob = target
	if(target_mob.mob_biotypes & biotype_we_look_for || istype(target_mob, /mob/living/simple_animal/hostile/megafauna))
		damage *= biotype_damage_multiplier
	return ..()

/obj/projectile/bullet/c25euro/tracer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bane, mob_biotypes = MOB_BEAST, damage_multiplier = 5)

/obj/projectile/bullet/c25euro/tracer/update_overlays()
	. = ..()
	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, icon_state, src)
	emissive_overlay.transform = transform
	emissive_overlay.alpha = alpha
	. += emissive_overlay
