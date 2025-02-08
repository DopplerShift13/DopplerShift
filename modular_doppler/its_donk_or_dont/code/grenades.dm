/obj/item/grenade/frag/impact
	name = "Defensive Dart Impact Grenade"
	desc = "A strange device made to throw darts EVERYWHERE on impact with the ground, or after five seconds pass from \
		arming. Due to how the mechanism needs to wind up, it won't spring on impact for at least two seconds after arming."
	icon = 'modular_doppler/its_donk_or_dont/icons/grenades.dmi'
	icon_state = "impact_defense"
	shrapnel_type = /obj/projectile/bullet/foam_dart/riot
	shrapnel_radius = 3
	ex_dev = 0
	ex_heavy = 0
	ex_light = 0
	ex_flame = 0
	/// Can this grenade explode on impact yet?
	var/impact_explosion_ready = FALSE
	/// Det time divider, larger means less time before it explodes on impact
	var/det_divider = 2

/obj/item/grenade/frag/impact/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!impact_explosion_ready)
		return
	detonate()

/obj/item/grenade/frag/impact/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(ready_impact)), det_time / det_divider)

/// Allows the grenade to explode on throw impact
/obj/item/grenade/frag/impact/proc/ready_impact()
	impact_explosion_ready = TRUE

/obj/item/grenade/frag/impact/smaller
	name = "Offensive Dart Impact Grenade"
	icon = 'modular_doppler/its_donk_or_dont/icons/grenades.dmi'
	icon_state = "impact_offense"
	shrapnel_radius = 1
	det_divider = 3
