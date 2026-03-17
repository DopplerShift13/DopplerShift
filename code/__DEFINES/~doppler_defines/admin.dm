#define MUTE_LOOC (1<<6)

/// Sends all admins the chosen sound
#define SEND_ADMINS_NOTIFICATION_SOUND(sound_to_play) for(var/client/X in GLOB.admins){X.mob.playsound_local(null, sound_to_play, 100, vary = FALSE, channel = CHANNEL_ADMIN_SOUNDS, pressure_affected = FALSE, use_reverb = FALSE);}

/// Sends a message in adminchat
#define SEND_ADMINCHAT_MESSAGE(message) to_chat(GLOB.admins, type = MESSAGE_TYPE_ADMINCHAT, html = message, confidential = TRUE)

/// Sends a message in adminchat with the chosen notification sound
#define SEND_NOTIFIED_ADMIN_MESSAGE(sound, message) SEND_ADMINS_NOTIFICATION_SOUND(sound); SEND_ADMINCHAT_MESSAGE(message)
