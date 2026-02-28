#define WAR_POSTER_MOOD_CAT "poster_mood"

/datum/mood_event/war_poster_sympathy
	description = "I saw a poster that reinforces my beliefs. It's good to have like-minded people around."
	mood_change = 2
	category = WAR_POSTER_MOOD_CAT
	timeout = 120 SECONDS

/datum/mood_event/war_poster_wrong
	description = "I saw a poster that really pissed me off! How can people like that be allowed to work here?!"
	mood_change = -4
	category = WAR_POSTER_MOOD_CAT
	timeout = 120 SECONDS

#undef WAR_POSTER_MOOD_CAT
