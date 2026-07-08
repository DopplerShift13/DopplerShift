/obj/item/ammo_casing/energy/coherent_energy_beam
	fire_sound = null
	e_cost = LASER_SHOTS(33, STANDARD_CELL_CHARGE)
	select_name = "boil"
	projectile_type = /obj/projectile/energy/coherent_energy_beam
	firing_effect_type = null

/obj/projectile/energy/coherent_energy_beam
	name = "energy beam"
	icon_state = null
	hitscan = TRUE
	impact_effect_type = null
	damage = 5
	wound_bonus = 10
	exposed_wound_bonus = 70
	/// Firestacks we're applying to the target. This is kept low because we're generally hitting them a LOT
	var/fire_stacks = 1

/obj/projectile/energy/coherent_energy_beam/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	firer.Beam(target, icon_state = "solar_beam", time = 1)

	if(iscarbon(target))
		var/mob/living/carbon/target_carbon = target
		target_carbon.adjust_fire_stacks(fire_stacks)
		target_carbon.ignite_mob()

	if(!QDELETED(target) && isstructure(target))
		SSexplosions.low_mov_atom += target
	else if(!QDELETED(target) && isturf(target))
		SSexplosions.lowturf += target

/// Looping sound for the beam cutter
/datum/looping_sound/coherent_beam_cutter
	start_sound = list('modular_doppler/modular_weapons/sounds/start_beam.wav' = 1)
	start_volume = 100
	start_length = 1 SECONDS
	mid_sounds = list('modular_doppler/modular_weapons/sounds/constant_beam.wav' = 1)
	mid_length = 3 SECONDS
	volume = 100
	end_sound = list('modular_doppler/modular_weapons/sounds/end_beam.wav' = 1)
	end_volume = 100
	ignore_walls = FALSE
	reserve_random_channel = TRUE
