GLOBAL_LIST_INIT(used_sound_channels, list(
	CHANNEL_MASTER_VOLUME,
	CHANNEL_MACHINERY,
))

GLOBAL_LIST_INIT(proxy_sound_channels, list(
	CHANNEL_MACHINERY,
))

GLOBAL_DATUM_INIT(cached_mixer_channels, /alist, alist())

/proc/guess_mixer_channel(soundin)
	var/sound_text_string
	if(istype(soundin, /sound))
		var/sound/bleh = soundin
		sound_text_string = "[bleh.file]"
	else
		sound_text_string = "[soundin]"
	if(GLOB.cached_mixer_channels[sound_text_string])
		return GLOB.cached_mixer_channels[sound_text_string]
	else if(findtext(sound_text_string, "machines/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_MACHINERY
	else
		return FALSE

/// Calculates the "adjusted" volume for a user's volume mixer
/proc/calculate_mixed_volume(client/client, volume, mixer_channel)
	. = volume
	var/list/channels = client?.prefs?.channel_volume
	if(isnull(channels))
		return .
	. *= channels["[CHANNEL_MASTER_VOLUME]"] * 0.01
	if(isnull(mixer_channel) || !("[mixer_channel]" in channels))
		return .
	. *= channels["[mixer_channel]"] * 0.01

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)
