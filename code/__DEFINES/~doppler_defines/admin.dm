#define MUTE_LOOC (1<<6)

/// Define for the admin verb that allows them to review submitted cassettes.
#define ADMIN_OPEN_REVIEW(id) "(<A href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];open_music_review=[id]'>Open Review</a>)"

/// Sends a message in adminchat with the chosen notfication sound
#define SEND_NOTFIED_ADMIN_MESSAGE(sound, message) SEND_ADMINS_NOTFICATION_SOUND(sound); SEND_ADMINCHAT_MESSAGE(message)
