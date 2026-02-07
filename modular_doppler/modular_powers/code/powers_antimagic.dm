/*
	I originally considered overriding the original /mob/proc/can_block_magic but really keeping it modular is the name of the game.

*/

/mob/proc/can_block_resonance(charge_cost = 1)
	var/list/antimagic_sources = list()
	var/is_resonance_blocked = FALSE

	if(SEND_SIGNAL(src, COMSIG_MOB_RECEIVE_MAGIC, MAGIC_RESISTANCE, charge_cost, antimagic_sources) & COMPONENT_MAGIC_BLOCKED)  // Normal magic immunity applies too.
		is_resonance_blocked = TRUE
	if(HAS_TRAIT(src, TRAIT_ANTIMAGIC)) // Normal magic immunity.
		is_resonance_blocked = TRUE
	if(HAS_TRAIT(src, TRAIT_ANTIRESONANCE)) // Resonance based magic immunity.
		is_resonance_blocked = TRUE

	if(is_resonance_blocked && charge_cost > 0 && !HAS_TRAIT(src, TRAIT_RECENTLY_BLOCKED_MAGIC))
		on_block_resonance_effects(antimagic_sources)
	return is_resonance_blocked

// Called when we succesfully block a resonant effect..
/mob/proc/on_block_resonance_effects()
	return

/mob/living/on_block_resonance_effects(list/antimagic_sources)
	ADD_TRAIT(src, TRAIT_RECENTLY_BLOCKED_MAGIC, MAGIC_TRAIT)
	addtimer(TRAIT_CALLBACK_REMOVE(src, TRAIT_RECENTLY_BLOCKED_MAGIC, MAGIC_TRAIT), 6 SECONDS)

	var/mutable_appearance/antimagic_effect
	var/antimagic_color
	var/atom/antimagic_source = length(antimagic_sources) ? pick(antimagic_sources) : src

	visible_message(
		span_warning("[src] pulses blue as [ismob(antimagic_source) ? p_they() : antimagic_source] absorbs resonant energy!"),
		span_userdanger("An intense resonant aura pulses around [ismob(antimagic_source) ? "you" : antimagic_source] as it dissipates into the air!"),
	)
	antimagic_effect = mutable_appearance('icons/effects/effects.dmi', "shield-old", MOB_SHIELD_LAYER)
	antimagic_color = LIGHT_COLOR_DARK_BLUE
	playsound(src, 'sound/effects/magic/magic_block.ogg', 50, TRUE)

	mob_light(range = 2, power = 2, color = antimagic_color, duration = 5 SECONDS)
	add_overlay(antimagic_effect)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), antimagic_effect), 5 SECONDS)

/*
Dispel proc handler
*/

/proc/dispel(atom/target, atom/dispeller, dispel_flags = 0)
	if(!target)
		return FALSE

	var/signal_result = SEND_SIGNAL(target, COMSIG_ATOM_DISPEL, dispeller)
	var/was_dispersed = (signal_result & DISPEL_RESULT_DISPELLED)

	// Only cascade if explicitly requested AND target is a mob
	if((dispel_flags & DISPEL_CASCADE_CARRIED) && ismob(target))
		var/mob/living/target_mob = target

		for(var/obj/item/held_item in target_mob.held_items)
			if(dispel(held_item, dispeller))
				was_dispersed = TRUE

		for(var/obj/item/worn_item in target_mob.get_equipped_items())
			if(dispel(worn_item, dispeller))
				was_dispersed = TRUE

	// SFX that a dispel occurred.
	if(was_dispersed)
		playsound(target, 'sound/effects/magic/smoke.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	return was_dispersed


/*
	Very simple wiz spell to test dispel functionality, plus for admeme purposes.
*/

/datum/action/cooldown/spell/pointed/resonant_dispel
	name = "Dispel Resonance"
	desc = "Ends the weaker, resonance-based magics on the target and anything contained on or within. Doesn't dispel any ADVANCED magic!"
	button_icon_state = "emp"

	sound = 'sound/effects/magic/disable_tech.ogg'
	school = SCHOOL_EVOCATION
	cooldown_time = 10 SECONDS
	cooldown_reduction_per_rank = 2 SECONDS

	invocation = "WE AK." // I am glad I did not add invocations to Thaumaturge because my creativity with these would ruin server prop.
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	active_msg = "You prepare to dispel a target..."

/datum/action/cooldown/spell/pointed/resonant_dispel/cast(atom/cast_on)
	. = ..()
	if(ismob(cast_on))
		var/mob/living/living_target = cast_on
		if(living_target.can_block_magic(antimagic_flags))
			to_chat(owner, span_warning("Your dispel failed to work!"))
			return FALSE

	dispel(cast_on, owner, DISPEL_CASCADE_CARRIED)
	return TRUE
