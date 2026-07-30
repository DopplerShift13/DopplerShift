/*
	BIG FUCKING SPOILERS BELOW

	BIG FUCKING SPOILERS BELOW

	BIG FUCKING SPOILERS BELOW

	Hey so did you know that casting a Thaumaturge's Mending fixes the delam to this specific type?
	This basically causes full-on erasure of the station, systmetically destroying everything (besides mobs) thats adjacent to space until nothing is left.
	This exlcudes shuttles.
	This has the lowest priorities of other delams, so you can bypass this by force-delamming into another special type (which may not be strictly better)

	For the actual controller thats responsible for erasing the station, see modular_doppler\modular_powers\code\misc\erasure_event\erasure_controller.dm
*/

/// Whether this crystal has been tainted by thaumaturgic mending and should later delaminate into erasure.
/obj/machinery/power/supermatter_crystal/var/tainted_by_mending = FALSE

/datum/sm_delam/erasure

/datum/sm_delam/erasure/can_select(obj/machinery/power/supermatter_crystal/sm)
	return sm.is_main_engine && sm.tainted_by_mending

/datum/sm_delam/erasure/delam_progress(obj/machinery/power/supermatter_crystal/sm)
	if(!..())
		return FALSE

	sm.radio.talk_into(
		sm,
		"DANGER: SENSORS FAILING, RESONANT INTERFERENCE.",
		sm.damage >= sm.emergency_point ? sm.emergency_channel : sm.warning_channel,
	)

	var/list/messages = list(
		"Reality begins to fade away before your eyes.",
		"The world seems to vanish around you.",
		"From the edges of your vision, all you see is space.",
		"You feel the cold chill of space, and a difficulty of breath.",
	)
	var/message_to_send = pick(messages)
	for(var/mob/player_mob as anything in GLOB.player_list)
		var/mob/living/living_player = player_mob
		if(!istype(living_player) || !living_player.has_power_in_path(POWER_PATH_THAUMATURGE))
			continue
		to_chat(living_player, span_danger(message_to_send))

	return TRUE

/datum/sm_delam/erasure/on_select(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] is heading towards a mass erasure event. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("is heading towards a mass erasure event.", INVESTIGATE_ENGINE)
	addtimer(CALLBACK(src, PROC_REF(announce_erasure), sm), 2 MINUTES)

/datum/sm_delam/erasure/on_deselect(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] will no longer trigger a mass erasure event. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("will no longer trigger a mass erasure event.", INVESTIGATE_ENGINE)

/datum/sm_delam/erasure/lights(obj/machinery/power/supermatter_crystal/sm)
	..()
	sm.set_light_color(POWER_COLOR_THAUMATURGE)

/datum/sm_delam/erasure/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Supermatter [sm] at [ADMIN_VERBOSEJMP(sm)] triggered a mass erasure event.")
	sm.investigate_log("triggered a mass erasure event.", INVESTIGATE_ENGINE)
	broadcast_erasure_message(sm)
	begin_mass_erasure(sm)
	force_emergency_shuttle(sm)
	return ..()

/datum/sm_delam/erasure/count_down_messages(obj/machinery/power/supermatter_crystal/sm)
	var/list/messages = list()
	messages += "CRYSTAL DELAMINATION IMMINENT. The supermatter has reached critical integrity failure. Resonant phenomena has caused mass-sensor failure. Mass reality altering event imminent. Prepare for unforseen consequences."
	messages += "Crystalline hyperstructure returning to safe operating parameters. Resonant phemona decreasing."
	messages += "remain until crystal delamination."
	return messages

/datum/sm_delam/erasure/proc/announce_erasure(obj/machinery/power/supermatter_crystal/sm)
	if(QDELETED(sm))
		return FALSE
	if(!can_select(sm))
		return FALSE
	priority_announce(
		"Attention: Unusual resonant phenomena is intervening with our anomaly scanners, the earlier Thaumaturgic interaction with the Supermatter has led to unforseen consequences. Mass reality altering events may occur upon delamination. We have no data on this; please prevent this at any and all costs.",
		"4CA Anomalous Observation Branch",
		'sound/announcer/alarm/airraid.ogg',
	)
	return TRUE

/// Spawns the erasure anchor that handles the initial wipe and ongoing hotspot-based spread.
/datum/sm_delam/erasure/proc/begin_mass_erasure(obj/machinery/power/supermatter_crystal/sm)
	var/turf/center_turf = get_turf(sm)
	if(!center_turf)
		return

	var/obj/effect/mass_erasure_controller/mass_erasure_controller = new /obj/effect/mass_erasure_controller(center_turf)
	mass_erasure_controller.activate_erasure()

/// Sends the station-wide erasure warning text and music, with special messaging for thaumaturges and Void Path heretics.
/datum/sm_delam/erasure/proc/broadcast_erasure_message(obj/machinery/power/supermatter_crystal/sm)
	if(!is_station_level(sm.z))
		return

	for(var/mob/station_mob as anything in GLOB.player_list)
		if(!is_station_level(station_mob.z))
			continue

		var/message_text = "A chill goes down your spine, and the whole world around you feels like its fading away."
		var/datum/antagonist/heretic/heretic_datum = station_mob.mind?.has_antag_datum(/datum/antagonist/heretic)
		if(heretic_datum?.heretic_path?.route == PATH_VOID)
			message_text = "IT IS BEAUTIFUL; THIS POWER TO BEHOLD. THE VOID, IT BECKONS!"
		else
			var/mob/living/living_station_mob = station_mob
			if(istype(living_station_mob) && living_station_mob.has_power_in_path(POWER_PATH_THAUMATURGE))
				message_text = "Reality is begining to unfold, the thaumaturgic magic that previously mended the crystal has now turned on the station, undoing its existence. Is this what magic can do?!"

		SEND_SOUND(station_mob, sound('sound/music/antag/heretic/VoidsEmbrace.ogg', volume = 60))
		to_chat(station_mob, "<font color='[POWER_COLOR_THAUMATURGE]' size='5'><b>[message_text]</b></font>")

/// Calls the emergency shuttle with a fixed 10 minute timer for the erasure event.
/datum/sm_delam/erasure/proc/force_emergency_shuttle(obj/machinery/power/supermatter_crystal/sm)
	if(!SSshuttle?.emergency)
		return

	SSshuttle.emergency.request(
		signal_origin = get_area(sm),
		reason = "\n\nNature of emergency:\nMass erasure event in progress.",
		red_alert = TRUE,
		set_coefficient = 1,
	)
