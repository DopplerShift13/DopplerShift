/obj/effect/overlay/meta_indicator/emote_popup
	icon = 'modular_doppler/indicators/icons/popup_flicks.dmi'


/**
 * A proc type that, when called, causes a image/sprite to appear besides whatever entity it is called on.
 *
 * There are two types: on_mob and on_obj, they can only be called on their respective typepaths.
 *
 * Arguments:
 * * state -- The icon_state of whatever .dmi file you're attempting to use for the sprite, in "" format. Ex. "combat", not combat.dmi.
 * * time -- The amount of time the sprite remains before flickback_emote_popup_on_obj is called. Is used in the addtimer.
 */

/mob/living/proc/flick_emote_popup_on_mob(state, time)
	var/obj/effect/overlay/meta_indicator/emote_popup/emote_overlay = new
	emote_overlay.icon_state = state
	vis_contents += emote_overlay
	animate(emote_overlay, alpha = 255, time = 5, easing = ELASTIC_EASING, pixel_w = 20)
	addtimer(CALLBACK(src, PROC_REF(flickback_emote_popup_on_mob), emote_overlay, time), time)

/obj/proc/flick_emote_popup_on_obj(state, time)
	var/obj/effect/overlay/meta_indicator/emote_popup/emote_overlay = new
	emote_overlay.icon_state = state
	vis_contents += emote_overlay
	animate(emote_overlay, alpha = 255, time = 5, easing = ELASTIC_EASING, pixel_w = 20)
	addtimer(CALLBACK(src, PROC_REF(flickback_emote_popup_on_obj), emote_overlay, time), time)


/**
 * Connected to the above proc, the return animation of the pop-up
 *
 * Arguments:
 * * emote_overlay -- Inherits state from the preceding proc.
 * * time -- The amount of time the sprite remains before remove_emote_popup_on_obj is called. Is used in the addtimer.
 */

/mob/living/proc/flickback_emote_popup_on_mob(obj/effect/overlay/meta_indicator/emote_popup/emote_overlay, time)
	animate(emote_overlay, alpha = 0, time = 5, easing = BACK_EASING, pixel_w = 32)
	addtimer(CALLBACK(src, PROC_REF(remove_emote_popup_on_mob), emote_overlay), 5)

/obj/proc/flickback_emote_popup_on_obj(obj/effect/overlay/meta_indicator/emote_popup/emote_overlay, time)
	animate(emote_overlay, alpha = 0, time = 5, easing = BACK_EASING, pixel_w = 32)
	addtimer(CALLBACK(src, PROC_REF(remove_emote_popup_on_obj), emote_overlay), 5)


/**
 * A proc that is automatically called whenever flickback_emote_popup_on_mob's addtimer expires, and removes the popup.
 *
 * Arguments:
 * * emote_overlay -- Inherits state from the preceding proc.
 */

/mob/living/proc/remove_emote_popup_on_mob(obj/effect/overlay/meta_indicator/emote_popup/emote_overlay)
	vis_contents -= emote_overlay
	qdel(emote_overlay)
	return

/obj/proc/remove_emote_popup_on_obj(obj/effect/overlay/meta_indicator/emote_popup/emote_overlay)
	vis_contents -= emote_overlay
	qdel(emote_overlay)
	return
