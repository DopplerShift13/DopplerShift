/// Enables the choice of background in the character preview menu
/datum/preference/choiced/background_state
	savefile_key = "background_state"
	savefile_identifier = PREFERENCE_CHARACTER

GLOBAL_LIST_INIT(background_state_options, list(
	"Black",
	"Grey",
	"White",
	"Dark Tiles",
	"Grey Tiles",
	"White Tiles",
	"Plating",
	"Reinforced Floor",
	"Grass",
	"4CA",
))

/datum/preference/choiced/background_state/create_default_value()
	return GLOB.background_state_options["Grey"]

/datum/preference/choiced/background_state/init_possible_values()
	return GLOB.background_state_options

/datum/preference/choiced/background_state/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
