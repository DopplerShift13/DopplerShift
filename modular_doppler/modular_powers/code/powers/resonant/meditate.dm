/* Since this is used by two different archetypes there will be a bit of snowflaking.
Reduces stress for psykers and restores Energy for cultivators
*/

/datum/action/cooldown/power/resonant_meditate
	name = "Resonant Meditation"
	desc = "Restores the full potential of your resonant powers."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "chuuni"

	/// Both Cultivator and Psyker can benefit from meditate.
	var/psyker_spotlight_color = "#ba2cc9"

	/// Reference to the psyker organ, if any
	var/obj/item/organ/resonant/psyker/psyker_organ
	/// Reference to the cultivator energy component, if any
	var/datum/component/cultivator_energy/cultivator_energy

	/// used for the do while loop
	var/keep_going

// Makes it end meditation by clicking it again.
/datum/action/cooldown/power/resonant_meditate/Trigger(mob/clicker, trigger_flags, atom/target)
	if(active)
		keep_going = FALSE
	else
		. = ..()
	return TRUE

/datum/action/cooldown/power/resonant_meditate/use_action()
	. = ..()
	keep_going = TRUE
	var/mob/living/spotlighttarget = owner // cause we need to call it on a mob/living

	to_chat(owner, span_notice("You start meditating."))
	// Gets the owner's psyker organ & cultivator component
	update_components()
	// Adds visual effects
	var/list/spotlight_config = get_meditation_spotlight_config(owner)
	spotlighttarget.apply_status_effect(/datum/status_effect/spotlight_light/meditation, 3000, null, spotlight_config["color"], spotlight_config["emit_light"])
	do
		active = TRUE
		if(do_after(owner, 25, target = owner))
			if(user_has_active_power(owner))
				to_chat(owner, span_notice("You have active abilities draining your resources!"))
				keep_going = FALSE
				break
			if(!psyker_organ && !cultivator_energy)
				to_chat(owner, span_notice("I have nothing to meditate on!"))
			if(psyker_organ)
				psyker_organ.modify_stress(-PSYKER_STRESS_MEDITATION_POWER)
				if(psyker_organ.stress <= 0)
					to_chat(owner, span_notice("I no longer feel any stress"))
			if(cultivator_energy)
				cultivator_energy.adjust_energy(CULTIVATOR_ENERGY_MEDITATION_POWER)
				if(cultivator_energy.energy >= CULTIVATOR_ENERGY_MAX)
					to_chat(owner, span_notice("My Energy is fully charged."))
		else
			keep_going = FALSE
			break
	while (keep_going)

	to_chat(owner, span_notice("You stop meditating."))
	active = FALSE
	spotlighttarget.remove_status_effect(/datum/status_effect/spotlight_light/meditation)
	return

/// Changes the colors on meditate to whatever matches alignment.
/datum/action/cooldown/power/resonant_meditate/proc/get_meditation_spotlight_config(mob/living/user)
	var/list/config = list(
		"color" = null,
		"emit_light" = TRUE,
	)
	var/datum/action/cooldown/power/cultivator/alignment/alignment_action = get_alignment_action(user)
	if(alignment_action)
		config["color"] = alignment_action.alignment_outline_color
		config["emit_light"] = should_alignment_spotlight_emit_light(alignment_action)
		return config
	if(psyker_organ) // alignment color gets priority over psyker.
		config["color"] = psyker_spotlight_color
	return config

/// Gets the first alignment action that's used as our root.
/datum/action/cooldown/power/resonant_meditate/proc/get_alignment_action(mob/living/user)
	if(!user)
		return null
	var/datum/action/cooldown/power/cultivator/alignment/first_alignment
	for(var/datum/action/cooldown/power/cultivator/alignment/alignment_action in user.actions)
		if(!first_alignment)
			first_alignment = alignment_action
		if(alignment_action.active)
			return alignment_action
	return first_alignment

/// Checkes if we need to emit light; basically no dark colors.
/datum/action/cooldown/power/resonant_meditate/proc/should_alignment_spotlight_emit_light(datum/action/cooldown/power/cultivator/alignment/alignment_action)
	if(!alignment_action)
		return TRUE
	var/alignment_color = alignment_action.alignment_outline_color
	// Dark colors should not emit a light source.
	if(alignment_color && is_color_dark(alignment_color))
		return FALSE
	return TRUE

/// gets the psyker organ and the cultivator component
/datum/action/cooldown/power/resonant_meditate/proc/update_components()
	psyker_organ = owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	cultivator_energy = owner.GetComponent(/datum/component/cultivator_energy)

/// Returns TRUE if any active Cultivator or Psyker power is active on the target.
/datum/action/cooldown/power/resonant_meditate/proc/user_has_active_power(mob/living/user)
	if(!istype(user, /mob/living) || !user.powers)
		return FALSE
	for(var/datum/power/power in user.powers)
		if(power.path != POWER_PATH_CULTIVATOR && power.path != POWER_PATH_PSYKER)
			continue
		var/datum/action/cooldown/power/action = power.action_path
		if(action && action.active)
			return TRUE
	return FALSE

// Meditation spotlight with runtime color/light config.
/datum/status_effect/spotlight_light/meditation
	id = "meditation_spotlight"
	var/emit_light = TRUE

/datum/status_effect/spotlight_light/meditation/on_creation(mob/living/new_owner, duration, additional_overlay, custom_spotlight_color, custom_emit_light)
	if(!isnull(custom_spotlight_color))
		spotlight_color = custom_spotlight_color
	if(!isnull(custom_emit_light))
		emit_light = custom_emit_light
	. = ..()

/datum/status_effect/spotlight_light/meditation/on_apply()
	if(emit_light)
		return ..()

	beam_from_above_a = new /obj/effect/overlay/spotlight
	beam_from_above_a.color = spotlight_color
	beam_from_above_a.alpha = 62
	owner.vis_contents += beam_from_above_a
	beam_from_above_a.layer = BELOW_MOB_LAYER

	beam_from_above_b = new /obj/effect/overlay/spotlight
	beam_from_above_b.color = spotlight_color
	beam_from_above_b.alpha = 62
	beam_from_above_b.layer = ABOVE_MOB_LAYER
	beam_from_above_b.pixel_y = -2 // Slight vertical offset for an illusion of volume.
	owner.vis_contents += beam_from_above_b

	if(additional_overlay)
		owner.add_overlay(additional_overlay)
	return TRUE
