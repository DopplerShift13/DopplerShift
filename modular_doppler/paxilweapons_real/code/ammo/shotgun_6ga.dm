// 6 gauge giant shotgun shells for killing things dead

/obj/item/ammo_casing/s6gauge
	name = "6 gauge buckshot shell"
	desc = "A monster sized pelletshot shell with pellets special made to thoroughly ruin someone's day."
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "ramu_buckshot"
	caliber = CALIBER_6GAUGE
	projectile_type = /obj/projectile/bullet/s6gauge
	pellets = 8
	variance = 35

/obj/projectile/bullet/s6gauge
	name = "6 gauge pellet"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	icon_state = "shortbullet"
	damage = 7.5
	damage_falloff_tile = -0.25
	range = 12

// 6 gauge buckshot but with a spread better made for longer range fighting

/obj/item/ammo_casing/s6gauge/longshot
	name = "6 gauge longshot shell"
	desc = "A monster sized pelletshot shell with pellets special made to thoroughly ruin someone's day. \
		Longshot is designed to have a tighter spread of pellets that fly further, but behave otherwise identically \
		to standard 6 gauge pellet"
	icon_state = "ramu_longshot"
	projectile_type = /obj/projectile/bullet/s6gauge/longshot
	variance = 15

/obj/projectile/bullet/s6gauge/longshot
	range = 30

// 6 gauge slug, tarkov leg meta

/obj/item/ammo_casing/s6gauge/slug
	name = "6 gauge slug shell"
	desc = "A monster sized slug for monster sized problems, you wouldn't want to get hit by one of these things."
	icon_state = "ramu_slug"
	projectile_type = /obj/projectile/bullet/s6gauge/slug
	pellets = 1
	variance = 5

/obj/projectile/bullet/s6gauge/slug
	name = "6 gauge slug"
	icon_state = "bigshot"
	damage = 60
	armour_penetration = 10
	damage_falloff_tile = -3

// 6 gauge slug, but it makes a (non stunning) flashbang on range out (3 tiles)

/obj/item/ammo_casing/s6gauge/flashbang
	name = "6 gauge flash shell"
	desc = "A monster sized slug filled with an evil amount of flash powder. Hearing and eye protection suggested during use."
	icon_state = "ramu_flash"
	projectile_type = /obj/projectile/bullet/s6gauge/slug/flash
	pellets = 1
	variance = 5

/obj/projectile/bullet/s6gauge/slug/flash
	name = "6 gauge flash slug"
	icon_state = "bigshot"
	damage = 40
	range = 3
	/// How much range should the shell's aoe effects have
	var/flash_range = 3

/obj/projectile/bullet/s6gauge/slug/flash/on_hit(atom/target, blocked = 0, pierce_hit)
	..()
	flash_them()
	return BULLET_ACT_HIT

/obj/projectile/bullet/s6gauge/slug/flash/on_range()
	flash_them()
	return ..()

/obj/projectile/bullet/s6gauge/slug/flash/proc/flash_them()
	var/turf/flash_turf = get_turf(src)
	flash_turf.flash_lighting_fx(range = flash_range)
	playsound(flash_turf, 'sound/items/weapons/flashbang.ogg', 100, TRUE, 2, 0.9)
	for(var/mob/living/living_mob_nearby in get_hearers_in_view(flash_range, flash_turf))
		living_mob_nearby.flash_act(affect_silicon = TRUE)
		if(!iscarbon(living_mob_nearby))
			living_mob_nearby.soundbang_act()
		else
			var/mob/living/carbon/flashee = living_mob_nearby
			flashee.soundbang_act(stun_pwr = 0, damage_pwr = 2, deafen_pwr = 5)
