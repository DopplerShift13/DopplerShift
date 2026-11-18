/datum/preference/toggle/admin
	abstract_type = /datum/preference/toggle/admin

/datum/preference/toggle/admin/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent)


/datum/preference/choiced/ooc_channel_emoji_sec
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ooc_channel_emoji_sec"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/ooc_channel_emoji_sec/create_default_value()
	return "shades"

/datum/preference/choiced/ooc_channel_emoji_sec/init_possible_values()
	return list(
		"shades",
		"flash",
		"flashbang",
		"whiskey",
		"riot",
		"up",
		"help",
		"cam",
		"disarm",
		"thinking",
		"drone",
		"taser",
		"charged",
		"on",
		"thelaw",
		"salt",
		"popcorn",
		"donut",
		"donut2",
	)

/datum/preference/choiced/ooc_channel_emoji_tot
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ooc_channel_emoji_tot"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/ooc_channel_emoji_tot/create_default_value()
	return "toysword"

/datum/preference/choiced/ooc_channel_emoji_tot/init_possible_values()
	return list(
		"toysword",
		"c4",
		"revolver",
		"disk",
		"pepper",
		"fedora",
		"rollie",
		"down",
		"flush",
		"swarmer",
		"call",
		"cultie",
		"haxxor",
		"sbomb",
		"conbaton",
		"trap",
		"sink",
		"grab",
		"harm",
	)
