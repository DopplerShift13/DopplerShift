/datum/quirk/genemodded
	name = "Genemodded"
	desc = "Some aspect of your physiology has been modified from your race's ordinary baseline, granting you a neutral or negative mutation of your choice."
	gain_text = span_notice("Your body feels unusual...")
	lose_text = span_notice("Normality returns in a flash.")
	medical_record_text = "Subject has innately modified genetic information."
	value = 0
	icon = FA_ICON_FLASK
	var/datum/mutation/added_mutation = NONE

/datum/quirk/genemodded/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/desired_mutation = client_source?.prefs.read_preference(/datum/preference/choiced/genemodded_dna)

	if (desired_mutation)
		added_mutation = GLOB.possible_genemods_for_quirk[desired_mutation]
		human_holder.dna.add_mutation(added_mutation, MUTATION_SOURCE_QUIRK)

/datum/quirk/genemodded/remove()
	// Prevents deleting quirks when the mob's already being removed which causes runtimes.
	if(QDELING(quirk_holder))
		return
	if (added_mutation)
		var/mob/living/carbon/human/human_holder = quirk_holder
		human_holder.dna.remove_mutation(added_mutation, MUTATION_SOURCE_QUIRK)
		added_mutation = null

/datum/quirk_constant_data/genemodded
	associated_typepath = /datum/quirk/genemodded
	customization_options = list(/datum/preference/choiced/genemodded_dna)

/datum/preference/choiced/genemodded_dna
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "genemodded_dna"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/proc/generate_genemod_quirk_list()
	var/list/allowed_mutation_qualities = list(NEGATIVE, MINOR_NEGATIVE)
	// Positive mutations that are intentionally available through Genemodded.
	var/list/whitelisted_mutations = list(
		/datum/mutation/dwarfism, // I'll be real this is cleaner than modular editing in a change to 0 stability. Oh no, alcohol healing. Oh no, tablepass.
	)
	// Negative mutations that are intentionally unavailable through Genemodded.
	var/list/blacklisted_mutations = list(
		/datum/mutation/blind,
		/datum/mutation/void,
		/datum/mutation/badblink,
		/datum/mutation/acidflesh,
		/datum/mutation/fire, // CI/CD pipeline issues
		/datum/mutation/stoner, // CI/CD pipeline issues
	)

	var/list/genemods = list()
	for (var/datum/mutation/mut as anything in subtypesof(/datum/mutation))
		// Unavailable mutations
		if(initial(mut.locked))
			continue
		// Mutations that are counted as positive that are not on the whitelist
		if(!(initial(mut.quality) in allowed_mutation_qualities) && !(mut in whitelisted_mutations))
			continue
		// Mutations that are not positive that are on the blacklist.
		if(mut in blacklisted_mutations)
			continue

		genemods[initial(mut.name)] = mut

	return sort_list(genemods)

GLOBAL_LIST_INIT(possible_genemods_for_quirk, generate_genemod_quirk_list())

/datum/preference/choiced/genemodded_dna/init_possible_values()
	return assoc_to_keys(GLOB.possible_genemods_for_quirk)

/datum/preference/choiced/genemodded_dna/create_default_value()
	return pick(assoc_to_keys(GLOB.possible_genemods_for_quirk))

/datum/preference/choiced/genemodded_dna/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Genemodded" in preferences.all_quirks

/datum/preference/choiced/genemodded_dna/apply_to_human(mob/living/carbon/human/target, value)
	return
