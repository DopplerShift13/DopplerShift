/datum/power/cultivator/fly_like_a_shooting_star
	name = "Fly Like A Shooting Star"
	desc = "Whilst your alignment is active, you can fly. You can propel yourself through the air and space as if wearing a jetpack. \
	If you aren't able to use your legs, you're able to move around with this ability, regardless of the current gravity."
	security_record_text = "Subject can fly regardless of gravitational environment whilst in their heightened state."
	value = 3
	required_powers = list(/datum/power/cultivator_root/astral_touched)

	/// the trailing particles
	var/datum/effect_system/trail_follow/ion/grav_allowed/flight_trail
	/// ref to the root power's action
	var/datum/action/cooldown/power/cultivator/alignment/astral_touched/astral_alignment

/datum/power/cultivator/fly_like_a_shooting_star/add(client/client_source)
	. = ..()
	if(!power_holder)
		return
	RegisterSignal(power_holder, COMSIG_CULTIVATOR_ALIGNMENT_ENABLED, PROC_REF(on_alignment_enabled))
	RegisterSignal(power_holder, COMSIG_CULTIVATOR_ALIGNMENT_DISABLED, PROC_REF(on_alignment_disabled))

/datum/power/cultivator/fly_like_a_shooting_star/remove()
	if(power_holder)
		UnregisterSignal(power_holder, list(COMSIG_CULTIVATOR_ALIGNMENT_ENABLED, COMSIG_CULTIVATOR_ALIGNMENT_DISABLED))
		remove_flight(power_holder)
	. = ..()

/// When alignemnt is enabled, start flying
/datum/power/cultivator/fly_like_a_shooting_star/proc/on_alignment_enabled(mob/living/user, datum/action/cooldown/power/cultivator/alignment/alignment_action)
	SIGNAL_HANDLER
	if(!istype(alignment_action, /datum/action/cooldown/power/cultivator/alignment/astral_touched))
		return
	apply_flight(user)

/// When alignment is disabled, stop flying
/datum/power/cultivator/fly_like_a_shooting_star/proc/on_alignment_disabled(mob/living/user, datum/action/cooldown/power/cultivator/alignment/alignment_action)
	SIGNAL_HANDLER
	if(!istype(alignment_action, /datum/action/cooldown/power/cultivator/alignment/astral_touched))
		return
	remove_flight(user)

/// Adds the flight traits and particles on alignment activation
/datum/power/cultivator/fly_like_a_shooting_star/proc/apply_flight(mob/living/user)
	if(!user)
		return
	user.AddElementTrait(TRAIT_ASTRAL_TOUCHED_FLIGHT, REF(src), /datum/element/forced_gravity, 0)
	user.AddElementTrait(TRAIT_ASTRAL_TOUCHED_FLIGHT, REF(src), /datum/element/simple_flying)
	if(!flight_trail)
		flight_trail = new
	flight_trail.set_up(user)
	flight_trail.start()

/// Removes the flight trait and particles on alignment deactivation
/datum/power/cultivator/fly_like_a_shooting_star/proc/remove_flight(mob/living/user)
	if(!user)
		return
	REMOVE_TRAIT(user, TRAIT_ASTRAL_TOUCHED_FLIGHT, REF(src))
	if(flight_trail)
		flight_trail.stop()
		QDEL_NULL(flight_trail)
