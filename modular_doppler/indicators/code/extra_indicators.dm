#define INDICATOR_SSD "ssd"
/// The time for which the sound effect and `emote_popup` alert are disabled
#define NOTICE_COOLDOWN (2.5 SECONDS)

GLOBAL_LIST_INIT(extra_indicator_overlays, generate_extra_overlays())

/proc/generate_extra_overlays()
	return list(
		INDICATOR_SSD = new /obj/effect/overlay/meta_indicator/ssd()
	)

/*
	SSD/Dropped connection
*/

/obj/effect/overlay/meta_indicator/ssd
	icon = 'modular_doppler/indicators/icons/extra_indicators.dmi'
	icon_state = INDICATOR_SSD

/mob/living
	var/ssd_indicator = FALSE
	var/lastclienttime = 0

/mob/living/proc/set_ssd_indicator(state)
	if(state == ssd_indicator)
		return
	ssd_indicator = state
	if(ssd_indicator)
		add_overlay(GLOB.extra_indicator_overlays[INDICATOR_SSD])
		flick_emote_popup_on_mob(INDICATOR_SSD, NOTICE_COOLDOWN)
		playsound(src, 'modular_doppler/modular_sounds/sound/mobs/humanoids/combat_indicator/ssd.ogg', vol = 15, vary = TRUE, extrarange = -6, falloff_exponent = 4, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = FALSE, falloff_distance = 1)
		log_message("<font color='green'>has went SSD and got their indicator!</font>", LOG_ATTACK)
	else
		cut_overlay(GLOB.extra_indicator_overlays[INDICATOR_SSD])
		log_message("<font color='green'>is no longer SSD and lost their indicator!</font>", LOG_ATTACK)

/mob/living/Login()
	. = ..()
	set_ssd_indicator(FALSE)

/mob/living/Logout()
	lastclienttime = world.time
	set_ssd_indicator(TRUE)
	if(combat_indicator != "none")
		set_combat_indicator("none", involuntary = TRUE) // turn combat indicator off for the disconnected player
	. = ..()

#undef INDICATOR_SSD
#undef NOTICE_COOLDOWN
