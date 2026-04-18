/*
* basically a cross between the skeleton pirates' cannon and the BSA mechanically, or a proton cannon that's been obrezed.
* this fires explosive projectiles, sucks a ton of power off the shuttle's grid to do so, and has a moderate cooldown.
*/

/obj/machinery/deployable_turret/snub_particle_cannon
	name = "snub nose deck cannon"
	desc = "A weaponized particle accelerator that fires balls of hyper-energized protons. Originally built to fit ships much \
	larger than this, this one has had most of its barrel and much of its cooling systems removed."
	icon = 'modular_doppler/modular_weapons/icons/obj/naval_gun.dmi'
	icon_state = "snub_nose_ppc"
	density = TRUE
	projectile_type = /obj/projectile/energy/snub_particle_cannon_bolt
	number_of_shots = 1
	cooldown_duration = 10 SECONDS
	firesound = 'modular_doppler/modular_sounds/sound/items/particle_cannon.ogg'
	always_anchored = TRUE
	/// how much energy we take out of the grid when we fire a shot.
	var/power_draw_per_shot = 50 MEGA WATTS	//specifically enough to drain the apc and briefly blackout the ship

/obj/machinery/deployable_turret/snub_particle_cannon/examine_more(mob/user)
	. = ..()
	. += span_notice("There's a gunner's seat attached to it.")

/obj/machinery/deployable_turret/snub_particle_cannon/fire_helper(mob/user)
	. = ..()
	use_energy(power_draw_per_shot)

/obj/machinery/deployable_turret/snub_particle_cannon/direction_track(mob/user, atom/targeted)
	if(user.incapacitated)
		return
	setDir(get_dir(src,targeted))
	user.setDir(dir)
	switch(dir)
		if(NORTH)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 7
			user.pixel_y = 3
		if(NORTHEAST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = -7
			user.pixel_y = 3
		if(EAST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = -7
			user.pixel_y = 3
		if(SOUTHEAST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = -7
			user.pixel_y = 3
		if(SOUTH)
			layer = BELOW_MOB_LAYER
			user.pixel_x = -5
			user.pixel_y = 12
		if(SOUTHWEST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 11
			user.pixel_y = 3
		if(WEST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 11
			user.pixel_y = 3
		if(NORTHWEST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 11
			user.pixel_y = 3

/obj/projectile/energy/snub_particle_cannon_bolt	//approximately one skeleton pirate cannonball, sans passthru mechanics
	name = "energized particle bolt"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	icon_state = "ppc_bolt"
	damage = 50

/obj/projectile/energy/snub_particle_cannon_bolt/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	explosion(target, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, flame_range = 3, explosion_cause = src)	//small concentrated explosion makes tiny breaches for ingress
	return BULLET_ACT_HIT
