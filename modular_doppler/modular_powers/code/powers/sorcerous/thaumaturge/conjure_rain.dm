// bless my rains down with reagents.
/datum/power/thaumaturge/conjure_rain
	name = "Conjure Rain"
	desc = "Coats a 3x3 area at the chosen location in rain. Everything in the area becomes wet, and any reagent containers are filled with 20u of water (for mobs, this is being splashed with that amount instead). \
	Holding a reagent container in hand will consume the chemical and replaces that much of the water with the held reagent (only works with chemicals that can be synthesized). Replacing all the water in a cast will prevent slippery tiles. \
	Requires Affinity 3. Higher affinity improves the reagent conversion ratio (10% per affinity)."
	value = 4

	action_path = /datum/action/cooldown/power/thaumaturge/conjure_rain
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/conjure_rain
	name = "Conjure Rain"
	desc = "Coats a 3x3 area at the chosen location in rain. Everything in the area becomes wet, and any reagent containers are filled with 20u water (for mobs, this is being splashed with that amount instead). \
	Holding a reagent container in hand will consume the chemical and replaces that much of the water with the held reagent (only works with chemicals that can be synthesized). Replacing all the water in a cast will prevent slippery tiles. \ "
	button_icon = 'icons/effects/weather_effects.dmi'
	button_icon_state = "rain_low"

	required_affinity = 3
	prep_cost = 4
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

	use_time_overlay_type = /obj/effect/temp_visual/conjure_rain
	use_time = 5
	use_time_flags = IGNORE_USER_LOC_CHANGE

	// the chem that the base rain uses
	var/rain_chem = /datum/reagent/water
	// the base conversion ratio of the chem.
	var/base_chem_ratio = 1
	// how much the ratio increases per affinity level
	var/affinity_chem_bonus = 0.1

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
			if(reagent.chemical_flags & REAGENT_CAN_BE_SYNTHESIZED)// Prevents us from duping SPECIAL CHEMS.
				synth_volume += reagent.volume
		var/drain_amount = min(buffer.buffer_volume, synth_volume)
		if(drain_amount > 0)
			buffer.reagents.remove_reagent(rain_chem, drain_amount) // 1:1 water consumption
			var/chem_ratio = base_chem_ratio + (affinity_chem_bonus * (affinity - required_affinity))
			// in some alt universe you get negative chem ratio
			if(chem_ratio < 0)
				chem_ratio = 0
			var/part = drain_amount / synth_volume
			for(var/datum/reagent/reagent as anything in held_container.reagents.reagent_list)
				var/transfer_amount = reagent.volume * part
				if(transfer_amount > 0)
					held_container.reagents.trans_to(buffer.reagents, transfer_amount, chem_ratio, target_id = reagent.type, transferred_by = user)

	// sets the rain color and plays the noise
	var/rain_color = mix_color_from_reagents(buffer.reagents.reagent_list)
	playsound(target, 'sound/effects/splat.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)

	// every tile in range...
	for(var/turf/area_turf in range(1, target_turf))
		// splash it onto the space.
		buffer.reagents.expose(area_turf, TOUCH)
		// applies it to every reagent container in the area
		for(var/obj/item/reagent_containers/target_container in area_turf)
			if(target_container.reagents)
				buffer.reagents.trans_to(target_container, buffer.buffer_volume, transferred_by = user, copy_only = TRUE)
		// splashes it onto every mob in the area
		for(var/mob/living/area_mob in area_turf)
			buffer.reagents.expose(area_mob, TOUCH)

		// rain fx
		new /obj/effect/temp_visual/thaum_rain(area_turf, rain_color)

	qdel(buffer)
	return TRUE

// Adds a cast effect, just to make it clear to EVEROYNE we're about to rain some shit down on them.


// We create a temporary buffer for holding the reagents.
/obj/effect/abstract/thaum_rain_buffer
	name = "resonant beaker"
	desc = "You caught me doing it again; I did it once with the blender, now I am doing it again. YES. This is NECESSARY for Reagents. Don't you judge the coder! You aren't even meant to see this, peasant!"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE

	var/datum/reagents/reagent_buffer
	// also affects how much our rain produces
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

/obj/effect/temp_visual/thaum_rain/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	return ..()

// visual effect on the caster for casting rain
/obj/effect/temp_visual/conjure_rain
	icon_state = "blessed"
	color = "#243fda"
	duration = 1 SECONDS
