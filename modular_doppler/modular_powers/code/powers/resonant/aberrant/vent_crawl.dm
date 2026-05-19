// Vent crawling with caveats. Beware; this is quite jerry-rigged just to keep it modular.
/datum/power/aberrant/vent_crawl
	name = "Vent Crawl"
	desc = "Your anatomy is capable of fitting in tight spaces. You can crawl into vents if you are not wearing anything in your back slot, helmet slot or suit slot. \
	\nIf you are undersized, you can crawl in vents while wearing your normal equipment. Does not work on oversized mobs."
	security_record_text = "Subject can crawl through ventilation shafts."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	required_powers = list(/datum/power/aberrant_root/beastial, /datum/power/aberrant_root/monstrous)
	required_allow_any = TRUE

/datum/power/aberrant/vent_crawl/add(client/client_source)
	. = ..()
	if(!power_holder)
		return
	ADD_TRAIT(power_holder, TRAIT_VENTCRAWLER_ALWAYS, src)
	RegisterSignal(power_holder, COMSIG_MOB_ALTCLICKON, PROC_REF(on_altclick))

/datum/power/aberrant/vent_crawl/remove()
	if(power_holder)
		REMOVE_TRAIT(power_holder, TRAIT_VENTCRAWLER_ALWAYS, src)
		REMOVE_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)
		UnregisterSignal(power_holder, COMSIG_MOB_ALTCLICKON)
	return ..()

/** Ventcrawling only has two states; always and nude. This is kind-of cringe; but I don't want to tweak ventcrawling.dm unncessarily just for one power.
 *	We process and check if they're vent_crawling; if true, we check for restricted gear. If true, we immobilize them til they fukken undress.
 *	It's gross but it's either mr riot suit crawling out of the vents or everyone being buck naked.
**/
/datum/power/aberrant/vent_crawl/process(seconds_per_tick)
	if(!power_holder)
		return
	// If a different source grants always-ventcrawling, don't enforce restrictions here.
	if(HAS_TRAIT(power_holder, TRAIT_VENTCRAWLER_ALWAYS) && !HAS_TRAIT_FROM_ONLY(power_holder, TRAIT_VENTCRAWLER_ALWAYS, src))
		REMOVE_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)
		return
	// Disqualifies for gear check if not ventcrawling
	if(!(power_holder.movement_type & VENTCRAWLING) || !HAS_TRAIT(power_holder, TRAIT_MOVE_VENTCRAWLING))
		REMOVE_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)
		return
	// Disqualifies for gear check if undersized
	if(HAS_TRAIT(power_holder, TRAIT_UNDERSIZED))
		REMOVE_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)
		return

	// Check if they are wearing a back slot, helmet slot or suit slot. Hands are fine.
	if(has_restricted_gear(power_holder))
		ADD_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)
	// Clear it incase they don't and are immobilized from this.
	else
		REMOVE_TRAIT(power_holder, TRAIT_IMMOBILIZED, src)

/// Alt clicking on vents. Prevent them from venting if they're wearing too much crap.
/datum/power/aberrant/vent_crawl/proc/on_altclick(mob/living/source, atom/target)
	SIGNAL_HANDLER
	if(!can_use_ventcrawl(source))
		if(istype(target, /obj/machinery/atmospherics/components/unary))
			return COMSIG_MOB_CANCEL_CLICKON
		return
	if(!istype(target, /obj/machinery/atmospherics/components/unary))
		return
	if(HAS_TRAIT(source, TRAIT_UNDERSIZED))
		return
	if(!has_restricted_gear(source))
		return
	source.balloon_alert(source, "Need empty back, helmet & suit slot!")
	to_chat(source, span_warning("You need to remove your backpack, helmet, and suit to ventcrawl!"))
	return COMSIG_MOB_CANCEL_CLICKON

/// Are you TOO FUKKEN BIG? or are you SILENCED?
/datum/power/aberrant/vent_crawl/proc/can_use_ventcrawl(mob/living/source)
	if(HAS_TRAIT(source, TRAIT_RESONANCE_SILENCED))
		source.balloon_alert(source, "Silenced!")
	if(HAS_TRAIT(source, TRAIT_OVERSIZED))
		source.balloon_alert(source, "You're too big to fit!")
		return FALSE
	return TRUE

/// Checks for back slot, head slot and suit slot
/datum/power/aberrant/vent_crawl/proc/has_restricted_gear(mob/living/source)
	var/mob/living/carbon/carbon_source = source
	return carbon_source.get_item_by_slot(ITEM_SLOT_BACK) || carbon_source.get_item_by_slot(ITEM_SLOT_HEAD) || carbon_source.get_item_by_slot(ITEM_SLOT_OCLOTHING)
