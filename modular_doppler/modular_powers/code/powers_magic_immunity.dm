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
