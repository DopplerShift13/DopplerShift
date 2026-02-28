/datum/proximity_monitor/advanced/war_demoraliser
	/// The faction, using defines from TESHARI_WAR_defines.dm. Do NOT use neutral.
	var/faction
	/// Mood category to apply to moods
	var/mood_category
	/// Assoc list of (WAR_FACTION -> list(/datum/war_demoralisation_reaction, chance)). Used in pickweight to determine what people think when they see the poster, depending on
	var/list/faction_reactions = list()
	var/list/faction_moods = list()
	/// For literacy checks
	var/reading_requirements = READING_CHECK_LIGHT

/datum/proximity_monitor/advanced/war_demoraliser/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, faction, mood_category, list/faction_reactions, list/faction_moods, reading_requirements)
	. = ..()

	if (faction == WAR_FACTION_NEUTRAL)
		CRASH("War demoralizers should not be neutral. That's like, their entire point. They're propoganda.")
	RegisterSignal(host, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

	src.faction = faction
	src.mood_category = mood_category
	src.faction_reactions = faction_reactions
	src.faction_moods = faction_moods
	src.reading_requirements = reading_requirements

/datum/proximity_monitor/advanced/war_demoraliser/field_turf_crossed(atom/movable/crossed, turf/old_location, turf/new_location)
	if (!isliving(crossed))
		return
	if (!can_see(crossed, host, current_range))
		return
	on_seen(crossed)

/*
 * Signal proc for [COMSIG_ATOM_EXAMINE].
 * Immediately tries to apply a mood to the examiner, ignoring the proximity check.
 * If someone wants to make themselves sad through a camera that's their choice I guess.
 */
/datum/proximity_monitor/advanced/war_demoraliser/proc/on_examine(datum/source, mob/examiner)
	SIGNAL_HANDLER
	if (isliving(examiner))
		on_seen(examiner)

/**
 * Called when someone is looking at a war-related demoralizer.
 * Applies a mood if they are conscious and don't already have it.
 * Different moods are applied based on their faction.
 *
 * Arguments
 * * viewer - Whoever is looking at this.
 */
/datum/proximity_monitor/advanced/war_demoraliser/proc/on_seen(mob/living/viewer)
	if (!viewer.mind)
		return
	// If you're not conscious you're too busy or dead to look at propaganda
	if (viewer.stat != CONSCIOUS)
		return
	if(viewer.is_blind())
		return
	if (!should_demoralise(viewer))
		return
	if(!viewer.can_read(host, reading_requirements, TRUE)) //if it's a text based demoralization datum, make sure the mob has the capability to read. if it's only an image, make sure it's just bright enough for them to see it.
		return

	var/target_faction = viewer.mind.war_faction
	var/datum/mood_event/mood = faction_moods[target_faction]
	if (isnull(mood))
		return
	viewer.add_mood_event(mood_category, mood)
	var/list/reactions = faction_reactions[target_faction]
	if (isnull(reactions))
		return
	var/reaction = pick_weight(reactions)
	to_chat(viewer, span_notice(reaction))

/**
 * Returns true if user is capable of experiencing moods and doesn't already have the one relevant to this datum, false otherwise.
 *
 * Arguments
 * * viewer - Whoever just saw the parent.
 */
/datum/proximity_monitor/advanced/war_demoraliser/proc/should_demoralise(mob/living/viewer)
	if (!viewer.mob_mood)
		return FALSE

	return !viewer.mob_mood.has_mood_of_category(mood_category)
