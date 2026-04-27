GLOBAL_VAR_INIT(ssd_indicator_overlay, mutable_appearance('modular_doppler/indicators/icons/extra_indicator.dmi', "ssd", FLY_LAYER))

/mob/living
	var/ssd_indicator = FALSE
	var/lastclienttime = 0

/mob/living/proc/set_ssd_indicator(state)
	if(state == ssd_indicator)
		return
	ssd_indicator = state
	if(ssd_indicator)
		add_overlay(GLOB.ssd_indicator_overlay)
		flick_emote_popup_on_mob("ssd", 20)
		playsound(src, 'modular_doppler/modular_sounds/sound/mobs/humanoids/combat_indicator/ssd.ogg', vol = 15, vary = TRUE, extrarange = -6, falloff_exponent = 4, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = FALSE, falloff_distance = 1)
		log_message("<font color='green'>has went SSD and got their indicator!</font>", LOG_ATTACK)
	else
		cut_overlay(GLOB.ssd_indicator_overlay)
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
