
/mob/living/silicon/ai
	/// The AI's internal MODlink datum.
	VAR_FINAL/datum/mod_link/mod_link
	/// Action to use the AI's internal MODlink.
	VAR_FINAL/datum/action/innate/ai_modlink/modlink_action = new()

/mob/living/silicon/ai/Initialize(mapload)
	. = ..()
	mod_link = new(
		src,
		MODLINK_FREQ_NANOTRASEN,
		CALLBACK(src, PROC_REF(get_modlink_user)),
		CALLBACK(src, PROC_REF(can_call)),
		CALLBACK(src, PROC_REF(make_link_visual)),
		CALLBACK(src, PROC_REF(get_link_visual)),
		CALLBACK(src, PROC_REF(delete_link_visual))
	)
	modlink_action.Grant(src)

/mob/living/silicon/ai/Destroy()
	QDEL_NULL(mod_link)
	return ..()

/mob/living/silicon/ai/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods, message_range)
	. = ..()
	if(isnull(mod_link.link_call) || isnull(mod_link.visual))
		return
	if(speaker != src)
		return
	if(radio_freq)
		return // For AIs, don't talk into our holocall if we're using a radio.
	mod_link.visual.say(raw_message, spans = spans, sanitize = FALSE, language = message_language, message_range = 3, message_mods = message_mods)


/mob/living/silicon/ai/proc/get_modlink_user()
	return src

/mob/living/silicon/ai/proc/can_call()
	return mind && (stat < DEAD)


/**
 * Difficulties with performing this as a modular override due to it being needed on a verb.
 * Edits can be found here:
 * - code/modules/mob/living/silicon/ai/ai.dm (/mob/living/silicon/ai/proc/ai_hologram_change(...))
 */
/mob/living/silicon/ai/proc/update_link_visual()
	if(QDELETED(mod_link.link_call))
		return

	var/atom/work_off = hologram_appearance || src
	mod_link.visual.icon = work_off.icon
	mod_link.visual.icon_state = work_off.icon_state
	apply_link_overlays(mod_link.visual, cut_old = TRUE)


/mob/living/silicon/ai/proc/make_link_visual()
	var/atom/work_off = hologram_appearance || src
	var/obj/effect/overlay/link_visual = new()
	link_visual.name = "holocall ([name])"
	link_visual.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	link_visual.appearance_flags |= KEEP_TOGETHER
	link_visual.icon = work_off.icon
	link_visual.icon_state = work_off.icon_state
	apply_link_overlays(link_visual)
	link_visual.makeHologram(0.75)
	LAZYADD(update_on_z, link_visual)
	mod_link.visual = link_visual
	return link_visual

/mob/living/silicon/ai/proc/apply_link_overlays(obj/effect/overlay/link_visual, cut_old = FALSE)
	if(cut_old)
		link_visual.cut_overlay(mod_link.visual_overlays)

	var/atom/work_off = hologram_appearance || src
	if(ismob(work_off))
		var/mob/work_off_mob = work_off
		mod_link.visual_overlays = work_off_mob.overlays - work_off_mob.active_thinking_indicator
	else
		mod_link.visual_overlays = work_off.overlays

	link_visual.add_overlay(mod_link.visual_overlays)

/mob/living/silicon/ai/proc/get_link_visual(atom/movable/visuals)
	playsound(src, 'sound/machines/terminal/terminal_processing.ogg', 50, vary = TRUE)
	visuals.add_overlay(mutable_appearance('icons/effects/effects.dmi', "static_base", ABOVE_NORMAL_TURF_LAYER))
	visuals.add_overlay(mutable_appearance('icons/effects/effects.dmi', "modlink", ABOVE_ALL_MOB_LAYER))
	visuals.add_filter("crop_square", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "modlink_filter")))
	visuals.maptext_height = 6
	visuals.alpha = 0
	vis_contents += visuals
	visuals.forceMove(src)
	animate(visuals, 0.5 SECONDS, alpha = 255)
	var/datum/callback/setdir_callback = CALLBACK(src, PROC_REF(on_user_set_dir))
	setdir_callback.Invoke(src, src.dir, src.dir)
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_user_set_dir))

/mob/living/silicon/ai/proc/delete_link_visual()
	playsound(mod_link.get_other().holder, 'sound/machines/terminal/terminal_processing.ogg', 50, vary = TRUE, frequency = -1)
	LAZYREMOVE(update_on_z, mod_link.visual)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	QDEL_NULL(mod_link.visual)

/mob/living/silicon/ai/proc/on_user_set_dir(atom/source, dir, newdir)
	SIGNAL_HANDLER
	on_user_set_dir_generic(mod_link, newdir || SOUTH)


/datum/action/innate/ai_modlink
	name = "Use MODlink"
	desc = "Attempt to use your internal MODlink scryer."
	button_icon = 'modular_doppler/modular_silicons/icons/actions_silicon_modlink.dmi'
	button_icon_state = "call"

/datum/action/innate/ai_modlink/Trigger(trigger_flags)
	var/mob/living/silicon/ai/user = owner
	if(isnull(user))
		return
	if(user.mod_link.link_call)
		user.mod_link.end_call()
		return
	call_link(user, user.mod_link)
