/datum/action/cooldown/spell/resonant_meditate
	name = "Resonant Meditation"
	desc = "Restores the full potential of your resonant powers."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "chuuni"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 6 SECONDS // Just don't let people spam it on or off.


	// Both Cultivator and Psyker can benefit from meditate.

	// The components responsible for meditation.
	var/obj/item/organ/resonant/psyker/psyker_organ
	var/cultivator_organ //TODO: Cultivator Organ

/datum/action/cooldown/spell/resonant_meditate/cast()
	. = ..()
	var/keep_going = TRUE
	var/mob/living/spotlighttarget = owner // cause we need to call it on a mob/living

	to_chat(owner, "You start meditating.")
	update_organs()
	// Adds visual effects
	var/datum/status_effect/spotlight_light/light = get_spotlight_color()
	spotlighttarget.apply_status_effect(light, 300)
	do
		if(do_after(owner, 25, target = owner))
			if(!psyker_organ)
				to_chat(owner, "I have nothing to meditate on!")
				keep_going = FALSE
			if(psyker_organ)
				psyker_organ.remove_stress(PSYKER_STRESS_MEDITATION_POWER)
				if(psyker_organ.stress <= 0)
					to_chat(owner, "I no longer feel any stress")
					keep_going = FALSE
		else
			keep_going = FALSE
	while (keep_going)

	to_chat(owner, "You stop meditating.")
	spotlighttarget.remove_status_effect(light)
	return

/datum/action/cooldown/spell/resonant_meditate/proc/get_spotlight_color()

	if(psyker_organ && cultivator_organ)
		return /datum/status_effect/spotlight_light/resonant
	else if(psyker_organ)
		return /datum/status_effect/spotlight_light/psyker
	else if(cultivator_organ)
		return /datum/status_effect/spotlight_light/cultivator
	else
		return /datum/status_effect/spotlight_light

/datum/action/cooldown/spell/resonant_meditate/proc/update_organs()
	psyker_organ = owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	//TODO: Cultivator Organ

// I wish I could just change the color on spotlights but no we have to make it special.
/datum/status_effect/spotlight_light/psyker
	id = "psyker_spotlight"
	spotlight_color = "#ba2cc9"
/datum/status_effect/spotlight_light/cultivator
	id = "cultivator_spotlight"
	spotlight_color = "#f5c612"
/datum/status_effect/spotlight_light/resonant // if you somehow have both
	id = "resonant_spotlight"
	spotlight_color = "#cf2525"
