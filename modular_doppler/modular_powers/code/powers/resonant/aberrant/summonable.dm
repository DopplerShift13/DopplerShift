/*
	You can be summoned by speaking a specific keywords.
*/
/datum/power/aberrant/summonable
	name = "Summonable"
	desc = "By speaking a specific name or word, you appear next to the speaker after a short delay. The summoning takes time, you are stunned throughout, is entirely involuntary and can only be stopped by being silenced, buckled or dispelled.\
	\n After being succesfuly summoned, you are unable to be summoned again for 1 minute. \
	\n The chosen word is a partial secret; the Security Records on your powers contain the word as well. It cannot contain any special characters, only standard letters and numbers."
	security_threat = POWER_THREAT_MAJOR
	value = 7

	required_powers = list(/datum/power/aberrant_root/anomalous)

	/// Reference to the beetlejuice component
	var/datum/component/beetlejuice/summonable/summon_component

// Lists the word in sec records.
/datum/power/aberrant/summonable/get_security_record_text()
	var/keyword = summon_component?.keyword
	if(!keyword)
		keyword = power_holder?.client?.prefs?.read_preference(/datum/preference/text/summonable_keyword)
	if(!keyword)
		var/datum/preference/text/summonable_keyword/pref_entry = GLOB.preference_entries[/datum/preference/text/summonable_keyword]
		keyword = pref_entry?.create_default_value() || "Beetlejuice"
	return "Subject is summonable via keyword \"[keyword]\"."

// Adds the custom beetlejuice component and sets the beetlejuiec word.
/datum/power/aberrant/summonable/post_add()
	if(!power_holder)
		return

	var/mob/living/holder = power_holder
	var/datum/component/beetlejuice/summonable/component = holder.GetComponent(/datum/component/beetlejuice/summonable)
	if(!component)
		component = holder.AddComponent(/datum/component/beetlejuice/summonable)

	summon_component = component

	var/keyword = holder.client?.prefs?.read_preference(/datum/preference/text/summonable_keyword)
	if(!keyword)
		var/datum/preference/text/summonable_keyword/pref_entry = GLOB.preference_entries[/datum/preference/text/summonable_keyword]
		keyword = pref_entry?.create_default_value() || "Beetlejuice"

	component.keyword = keyword
	component.update_regex()
	component.rune_color = holder.client?.prefs?.read_preference(/datum/preference/color/summonable_rune_color) || component.rune_color

	. = ..()

/datum/power/aberrant/summonable/remove()
	. = ..()
	if(summon_component)
		QDEL_NULL(summon_component)

// Custom beetlejuice component for Summonable.
/datum/component/beetlejuice/summonable
	min_count = 1
	cooldown = 60 SECONDS // for the love of god don't make this shorter than 10 seconds you will break things.
	/// Delay after your name being mentioned before the summoning begins
	var/summon_delay = 1 SECONDS
	/// How long it takes for you to fully float up
	var/float_time = 3.5 SECONDS
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

// Custom apport because frankly put its cooler this way.
/datum/component/beetlejuice/summonable/apport(atom/target)
	var/atom/movable/summoned = parent
	if(ismob(summoned))
		var/mob/living/living_summoned = summoned
		if(living_summoned.buckled || HAS_TRAIT(living_summoned, TRAIT_RESONANCE_SILENCED))
			return
	var/turf/target_turf = get_adjacent_open_turf(target)
	if(QDELETED(summoned) || !target_turf)
		return
	active = FALSE
	addtimer(VARSET_CALLBACK(src, active, TRUE), cooldown)
	addtimer(CALLBACK(src, PROC_REF(begin_summon), summoned, target_turf), summon_delay)

/// Gets a valid nearby turf within the mob's area.
/datum/component/beetlejuice/summonable/proc/get_adjacent_open_turf(atom/target)
	var/turf/center = get_turf(target)
	if(!center)
		return null
	var/list/candidates = list()
	for(var/turf/T in orange(1, center))
		if(T == center)
			continue
		if(T.is_blocked_turf(exclude_mobs = FALSE, ignore_atoms = list(/obj/structure/table), type_list = TRUE))
			continue
		candidates += T
	if(!length(candidates))
		return null
	return pick(candidates)

/// Starts the timers and starts manifesting effects.
/datum/component/beetlejuice/summonable/proc/begin_summon(atom/movable/summoned, turf/target_turf)
	if(QDELETED(summoned) || QDELETED(target_turf))
		return
	if(isliving(summoned))
		var/mob/living/living_summoned = summoned
		if(HAS_TRAIT(living_summoned, TRAIT_RESONANCE_SILENCED))
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

/// Removes the spotlight
/datum/component/beetlejuice/summonable/proc/clear_origin_spotlight(obj/effect/temp_visual/spotlight/summonable/origin_spotlight)
	QDEL_NULL(origin_spotlight)

/// Creates the cool floaty runes
/datum/component/beetlejuice/summonable/proc/spawn_rune_sequence(atom/movable/summoned, turf/target_turf, list/obj/effect/summonable_rune_orbiter/runes, rune_index, old_alpha, old_pixel_y)
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
/datum/component/beetlejuice/summonable/proc/begin_arrival(atom/movable/summoned, turf/target_turf, list/obj/effect/summonable_rune_orbiter/runes, old_alpha, old_pixel_y)
	if(!summoning)
		QDEL_LIST(runes)
		return
	if(QDELETED(summoned) || QDELETED(target_turf))
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
/datum/component/beetlejuice/summonable/proc/fade_and_clear_runes(list/obj/effect/summonable_rune_orbiter/runes)
	for(var/obj/effect/summonable_rune_orbiter/rune in runes)
		animate(rune, alpha = 0, time = rune_fade_time)
	addtimer(CALLBACK(src, PROC_REF(clear_runes), runes), rune_fade_time)

/// Removes all active runes.
/datum/component/beetlejuice/summonable/proc/clear_runes(list/obj/effect/summonable_rune_orbiter/runes)
	QDEL_LIST(runes)

/// Alright, shows over, he's here now. Time to pack up and go.
/datum/component/beetlejuice/summonable/proc/finish_summon(atom/movable/summoned, turf/target_turf, old_alpha, old_pixel_y, obj/effect/temp_visual/spotlight/summonable/spotlight)
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
/datum/component/beetlejuice/summonable/proc/on_dispel(atom/movable/target, atom/dispeller)
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
/datum/component/beetlejuice/summonable/proc/cancel_summon(atom/movable/summoned)
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

/datum/power_constant_data/summonable
	associated_typepath = /datum/power/aberrant/summonable
	customization_options = list(/datum/preference/text/summonable_keyword, /datum/preference/color/summonable_rune_color)

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
