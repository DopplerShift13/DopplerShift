/// Emits a series of EMP waves from a synthetic Psyker.
/datum/psyker_event/catastrophic/emp_wave
	lingering = TRUE
	/// Minimum number of EMP pulses in the sequence.
	var/minimum_pulses = 1
	/// Maximum number of EMP pulses in the sequence.
	var/maximum_pulses = 5
	/// Radius of the square affected by each pulse. A radius of two produces a 5x5 area.
	var/pulse_radius = 2
	/// Pulses remaining in the current sequence.
	var/pulses_remaining = 0
	/// Psyker currently displaying the overload warning overlay.
	var/mob/living/carbon/human/overloading_psyker
	/// Overlay displayed during the delay before the first pulse.
	var/mutable_appearance/overload_overlay

/datum/psyker_event/catastrophic/emp_wave/can_execute(mob/living/carbon/human/psyker)
	if((psyker.mob_biotypes & MOB_ROBOTIC) != NONE)
		return TRUE

	// Future proofing in case we get robotic psyker organs
	var/obj/item/organ/resonant/psyker/psyker_organ = psyker.get_organ_slot(ORGAN_SLOT_PSYKER)
	return psyker_organ && IS_ROBOTIC_ORGAN(psyker_organ)

/datum/psyker_event/catastrophic/emp_wave/execute(mob/living/carbon/human/psyker)
	// Rolls how often we'll pulse
	pulses_remaining = rand(minimum_pulses, maximum_pulses)
	// Applies a lingering overlay
	overloading_psyker = psyker
	overload_overlay = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "empdisable",
		layer = psyker.layer + 0.1,
		appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM | KEEP_APART,
	)
	psyker.add_overlay(overload_overlay)
	psyker.visible_message(
		span_danger("[psyker] begins to spark with electromagnetic energy!"),
		span_userdanger("Your systems are overloading!"),
	)
	playsound(psyker, 'sound/effects/clockcult_gateway_disrupted.ogg', 50, FALSE)
	addtimer(CALLBACK(src, PROC_REF(begin_pulses), psyker), 2.7 SECONDS)
	return TRUE

/// Clears the overload warning and starts the EMP sequence.
/datum/psyker_event/catastrophic/emp_wave/proc/begin_pulses(mob/living/carbon/human/psyker)
	clear_overload_overlay()
	if(QDELETED(psyker))
		qdel(src)
		return

	pulse(psyker)

/// Removes the warning overlay from the Psyker.
/datum/psyker_event/catastrophic/emp_wave/proc/clear_overload_overlay()
	if(!QDELETED(overloading_psyker) && overload_overlay)
		overloading_psyker.cut_overlay(overload_overlay)
	overloading_psyker = null
	overload_overlay = null

/// Emits one pulse and schedules the next at a random delay, deleting the event after the final pulse.
/datum/psyker_event/catastrophic/emp_wave/proc/pulse(mob/living/carbon/human/psyker)
	if(QDELETED(psyker))
		qdel(src)
		return

	var/turf/center_turf = get_turf(psyker)
	if(!center_turf)
		qdel(src)
		return

	psyker.visible_message(
		span_danger("[psyker] unleashes an electromagnetic pulse!"),
		span_userdanger("You unleash an electromagnetic pulse!"),
	)
	playsound(psyker, 'sound/effects/magic/disable_tech.ogg', 50, TRUE)

	for(var/turf/affected_turf as anything in RANGE_TURFS(pulse_radius, center_turf))
		var/emp_severity = affected_turf == center_turf ? EMP_HEAVY : EMP_LIGHT
		affected_turf.emp_act(emp_severity)
		for(var/atom/affected_atom as anything in affected_turf)
			affected_atom.emp_act(emp_severity)

	new /obj/effect/temp_visual/circle_wave/emp_wave(center_turf)
	pulses_remaining--
	if(pulses_remaining <= 0)
		qdel(src)
		return

	addtimer(CALLBACK(src, PROC_REF(pulse), psyker), rand(0.5 SECONDS, 3 SECONDS))

/datum/psyker_event/catastrophic/emp_wave/Destroy(force)
	clear_overload_overlay()
	return ..()

// Adds the backlash option as a smite for admins.
/datum/smite/psyker_breakdown/emp_wave
	name = "Psyker Event: EMP Wave (Robotic Only)"
	event_type = /datum/psyker_event/catastrophic/emp_wave

// Custom emp wave
/obj/effect/temp_visual/circle_wave/emp_wave
	color = COLOR_BLUE_VERY_LIGHT
	duration = 0.5 SECONDS
	amount_to_scale = 3
