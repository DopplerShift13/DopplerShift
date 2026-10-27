/datum/secrets_menu/doppler
    parent_type = /datum/secrets_menu

/datum/secrets_menu/doppler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DopplerSecrets")
		ui.open()

/datum/secrets_menu/doppler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("changingroomreset")
			var/delete_mobs = tgui_alert(usr, "Clear all mobs?", "Changing Room Reset", list("Yes", "No", "Cancel"))
			if(!delete_mobs || delete_mobs == "Cancel")
				return

			log_admin("[key_name(holder)] reset the changing room to default with delete_mobs marked as [delete_mobs].")
			message_admins(span_adminnotice("[key_name_admin(holder)] reset the changing room to default with delete_mobs marked as [delete_mobs]."))

			var/area/changingroom = GLOB.areas_by_type[/area/centcom/changing_room]
			if(delete_mobs == "Yes")
				for(var/mob/living/mob in changingroom)
					qdel(mob)
			for(var/obj/obj in changingroom)
				qdel(obj)

			var/datum/map_template/changing_room_template = new /datum/map_template/changing_room()
			changing_room_template.should_place_on_top = FALSE
			var/turf/changing_room_corner = locate(changingroom.x - 17, changingroom.y, 1)
			changing_room_template.load(changing_room_corner)

			return TRUE

// your doppler-specific secret panel button functions go here!

	return ..()
