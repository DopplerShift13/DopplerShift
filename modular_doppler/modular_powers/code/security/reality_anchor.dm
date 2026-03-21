/obj/structure/reality_anchor
	name = "miniature reality anchor"
	desc = "The chiseled out parts of a broken down reality anchor. Crude machinery is managing to keep it docile; but when enabled, it will start enforcing normality back in a large area around it."
	icon = 'modular_doppler/modular_powers/icons/items/reality_anchor.dmi'
	icon_state = "reality_anchor"
	density = TRUE

	// Is it on/off
	var/active = FALSE

	// Pulse interval
	var/pulse_interval = 6 SECONDS
	var/next_pulse_time = 0

	// Range in turfs
	var/pulse_range = 6

	// Ripple filter while active.
	var/ripple_filter_id = "reality_anchor_ripple"

/obj/structure/reality_anchor/Destroy()
	STOP_PROCESSING(SSobj, src)
	apply_ripple_filter(FALSE)
	. = ..()

// Turns the thing on or off after the do_after.
/obj/structure/reality_anchor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/action_word = active ? "deactivate" : "activate"
	var/action_word_past_tense = active ? "deactivating" : "activating"
	user.visible_message(
		span_warning("[user] begins to [action_word] the reality anchor..."),
		span_warning("You begin to [action_word] the reality anchor...")
	)
	if(!do_after(user, 3 SECONDS, target = src))
		return
	user.visible_message(
		span_warning("[user] finishes [action_word_past_tense] the reality anchor."),
		span_warning("You finish [action_word_past_tense] the reality anchor.")
	)
	toggle_anchor(user)

// Switches it on or off.
/obj/structure/reality_anchor/proc/toggle_anchor(mob/user)
	active = !active
	if(active)
		anchored = TRUE
		apply_ripple_filter(TRUE)
		playsound(launched, 'sound/effects/magic/repulse.ogg', 75, TRUE)
		pulse()
		next_pulse_time = world.time + pulse_interval
		START_PROCESSING(SSobj, src)
		return
	anchored = FALSE
	apply_ripple_filter(FALSE)
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

// Applies a rippling effect.
/obj/structure/reality_anchor/proc/apply_ripple_filter(active_state)
	if(active_state)
		add_filter(ripple_filter_id, 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
		var/filter = get_filter(ripple_filter_id)
		if(filter)
			animate(filter, radius = 0, time = 0.2 SECONDS, size = 2, easing = JUMP_EASING, loop = -1, flags = ANIMATION_PARALLEL)
			animate(radius = 32, time = 1.5 SECONDS, size = 0)
		return
	remove_filter(ripple_filter_id)

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
	icon = 'modular_doppler/modular_powers/icons/items/reality_anchor.dmi'
	icon_state = "reality_anchor"

// The effect from reality anchors
/obj/effect/temp_visual/circle_wave/reality_anchor
	color = COLOR_SILVER
	max_alpha = 20
	duration = 0.5 SECONDS
	amount_to_scale = 6

/obj/structure/reality_anchor/update_overlays()
	. = ..()
