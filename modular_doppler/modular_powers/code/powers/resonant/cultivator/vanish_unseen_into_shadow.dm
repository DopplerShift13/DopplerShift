/*
	Untrackable by resonant means and no slowdown in darkness. Quick getaways ahoy.
*/

/datum/power/cultivator/vanish_unseen_into_shadow
	name = "Vanish Unseen into Shadow"
	desc = "You are untrackable within the shadows. You are immune to resonant scrying and slowdowns while you're stood in darkness or are in alignment."
	security_record_text = "Subject is exceedingly fast and immune to resonant-based detection while stood in darkness."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/cultivator_root/shadow_walker)
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES

	/// Cached alignment action for gating effects.
	var/datum/action/cooldown/power/cultivator/alignment/shadow_walker/shadow_walker_alignment
	/// Current instance of the status effect
	var/datum/status_effect/power/vanish_unseen_into_shadow/active_effect

// Cleanup lingering effects
/datum/power/cultivator/vanish_unseen_into_shadow/remove()
	if(active_effect)
		qdel(active_effect)
		active_effect = null
	return ..()

// Keeps the status effect applied while in darkness or alignment.
/datum/power/cultivator/vanish_unseen_into_shadow/process(seconds_per_tick)
	var/mob/living/user = power_holder
	if(!user)
		return

	var/should_apply = is_in_darkness(user) || is_shadow_walker_alignment_active(user)
	if(should_apply)
		if(!active_effect || QDELETED(active_effect))
			active_effect = user.apply_status_effect(/datum/status_effect/power/vanish_unseen_into_shadow)
		return

	if(active_effect)
		qdel(active_effect)
		active_effect = null

/// Are we in a dark space?
/datum/power/cultivator/vanish_unseen_into_shadow/proc/is_in_darkness(mob/living/user)
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE
	return user_turf.get_lumcount() <= LIGHTING_TILE_IS_DARK

/// Gets and sets our alignment if its not there; then checks if its active.
/datum/power/cultivator/vanish_unseen_into_shadow/proc/is_shadow_walker_alignment_active(mob/living/user)
	if(!shadow_walker_alignment || QDELETED(shadow_walker_alignment))
		for(var/datum/action/cooldown/power/cultivator/alignment/shadow_walker/alignment_action in user.actions)
			shadow_walker_alignment = alignment_action
			break
		if(!shadow_walker_alignment)
			return FALSE
	return shadow_walker_alignment.active

// Status effect that handles the bonuses.
/datum/status_effect/power/vanish_unseen_into_shadow
	id = "vanish_unseen_into_shadow"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/vanish_unseen_into_shadow

/datum/status_effect/power/vanish_unseen_into_shadow/on_apply()
	if(!owner)
		return FALSE
	owner.ignore_slowdown(type)
	ADD_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, type)
	return TRUE

/datum/status_effect/power/vanish_unseen_into_shadow/on_remove()
	if(owner)
		owner.unignore_slowdown(type)
		REMOVE_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, type)
	return

/atom/movable/screen/alert/status_effect/vanish_unseen_into_shadow
	name = "Vanish Unseen Into Shadow"
	desc = "You are undetectable through scrying and are unaffected by slowdowns."
	icon = 'icons/effects/effects.dmi'
	icon_state = "blank"
