
/mob/living/silicon/robot
	/// The robot's internal MODlink datum.
	VAR_FINAL/datum/mod_link/mod_link
	/// Action to use the robot's internal MODlink.
	VAR_FINAL/datum/action/innate/robot_modlink/modlink_action = new()

/mob/living/silicon/robot/Initialize(mapload)
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

/mob/living/silicon/robot/Destroy()
	QDEL_NULL(mod_link)
	return ..()

/mob/living/silicon/robot/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods, message_range)
	. = ..()
	if(isnull(mod_link.link_call) || isnull(mod_link.visual))
		return
	if(speaker != src)
		return
	if(radio_freq)
		return // For AIs, don't talk into our holocall if we're using a radio.
	mod_link.visual.say(raw_message, spans = spans, sanitize = FALSE, language = message_language, message_range = 3, message_mods = message_mods)


/mob/living/silicon/robot/proc/get_modlink_user()
	return src

/mob/living/silicon/robot/proc/can_call()
	return mind && (stat < DEAD)


/mob/living/silicon/robot/proc/update_link_visual_height(var/height_offset)
	if(QDELETED(mod_link.link_call))
		return

	var/atom/movable/other_visuals = mod_link.get_other()?.visual
	if(isnull(other_visuals))
		return

	other_visuals.pixel_z = height_offset

/mob/living/silicon/robot/proc/get_link_offset()
	if(isnull(model))
		return 0
	if(islist(model.hat_offset))
		var/list/offset = model.hat_offset[dir2text(SOUTH)]
		return offset[1]
	return model.hat_offset

/mob/living/silicon/robot/proc/get_link_eyelights(eyelights_icon)
	var/eyelights_icon_state = "[model.special_light_key ? "[model.special_light_key]":"[model.cyborg_base_icon]"]_e"
	var/mutable_appearance/eyelights_overlay = mutable_appearance(eyelights_icon, eyelights_icon_state, MOB_LAYER)
	eyelights_overlay.color = COLOR_WHITE
	return eyelights_overlay

/mob/living/silicon/robot/proc/make_link_visual()
	var/obj/effect/overlay/link_visual = new()
	link_visual.name = "holocall ([name])"
	link_visual.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	link_visual.appearance_flags |= KEEP_TOGETHER
	apply_link_overlays(link_visual)
	link_visual.makeHologram(0.75)
	LAZYADD(update_on_z, link_visual)
	mod_link.visual = link_visual
	return link_visual

/mob/living/silicon/robot/proc/apply_link_overlays(obj/effect/overlay/link_visual)
	if(isnull(model))
		link_visual.icon = icon
		link_visual.icon_state = icon_state
		return

	var/overlay_icon = model.cyborg_icon_override || icon
	var/overlay_icon_state = model.cyborg_base_icon
	var/overlay_offset = get_link_offset()
	var/mutable_appearance/robot_overlay = mutable_appearance(overlay_icon, overlay_icon_state, MOB_LAYER)
	var/mutable_appearance/eyelights_overlay = get_link_eyelights(overlay_icon)
	robot_overlay.pixel_z -= overlay_offset
	eyelights_overlay.pixel_z -= overlay_offset
	link_visual.add_overlay(robot_overlay)
	link_visual.add_overlay(eyelights_overlay)

/mob/living/silicon/robot/proc/get_link_visual(atom/movable/visuals)
	playsound(src, 'sound/machines/terminal/terminal_processing.ogg', 50, vary = TRUE)
	visuals.add_overlay(mutable_appearance('icons/effects/effects.dmi', "static_base", ABOVE_NORMAL_TURF_LAYER))
	visuals.add_overlay(mutable_appearance('icons/effects/effects.dmi', "modlink", ABOVE_ALL_MOB_LAYER))
	visuals.add_filter("crop_square", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "modlink_filter")))
	visuals.maptext_height = 6
	visuals.alpha = 0
	vis_contents += visuals
	if(!robot_resting)
		visuals.pixel_z += get_link_offset()
	visuals.forceMove(src)
	animate(visuals, 0.5 SECONDS, alpha = 255)
	var/datum/callback/setdir_callback = CALLBACK(src, PROC_REF(on_user_set_dir))
	setdir_callback.Invoke(src, src.dir, src.dir)
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_user_set_dir))

/mob/living/silicon/robot/proc/delete_link_visual()
	playsound(mod_link.get_other().holder, 'sound/machines/terminal/terminal_processing.ogg', 50, vary = TRUE, frequency = -1)
	LAZYREMOVE(update_on_z, mod_link.visual)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	QDEL_NULL(mod_link.visual)

/mob/living/silicon/robot/proc/on_user_set_dir(atom/source, dir, newdir)
	SIGNAL_HANDLER
	on_user_set_dir_generic(mod_link, newdir || SOUTH)


/datum/action/innate/robot_modlink
	name = "Use MODlink"
	desc = "Attempt to use your internal MODlink scryer."
	button_icon = 'modular_doppler/modular_silicons/icons/actions_silicon_modlink.dmi'
	button_icon_state = "call"

/datum/action/innate/robot_modlink/Trigger(trigger_flags)
	var/mob/living/silicon/robot/user = owner
	if(isnull(user))
		return
	if(user.mod_link.link_call)
		user.mod_link.end_call()
		return
	call_link(user, user.mod_link)
