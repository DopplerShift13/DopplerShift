// Lets you speak a lot of things; but not as many lots as Curator.
/datum/power/expert/omnilingual
	name = "Omnilingual"
	desc = "You speak an absurd amount of languages; you are able to understand and speak every language at full proficiency. Does not apply to languages not available to your character at character selection."
	value = 4
	/// Saved list of languages that were given by this power to remove when the power is removed.
	var/list/given_languages_list = list()

/datum/power/expert/omnilingual/get_security_record_text()
	var/datum/language_holder/holder = power_holder?.get_language_holder()
	var/total_languages = LAZYLEN(holder?.spoken_languages)
	return "Subject has fluency in [total_languages] languages."

// Iterate through the language prefs list. If they have it, skip, otherwise, give it to them and add it to given_languages_list.
/datum/power/expert/omnilingual/add()
	if(!power_holder)
		return

	var/datum/species/species = null
	if(istype(power_holder, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_holder = power_holder
		species = human_holder.dna?.species

	var/datum/language_holder/lang_holder = null
	if(species)
		lang_holder = new species.species_language_holder()

	given_languages_list = list()
	// Doppler languages specifically filter all languages, so we mimmick those filters.
	for (var/language_name in GLOB.all_languages_by_priority)
		var/datum/language/language = GLOB.language_datum_instances[language_name]

		// If we already have the language, skip
		if(power_holder.has_language(language.type, ALL))
			continue

		// Skips secret languages.
		if(language.secret && !(species && (language.type in species.language_prefs_whitelist)))
			continue

		// Trims languages not available to your species.
		if(species && species.always_customizable && lang_holder && !(language.type in lang_holder.spoken_languages))
			continue

		power_holder.grant_language(language.type, ALL, src)
		given_languages_list += language.type

	if(lang_holder)
		qdel(lang_holder)

// Removes all languages that were given through omnilingual.
/datum/power/expert/omnilingual/remove()
	if(!power_holder)
		return

	for(var/datum/language/language_type as anything in given_languages_list)
		power_holder.remove_language(language_type, ALL, src)
	given_languages_list.Cut()
