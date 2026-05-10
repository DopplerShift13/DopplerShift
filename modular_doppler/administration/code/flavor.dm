/*
	returns the appropriate message color for the OOC channels.
	SOOC_COLOR for secoffs, AOOC_COLOR for antags, and the ooc pref for admins
*/
/proc/ooc_channel_color(mob/living/carbon/human/chatter)
	var/color = "#c43b23"
	if(!chatter.mind || !chatter.client || !chatter.client?.prefs)
		return color

	// if you're sec
	if(GLOB.sooc_job_lookup[chatter.mind?.assigned_role?.title])
		color = SOOC_COLOR
	// if you're tot
	if(length(chatter.mind?.antag_datums))
		color = AOOC_COLOR
	// if you're admin
	if(is_admin(chatter) && !GLOB.deadmins[chatter.client?.ckey])
		color = chatter.client?.prefs?.read_preference(/datum/preference/color/ooc_color)

	return color

/*
	returns the appropriate emoji for the OOC channels.
	picks from a pref regarding if youre secoff or antag. always doppie for admins
*/
/proc/ooc_channel_emoji(mob/living/carbon/human/chatter)
	var/emoji_icon_state = "fpalm"
	var/emoji_icon_file = EMOJI_SET
	if(!chatter.mind || !chatter.client || !chatter.client?.prefs)
		return icon2html(emoji_icon_file, world, emoji_icon_state)

	// if you're sec
	if(GLOB.sooc_job_lookup[chatter.mind?.assigned_role?.title])
		emoji_icon_state = chatter.client?.prefs?.read_preference(/datum/preference/choiced/ooc_channel_emoji_sec)
	// if you're tot
	if(length(chatter.mind?.antag_datums))
		emoji_icon_state = chatter.client?.prefs?.read_preference(/datum/preference/choiced/ooc_channel_emoji_tot)
	// if you're admin
	if(is_admin(chatter) && !GLOB.deadmins[chatter.client?.ckey])
		emoji_icon_state = "dolphin"
		emoji_icon_file = MODULAR_EMOJI_SET

	return icon2html(emoji_icon_file, world, emoji_icon_state)
