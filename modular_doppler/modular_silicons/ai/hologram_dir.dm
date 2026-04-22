// Allow AIs to turn their hologram instead on alt-move.
/mob/living/silicon/ai/keybind_face_direction(direction)
	var/obj/machinery/holopad/active_pad = current
	if(istype(active_pad) && active_pad.masters[src])
		var/obj/effect/overlay/holo_pad_hologram/ai_holo = active_pad.masters[src]
		ai_holo.setDir(direction)
		return
	return ..()
