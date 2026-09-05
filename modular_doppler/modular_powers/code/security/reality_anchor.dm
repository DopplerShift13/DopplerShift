/obj/machinery/reality_anchor
	name = "miniature reality anchor"
	desc = "The chiseled out Eschatite remains of an anchor, smoothed and cobbled together. Crude machinery is managing to keep it docile; but when enabled, it will start enforcing normality back in a large area around it."
	icon = 'modular_doppler/modular_powers/icons/items/reality_anchor.dmi'
	icon_state = "reality_anchor"
	density = TRUE
	anchored = FALSE
	max_integrity = 600 // tonky
	use_power = NO_POWER_USE
	active_power_usage = 5 KILO WATTS
	processing_flags = START_PROCESSING_MANUALLY

	/// Is it on/off
	var/active = FALSE

	/// Pulse interval
	var/pulse_interval = 6 SECONDS
	/// Time until the next pulse
	var/next_pulse_time = 0

	/// Range in turfs
	var/pulse_range = 6
	/// Baseline energy consumed by each pulse.
	var/base_pulse_energy_usage = 50 KILO JOULES
	/// Maximum proportional variance from the baseline active and pulse consumption.
	var/consumption_variance = 0.25
	/// Energy that the most recent pulse attempted to consume.
	var/current_pulse_energy_usage

	/// Ripple filter while active.
	var/ripple_filter_id = "reality_anchor_ripple"

/obj/machinery/reality_anchor/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_PSYKER_MANIPULATE, PROC_REF(on_manipulate))

/obj/machinery/reality_anchor/Destroy()
	STOP_PROCESSING(SSobj, src)
	apply_ripple_filter(FALSE)
	. = ..()

/// Makes it so that examining the reality anchor adds a red text to indicate that they do not like reality anchors.
/obj/machinery/reality_anchor/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	if(living_user.has_power_in_archetype(POWER_ARCHETYPE_SORCEROUS, magic_filter = POWER_MAGIC_FILTER_MAGICAL) || living_user.has_power_in_archetype(POWER_ARCHETYPE_RESONANT, magic_filter = POWER_MAGIC_FILTER_MAGICAL))
		. += span_bold(span_red("Even looking at it makes you feel uncomfortable."))

// Turns the thing on or off after the do_after.
/obj/machinery/reality_anchor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!active && !powered(ignore_use_power = TRUE))
		balloon_alert(user, "no power supply!")
		return
	var/action_word = active ? "deactivate" : "activate"
	var/action_word_past_tense = active ? "deactivating" : "activating"
	user.visible_message(
		span_warning("[user] begins to [action_word] the reality anchor..."),
		span_warning("You begin to [action_word] the reality anchor...")
	)
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(!toggle_anchor(user))
		return
	user.visible_message(
		span_warning("[user] finishes [action_word_past_tense] the reality anchor."),
		span_warning("You finish [action_word_past_tense] the reality anchor.")
	)

/// Reality anchors cannot be operated with genetic telekinesis.
/obj/machinery/reality_anchor/attack_tk(mob/user)
	trigger_remote_interaction_backlash(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// Prevents Psyker Manipulate from falling through to the anchor's hand interaction.
/obj/machinery/reality_anchor/proc/on_manipulate(datum/source, mob/living/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(trigger_remote_interaction_backlash), user)
	return COMPONENT_PSYKER_MANIPULATE_HANDLED

/// Blasts anyone attempting to interact with the anchor through telekinetic means.
/obj/machinery/reality_anchor/proc/trigger_remote_interaction_backlash(mob/user)
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	to_chat(living_user, span_userdanger("Reaching out to the [name] exposes you to a heavy blast of anti-resonant force!"))
	if(!living_user.can_block_resonance(0) && !living_user.mind?.has_antag_datum(/datum/antagonist/heretic))
		living_user.apply_status_effect(/datum/status_effect/power/reality_anchor_silenced)
	living_user.dispel(src, DISPEL_CASCADE_CARRIED)
	living_user.emote("scream", forced = TRUE)

/// An EMP forces an active reality anchor to shut down.
/obj/machinery/reality_anchor/emp_act(severity)
	. = ..()
	if(!active || (. & EMP_PROTECT_SELF))
		return
	toggle_anchor()

/// Switches it on or off.
/obj/machinery/reality_anchor/proc/toggle_anchor(mob/user)
	if(active)
		active = FALSE
		anchored = FALSE
		update_use_power(NO_POWER_USE)
		apply_ripple_filter(FALSE)
		STOP_PROCESSING(SSobj, src)
		return TRUE
	if(!powered(ignore_use_power = TRUE))
		balloon_alert(user, "no power supply!")
		return FALSE
	active = TRUE
	anchored = TRUE
	update_use_power(ACTIVE_POWER_USE)
	apply_ripple_filter(TRUE)
	playsound(src, 'sound/effects/magic/repulse.ogg', 75, TRUE)
	pulse()
	if(!active) // pulsing may consume the last ounce of energy and forcefully turn it off.
		return FALSE
	next_pulse_time = world.time + pulse_interval
	START_PROCESSING(SSobj, src)
	return TRUE

// Countdown til dispel pulse.
/obj/machinery/reality_anchor/process(seconds_per_tick)
	if(!active)
		return
	if(!powered()) // turn off the anchor if we lose power
		toggle_anchor()
		return
	if(world.time < next_pulse_time)
		return
	pulse()
	next_pulse_time = world.time + pulse_interval

/// Dispel AoE effect.
/obj/machinery/reality_anchor/proc/pulse()
	randomize_power_consumption()
	if(!use_energy(current_pulse_energy_usage, force = FALSE)) // tries to consume a spike of energy
		toggle_anchor()
		return
	var/turf/center = get_turf(src)
	if(!center)
		return
	var/obj/effect/temp_visual/circle_wave/reality_anchor/pulse_fx = new(center)
	pulse_fx.amount_to_scale = pulse_range + 2 // falls short without the +1
	// We get EVERYTHING in range and dispel it. This shouldn't be too much of a lag-machine (hopefully)
	for(var/atom/movable/target in range(pulse_range, center))
		if(isliving(target))
			var/mob/living/living_target = target
			// Being immune to resonance or a heretic prevents the application of the silence effect
			if(!living_target.can_block_resonance() && !living_target.mind?.has_antag_datum(/datum/antagonist/heretic))
				living_target.apply_status_effect(/datum/status_effect/power/reality_anchor_silenced)
			living_target.dispel(src, DISPEL_CASCADE_CARRIED)
		else if(isobj(target))
			target.dispel(src)

/// Because it is unpredictable resonant nonsense, as a flavor-thing we randomize the power consumption of the anchor whilst it is active.
/// Gets the base value, applies a random variance, sets the value to the new value. This happesn every pulse.
/obj/machinery/reality_anchor/proc/randomize_power_consumption()
	update_mode_power_usage(ACTIVE_POWER_USE, rand(
		initial(active_power_usage) * (1 - consumption_variance),
		initial(active_power_usage) * (1 + consumption_variance),
	))
	current_pulse_energy_usage = rand(
		base_pulse_energy_usage * (1 - consumption_variance),
		base_pulse_energy_usage * (1 + consumption_variance),
	)

/// Applies a rippling effect.
/obj/machinery/reality_anchor/proc/apply_ripple_filter(active_state)
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
	tick_interval = 1 SECONDS
	/// The owner's power archetype when this effect was applied.
	var/owner_archetype = POWER_ARCHETYPE_MORTAL
	/// Whether mental antimagic blocked the psychological effects when this status was applied.
	var/mental_effects_blocked = FALSE
	/// Filter key used on the owner's game plane master.
	var/blur_filter_id = "reality_anchor_blur"
	/// Exact plane master carrying our filter, retained for reliable cleanup.
	var/atom/movable/plane_master_controller/blur_plane_master_controller

/datum/status_effect/power/reality_anchor_silenced/on_apply()
	set_anchor_archetype()
	// Checks if mental antimagic existed on the mob upon application, which blocks all the negative mental effects, but not the silence.
	mental_effects_blocked = owner.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0)
	if(mental_effects_blocked && owner_archetype != POWER_ARCHETYPE_MORTAL) // only show if it would've done something to the owner.
		to_chat(owner, span_warning("Your mental resistance shields you from the excruciating effects of having your powers suppressed!"))
	else
		send_initial_message()
		if(owner_archetype != POWER_ARCHETYPE_MORTAL) // non-mortals hear a grating sound
			owner.playsound_local(owner, 'sound/effects/curse/curse5.ogg', 50, FALSE) // specifically this one because it sounds like a scream.
	ADD_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAIT_STATUS_EFFECT(id))
	if(!mental_effects_blocked)
		apply_mental_effects()
	return TRUE

/datum/status_effect/power/reality_anchor_silenced/on_remove()
	REMOVE_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAIT_STATUS_EFFECT(id))
	clear_mental_effects()
	return

// Rechecks mental antimagic when the status effect is refreshed.
/datum/status_effect/power/reality_anchor_silenced/refresh(effect, ...)
	. = ..()
	var/mental_effects_were_blocked = mental_effects_blocked
	mental_effects_blocked = owner.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0)
	if(mental_effects_blocked == mental_effects_were_blocked)
		return
	if(mental_effects_blocked)
		clear_mental_effects()
		return
	apply_mental_effects()

/// Applies the mood and visual effects that mental antimagic can block.
/datum/status_effect/power/reality_anchor_silenced/proc/apply_mental_effects()
	owner.add_mood_event(id, get_anchor_moodlet())
	var/screen_effect_type = get_anchor_screen_effect()
	if(screen_effect_type)
		owner.overlay_fullscreen("reality_anchor_static", screen_effect_type)
	apply_anchor_blur()

/// Clears the mood, visual, and audio effects that mental antimagic can block.
/datum/status_effect/power/reality_anchor_silenced/proc/clear_mental_effects()
	owner.clear_mood_event(id)
	owner.clear_fullscreen("reality_anchor_static")
	owner.stop_sound_channel(CHANNEL_HEARTBEAT)
	clear_anchor_blur()

/datum/status_effect/power/reality_anchor_silenced/tick(seconds_between_ticks)
	if(mental_effects_blocked || owner_archetype == POWER_ARCHETYPE_MORTAL) // normies and the mentally shielded don't hear the heartbeat
		return
	owner.playsound_local(owner, 'sound/effects/health/slowbeat.ogg', 40, FALSE, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)

/// Warns the owner when the anchor's silence is first applied.
/datum/status_effect/power/reality_anchor_silenced/proc/send_initial_message()
	if(owner_archetype == POWER_ARCHETYPE_SORCEROUS)
		to_chat(owner, span_userdanger("You sense your powers being suppressed, and you are wracked with an excruciating pain spreading throughout your entire body! MAKE IT STOP!"))
		return
	if(owner_archetype == POWER_ARCHETYPE_RESONANT)
		to_chat(owner, span_boldwarning("You sense your powers being suppressed, and you begin to feel extremely unwell!"))
	// no message for mortal since they barely notice anything.

/// Determines and stores the owner's archetype for all of the anchor's effects.
/datum/status_effect/power/reality_anchor_silenced/proc/set_anchor_archetype()
	owner_archetype = POWER_ARCHETYPE_MORTAL
	if(owner.has_power_in_archetype(POWER_ARCHETYPE_SORCEROUS, magic_filter = POWER_MAGIC_FILTER_MAGICAL))
		owner_archetype = POWER_ARCHETYPE_SORCEROUS
		return
	if(owner.has_power_in_archetype(POWER_ARCHETYPE_RESONANT, magic_filter = POWER_MAGIC_FILTER_MAGICAL))
		owner_archetype = POWER_ARCHETYPE_RESONANT

/// Delegates the appropriate moodlet to the appropriate archetype.
/datum/status_effect/power/reality_anchor_silenced/proc/get_anchor_moodlet()
	if(owner_archetype == POWER_ARCHETYPE_SORCEROUS)
		return /datum/mood_event/reality_anchor_silenced/sorcerous
	if(owner_archetype == POWER_ARCHETYPE_RESONANT)
		return /datum/mood_event/reality_anchor_silenced/resonant
	return /datum/mood_event/reality_anchor_silenced/mortal

/// Returns the static overlay appropriate for the owner's archetype. Mortals receive no overlay.
/datum/status_effect/power/reality_anchor_silenced/proc/get_anchor_screen_effect()
	if(owner_archetype == POWER_ARCHETYPE_SORCEROUS)
		return /atom/movable/screen/fullscreen/reality_anchor_static/sorcerous
	if(owner_archetype == POWER_ARCHETYPE_RESONANT)
		return /atom/movable/screen/fullscreen/reality_anchor_static/resonant
	return null

/// Applies a constant radial blur to the owner's rendered game plane.
/datum/status_effect/power/reality_anchor_silenced/proc/apply_anchor_blur()
	var/blur_size = get_anchor_blur_size()
	if(!blur_size || !owner.hud_used)
		return
	blur_plane_master_controller = owner.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	if(!blur_plane_master_controller)
		return
	blur_plane_master_controller.add_filter(blur_filter_id, 1, list("type" = "radial_blur", "size" = blur_size))

/// Removes the reality anchor's blur without disturbing other game-plane filters.
/datum/status_effect/power/reality_anchor_silenced/proc/clear_anchor_blur()
	if(!QDELETED(blur_plane_master_controller))
		blur_plane_master_controller.remove_filter(blur_filter_id)
	blur_plane_master_controller = null

/// Returns blur strength appropriate for the owner's archetype. Mortals receive no blur.
/datum/status_effect/power/reality_anchor_silenced/proc/get_anchor_blur_size()
	if(owner_archetype == POWER_ARCHETYPE_SORCEROUS)
		return 0.02
	if(owner_archetype == POWER_ARCHETYPE_RESONANT)
		return 0.01
	return 0

/atom/movable/screen/fullscreen/reality_anchor_static
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "noise"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#202852"

/atom/movable/screen/fullscreen/reality_anchor_static/sorcerous
	alpha = 140

/atom/movable/screen/fullscreen/reality_anchor_static/resonant
	alpha = 70

/atom/movable/screen/alert/status_effect/reality_anchor_silenced
	name = "Silenced"
	desc = "Resonant powers are supressed around the reality anchor!"
	icon = 'modular_doppler/modular_powers/icons/items/reality_anchor.dmi'
	icon_state = "reality_anchor"

/datum/mood_event/reality_anchor_silenced
	description = "I feel like something's different in the air."
	mood_change = 0

/datum/mood_event/reality_anchor_silenced/sorcerous
	description = "MY WHOLE BODY WRITHES WITHOUT THE MAGIC THAT SUSTAINS IT, LIKE IT IS DROWNING IN A BLEACHED MORASS OF MUNDANITY!"
	mood_change = -20
	special_screen_obj = "mood_despair"

/datum/mood_event/reality_anchor_silenced/resonant
	description = "My chest hurts, my stomach cramps, my mind aches. My magic is supressed; and it makes me sick!"
	mood_change = -10
	special_screen_obj = "mood_happiness_bad"

/datum/mood_event/reality_anchor_silenced/mortal
	description = "I feel like something's different in the air."
	mood_change = 0

// The effect from reality anchors
/obj/effect/temp_visual/circle_wave/reality_anchor
	color = COLOR_SILVER
	max_alpha = 20
	duration = 0.5 SECONDS
	amount_to_scale = 7
