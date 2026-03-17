/obj/structure/reality_anchor
	name = "reassembled reality anchor"
	desc = "The fragments of a broken down reality anchor, reassembled. Crude machinery is managing to keep it docile; but when enabled, it will start enforcing normality back in a large area around it."
	icon = 'icons/obj/antags/cult/structures.dmi'
	icon_state = "pylon_off"
	anchored = TRUE
	density = TRUE

	// Is it on/off
	var/active = FALSE

	// Pulse interval
	var/pulse_interval = 6 SECONDS
	var/next_pulse_time = 0

	// Range in turfs
	var/pulse_range = 6

	// on and off icon states.
	var/on_icon_state = "pylon"
	var/off_icon_state = "pylon_off"

/obj/structure/reality_anchor/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

// Turns the thing on or off after the do_after.
/obj/structure/reality_anchor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/action_word = active ? "deactivate" : "activate"
	user.visible_message(
		span_warning("[user] begins to [action_word] the reality anchor..."),
		span_warning("You begin to [action_word] the reality anchor...")
	)
	if(!do_after(user, 3 SECONDS, target = src))
		return
	user.visible_message(
		span_warning("[user] finishes [action_word]ing the reality anchor."),
		span_warning("You finish [action_word]ing the reality anchor.")
	)
	toggle_anchor(user)

// Switches it on or off.
/obj/structure/reality_anchor/proc/toggle_anchor(mob/user)
	active = !active
	if(active)
		icon_state = on_icon_state
		pulse()
		next_pulse_time = world.time + pulse_interval
		START_PROCESSING(SSobj, src)
		return

	icon_state = off_icon_state
	STOP_PROCESSING(SSobj, src)

// Countdown til dispel pulse.
/obj/structure/reality_anchor/process(seconds_per_tick)
	if(!active)
		return
	if(world.time < next_pulse_time)
		return
	pulse()
	next_pulse_time = world.time + pulse_interval

// Dispel pulse.
/obj/structure/reality_anchor/proc/pulse()
	var/turf/center = get_turf(src)
	if(!center)
		return
	var/obj/effect/temp_visual/circle_wave/reality_anchor/pulse_fx = new(center)
	pulse_fx.amount_to_scale = pulse_range + 1 // falls short without the +1
	// We get EVERYTHING in range and dispel it. This shouldn't be too much of a lag-machine (hopefully)
	for(var/atom/movable/target in range(pulse_range, center))
		if(ismob(target))
			var/mob/living/living_target = target
			living_target.dispel(src, DISPEL_CASCADE_CARRIED)
			living_target.apply_status_effect(/datum/status_effect/power/reality_anchor_silenced)
		else if(isobj(target))
			target.dispel(src)

// Status effect responsible for silencing.
/datum/status_effect/power/reality_anchor_silenced
	id = "reality_anchor_silenced"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/reality_anchor_silenced
	show_duration = TRUE
	duration = 10 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK

/datum/status_effect/power/reality_anchor_silenced/on_apply()
	ADD_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/power/reality_anchor_silenced/on_remove()
	REMOVE_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAIT_STATUS_EFFECT(id))
	return

/atom/movable/screen/alert/status_effect/reality_anchor_silenced
	name = "Silenced"
	desc = "Resonant powers are periodically dispelled and supressed around the reality anchor!"
	icon = 'icons/obj/antags/cult/structures.dmi'
	icon_state = "pylon"

// The effect from reality anchors
/obj/effect/temp_visual/circle_wave/reality_anchor
	color = COLOR_SILVER
	max_alpha = 20
	duration = 0.5 SECONDS
	amount_to_scale = 6
