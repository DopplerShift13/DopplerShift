// Does a lot of things to plants. Makes em grow, makes em produce, makes em healthy.
// This applies to A LOT of plants. Interpet as you will.

/datum/power/thaumaturge/vitalize_flora
	name = "Vitalize Flora"
	desc = "Breathes life into the plants around you. This heals any and all plants (including plant creatures), makes them grow if they're still in the growth phase, and speeds up the time until the next harvest. \
	\nRequires Affinity 1. Affinity gives a chance to not consume charges."
	security_record_text = "Subject can magically heal and grow plantlife around it."
	value = 2

	action_path = /datum/action/cooldown/power/thaumaturge/vitalize_flora
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/vitalize_flora
	name = "Vitalize Flora"
	desc = "Breathes life into the plants around you. This heals any and all plants (including plant creatures), makes them grow if they're still in the growth phase, and speeds up the time until the next harvest."
	button_icon = 'icons/obj/fluff/flora/plants.dmi'
	button_icon_state = "plant-03"

	required_affinity = 1
	prep_cost = 2

	/// the amount to heal mob plants by
	var/mob_heal_amount = 15
	/// the amount to heal non-mob plants by
	var/obj_heal_amount = 10
	/// How many seconds to make it grow by.
	var/grow_amount = (15 SECONDS) / (HYDROTRAY_CYCLE_DELAY)

/datum/action/cooldown/power/thaumaturge/vitalize_flora/use_action(mob/living/user, atom/target)
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE

	// affected anything at all
	var/affected_anything = FALSE
	// affected something this cycle
	var/affected_anything_this_cycle = FALSE
	// nearby vine to propagate from (if any)
	var/obj/structure/spacevine/nearby_vine = locate(/obj/structure/spacevine) in range(1, user_turf)
	var/datum/spacevine_controller/vine_master = nearby_vine?.master

	// Get everyhing in a 3x3 area
	for(var/turf/area_turf in range(1, user_turf))
		affected_anything_this_cycle = FALSE
		// If hydro tray: Heals the plant inside it.
		for(var/obj/machinery/hydroponics/hydro_tray in area_turf)
			if(!hydro_tray.myseed || hydro_tray.plant_status == HYDROTRAY_PLANT_DEAD)
				continue
			// heals the plant
			hydro_tray.adjust_plant_health(obj_heal_amount)
			// if its not fully aged yet; make it age.
			if(hydro_tray.age < hydro_tray.myseed.maturation)
				hydro_tray.age += grow_amount
				hydro_tray.lastproduce = hydro_tray.age
			// if it is mature, advance progress toward next harvest
			else
				hydro_tray.lastproduce = max(hydro_tray.lastproduce - grow_amount, 0)
			hydro_tray.update_appearance()
			affected_anything = TRUE
			affected_anything_this_cycle = TRUE

		// As above, but instead of hydotray its other flora objects.
		for(var/obj/structure/flora/area_flora in area_turf)
			if(area_flora.get_integrity() < area_flora.max_integrity)
				area_flora.repair_damage(obj_heal_amount)
			if(area_flora.harvested && prob(30)) // Because of how area flora is coded this is best we can do to speed it up in a way that isn't always success.
				area_flora.regrow()
			affected_anything = TRUE
			affected_anything_this_cycle = TRUE

		// Kudzu growth (spacevines) around the caster, only if vines are nearby
		if(vine_master && !isspaceturf(area_turf) && !locate(/obj/structure/spacevine) in area_turf)
			vine_master.spawn_spacevine_piece(area_turf, nearby_vine, list())
			affected_anything = TRUE
			affected_anything_this_cycle = TRUE

		// Heals plant mobs in the area for either burn, brute or tox. Also does things to turtles.
		for(var/mob/living/area_mob in area_turf)
			if(!(area_mob.mob_biotypes & MOB_PLANT))
				continue
			// prevents charge consumption for platn creatures when theyre at full hp
			if(area_mob.health >= area_mob.maxHealth)
				continue
			// heals plant creatures
			area_mob.heal_ordered_damage(mob_heal_amount, list(BRUTE, BURN, TOX))
			// so there's these cute turtles that can grow plants on themselves and clearly we should be able to grow that too.
			if(istype(area_mob, /mob/living/basic/turtle))
				var/mob/living/basic/turtle/plant_turtle = area_mob
				plant_turtle.set_plant_growth(plant_turtle.retrieve_destined_path(), grow_amount)
			affected_anything = TRUE
			affected_anything_this_cycle = TRUE

		//glowy particles to tell people somethings happening on that space.
		if(affected_anything_this_cycle)
			new /obj/effect/temp_visual/plant_growth(area_turf)

	if(!affected_anything)
		user.balloon_alert(user, "no valid targets in range!")
		return FALSE
	playsound(user, 'sound/effects/magic/charge.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

// Refund chance, similar to phantasmal tool & blend for me.
/datum/action/cooldown/power/thaumaturge/vitalize_flora/on_action_success(mob/living/user, atom/target, override_charges)
	var/chance_to_refund = clamp(THAUMATURGE_REFUND_MULT_AFFINITY * affinity + THAUMATURGE_REFUND_MULT_BASE, 0, THAUMATURGE_REFUND_MAX)
	if(prob(chance_to_refund))
		override_charges = 0
		to_chat(owner, span_notice("Your [name] spell did not consume a charge!"))
	else if(chance_to_refund >= 51) // At this point it's more common that it does not consume a charge, so we invert them and tell them when it does consume a charge!
		to_chat(owner, span_warning("Your [name] spell consumed a charge!"))
	return ..(user, target, override_charges)

// visual effect for plant growth
/obj/effect/temp_visual/plant_growth
	icon_state = "blessed"
	color = "#24da3c"
	duration = 1 SECONDS
