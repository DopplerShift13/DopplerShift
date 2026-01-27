/datum/power/psyker_power/levitate
	name = "Levitate"
	desc = "Grants the ability to levitate yourself above surfaces and letting you propel yourself in zero-gravity. Passively drains stress while in use."

	value = 5
	priority = POWER_PRIORITY_BASIC
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/levitate

/datum/power/psyker_power/levitate/dispel()
	// TODO: Ask Ephe on how to do this better.
	var/datum/action/cooldown/power/psyker/levitate/to_be_dispelled = action_path
	if(to_be_dispelled.dispel())
		return TRUE
	return FALSE

/datum/action/cooldown/power/psyker/levitate
	name = "Levitate"
	desc = "Toggles levitation, causing you to ignore the ground. Also allows for propulsion in zero-gravity. Passively drains stress while in use."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_up"

	// Overlay we add to the caster
	var/mutable_appearance/caster_effect

/datum/action/cooldown/power/psyker/levitate/use_action()
	. = ..()
	psyker_organ = owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!active)
		owner.AddElement(/datum/element/forced_gravity, 0)
		owner.AddElement(/datum/element/simple_flying)
		to_chat(owner, span_boldnotice("Your body gently floats in the air!"))
		START_PROCESSING(SSfastprocess, src)
		active = TRUE
		//visual fx
		caster_effect = mutable_appearance(
			icon = 'icons/effects/effects.dmi',
			icon_state = "psychic",
			layer = owner.layer - 0.1,
			appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
		)
		owner.add_overlay(caster_effect)
		playsound(owner, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	else
		owner.RemoveElement(/datum/element/forced_gravity, 0)
		owner.RemoveElement(/datum/element/simple_flying)
		to_chat(owner, span_boldnotice("You let yourself gently drop the ground."))
		STOP_PROCESSING(SSfastprocess, src)
		active = FALSE
		// visual fx
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	return

/datum/action/cooldown/power/psyker/levitate/process(seconds_per_tick)
	if(!owner)
		STOP_PROCESSING(SSfastprocess, src)
		return

	// Passive stress cost
	if(active)
		var/mob/living/carbon/human/psyker = owner
		var/cost = PSYKER_STRESS_TRIVIAL * 2
		if(psyker.get_quirk(/datum/quirk/paraplegic)) // There'll probably be several that'd like to do this. Effecively puts you just below the rate at which regen will keep up.
			cost = PSYKER_STRESS_TRIVIAL
		add_stress(cost * seconds_per_tick)

// Dispel function; basically off-switch and possibly comedic faceplant

// TODO: TURN THIS INTO A LISTENER
/datum/action/cooldown/power/psyker/levitate/proc/dispel()
	var/mob/living/carbon/human/victim = owner
	if(active)
		owner.RemoveElement(/datum/element/forced_gravity, 0)
		owner.RemoveElement(/datum/element/simple_flying)
		STOP_PROCESSING(SSfastprocess, src)
		active = FALSE
		// visual fx
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

		// Do you have anything to brace your fall? Or do you possibly manage to get lucky?
		var/obj/item/organ/wings/gliders = owner.get_organ_by_type(/obj/item/organ/wings)
		if(HAS_TRAIT(owner, TRAIT_FREERUNNING) || gliders?.can_soften_fall() || prob(30))
			to_chat(owner, span_warning("You suddenly fall to the ground, but manage to catch yourself!"))
		else
			to_chat(owner, span_userdanger("You suddenly fall to the ground!"))
			playsound(owner, 'sound/effects/desecration/desecration-02.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
			victim.Knockdown(3 SECONDS)
		return TRUE

	return FALSE
