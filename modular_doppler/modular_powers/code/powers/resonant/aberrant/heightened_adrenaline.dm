/*
	Physical damage is a myth, only stopping power gets you to slow the fuck down.
	Gain a buff that grants resistance to damage slows, generates Determination, and immunity to soft-crit.
	Counters burst-damage given the floor and especially projectiles with wound-bonuses, giving you to the edge to fight or flight, especially with the high amounts of lingering Determination.
*/
/datum/power/aberrant/heightened_adrenaline
	name = "Heightened Adrenaline"
	desc = "Physical damage barely keeps you down: only stopping power does. For every point of brute or burn damage you gain, gain a stacking buff called Adrenaline. You also gain Adrenaline when receiving a wound, proportional to severity.\
	\nWhilst you have at least 5 stacks of Adrenaline: you become immmune to damage slowdown, you build up Determination in your system, and you remain standing when entering soft crit whilst it is active.\
	\nYou lose a stack of Adrenaline every 0.25 seconds. You cannot gain Adrenaline after you go down in critical condition, or are otherwise unconscious. \
	You also become discoordinated when it comes to your manual dexterity whilst active, preventing you from interacting with many objects, including firearms, whilst you have 5 or more stacks."
	security_record_text = "Subject experiences extreme bursts of adrenaline when exposed to high physical trauma in a short span of time."
	value = 4
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	required_powers = list(/datum/power/aberrant_root/monstrous)
	magic_flags = NONE // non-magical

	menu_icon = 'icons/mob/actions/actions_changeling.dmi'
	menu_icon_state = "adrenaline"

	/// Time between each Adrenaline stack decaying.
	var/stack_drain_interval = 0.25 SECONDS
	/// Stacks required before Adrenaline grants its benefits.
	var/minimum_stacks = 5
	/// Determination generated on each Adrenaline decay tick while its benefits are active. Determination drains by 0.15 per tick so semi-equilibrium.
	var/determination_per_tick = 0.16

/datum/power/aberrant/heightened_adrenaline/post_add(client/client_source)
	. = ..()
	RegisterSignals(power_holder, list(COMSIG_MOB_AFTER_APPLY_DAMAGE, COMSIG_CARBON_GAIN_WOUND), PROC_REF(gain_adrenaline))

/datum/power/aberrant/heightened_adrenaline/remove()
	UnregisterSignal(power_holder, list(COMSIG_MOB_AFTER_APPLY_DAMAGE, COMSIG_CARBON_GAIN_WOUND))
	power_holder?.remove_status_effect(/datum/status_effect/heightened_adrenaline)
	return ..()

/// Gains Adrenaline from brute or burn damage, as well as when a wound is triggered, giving the same amount as it would've given Determination.
/datum/power/aberrant/heightened_adrenaline/proc/gain_adrenaline(datum/source, amount, damage_type)
	SIGNAL_HANDLER

	if(power_holder.stat != CONSCIOUS)
		return

	// Raw damage has an amount so we pass it along.
	if(source == power_holder && (damage_type in list(BRUTE, BURN)) && amount > 0)
		power_holder.apply_status_effect(/datum/status_effect/heightened_adrenaline, amount, stack_drain_interval, minimum_stacks, determination_per_tick)
		return

	// Check if its a wound.
	if(source != power_holder || !istype(amount, /datum/wound))
		return

	// Give adrenaline equal to the amount of determination we gain.
	var/datum/wound/gained_wound = amount
	var/adrenaline_to_add
	switch(gained_wound.severity)
		if(WOUND_SEVERITY_MODERATE)
			adrenaline_to_add = WOUND_DETERMINATION_MODERATE
		if(WOUND_SEVERITY_SEVERE)
			adrenaline_to_add = WOUND_DETERMINATION_SEVERE
		if(WOUND_SEVERITY_CRITICAL)
			adrenaline_to_add = WOUND_DETERMINATION_CRITICAL
		if(WOUND_SEVERITY_LOSS)
			adrenaline_to_add = WOUND_DETERMINATION_LOSS
	if(adrenaline_to_add)
		power_holder.apply_status_effect(/datum/status_effect/heightened_adrenaline, adrenaline_to_add, stack_drain_interval, minimum_stacks, determination_per_tick)

/// A rapidly fading resistance to damage-based slowdown and soft-crit. Only effective at 5 stacks, so micro-damage doesn't proc it.
/datum/status_effect/heightened_adrenaline
	id = "heightened_adrenaline"
	duration = STATUS_EFFECT_PERMANENT
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	show_duration = FALSE
	/// Current Adrenaline intensity.
	var/stacks = 0
	/// Maximum Adrenaline stacks you can have at a time.
	var/max_stacks = 100
	/// Stacks required before the combat benefits activate.
	var/minimum_stacks = 5
	/// Determination generated on each decay tick while the threshold benefits are active.
	var/determination_per_tick = 0.16
	/// Whether the threshold benefits are currently applied.
	var/active = FALSE
	/// The visible alert, created only while Adrenaline is active.
	var/atom/movable/screen/alert/status_effect/heightened_adrenaline/active_alert

/datum/status_effect/heightened_adrenaline/on_creation(mob/living/new_owner, stacks_to_add, stack_drain_interval, minimum_stacks, determination_per_tick)
	tick_interval = stack_drain_interval
	// Tick-interval alone does not function with dynamic durations so we have to include upperbound and lowerbound
	tick_interval_lowerbound = stack_drain_interval
	tick_interval_upperbound = stack_drain_interval
	src.minimum_stacks = minimum_stacks
	src.determination_per_tick = determination_per_tick
	. = ..()
	if(!.)
		return
	adjust_stacks(stacks_to_add)

/datum/status_effect/heightened_adrenaline/refresh(effect, stacks_to_add, stack_drain_interval, minimum_stacks, determination_per_tick)
	. = ..()
	tick_interval_lowerbound = stack_drain_interval
	tick_interval_upperbound = stack_drain_interval
	src.minimum_stacks = minimum_stacks
	src.determination_per_tick = determination_per_tick
	adjust_stacks(stacks_to_add)

// Adds adrenaline and ticks down the stacks.
/datum/status_effect/heightened_adrenaline/tick(seconds_between_ticks)
	if(active)
		owner.reagents.add_reagent(/datum/reagent/determination, determination_per_tick)
	adjust_stacks(-1)

/datum/status_effect/heightened_adrenaline/on_remove()
	set_active(FALSE)

/// Adjusts the stack total, deleting the effect once it has lost of all of its stacks.
/datum/status_effect/heightened_adrenaline/proc/adjust_stacks(amount)
	stacks = clamp(stacks + amount, 0, max_stacks)
	if(stacks <= 0)
		qdel(src)
		return
	set_active(stacks >= minimum_stacks)
	if(active_alert)
		active_alert.maptext = MAPTEXT_TINY_UNICODE("<span style='text-align:center'>[floor(stacks)]</span>")

/// Applies or removes the mobility and critical-condition benefits.
/datum/status_effect/heightened_adrenaline/proc/set_active(should_be_active)
	if(active == should_be_active)
		return
	active = should_be_active
	if(active)
		owner.add_movespeed_mod_immunities(id, /datum/movespeed_modifier/damage_slowdown)
		owner.add_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOGUNS, TRAIT_DISCOORDINATED_TOOL_USER), TRAIT_STATUS_EFFECT(id))
		active_alert = owner.throw_alert(id, /atom/movable/screen/alert/status_effect/heightened_adrenaline)
		active_alert.attached_effect = src
		return
	owner.remove_movespeed_mod_immunities(id, /datum/movespeed_modifier/damage_slowdown)
	owner.remove_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOGUNS, TRAIT_DISCOORDINATED_TOOL_USER), TRAIT_STATUS_EFFECT(id))
	owner.clear_alert(id)
	active_alert = null

/atom/movable/screen/alert/status_effect/heightened_adrenaline
	name = "Heightened Adrenaline"
	desc = "Adrenaline keeps you moving, suppressing damage slowdown and preventing soft-crit from downing you."
	icon = 'icons/mob/actions/actions_changeling.dmi'
	icon_state = "adrenaline"
