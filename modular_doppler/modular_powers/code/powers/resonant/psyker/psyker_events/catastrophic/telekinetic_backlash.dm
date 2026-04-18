// Resonant forces batter and wound your body. This one will always return TRUE, and is probably the deadliest.
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

	weight = PSYKER_EVENT_RARITY_UNCOMMON

/datum/psyker_event/catastrophic/telekinetic_backlash/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("<b>As you strain your psychic powers past the breaking point, you feel yourself wracked by pain, as your skin, bones and flesh are pulled in all manner of directions!</b>"))

	// Start the chain after ~1 second
	addtimer(CALLBACK(src, PROC_REF(_backlash_tick), psyker, 0), 1 SECONDS)

	return TRUE

/// Every tick we do horrible things to the mob; then check if we should do another tick.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/_backlash_tick(mob/living/carbon/human/psyker, tick_count)
	if(!psyker || QDELETED(psyker))
		qdel(src)
		return

	if(tick_count >= max_ticks)
		qdel(src)
		return

	var/obj/item/bodypart/target_limb = pick_wound_bodypart(psyker)
	if(!target_limb)
		qdel(src)
		return

	//What wound type we apply for this instance.
	var/wound_type = pick(WOUND_SLASH, WOUND_PIERCE, WOUND_BLUNT)

	// Roll which effect happens this tick (65/20/10/5)
	var/roll = rand(1, 100)

	if(roll <= 65)
		to_chat(psyker, span_warning("Your body lurches as invisible forces wrench at your flesh!"))
		psyker.apply_damage(moderate_brute, BRUTE, def_zone = target_limb.body_zone)
		psyker.cause_wound_of_type_and_severity(wound_type, target_limb, WOUND_SEVERITY_MODERATE, WOUND_SEVERITY_MODERATE)
	else if(roll <= 85)
		to_chat(psyker, span_danger("You feel something tear inside you as the force twists harder!"))
		psyker.apply_damage(severe_brute, BRUTE, def_zone = target_limb.body_zone)
		psyker.cause_wound_of_type_and_severity(wound_type, target_limb, WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_CRITICAL)
	else if(roll <= 95)
		to_chat(psyker, span_userdanger("Agony spikes through you as feel your body being ripped apart!"))
		psyker.apply_damage(critical_brute, BRUTE, def_zone = target_limb.body_zone)
		psyker.cause_wound_of_type_and_severity(wound_type, target_limb, WOUND_SEVERITY_CRITICAL, WOUND_SEVERITY_CRITICAL)
		psyker.emote("scream")
	else
		// MY LEG!
		var/obj/item/bodypart/part = pick_wound_bodypart(psyker, FALSE)
		if(part)
			part.dismember()
			to_chat(psyker, span_userdanger("Something gives way—your body can't hold together!"))
			psyker.emote("scream")

	// 75% chance to continue applying effects
	if(!prob(75))
		qdel(src)
		return

	// Schedule next tick in ~1 second
	addtimer(CALLBACK(src, PROC_REF(_backlash_tick), psyker, tick_count + 1), 1 SECONDS)

/// Picks a bodypart to wound.
/datum/psyker_event/catastrophic/telekinetic_backlash/proc/pick_wound_bodypart(mob/living/carbon/human/psyker, allow_vital = TRUE)
	if(!psyker || !length(psyker.bodyparts))
		return null

	var/list/candidates = list()
	for(var/obj/item/bodypart/bodypart as anything in psyker.bodyparts)
		// Skip missing/destroyed parts if your fork tracks those (optional safety)
		if(QDELETED(bodypart))
			continue

		// Avoid vital zones unless explicitly allowed
		if(!allow_vital)
			if(bodypart.body_zone == BODY_ZONE_HEAD || bodypart.body_zone == BODY_ZONE_CHEST)
				continue

		candidates += bodypart

	if(!length(candidates))
		return null

	return pick(candidates)
