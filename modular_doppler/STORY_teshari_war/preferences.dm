GLOBAL_LIST_INIT(teshari_war_factions, list(
	WAR_FACTION_TIZIRA,
	WAR_FACTION_TESHARI,
	WAR_FACTION_NEUTRAL
))

/datum/preference/choiced/doppler_war_faction
	savefile_key = "doppler_war_faction"
	main_feature_name = "War Alignment"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/doppler_war_faction/init_possible_values()
	return GLOB.teshari_war_factions

/datum/preference/choiced/doppler_war_faction/create_default_value()
	return WAR_FACTION_NEUTRAL

/datum/preference/choiced/doppler_war_faction/apply_to_human(mob/living/carbon/human/target, value)
	RegisterSignal(target, COMSIG_MOB_MIND_INITIALIZED, PROC_REF(apply_mind_variable), override = TRUE)
	return

/// Signal handler that waits for mind to init and then sets the war faction variable.
/datum/preference/choiced/doppler_war_faction/proc/apply_mind_variable(mob/living/carbon/human/target, datum/mind/new_mind)
	SIGNAL_HANDLER

	new_mind.war_faction = target.client.prefs.read_preference(/datum/preference/choiced/doppler_war_faction)
	UnregisterSignal(target, COMSIG_MOB_MIND_INITIALIZED)

