/obj/item/motiondetector
	name = "motion detector"
	desc = "A device that detects nearby movement, displaying them as visible blips. Does not differentiate between friend or foe."
	icon_state = "scanner"
	icon = 'modular_doppler/its_donk_or_dont/icons/detector.dmi'
	///The range of this motion detector
	var/scan_range = 9
	/// Used for the cooldown below, how long do we wait between uses
	var/scan_cooldown_time = 10 SECONDS
	/// Time between using the big ping scan
	COOLDOWN_DECLARE(motion_detector_cooldown)

/obj/item/motiondetector/attack_self(mob/user, modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, motion_detector_cooldown))
		balloon_alert(user, "recharging")
		return
	balloon_alert(user, "readying sonar...")
	playsound(user, 'sound/vehicles/mecha/skyfall_power_up.ogg', vol = 20, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	if(!do_after(user, 1.1 SECONDS))
		return
	playsound(user, 'sound/effects/ping_hit.ogg', vol = 75, vary = TRUE) // Should be audible for the radius of the sonar
	var/detected_count = 0
	for(var/mob/living/nearby_living_thing in range(scan_range, user))
		if(nearby_living_thing == user)
			continue
		if(nearby_living_thing.stat == DEAD)
			continue
		new /obj/effect/temp_visual/sonar_ping(user.loc, user, nearby_living_thing)
		detected_count += 1
	for(var/mob/living/nearby_living_thing in range(scan_range, user))
		if(nearby_living_thing == user)
			continue
		if(nearby_living_thing.stat == DEAD)
			continue
		new /obj/effect/temp_visual/sonar_ping(user.loc, user, nearby_living_thing)
		detected_count += 1
	to_chat(user, span_notice("The sensor pings, detecting [detected_count] living beings nearby!"))
	flick("scanner_ping", src)
	COOLDOWN_START(src, motion_detector_cooldown, scan_cooldown_time)

// Radio jamming beacon that also shows up on the motion detector

/obj/item/detector_jammer
	name = "jamming beacon"
	desc = "A small beacon that emits jamming signals among most common radio frequencies. \
		As a side benefit (or downside), these also appear on most motion detectors due to their unique sound signature."
	icon = 'icons/obj/devices/stock_parts.dmi'
	icon_state = "quadratic_capacitor"
	anchored = TRUE

/obj/item/detector_jammer/Initialize(mapload)
	. = ..()
	GLOB.active_jammers |= src
	addtimer(CALLBACK(src, PROC_REF(blow_up)), 2 MINUTES, TIMER_DELETE_ME | TIMER_STOPPABLE)

/obj/item/detector_jammer/Destroy()
	GLOB.active_jammers -= src
	return ..()

/// Destroys the jammer with a cloud of sparks
/obj/item/detector_jammer/proc/blow_up()
	do_sparks(3, FALSE, src)
	qdel(src)
