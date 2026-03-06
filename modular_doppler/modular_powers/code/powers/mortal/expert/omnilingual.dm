// Lets you speak a lot of things; but not as many lots as Curator.
/datum/power/expert/omnilingual
	name = "Omnilingual"
	desc = "You speak an absurd amount of languages; you start off understanding every language at full proficiency. Does not apply to languages not available at character selection."

	value = 4
	// Saved list of languages that were given by this power to remove when the power is removed.
	var/list/given_languages_list = list()

// Iterate through every language in the roundstart languages. If they have it, skip, otherwise, give it to them and add it to given_langauges_list
/datum/power/expert/omnilingual/add()
	for(var/datum/language/language_type as anything in GLOB.uncommon_roundstart_languages)
		if(power_holder.has_language(language_type, ALL))
			continue
		power_holder.grant_language(language_type, ALL, src)
		given_languages_list += language_type

// Removes all languages that were given through omnilingual.
/datum/power/expert/omnilingual/remove()
	if(!power_holder)
		return

	for(var/datum/language/language_type as anything in given_languages_list)
		power_holder.remove_language(language_type, ALL, src)
	given_languages_list.Cut()
