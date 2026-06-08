/datum/power/cultivator_root/astral_touched
	name = "Astral Touched Alignment"
	desc = "You gain Energy through Aura by being able to view space (or space adjacent things), proportional to distance. Activating it gives you a radiant, blue aura causing your punches to do extra burn damage.\
	\nPassively, your cold temprature tolerance is increased by 40C; activating the alignment makes you immune to cold and pressure, allowing you to navigate space unharmed (though you still need to breathe).\
	\nYou gain armor IV across your whole body. Has diminishing effects with your worn armor."
	security_record_text = "Subject is capable of entering a heightened state by observing space, granting them resistance to damage, deadlier punches and the ability to ignore cold tempratures and low pressure."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/cultivator/alignment/astral_touched

	value = 6

	/// bonus to cold tolerance
	var/cold_tolerance_bonus = 40

// Gives innate resistance to cold.
/datum/power/cultivator_root/astral_touched/post_add()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_cold_damage_limit -= cold_tolerance_bonus

/datum/power/cultivator_root/astral_touched/remove()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_cold_damage_limit += cold_tolerance_bonus

/datum/action/cooldown/power/cultivator/alignment/astral_touched
	name = "Astral Touched Alignment"
	desc = "Activates your Astral Touched Alignment aura, granting you immune to cold and pressure, increasing your defenses (if unarmored), and increasing your strength with unarmed attacks."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "teleport"

	alignment_outline_color = "#c1effa"
	alignment_activation_sound = 'sound/effects/magic/cosmic_energy.ogg'
	alignment_overlay_state = "shieldsparkles"

	alignment_damage_type = BURN

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/astral_touched/enable_alignment(mob/living/carbon/user)
	. = ..()
	user.add_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), src)

/datum/action/cooldown/power/cultivator/alignment/astral_touched/disable_alignment(mob/living/carbon/user)
	. = ..()
	user.remove_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), src)

/datum/action/cooldown/power/cultivator/alignment/astral_touched/aura_farm()
	var/total = 0
	var/mob/living/owner_mob = owner
	if(!owner_mob)
		return total

	var/space_value = CULTIVATOR_AURA_FARM_MINOR * 0.6 // the real thing
	var/glass_value = CULTIVATOR_AURA_FARM_MINOR * 0.3 // not as cool but its something
	var/fake_space_value = CULTIVATOR_AURA_FARM_MINOR * 0.4 // looks pretty real.
	var/space_cube_value = CULTIVATOR_AURA_FARM_MINOR * 0.5 // Praise the space cube.
	var/in_space_value = CULTIVATOR_AURA_FARM_MAJOR // Being out in space basically guarantees 50% charge.

	// Do we see space turfs?
	for(var/turf/T in view(owner_mob))
		if(istype(T, /turf/open/space))
			total += space_value
			continue
		if(istype(T, /turf/open/floor/glass)) // Note, we check if you can see space on the z-level below. If you can or there's no z-level you get the space bonus.
			var/turf/below = locate(T.x, T.y, T.z - 1)
			if(!below || istype(below, /turf/open/space))
				total += glass_value
			continue
		if(istype(T, /turf/open/floor/fakespace))
			total += fake_space_value
			continue

	// PRAISE THE SPACE CUBE. IT HAS SPACE ON IT - THAT COUNTS!
	for(var/obj/structure/sign/poster/contraband/space_cube/cube in view(owner_mob))
		total += space_cube_value
	for(var/obj/item/dice/d6/space/cube in view(owner_mob))
		total += space_cube_value

	// Are we in space?
	var/turf/owner_turf = get_turf(owner_mob)
	if(istype(owner_turf, /turf/open/space))
		total += in_space_value

	return total
