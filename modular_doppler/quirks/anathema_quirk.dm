/datum/quirk/anathema
	name = "Anathema"
	desc = "Reality anchors and resonant-suppressing effects will boil away your body, causing grievous burns when active nearby."
	gain_text = span_danger("Your surroundings feel soft.")
	lose_text = span_notice("The world feels more solid again.")
	medical_record_text = "Subject's body is harmed by reality anchoring effects."
	value = -4
	icon = FA_ICON_ALIGN_JUSTIFY
	mob_trait = TRAIT_ANATHEMA // Used to track if the element is present & in case other pieces of code want to check if a mob is Anathema

/datum/quirk/anathema/add(client/client_source)
	// So long as you have the trait you will have the element; it's removed automatically when the trait is removed
	quirk_holder.AddElementTrait(TRAIT_ANATHEMA, QUIRK_TRAIT, /datum/element/anathema)

/// Silencing effects (reality anchor, ontologically immutable) boil whoever carries this. Attach through AddElementTrait(TRAIT_ANATHEMA, your source here, /datum/element/anathema)
/datum/element/anathema
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/anathema/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_ANCHOR_SILENCE_WARNING, PROC_REF(anchor_warning))
	RegisterSignal(target, COMSIG_LIVING_ANCHOR_SILENCE_TICK, PROC_REF(anchor_tick))
	RegisterSignal(target, COMSIG_LIVING_ANCHOR_SILENCE_MENTAL_APPLIED, PROC_REF(add_mental_effects))
	RegisterSignal(target, COMSIG_LIVING_ANCHOR_SILENCE_MENTAL_CLEARED, PROC_REF(clear_mental_effects))

/datum/element/anathema/Detach(mob/living/source)
	UnregisterSignal(source, list(
		COMSIG_LIVING_ANCHOR_SILENCE_WARNING,
		COMSIG_LIVING_ANCHOR_SILENCE_TICK,
		COMSIG_LIVING_ANCHOR_SILENCE_MENTAL_APPLIED,
		COMSIG_LIVING_ANCHOR_SILENCE_MENTAL_CLEARED,
	))
	source.clear_mood_event(src)
	return ..()

/datum/element/anathema/proc/anchor_warning(mob/living/source)
	SIGNAL_HANDLER
	to_chat(source, span_userdanger("Your body boils away as your biology is suppressed!"))
	// Plays the same silencing sound effect that sorcerers and resonants hear but for mortals, who normally wouldn't hear it
	if(!source.has_magical_power_in_archetype(POWER_ARCHETYPE_SORCEROUS) && !source.has_magical_power_in_archetype(POWER_ARCHETYPE_RESONANT))
		source.playsound_local(source, 'sound/effects/curse/curse5.ogg', 50, FALSE)

/datum/element/anathema/proc/anchor_tick(mob/living/source, seconds_between_ticks)
	SIGNAL_HANDLER
	source.apply_damage(5, BURN) // 40 to 50 burn damage per application of the effect

/datum/element/anathema/proc/add_mental_effects(mob/living/source, datum/status_effect/power/reality_anchor_silenced/effect)
	SIGNAL_HANDLER
	// Adds another moodlet on top of any existing ones
	source.add_mood_event(src, /datum/mood_event/anathema_boiling)
	// Replaces the base static overlay
	source.overlay_fullscreen("reality_anchor_static", /atom/movable/screen/fullscreen/reality_anchor_static/anathema)
	// This uses the status effect's apply_anchor_blur proc, and replaces the base blur effect if you would receive any
	effect.apply_anchor_blur(0.04)

/datum/element/anathema/proc/clear_mental_effects(mob/living/source)
	SIGNAL_HANDLER
	source.clear_mood_event(src) // We only clear the mood event, because the static and screen blur are handled by the status effect itself

/datum/mood_event/anathema_boiling
	description = "IT BURNS IT BURNS IT BURNS IT BURNS IT BURNS IT BURNS IT BURNS IT BURNS"
	mood_change = -20
	special_screen_obj = "mood_despair"

/atom/movable/screen/fullscreen/reality_anchor_static/anathema
	alpha = 170
	color = COLOR_DARK_RED
