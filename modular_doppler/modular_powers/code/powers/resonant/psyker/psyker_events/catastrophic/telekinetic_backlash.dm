// Resonant forces batter and wound your body. This is probably the deadliest event.
/datum/psyker_event/catastrophic/telekinetic_backlash
	lingering = TRUE
	/// I guess we'll have a pity system.
	var/max_ticks = 6

	/// Brute damage on a moderete severity roll
	var/moderate_brute = 5
	/// Damage on a severe severity roll
	var/severe_brute = 10
	/// Damage on a critical severity roll
	var/critical_brute = 20
	/// Lists all bodyparts and applicable wound types.
	var/list/applicable_bodyparts = list()

	weight = PSYKER_EVENT_RARITY_UNCOMMON

/datum/psyker_event/catastrophic/telekinetic_backlash/can_execute(mob/living/carbon/human/psyker)
	if(HAS_TRAIT(psyker, TRAIT_NEVER_WOUNDED) || HAS_TRAIT(psyker, TRAIT_NODISMEMBER)) // we wound and dismember so nogo if we cant do that
		return FALSE

	return has_applicable_bodypart(psyker)

/datum/psyker_event/catastrophic/telekinetic_backlash/execute(mob/living/carbon/human/psyker)
	cache_applicable_bodyparts(psyker) // Cache the applicable bodyparts first and see what's actually applicable.
	to_chat(psyker, span_userdanger("<b>You are suddenly wracked by pain as unseen forces pull your skin, bones, and flesh in all directions!</b>"))

	// Start the chain after ~1 second
	addtimer(CALLBACK(src, PROC_REF(_backlash_tick), psyker, 0), 1 SECONDS)

	return TRUE

/// Every tick we do horrible things to the mob; then check if we should do another tick.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/_backlash_tick(mob/living/carbon/human/psyker, tick_count)
	if(!psyker || QDELETED(psyker)) // where'd the fukken pysker go?
		qdel(src)
		return

	if(tick_count >= max_ticks) // congrats you got pity-systemed, and you're probably dead too.
		qdel(src)
		return

	// picks a random bodypart to apply a wound to.
	var/obj/item/bodypart/target_limb = pick_wound_bodypart(psyker)
	if(!target_limb)
		qdel(src)
		return

	// Roll which effect happens this tick (65/20/10/5)
	var/roll = rand(1, 100)

	// Gets the severity of the wound we are going to apply based on the roll
	var/wound_severity
	if(roll <= 65)
		wound_severity = WOUND_SEVERITY_MODERATE
	else if(roll <= 85)
		wound_severity = WOUND_SEVERITY_SEVERE
	else if(roll <= 95)
		wound_severity = WOUND_SEVERITY_CRITICAL

	var/datum/wound/wound_path
	// picks a random wound from the cached wounds for that bodypart.
	if(wound_severity)
		wound_path = pick_applicable_wound_path(target_limb, wound_severity)
		if(!wound_path)
			qdel(src)
			return

	if(roll <= 65)
		to_chat(psyker, span_warning("Your body lurches as invisible forces wrench at your flesh!"))
		psyker.apply_damage(moderate_brute, BRUTE, def_zone = target_limb.body_zone)
		target_limb.force_wound_upwards(wound_path)
	else if(roll <= 85)
		to_chat(psyker, span_danger("You feel something tear inside you as the force twists harder!"))
		psyker.apply_damage(severe_brute, BRUTE, def_zone = target_limb.body_zone)
		target_limb.force_wound_upwards(wound_path)
	else if(roll <= 95)
		to_chat(psyker, span_userdanger("Agony spikes through you as feel your body being ripped apart!"))
		psyker.apply_damage(critical_brute, BRUTE, def_zone = target_limb.body_zone)
		target_limb.force_wound_upwards(wound_path)
		psyker.emote("scream")
	else
		// MY LEG!
		var/obj/item/bodypart/part = pick_wound_bodypart(psyker, FALSE)
		if(part)
			applicable_bodyparts -= part
			part.dismember()
			to_chat(psyker, span_userdanger("Something gives way—your body can't hold together!"))
			psyker.emote("scream")

	// 75% chance to continue applying effects
	if(!prob(75))
		qdel(src)
		return

	// Schedule next tick in ~1 second
	addtimer(CALLBACK(src, PROC_REF(_backlash_tick), psyker, tick_count + 1), 1 SECONDS)

/// Caches the bodyparts and wound types which the backlash can affect.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/cache_applicable_bodyparts(mob/living/carbon/human/psyker)
	applicable_bodyparts.Cut()

	// Iterates all bodyparts
	for(var/obj/item/bodypart/bodypart as anything in psyker.bodyparts)
		if(QDELETED(bodypart) || !bodypart.is_woundable())
			continue

		// Checks what wounds can be applied to that bodypart
		var/list/applicable_wound_paths = get_applicable_wound_paths(bodypart)
		if(!length(applicable_wound_paths))
			continue

		// Save the acquired info
		applicable_bodyparts[bodypart] = applicable_wound_paths

/// Returns TRUE as soon as one compatible bodypart is found.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/has_applicable_bodypart(mob/living/carbon/human/psyker)
	if(!psyker)
		return FALSE

	// Iterates all bodyparts and returns TRUE if it finds one that works.
	for(var/obj/item/bodypart/bodypart as anything in psyker.bodyparts)
		if(QDELETED(bodypart) || !bodypart.is_woundable())
			continue
		if(length(get_applicable_wound_paths(bodypart)))
			return TRUE

	return FALSE

/// Picks from the cached bodyparts, discarding any which have since been deleted or detached.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/pick_wound_bodypart(mob/living/carbon/human/psyker, allow_vital = TRUE)
	if(!psyker)
		return null

	// Goes through the cached limbs and adds all possible canidates.
	var/list/candidates = list()
	for(var/obj/item/bodypart/bodypart as anything in applicable_bodyparts)
		if(!allow_vital && (bodypart.body_zone == BODY_ZONE_HEAD || bodypart.body_zone == BODY_ZONE_CHEST)) // if we don't allow vital parts e.g dismemberment.
			continue
		candidates += bodypart

	// Picks a random bodypart to be our chosen bodypart.
	while(length(candidates))
		var/obj/item/bodypart/bodypart = pick(candidates)
		if(!QDELETED(bodypart) && bodypart.owner == psyker)
			return bodypart
		applicable_bodyparts -= bodypart

	return null

/// Returns all wounds that can be applied to a bodypart, regardless of severity. This is used to cache the applicable wounds for later use.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/get_applicable_wound_paths(obj/item/bodypart/bodypart)
	var/list/applicable_wound_paths = list()
	for(var/wound_path in GLOB.all_wound_pregen_data)
		var/datum/wound_pregen_data/wound_data = GLOB.all_wound_pregen_data[wound_path]
		if(!(wound_data.required_wounding_type in list(WOUND_SLASH, WOUND_PIERCE, WOUND_BLUNT)))
			continue
		if(wound_data.can_be_applied_to(bodypart, random_roll = FALSE, duplicates_allowed = TRUE, care_about_existing_wounds = FALSE))
			applicable_wound_paths += wound_path

	return applicable_wound_paths

/// Picks a cached wound path matching the severity rolled by this backlash.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/pick_applicable_wound_path(obj/item/bodypart/bodypart, wound_severity)
	var/list/candidates = list()
	for(var/datum/wound/wound_path as anything in applicable_bodyparts[bodypart])
		if(initial(wound_path.severity) == wound_severity)
			candidates += wound_path

	return pick(candidates)

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/telekinetic_backlash
	name = "Psyker Event: Telekinetic Backlash"
	event_type = /datum/psyker_event/catastrophic/telekinetic_backlash
