/datum/power/psyker_power/levitate
	name = "Levitate"
	desc = "Grants the ability to levitate yourself above surfaces and letting you propel yourself in zero-gravity. Passively drains stress while in use."
	security_record_text = "Subject can levitate their body regardless of the current gravity."
	value = 4
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/levitate

/datum/action/cooldown/power/psyker/levitate
	name = "Levitate"
	desc = "Toggles levitation, causing you to ignore the ground. Also allows for propulsion in zero-gravity. Passively drains stress while in use."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_up"

	mental = FALSE
	/// Overlay we add to the caster
	var/mutable_appearance/caster_effect

/datum/action/cooldown/power/psyker/levitate/use_action()
	. = ..()
	if(!active)
		owner.AddElementTrait(TRAIT_PSYKER_LEVITATE_FLIGHT, REF(src), /datum/element/forced_gravity, 0)
		owner.AddElementTrait(TRAIT_PSYKER_LEVITATE_FLIGHT, REF(src), /datum/element/simple_flying)
		to_chat(owner, span_boldnotice("Your body gently floats in the air!"))
		START_PROCESSING(SSfastprocess, src)
		active = TRUE
		//visual fx
		caster_effect = mutable_appearance(
			icon = 'icons/effects/effects.dmi',
			icon_state = "psychic",
			layer = owner.layer - 0.1,
			alpha = 100,
			appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
		)
		owner.add_overlay(caster_effect)
		playsound(owner, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	else
		REMOVE_TRAIT(owner, TRAIT_PSYKER_LEVITATE_FLIGHT, REF(src))
		to_chat(owner, span_boldnotice("You let yourself gently drop the ground."))
		STOP_PROCESSING(SSfastprocess, src)
		active = FALSE
		// visual fx
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	return TRUE

/datum/action/cooldown/power/psyker/levitate/process(seconds_per_tick)
	if(!owner)
		STOP_PROCESSING(SSfastprocess, src)
		return
	//Faceplant if you get KO'd
	if(HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		on_dispel(owner, src)
	// Passive stress cost
	if(active)
		var/mob/living/carbon/human/psyker = owner
		var/cost = PSYKER_STRESS_TRIVIAL * 1.5
		if(psyker.get_quirk(/datum/quirk/paraplegic)) // paraplegic gets it better
			cost = PSYKER_STRESS_TRIVIAL * 0.5
		modify_stress(cost * seconds_per_tick)

// Dispel function; basically off-switch and possibly comedic faceplant
/datum/action/cooldown/power/psyker/levitate/Grant(mob/granted_to)
	. = ..()
	if(resonant)
		RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/psyker/levitate/Remove(mob/removed_from)
	. = ..()
	if(resonant)
		UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/// Ends the effect; makes them splat if they can't catch themselves.
/datum/action/cooldown/power/psyker/levitate/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/victim = owner
	if(active)
		REMOVE_TRAIT(owner, TRAIT_PSYKER_LEVITATE_FLIGHT, REF(src))
		STOP_PROCESSING(SSfastprocess, src)
		active = FALSE
		// visual fx
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

		// Do you have anything to brace your fall? Or do you possibly manage to get lucky?
		var/obj/item/organ/wings/gliders = owner.get_organ_by_type(/obj/item/organ/wings)
		if(HAS_TRAIT(owner, TRAIT_FREERUNNING) || gliders?.can_soften_fall() || prob(30))
			to_chat(owner, span_warning("You drop to the ground, but manage to catch yourself!"))
		else
			to_chat(owner, span_userdanger("You drop to the ground!"))
			playsound(owner, 'sound/effects/desecration/desecration-02.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE) // Research (vibes) shows desecration-02 is the best "hit the ground"-type splat; so we're using it instead of a random desecration.
			victim.adjustBruteLoss(5)
			victim.Knockdown(3 SECONDS)
		return DISPEL_RESULT_DISPELLED

	return NONE
