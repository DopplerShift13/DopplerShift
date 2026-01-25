/datum/power/psyker_power/levitate
	name = "Levitate"
	desc = "Grants the ability to levitate yourself above surfaces and letting you propel yourself in zero-gravity. Passively drains stress while in use."

	value = 5
	priority = POWER_PRIORITY_BASIC
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/spell/levitate

/datum/action/cooldown/spell/levitate
	name = "Levitate"
	desc = "Toggles levitation, causing you to ignore the ground. Also allows for propulsion in zero-gravity. Passively drains stress while in use."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_up"

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 2 SECONDS

	// Are we currently levitating?
	var/levitating = FALSE

	// Psyker organ for stress.
	var/obj/item/organ/resonant/psyker/psyker_organ

	// Overlay we add to the caster
	var/mutable_appearance/caster_effect

/datum/action/cooldown/spell/levitate/cast()
	. = ..()
	psyker_organ = owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!levitating)
		owner.AddElement(/datum/element/forced_gravity, 0)
		owner.AddElement(/datum/element/simple_flying)
		to_chat(owner, span_boldnotice("Your body gently floats in the air!"))
		START_PROCESSING(SSfastprocess, src)
		levitating = TRUE
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
		to_chat(owner, span_boldnotice("You let yourself be affected by gravity once more."))
		STOP_PROCESSING(SSfastprocess, src)
		levitating = FALSE
		// visual fx
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	return

/datum/action/cooldown/spell/levitate/process(seconds_per_tick)
	// Calling the parent process() stops processing when the ability is off cooldown, which is not what we want.
	if(!owner)
		build_all_button_icons(UPDATE_BUTTON_STATUS)
		STOP_PROCESSING(SSfastprocess, src)
		return
	build_all_button_icons(UPDATE_BUTTON_STATUS)

	// Passive stress cost
	if(levitating)
		var/mob/living/carbon/human/psyker = owner
		var/cost = PSYKER_STRESS_TRIVIAL * 2
		if(psyker.get_quirk(/datum/quirk/paraplegic)) // There'll probably be several that'd like to do this. Effecively puts you just below the rate at which regen will keep up.
			cost = PSYKER_STRESS_TRIVIAL
		psyker_organ.add_stress(cost * seconds_per_tick)


