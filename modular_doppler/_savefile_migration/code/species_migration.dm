/*
 * Transfers an Ethereal's old hardcoded palette selection to the standard mutant color preference.
 */
/datum/preferences/proc/migrate_ethereal_color_to_mutant_color(list/save_data)
	if(save_data?["species"] != SPECIES_ETHEREAL)
		return
	var/legacy_color_name = save_data["feature_ethcolor"]
	var/legacy_color = GLOB.color_list_ethereal[legacy_color_name]
	if(isnull(legacy_color))
		return
	write_preference(GLOB.preference_entries[/datum/preference/color/mutant_color], legacy_color)
	save_data -= "feature_ethcolor"
