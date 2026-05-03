/**
	Old wife tale of sneezing when your name is mentioned.
**/
/datum/power/psyker_power/premonition
	name = "Premonition"
	desc = "You are aware when a particular something is mentioned; a hunch as it were.\
	\n Select a specific word or phrase; anytime someone mentions it (no matter where they are), you will trigger the chosen emote. Has a cooldown of 10 seconds."
	security_record_text = "Subject has strange bodily reactions whenever a certain keyphrase is mentioned."
	value = 2

	/// Trakcs the component
	var/datum/component/beetlejuice/premonition/premonition_component

// Adds the special beetlejuice component, gets the prefernece components.
/datum/power/psyker_power/premonition/post_add()
	if(!power_holder)
		return

	// Gets the holder and component
	var/mob/living/holder = power_holder
	var/datum/component/beetlejuice/premonition/component = holder.GetComponent(/datum/component/beetlejuice/premonition)
	if(!component)
		component = holder.AddComponent(/datum/component/beetlejuice/premonition)

	premonition_component = component

	// Sets the word of the day.
	var/keyword = holder.client?.prefs?.read_preference(/datum/preference/text/premonition_keyword)
	if(!keyword)
		var/datum/preference/text/premonition_keyword/pref_entry = GLOB.preference_entries[/datum/preference/text/premonition_keyword]
		keyword = pref_entry?.create_default_value() || "Beetlejuice"

	component.keyword = keyword
	component.update_regex()

	// Sets the emote key.
	var/emote_choice = holder.client?.prefs?.read_preference(/datum/preference/choiced/premonition_emote)
	var/datum/preference/choiced/premonition_emote/pref_entry = GLOB.preference_entries[/datum/preference/choiced/premonition_emote]
	component.emote_key = pref_entry?.validate_premonition_emote_choice(emote_choice) || "sneeze"
	. = ..()

/datum/power/psyker_power/premonition/remove()
	. = ..()
	if(premonition_component)
		QDEL_NULL(premonition_component)

// Custom beetlejuice component for Premonition.
/datum/component/beetlejuice/premonition
	min_count = 1
	cooldown = 10 SECONDS
	var/emote_key = "sneeze"

// When the phrase is mentioned.
/datum/component/beetlejuice/premonition/apport(atom/target)
	var/atom/movable/triggered = parent
	if(!ismob(triggered))
		return
	var/mob/living/living_triggered = triggered
	if(HAS_TRAIT(living_triggered, TRAIT_RESONANCE_SILENCED))
		return
	if(!emote_key)
		return
	living_triggered.emote(emote_key, intentional = FALSE)
	active = FALSE
	addtimer(VARSET_CALLBACK(src, active, TRUE), cooldown)

// Preference choice for Premonition keyword selection.
/datum/preference/text/premonition_keyword
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "premonition_keyword"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 32

/datum/preference/text/premonition_keyword/create_default_value()
	return "Beetlejuice"

/datum/preference/text/premonition_keyword/is_valid(value)
	if(!istext(value))
		return FALSE
	if(length(value) < 1 || length(value) >= maximum_value_length)
		return FALSE
	// Allow only ASCII letters, numbers, and spaces.
	var/quoted = REGEX_QUOTE(value)
	var/static/regex/allowed_regex = regex("^" + ascii2text(91) + "A-Za-z0-9 " + ascii2text(93) + "+$")
	allowed_regex.next = 1
	return !!allowed_regex.Find(quoted)

/datum/preference/text/premonition_keyword/deserialize(input, datum/preferences/preferences)
	var/value = ..()
	if(!is_valid(value))
		return null
	return value

/datum/preference/text/premonition_keyword/apply_to_human(mob/living/carbon/human/target, value)
	return

// Preference choice for Premonition emote selection.
/datum/preference/choiced/premonition_emote
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "premonition_emote"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/premonition_emote/create_default_value()
	return validate_premonition_emote_choice("sneeze")

/datum/preference/choiced/premonition_emote/init_possible_values()
	return get_premonition_emote_choices()

/datum/preference/choiced/premonition_emote/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return TRUE

/datum/preference/choiced/premonition_emote/apply_to_human(mob/living/carbon/human/target, value)
	return

/// Gets the list of emotes available for preminition using the global emote list.
/datum/preference/choiced/premonition_emote/proc/get_premonition_emote_choices()
	var/list/choices = list()
	for(var/key in GLOB.emote_list)
		for(var/datum/emote/emote_action in GLOB.emote_list[key])
			if(emote_action.key == key)
				choices += key
				break
	if(!length(choices))
		return list("sneeze")
	return sort_list(choices)

/// Makes sure that the chosen emote is actually in the emote list and not just some random-thing you made up.
/datum/preference/choiced/premonition_emote/proc/validate_premonition_emote_choice(value)
	if(!istext(value))
		value = null
	var/list/choices = get_premonition_emote_choices()
	if(value && (value in choices))
		return value
	return choices[1]

/datum/power_constant_data/premonition
	associated_typepath = /datum/power/psyker_power/premonition
	customization_options = list(
		/datum/preference/text/premonition_keyword,
		/datum/preference/choiced/premonition_emote
	)
