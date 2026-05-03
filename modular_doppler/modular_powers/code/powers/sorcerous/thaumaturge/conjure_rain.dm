// bless my rains down with reagents.
/datum/power/thaumaturge/conjure_rain
	name = "Conjure Rain"
	desc = "Coats a 3x3 area at the chosen location in rain. Everything in the area becomes wet, and any reagent containers are filled with 20u water, up to a maximum of 60u spread out across all containers. Mobs are splashed with the same amount and don't count towards this limit. \
	\nHolding a reagent container in hand will consume the chemical and replaces that much of the water with the held reagent (only works with chemicals that can be synthesized). Replacing all the water in a cast will prevent slippery tiles. \
	\nRequires Affinity 3. Higher affinity increases the max amount of spreadable reagents by 20u."
	security_record_text = "Subject can conjure rains with varying chemical properties."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	action_path = /datum/action/cooldown/power/thaumaturge/conjure_rain
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/conjure_rain
	name = "Conjure Rain"
	desc = "Coats a 3x3 area at the chosen location in rain. Everything in the area becomes wet, and any reagent containers are filled with 20u water, up to a maximum of 60u spread out across all containers. Mobs are splashed with the same amount and don't count towards this limit. \
	Holding a reagent container in hand will consume the chemical and replaces that much of the water with the held reagent (only works with chemicals that can be synthesized). Replacing all the water in a cast will prevent slippery tiles. \ "
	button_icon = 'icons/effects/weather_effects.dmi'
	button_icon_state = "rain_low"

	required_affinity = 3
	prep_cost = 4
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

	use_time_overlay_type = /obj/effect/temp_visual/conjure_rain
	use_time = 1 SECONDS

	/// the chem that the base rain uses
	var/datum/reagent/rain_chem = /datum/reagent/water
	/// the base conversion ratio of the chem.
	var/base_chem_ratio = 1
	/// the max amount we put in a single container
	var/max_reagents_per_container = 20
	/// max amount of reagents we can spread across containers (not including mobs)
	var/max_reagents_dupe = 60
	/// bonus to max reagents per affinity above 3.
	var/affinity_max_reagents = 20
	/// Max units of reagent to expose per turf when splashing on the ground.
	var/ground_expose_cap = 10
	/// If TRUE, only allow chems that can be synthesized (unless bypassed below).
	var/require_synthesizable = TRUE
	/// Chems that bypass synthesizable check.
	var/list/synth_bypass_chems = list(/datum/reagent/blood) // blood is cool and has synergy iwth sanguine absorption

/// Is the chem alloewd? If its synthesizable or is on the bypass list.
/datum/action/cooldown/power/thaumaturge/conjure_rain/proc/is_allowed_rain_reagent(datum/reagent/reagent)
	if(!reagent)
		return FALSE
	if(reagent.type in synth_bypass_chems)
		return TRUE
	if(!require_synthesizable)
		return TRUE
	return (reagent.chemical_flags & REAGENT_CAN_BE_SYNTHESIZED)

// We piggyback into do_use_time to add a telegraph of the rain.
/datum/action/cooldown/power/thaumaturge/conjure_rain/do_use_time(mob/living/user, atom/target)
	if(use_time <= 0)
		return TRUE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	// we cheekily get the color of the held reagent container so we can color the rain even if we haven't calculated the buffer yet. May not be 100% accurate, but close enuff.
	var/rain_color
	var/obj/item/reagent_containers/held_container = user.get_active_held_item()
	if(istype(held_container) && held_container.reagents?.reagent_list?.len)
		// We need to make sure that the chems are synthesizable so that people aren't surprised that they can't blood rain
		var/list/datum/reagent/synth_reagents = list()
		for(var/datum/reagent/reagent in held_container.reagents.reagent_list)
			if(is_allowed_rain_reagent(reagent))
				synth_reagents += reagent
		// If all succeeds, mix the rain color.
		if(length(synth_reagents))
			rain_color = mix_color_from_reagents(synth_reagents)
	else // no reagent container, default to rain_chem
		rain_color = initial(rain_chem.color)

	// displays the telgraphed rain
	for(var/turf/area_turf in range(1, target_turf))
		new /obj/effect/temp_visual/thaum_rain_buildup(area_turf, rain_color)
	return ..()

/datum/action/cooldown/power/thaumaturge/conjure_rain/use_action(mob/living/user, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	// creatures the reagent buffer and adds water
	var/obj/effect/abstract/thaum_rain_buffer/buffer = new(target_turf, 20)
	buffer.reagents.add_reagent(rain_chem, buffer.buffer_volume)

	// If we have a held container, convert some of the rain into that reagent.
	var/obj/item/reagent_containers/held_container = user.get_active_held_item()
	if(istype(held_container) && held_container.reagents?.total_volume)
		var/synth_volume = 0
		for(var/datum/reagent/reagent as anything in held_container.reagents.reagent_list)
			if(is_allowed_rain_reagent(reagent))// Prevents us from duping SPECIAL CHEMS (unless bypassed).
				synth_volume += reagent.volume
		var/drain_amount = min(buffer.buffer_volume, synth_volume)
		if(drain_amount > 0)
			buffer.reagents.remove_reagent(rain_chem, drain_amount) // 1:1 water consumption
			var/chem_ratio = base_chem_ratio
			var/part = drain_amount / synth_volume
			for(var/datum/reagent/reagent as anything in held_container.reagents.reagent_list)
				if(!is_allowed_rain_reagent(reagent))
					continue
				var/transfer_amount = reagent.volume * part
				if(transfer_amount > 0)
					held_container.reagents.trans_to(buffer.reagents, transfer_amount, chem_ratio, target_id = reagent.type, transferred_by = user)

	// sets the rain color and plays the noise
	var/rain_color = mix_color_from_reagents(buffer.reagents.reagent_list)
	playsound(target, 'sound/effects/splat.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)

	var/list/obj/item/reagent_containers/area_containers = list()
	for(var/turf/area_turf in range(1, target_turf))
		for(var/obj/item/reagent_containers/target_container in area_turf)
			if(target_container.reagents)
				area_containers += target_container

	var/bonus_affinity = max(0, affinity - 3)
	var/max_spread = max_reagents_dupe + (bonus_affinity * affinity_max_reagents)
	var/per_container = 0
	var/ground_expose_modifier = 1
	if(buffer.reagents.total_volume > 0)
		ground_expose_modifier = min(1, ground_expose_cap / buffer.reagents.total_volume)

	// Get every reagent container in range and calculate how we spread the rain.
	if(length(area_containers))
		per_container = min(max_reagents_per_container, max_spread / length(area_containers))

	// every tile in range...
	for(var/turf/area_turf in range(1, target_turf))
		var/has_container = FALSE
		for(var/obj/item/reagent_containers/target_container in area_turf)
			has_container = TRUE
			break
		// splash it onto the space (skip if we're filling a container on that turf).
		if(!has_container)
			buffer.reagents.expose(area_turf, TOUCH, ground_expose_modifier)
		// splashes it onto every mob in the area
		for(var/mob/living/area_mob in area_turf)
			buffer.reagents.expose(area_mob, TOUCH)

		// rain fx
		new /obj/effect/temp_visual/thaum_rain(area_turf, rain_color)

	// Adds reagents to containers based on the calculated per_container.
	if(per_container > 0)
		for(var/obj/item/reagent_containers/target_container in area_containers)
			buffer.reagents.trans_to(target_container, per_container, transferred_by = user, copy_only = TRUE)

	qdel(buffer)
	return TRUE

// We create a temporary buffer for holding the reagents.
/obj/effect/abstract/thaum_rain_buffer
	name = "resonant beaker"
	desc = "You caught me doing it again; I did it once with the blender, now I am doing it again. YES. This is NECESSARY for Reagents. Don't you judge the coder! You aren't even meant to see this, peasant!"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE

	/// Holds reagents tempirarly.
	var/datum/reagents/reagent_buffer
	/// The size of our buffer; also affects how much our rain produces
	var/buffer_volume = 20

/obj/effect/abstract/thaum_rain_buffer/Initialize(mapload, new_buffer_volume)
	. = ..()
	if(isnum(new_buffer_volume) && new_buffer_volume > 0)
		buffer_volume = new_buffer_volume
	reagents = new /datum/reagents(buffer_volume, src)
	reagents.flags = TRANSPARENT | DRAINABLE

/obj/effect/temp_visual/thaum_rain
	name = "magical rain"
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "rain_high"
	duration = 1 SECONDS

/obj/effect/temp_visual/thaum_rain_buildup
	name = "light magical rain"
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "rain_low"
	duration = 1 SECONDS

// lets us recolor the rain
/obj/effect/temp_visual/thaum_rain_buildup/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	return ..()

/obj/effect/temp_visual/thaum_rain/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	return ..()

// visual effect on the caster for casting rain
/obj/effect/temp_visual/conjure_rain
	icon_state = "blessed"
	color = "#243fda"
	duration = 1 SECONDS
