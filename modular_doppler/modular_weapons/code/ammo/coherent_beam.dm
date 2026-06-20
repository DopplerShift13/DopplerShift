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
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

	if (!QDELETED(target) && (isturf(target) || isstructure(target)))
		if(isobj(target))
			SSexplosions.low_mov_atom += target
		else
			SSexplosions.lowturf += target

lowturf

/// Looping sound for the beam cutter
/datum/looping_sound/coherent_beam_cutter
	start_sound = list('modular_doppler/modular_weapon/sounds/start_beam.wav' = 1)
	start_volume = 100
	start_length = 200 MILLISECONDS
	mid_sounds = list('modular_doppler/modular_weapon/sounds/constant_beam.wav' = 1)
	mid_length = 3 SECONDS
	volume = 100
	end_sound = list('modular_doppler/modular_weapon/sounds/end_beam.wav' = 1)
	end_volume = 15
	ignore_walls = FALSE
	reserve_random_channel = TRUE
