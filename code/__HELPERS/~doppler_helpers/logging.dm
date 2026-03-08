/// This logs subtle emotes in game.log
/proc/log_subtle(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_SUBTLE, text, data)

/proc/log_floxy(text, list/data)
	logger.Log(LOG_CATEGORY_FLOXY, text, data)

/proc/log_music(text, list/data)
	logger.Log(LOG_CATEGORY_MUSIC, text, data)
