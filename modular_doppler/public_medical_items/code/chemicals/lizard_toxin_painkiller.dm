#define ASLANANE_COLOR_FILTER "aslanane_color_filter"

/datum/reagent/medicine/aslanane
	name = "Aslanane"
	description = "A potent mixture of Tiziran dendrotoxins and other, weaker painkillers to dilute the strength. \
		Originally used in some more esoteric sun-scale rituals (Earning its name from the Tiziran god of the sun, \
		Atra'Asl), it turned out to be an effective general anesthetic once bacterial-grown substitutes to the toxin \
		removed the need to milk venomous Tizirans like antivenoms of centuries past."
	color = "#948db3"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	overdose_threshold = 20
	ph = 4.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/impurity/healing/medicine_failure
	metabolized_traits = list(TRAIT_ANALGESIA)
	taste_description = "a metallic tang that turns numb"
	addiction_types = list(/datum/addiction/medicine = 5)

// Taking too much gives you the same effects as being bitten by a tiziran with the toxin used to make it
/datum/reagent/medicine/aslanane/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 10)
		affected_mob.set_eye_blur_if_lower(6 SECONDS * REM * seconds_per_tick)
		affected_mob.adjust_confusion(1 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
	if(affected_mob.adjustStaminaLoss(2 * REM * seconds_per_tick, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/aslanane/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!iscarbon(exposed_mob) || (exposed_mob.stat == DEAD) || (!exposed_mob.hud_used))
		return
	if(methods & INHALE)
		var/atom/movable/plane_master_controller/game_plane_master_controller = exposed_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		var/static/list/color_filter_wonky = list(2,-0.5,-0.5,0, -0.5,2,-0.5,0, -0.5,-0.5,2,0, 0,0,0,1)
		if(!isnull(game_plane_master_controller.get_filter(ASLANANE_COLOR_FILTER)))
			return
		game_plane_master_controller.add_filter(ASLANANE_COLOR_FILTER, 10, color_matrix_filter())
		game_plane_master_controller.transition_filter(ASLANANE_COLOR_FILTER, 5 SECONDS, color_matrix_filter(color_filter_wonky, FILTER_COLOR_RGB))
		exposed_mob.playsound_local(exposed_mob, 'sound/effects/singlebeat.ogg', 100, TRUE)

/datum/reagent/medicine/aslanane/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/medicine/aslanane/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	if(!affected_mob.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter(ASLANANE_COLOR_FILTER)

/datum/chemical_reaction/aslanane
	results = list(/datum/reagent/medicine/aslanane = 6)
	required_reagents = list(
		/datum/reagent/toxin/tiziran/less = 2,
		/datum/reagent/medicine/mine_salve = 3,
		/datum/reagent/copper = 1,
		/datum/reagent/chlorine = 1,
	)
	required_catalysts = list(
		/datum/reagent/diethylamine = 10,
	)
	required_temp = 375
	optimal_temp = 520
	mix_message = "The venom becomes clearer as it denatures."
	mix_sound = 'sound/effects/chemistry/catalyst.ogg'
	optimal_ph_min = 4.5
	optimal_ph_max = 6.8
	ph_exponent_factor = 0.25
	determin_ph_range = 5
	H_ion_release = 0.07
	reaction_tags = REACTION_TAG_DRUG
