/*
	You can be summoned by speaking a specific keyword, in a certain language, with a ton of caveats.
*/
#define SUMMONABLE_LANGUAGE_ANY "Any"

/// BIG TODO: Once Powers PR2 merges adjust this to Imbued and not Aberrant

/datum/power/aberrant/summonable
	name = "Summonable"
	desc = "By speaking a specific name or word (and depending on your choice: in a specific language), you appear next to the speaker after a short delay. The summoning takes time, you are stunned throughout, is entirely involuntary and can only be stopped by being silenced, buckled, wearing magboots or by being dispelled.\
	\n After being succesfuly summoned, you are unable to be summoned again for 1 minute. \
	\n The chosen word is a partial secret; the Security Records on your powers contain the word as well. It cannot contain any special characters, only standard letters and numbers."
	security_threat = POWER_THREAT_MAJOR
	value = 7

	required_powers = list(/datum/power/aberrant_root/anomalous)

	/// Reference to the summonable component
	var/datum/component/summonable/summon_component

// Lists the word in sec records.
/datum/power/aberrant/summonable/get_security_record_text()
	var/resolved_keyword = summon_component?.keyword
	var/resolved_language_name = summon_component?.language_name
	if(!resolved_keyword)
		var/datum/preference/text/summonable_keyword/preference_entry = GLOB.preference_entries[/datum/preference/text/summonable_keyword]
		resolved_keyword = preference_entry?.create_default_value() || "Beetlejuice"
	if(!resolved_language_name)
		var/datum/preference/choiced/summonable_language/language_preference = GLOB.preference_entries[/datum/preference/choiced/summonable_language]
		resolved_language_name = language_preference?.create_default_value() || SUMMONABLE_LANGUAGE_ANY
	if(resolved_language_name == SUMMONABLE_LANGUAGE_ANY) // if no language
		return "Subject is summonable via keyword \"[resolved_keyword]\"."
	return "Subject is summonable via keyword \"[resolved_keyword]\" when spoken in [resolved_language_name]."

// Gets and sets various prefs + the component
/datum/power/aberrant/summonable/add(client/client_source)
	if(!power_holder)
		return ..()

	// Gets the component on the mob
	var/mob/living/holder = power_holder
	var/datum/component/summonable/component = holder.GetComponent(/datum/component/summonable)
	if(!component)
		component = holder.AddComponent(/datum/component/summonable)
	summon_component = component

	// Gets the keywords from prefs
	component.keyword = client_source?.prefs?.read_preference(/datum/preference/text/summonable_keyword)
	if(!component.keyword)
		var/datum/preference/text/summonable_keyword/preference_entry = GLOB.preference_entries[/datum/preference/text/summonable_keyword]
		component.keyword = preference_entry?.create_default_value() || "Beetlejuice"

	// Gets the language from prefs
	component.language_name = client_source?.prefs?.read_preference(/datum/preference/choiced/summonable_language)
	if(!component.language_name)
		var/datum/preference/choiced/summonable_language/language_preference = GLOB.preference_entries[/datum/preference/choiced/summonable_language]
		component.language_name = language_preference?.create_default_value() || SUMMONABLE_LANGUAGE_ANY

	// Gets the color from prefs
	component.rune_color = client_source?.prefs?.read_preference(/datum/preference/color/summonable_rune_color) || component.rune_color
	component.update_regex()

	. = ..()

/datum/power/aberrant/summonable/remove()
	. = ..()
	if(summon_component)
		QDEL_NULL(summon_component)

// Standalone summonable component.
/datum/component/summonable
	/// Keyword used to trigger the summon.
	var/keyword
	/// Delay between summons.
	var/cooldown = 60 SECONDS // for the love of god don't make this shorter than 10 seconds you will break things.
	/// Whether the summon can currently trigger.
	var/active = TRUE
	/// Whether the keyword match is case sensitive.
	var/case_sensitive = FALSE
	/// Spoken language name required to trigger the summon, or "Any" for no restriction.
	var/language_name = SUMMONABLE_LANGUAGE_ANY
	/// Compiled regex for matching the keyword in speech.
	var/regex/keyword_regex
	/// Delay after your name being mentioned before the summoning begins
	var/summon_delay = 1 SECONDS
	/// How long it takes for you to fully float up
	var/float_time = 3.5 SECONDS
	/// How long a failed summon resistance holds you in place before the summon fizzles.
	var/resist_lock_time = 2 SECONDS
	/// How long the failed summon spotlight takes to fade out.
	var/resist_fade_time = 0.5 SECONDS
	/// Radius for orbiting runes
	var/rune_orbit_radius = 30
	/// Rotation speed for orbiting runes
	var/rune_rotation_speed = 30
	/// Amount of runes that orbit
	var/rune_count = 8
	/// Duration between each rune being sapwned
	var/rune_spawn_interval = 3.4
	/// Time for runes to fade in
	var/rune_fade_time = 6
	/// Color of the runes
	var/rune_color = "#ff2a2a"

	/// Are we currently being summoned? (mostly used for dispels)
	var/summoning = FALSE
	/// Are we currently being beamed up? (mostly used for dispels)
	var/beaming_up = FALSE
	/// List of currnet active runes orbiting the mob.
	var/list/obj/effect/summonable_rune_orbiter/current_runes

/*
	The beetlejuice component cannot satisfy our wants no more.
	Because we want language integration, we need to move off of COMSIG_MOB_SAY_SPECIAL and onto COMSIG_MOB_SAY. Paired with how we are full of redundancy in the beetlejuice component, we have now moved summonable to its own standalone component.
*/
/// Sets up summon tracking and registers speech listeners for all living mobs. This is how beetlejuice did it, and admittedly there's no easier way to do it.
/datum/component/summonable/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	var/atom/movable/owner = parent
	keyword = owner.name
	if(ismob(owner))
		var/mob/owner_mob = owner
		keyword = owner_mob.real_name
	update_regex()

	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(register_speaker))
	for(var/mob/living/living_mob as anything in GLOB.mob_living_list)
		register_speaker(null, living_mob)

/// Cleans up global and per-mob speech listeners.
/datum/component/summonable/Destroy(force)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED)
	for(var/mob/living/living_mob as anything in GLOB.mob_living_list)
		UnregisterSignal(living_mob, COMSIG_MOB_SAY)
	return ..()

/// Hooks newly created living mobs into the summon keyword listener.
/datum/component/summonable/proc/register_speaker(datum/source, mob/new_mob)
	SIGNAL_HANDLER

	if(!isliving(new_mob))
		return
	RegisterSignal(new_mob, COMSIG_MOB_SAY, PROC_REF(say_react))

/// Rebuilds the keyword regex after config changes.
/datum/component/summonable/proc/update_regex()
	keyword_regex = regex("[REGEX_QUOTE(keyword)]", "g[case_sensitive ? "" : "i"]")

/// Keeps the regex synchronized with VV edits to keyword-related vars.
/datum/component/summonable/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, keyword) || var_name == NAMEOF(src, case_sensitive))
		update_regex()

/// Watches spoken messages for the summon keyword and starts the summon once it matches.
/datum/component/summonable/proc/say_react(mob/speaker, list/say_args)
	SIGNAL_HANDLER

	if(!speaker || speaker == parent || !active)
		return

	var/message = say_args[SPEECH_MESSAGE]
	if(!message)
		return
	if(!language_matches_speech(say_args[SPEECH_LANGUAGE]))
		return

	var/found = keyword_regex.Find(message)
	if(!found)
		return
	keyword_regex.next = 1
	apport(speaker)

/// Returns TRUE when the spoken language satisfies the summon restriction.
/datum/component/summonable/proc/language_matches_speech(spoken_language)
	if(language_name == SUMMONABLE_LANGUAGE_ANY)
		return TRUE
	if(!spoken_language)
		return FALSE

	var/datum/language/required_language = GLOB.language_types_by_name[language_name]
	if(!required_language)
		return FALSE
	return (spoken_language == required_language || ispath(spoken_language, required_language))

/// Proc that validates and then starts the summoning sequence.
/datum/component/summonable/proc/apport(atom/target)
	var/atom/movable/summoned = parent
	if(ismob(summoned))
		var/mob/living/living_summoned = summoned
		if(HAS_TRAIT(living_summoned, TRAIT_RESONANCE_SILENCED))
			return
	// We don't block .loc for the sake of it being funny to be yoinked out of things, but cryopods are too integral to not.
	if(istype(summoned.loc, /obj/machinery/cryopod))
		return
	var/turf/target_turf = get_adjacent_open_turf(target)
	if(QDELETED(summoned) || !target_turf)
		return
	// Prevents being summoned to bad places.
	if(!can_summon_to_turf(target_turf))
		return
	if(destination_is_visible_to_summoned(summoned, target_turf))
		return
	active = FALSE
	addtimer(VARSET_CALLBACK(src, active, TRUE), cooldown)
	if(isliving(summoned))
		var/mob/living/living_summoned = summoned
		if(living_summoned.buckled)
			handle_resisted_summon(
				living_summoned,
				span_warning("[living_summoned] strains against an invisible pull upward, but remains held fast!"),
				span_warning("An invisible force tries to pull you away into the air, but whatever has you buckled keeps you in place!")
			)
			return
	addtimer(CALLBACK(src, PROC_REF(begin_summon), summoned, target_turf), summon_delay)

/// Gets a valid nearby turf within the mob's area.
/datum/component/summonable/proc/get_adjacent_open_turf(atom/target)
	var/turf/center = get_turf(target)
	if(!center)
		return null
	var/list/candidates = list()
	for(var/turf/candidate_turf in orange(1, center))
		if(candidate_turf == center)
			continue
		if(!can_summon_to_turf(candidate_turf))
			continue
		if(candidate_turf.is_blocked_turf(exclude_mobs = FALSE, ignore_atoms = list(/obj/structure/table), type_list = TRUE))
			continue
		candidates += candidate_turf
	if(!length(candidates))
		return null
	return pick(candidates)

/// Keeps Summonable off forbidden z-levels.
/datum/component/summonable/proc/can_summon_to_turf(turf/target_turf)
	if(!target_turf)
		return FALSE
	if(is_centcom_level(target_turf.z)) // no more sneaking into centcomm because a medibot said "an apple a day keeps me away"
		return FALSE
	return TRUE

/// Prevents summoning to locations the summoned can already see.
/datum/component/summonable/proc/destination_is_visible_to_summoned(atom/movable/summoned, turf/target_turf)
	if(!ismob(summoned) || !target_turf)
		return FALSE

	var/mob/summoned_mob = summoned
	return (target_turf in view(summoned_mob))

/// Starts the timers and starts manifesting effects.
/datum/component/summonable/proc/begin_summon(atom/movable/summoned, turf/target_turf)
	if(QDELETED(summoned) || QDELETED(target_turf))
		return
	if(!can_summon_to_turf(target_turf))
		return
	if(isliving(summoned))
		var/mob/living/living_summoned = summoned
		if(HAS_TRAIT(living_summoned, TRAIT_RESONANCE_SILENCED))
			return
		// Magboots prevent summons by just sheer magnetism. YE SCIENCE BITCH-
		if(has_active_magboots(living_summoned))
			handle_resisted_summon(
				living_summoned,
				span_warning("[living_summoned] strains against an invisible pull upward, but their magboots hold fast!"),
				span_warning("An invisible force tries to pull you away into the air, but your magboots lock you in place!")
			)
			return
	summoning = TRUE
	beaming_up = TRUE
	// Start departure immediately while runes are appearing.
	var/turf/origin_turf = get_turf(summoned)
	var/obj/effect/temp_visual/spotlight/summonable/origin_spotlight = origin_turf ? new(origin_turf, rune_color) : null

	var/old_alpha = summoned.alpha
	var/old_pixel_y = summoned.pixel_y

	RegisterSignal(summoned, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	summoned.anchored = TRUE
	ADD_TRAIT(summoned, TRAIT_IMMOBILIZED, "summonable_apport")
	// Keep them standing but unable to act; float without full levitation.
	ADD_TRAIT(summoned, TRAIT_MOVE_FLOATING, "summonable_apport")

	// Depart: float up and fade out at the origin.
	summoned.visible_message(span_warning("[summoned] leaves the ground, and begins to vanish into thin air!"))
	animate(summoned, alpha = 0, pixel_y = old_pixel_y + 32, time = float_time)
	addtimer(CALLBACK(src, PROC_REF(clear_origin_spotlight), origin_spotlight), float_time)

	var/list/obj/effect/summonable_rune_orbiter/runes = list()
	current_runes = runes
	addtimer(CALLBACK(src, PROC_REF(spawn_rune_sequence), summoned, target_turf, runes, 1, old_alpha, old_pixel_y), 0)

/// Returns TRUE if the living mob has active magboots equipped.
/datum/component/summonable/proc/has_active_magboots(mob/living/living_summoned)
	var/obj/item/clothing/shoes/magboots/equipped_magboots = living_summoned.get_item_by_slot(ITEM_SLOT_FEET)
	// worn magboots
	if(istype(equipped_magboots) && equipped_magboots.magpulse)
		return TRUE

	// magboots for mod modules support
	var/obj/item/mod/control/worn_modsuit = living_summoned.get_item_by_slot(ITEM_SLOT_BACK)
	if(!istype(worn_modsuit))
		return FALSE
	for(var/obj/item/mod/module/magboot/magboot_module as anything in worn_modsuit.modules)
		if(magboot_module.active)
			return TRUE

	return FALSE

/// Plays the failed-summon fakeout when something holds the target in place.
/datum/component/summonable/proc/handle_resisted_summon(mob/living/living_summoned, visible_message_text, self_message_text)
	var/turf/origin_turf = get_turf(living_summoned)
	if(!origin_turf)
		return

	var/obj/effect/temp_visual/spotlight/summonable/origin_spotlight = new(origin_turf, rune_color)

	living_summoned.visible_message(
		visible_message_text,
		self_message_text
	)
	ADD_TRAIT(living_summoned, TRAIT_IMMOBILIZED, "summonable_apport")
	living_summoned.Shake(pixelshiftx = 2, pixelshifty = 1, duration = resist_lock_time, shake_interval = 0.04 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(finish_resisted_summon), living_summoned, origin_spotlight), resist_lock_time)

/// Clears the failed-summon fakeout without ever moving the summoned target.
/datum/component/summonable/proc/finish_resisted_summon(mob/living/living_summoned, obj/effect/temp_visual/spotlight/summonable/origin_spotlight)
	if(!QDELETED(living_summoned))
		REMOVE_TRAIT(living_summoned, TRAIT_IMMOBILIZED, "summonable_apport")
	if(QDELETED(origin_spotlight))
		return
	animate(origin_spotlight, alpha = 0, time = resist_fade_time)
	addtimer(CALLBACK(src, PROC_REF(clear_origin_spotlight), origin_spotlight), resist_fade_time)

/// Removes the spotlight
/datum/component/summonable/proc/clear_origin_spotlight(obj/effect/temp_visual/spotlight/summonable/origin_spotlight)
	QDEL_NULL(origin_spotlight)

/// Creates the cool floaty runes
/datum/component/summonable/proc/spawn_rune_sequence(atom/movable/summoned, turf/target_turf, list/obj/effect/summonable_rune_orbiter/runes, rune_index, old_alpha, old_pixel_y)
	if(!summoning)
		QDEL_LIST(runes)
		return
	if(QDELETED(summoned) || QDELETED(target_turf))
		QDEL_LIST(runes)
		return
	if(rune_index > rune_count)
		begin_arrival(summoned, target_turf, runes, old_alpha, old_pixel_y)
		return

	var/obj/effect/summonable_rune_orbiter/rune = new(target_turf, rune_color)
	rune.orbit(target_turf, rune_orbit_radius, rotation_speed = rune_rotation_speed, rotation_segments = rune_count, pre_rotation = FALSE)
	runes += rune

	addtimer(CALLBACK(src, PROC_REF(spawn_rune_sequence), summoned, target_turf, runes, rune_index + 1, old_alpha, old_pixel_y), rune_spawn_interval)

/// BEGINS THE RAPTURE
/datum/component/summonable/proc/begin_arrival(atom/movable/summoned, turf/target_turf, list/obj/effect/summonable_rune_orbiter/runes, old_alpha, old_pixel_y)
	if(!summoning)
		QDEL_LIST(runes)
		return
	if(QDELETED(summoned) || QDELETED(target_turf))
		QDEL_LIST(runes)
		return
	// We check one more time if the spot's valid before actually going htere.
	if(!can_summon_to_turf(target_turf))
		cancel_summon(summoned)
		QDEL_LIST(runes)
		return
	beaming_up = FALSE

	var/obj/effect/temp_visual/spotlight/summonable/spotlight = new(target_turf, rune_color)
	fade_and_clear_runes(runes)

	summoned.forceMove(target_turf)
	summoned.alpha = 0
	summoned.pixel_y = 32
	animate(summoned, alpha = old_alpha, pixel_y = old_pixel_y, time = float_time)

	playsound(summoned, 'sound/effects/magic/voidblink.ogg', 50, TRUE)
	summoned.visible_message(span_warning("[summoned] appears out of thin air!"))

	addtimer(CALLBACK(src, PROC_REF(finish_summon), summoned, target_turf, old_alpha, old_pixel_y, spotlight), float_time)

/// Fade and clear the runes.
/datum/component/summonable/proc/fade_and_clear_runes(list/obj/effect/summonable_rune_orbiter/runes)
	for(var/obj/effect/summonable_rune_orbiter/rune in runes)
		animate(rune, alpha = 0, time = rune_fade_time)
	addtimer(CALLBACK(src, PROC_REF(clear_runes), runes), rune_fade_time)

/// Removes all active runes.
/datum/component/summonable/proc/clear_runes(list/obj/effect/summonable_rune_orbiter/runes)
	QDEL_LIST(runes)

/// Alright, shows over, he's here now. Time to pack up and go.
/datum/component/summonable/proc/finish_summon(atom/movable/summoned, turf/target_turf, old_alpha, old_pixel_y, obj/effect/temp_visual/spotlight/summonable/spotlight)
	if(QDELETED(summoned))
		QDEL_NULL(spotlight)
		return

	summoned.alpha = old_alpha
	summoned.pixel_y = old_pixel_y
	summoned.anchored = FALSE
	REMOVE_TRAIT(summoned, TRAIT_IMMOBILIZED, "summonable_apport")
	REMOVE_TRAIT(summoned, TRAIT_MOVE_FLOATING, "summonable_apport")
	if(target_turf)
		summoned.forceMove(target_turf)
	// Explicitly trigger glass table break checks on landing. This isn't clean, but its too funny to not have it.
	if(isliving(summoned))
		var/mob/living/living_summoned = summoned
		var/obj/structure/table/glass/glass_table = locate(/obj/structure/table/glass) in get_turf(living_summoned)
		if(glass_table)
			glass_table.check_break(living_summoned)

	QDEL_NULL(spotlight)
	UnregisterSignal(summoned, COMSIG_ATOM_DISPEL)
	summoning = FALSE
	beaming_up = FALSE
	current_runes = null
	active = FALSE
	addtimer(VARSET_CALLBACK(src, active, TRUE), cooldown)

/// Ends summon at certain stages.
/datum/component/summonable/proc/on_dispel(atom/movable/target, atom/dispeller)
	SIGNAL_HANDLER
	// Only cancel if they're currently being beamed up.
	if(!beaming_up || !summoning)
		return NONE
	cancel_summon(target)
	if(ishuman(target))
		var/mob/living/carbon/human/failed_summon = target
		// Do you have anything to brace your fall? Or do you possibly manage to get lucky?
		var/obj/item/organ/wings/gliders = failed_summon.get_organ_by_type(/obj/item/organ/wings)
		if(HAS_TRAIT(failed_summon, TRAIT_FREERUNNING) || gliders?.can_soften_fall() || prob(20))
			failed_summon.visible_message(span_warning("[failed_summon] suddenly reappears and lands back on the ground!"), span_warning("You drop to the ground, but manage to catch yourself!"))
		else
			failed_summon.visible_message(span_warning("[failed_summon] suddenly reappears and falls face-first onto the ground!"), span_userdanger("You suddenly fall face-first onto the ground!"))
			playsound(failed_summon, 'sound/effects/desecration/desecration-02.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
			failed_summon.adjustBruteLoss(5)
			failed_summon.Knockdown(3 SECONDS)
	return DISPEL_RESULT_DISPELLED

/// Ends the summoning right there and now.
/datum/component/summonable/proc/cancel_summon(atom/movable/summoned)
	if(summoned)
		summoned.alpha = initial(summoned.alpha)
		summoned.pixel_y = initial(summoned.pixel_y)
		summoned.anchored = FALSE
		REMOVE_TRAIT(summoned, TRAIT_IMMOBILIZED, "summonable_apport")
		REMOVE_TRAIT(summoned, TRAIT_MOVE_FLOATING, "summonable_apport")
		UnregisterSignal(summoned, COMSIG_ATOM_DISPEL)
	if(current_runes)
		QDEL_LIST(current_runes)
	current_runes = null
	summoning = FALSE
	beaming_up = FALSE

// Preference choice for Summonable keyword selection.
/datum/preference/text/summonable_keyword
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "summonable_keyword"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 32

/datum/preference/text/summonable_keyword/create_default_value()
	return "Beetlejuice"

/datum/preference/text/summonable_keyword/is_valid(value)
	if(!istext(value))
		return FALSE
	if(length(value) < 1 || length(value) >= maximum_value_length)
		return FALSE
	// Allow only ASCII letters and numbers.
	var/quoted = REGEX_QUOTE(value)
	var/static/regex/allowed_regex = regex("^" + ascii2text(91) + "A-Za-z0-9" + ascii2text(93) + "+$")
	allowed_regex.next = 1
	return !!allowed_regex.Find(quoted)

/datum/preference/text/summonable_keyword/deserialize(input, datum/preferences/preferences)
	var/value = ..()
	if(!is_valid(value))
		return null
	return value

/datum/preference/text/summonable_keyword/apply_to_human(mob/living/carbon/human/target, value)
	return

// Preference choice for Summonable rune/spotlight color.
/datum/preference/color/summonable_rune_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "summonable_rune_color"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/summonable_rune_color/create_default_value()
	return "ff2a2a"

/datum/preference/color/summonable_rune_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return TRUE

/datum/preference/color/summonable_rune_color/apply_to_human(mob/living/carbon/human/target, value)
	return

/// Preference options for which language can trigger your summon.
/datum/preference/choiced/summonable_language
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "summonable_language"
	savefile_identifier = PREFERENCE_CHARACTER
	should_generate_icons = TRUE

/datum/preference/choiced/summonable_language/create_default_value()
	return SUMMONABLE_LANGUAGE_ANY

/// Gets an icon for the chosen summonable language.
/datum/preference/choiced/summonable_language/icon_for(value)
	if(value == SUMMONABLE_LANGUAGE_ANY)
		var/datum/universal_icon/any_icon = uni_icon('icons/ui/chat/language.dmi', "unknown")
		any_icon.scale(32, 32)
		return any_icon

	var/datum/language/language_type = GLOB.language_types_by_name[value]
	if(language_type)
		var/datum/universal_icon/language_icon = uni_icon(language_type.icon, language_type.icon_state)
		language_icon.scale(32, 32)
		return language_icon

	var/datum/universal_icon/unknown_icon = uni_icon('icons/ui/chat/language.dmi', "unknown")
	unknown_icon.scale(32, 32)
	return unknown_icon

/// Uses the same language pool as the bilingual preference, plus an unrestricted option.
/datum/preference/choiced/summonable_language/init_possible_values()
	var/list/values = list()
	var/datum/species/species = GLOB.species_prototypes[/datum/species/human] // we can't read species choice in choiced components since they're generic, so we default to human
	var/datum/language_holder/lang_holder = null

	if(!GLOB.uncommon_roundstart_languages.len)
		generate_selectable_species_and_languages()

	if(species)
		lang_holder = new species.species_language_holder()

	values += SUMMONABLE_LANGUAGE_ANY

	// Iterates all languages, curbing any secret languages.
	for(var/datum/language/language_type as anything in GLOB.uncommon_roundstart_languages)
		var/datum/language/language = GLOB.language_datum_instances[language_type]
		if(language?.secret)
			continue
		if(species?.always_customizable && lang_holder && !(language.type in lang_holder.spoken_languages))
			continue
		if(initial(language_type.name) in values)
			continue
		values += initial(language_type.name)

	if(lang_holder)
		qdel(lang_holder)

	return values

/datum/preference/choiced/summonable_language/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/summonable
	associated_typepath = /datum/power/aberrant/summonable
	customization_options = list(/datum/preference/text/summonable_keyword, /datum/preference/color/summonable_rune_color, /datum/preference/choiced/summonable_language)

// Orbiting rune for Summonable arrival.
/obj/effect/summonable_rune_orbiter
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "small_rune_1"
	layer = BELOW_MOB_LAYER
	anchored = TRUE
	mouse_opacity = 0

// We set the specific icons because we don't want the color shifting. Beyond that, colors!
/obj/effect/summonable_rune_orbiter/Initialize(mapload, rune_color = "#ff2a2a")
	var/rune_state = "small_rune_[rand(1, 10)]"
	var/icon/rune_icon = icon('icons/effects/eldritch.dmi', rune_state, frame = 1)
	// Force the base green to a greyscale color.
	rune_icon.MapColors(0.33, 0.33, 0.33, 0.33, 0.33, 0.33, 0.33, 0.33, 0.33)
	// Boost brightness before applying the chosen color.
	rune_icon.Blend(rgb(160, 160, 160), ICON_ADD)
	// Apply the color from prefs.
	rune_icon.Blend(rune_color, ICON_MULTIPLY)
	icon = rune_icon
	icon_state = null
	return ..()

// Green spotlight at the destination.
/obj/effect/temp_visual/spotlight/summonable
	color = COLOR_RED
	duration = 3 SECONDS

/obj/effect/temp_visual/spotlight/summonable/Initialize(mapload, spotlight_color = COLOR_RED)
	color = spotlight_color
	return ..()

#undef SUMMONABLE_LANGUAGE_ANY
