#define ASOOC_RED 1
#define ASOOC_BLUE 2

/client/verb/backstage(msg as text)
	set name = "OOC: Backstage (Antag/Sec)"
	set category = "OOC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	var/red_or_blue = NONE
	if(length(mob.mind?.antag_datums))
		red_or_blue = ASOOC_RED
	else if(GLOB.sooc_job_lookup[mob.mind?.assigned_role?.title])
		red_or_blue = ASOOC_BLUE

	if(!holder)
		if(!red_or_blue)
			to_chat(src, span_danger("You don't have backstage access!"))
			return
		if(!GLOB.backstage_allowed)
			to_chat(src, span_danger("The backstage is staff-only."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("You cannot use OOC channels (muted)."))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("You have been banned from OOC channels."))
		return
	if(QDELETED(src))
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC communication muted."))
		return

	mob.log_talk(raw_msg, LOG_OOC, tag = "Backstage")

	var/keyname = key
	var/anon = FALSE

	//Anonimity for players and deadminned admins
	if(!holder || holder.deadmined)
		if(!GLOB.ckey_to_backstage_name[key])
			GLOB.ckey_to_backstage_name[key] = "[pick(GLOB.first_names)] [trim(pick(GLOB.last_names), 2)]."
		keyname = GLOB.ckey_to_backstage_name[key]
		anon = TRUE

	var/list/listeners = list()

	for(var/iterated_player as anything in GLOB.player_list)
		var/mob/iterated_mob = iterated_player
		//Admins with muted OOC do not get to listen to backstage chatter, but normal players do, as it could be admins talking important stuff to them
		if(iterated_mob.client?.holder && !iterated_mob.client?.holder?.deadmined && iterated_mob.client?.prefs?.chat_toggles & CHAT_OOC)
			listeners[iterated_mob.client] = LISTEN_ADMIN
		else
			var/datum/mind/mob_mind = iterated_mob.mind
			if(!isnull(mob_mind))
				if(!length(mob_mind.antag_datums) && !GLOB.sooc_job_lookup[mob_mind.assigned_role?.title])
					continue
				listeners[iterated_mob.client] = LISTEN_PLAYER

	for(var/iterated_listener as anything in listeners)
		var/client/iterated_client = iterated_listener
		var/mode = listeners[iterated_listener]
		var/color = (!anon && CONFIG_GET(flag/allow_admin_ooccolor) && iterated_client?.prefs?.read_preference(/datum/preference/color/ooc_color)) ? iterated_client?.prefs?.read_preference(/datum/preference/color/ooc_color) : GLOB.backstage_color[red_or_blue]
		var/name = (mode == LISTEN_ADMIN && anon) ? "([key])[keyname]" : keyname
		to_chat(iterated_client, span_oocplain("<font color='[color]'>[icon2html(EMOJI_SET, world, red_or_blue == ASOOC_RED ? "redban" : "bluban")] <EM>[name]</EM> says <b><span class='message linkify'>[msg]</span></b></font>"))

#undef ASOOC_RED
#undef ASOOC_BLUE

/proc/toggle_backstage(toggle = null)
	if(toggle != null) //if we're specifically en/disabling aooc
		if(toggle == GLOB.backstage_allowed)
			return
		GLOB.backstage_allowed = toggle
	else //otherwise just toggle it
		GLOB.backstage_allowed = !GLOB.backstage_allowed
	var/list/listeners = list()
	for(var/mind as anything in get_antag_minds(/datum/antagonist))
		var/datum/mind/antag_mind = mind
		if(!antag_mind.current || !antag_mind.current.client || isnewplayer(antag_mind.current))
			continue
		listeners[antag_mind.current.client] = TRUE

	for(var/iterated_player in GLOB.player_list)
		var/mob/iterated_mob = iterated_player
		if(!iterated_mob.client?.holder?.deadmined)
			listeners[iterated_mob.client] = TRUE
	for(var/iterated_listener in listeners)
		var/client/iterated_client = iterated_listener
		to_chat(iterated_client, span_oocplain("<B>Backstage access has been [GLOB.backstage_allowed ? "granted" : "revoked"].</B>"))

ADMIN_VERB(toggle_backstage, R_ADMIN, "Toggle Backstage Access", "Toggles Backstage Access.", ADMIN_CATEGORY_SERVER)
	toggle_backstage()
	log_admin("[key_name(usr)] toggled Backstage Access.")
	message_admins("[key_name_admin(usr)] toggled Backstage Access.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Backstage Access", "[GLOB.backstage_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
