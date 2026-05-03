/datum/power/aberrant/tripwire_webs
	name = "Tripwire Webs"
	desc = "Allows you to place near- invisible tripwires using web crafter.\
	\n Any creature that isn't able to safely pass webs will trigger the tripwire when they pass through it, destroying it and warning you of which wire was triggered.\
	\n Creatures immune to resonant scrying can trigger the webs without notifying you. Extreme distances and non-movement destruction will also not notify you."
	security_record_text = "Subject can craft tripwires from their spider silk."
	value = 3

	required_powers = list(/datum/power/aberrant/web_crafter)

/datum/power/aberrant/tripwire_webs/post_add(client/client_source)
	. = ..()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries |= /datum/web_craft_entry/tripwire_web

/datum/power/aberrant/tripwire_webs/remove()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries -= /datum/web_craft_entry/tripwire_web

/// Returns the web crafter action.
/datum/power/aberrant/tripwire_webs/proc/get_web_crafter_action()
	if(!power_holder)
		return null
	for(var/datum/action/cooldown/power/aberrant/web_crafter/action in power_holder.actions)
		return action
	return null

/obj/structure/spider/tripwire_web
	name = "tripwire web"
	desc = "Nearly invisible silk stretched tight."
	icon = 'icons/effects/navigation.dmi' // see pick_icon_state
	icon_state = "2-5" // default shown for the webcrafting
	anchored = TRUE
	density = FALSE
	alpha = 15
	max_integrity = 1
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	/// Who placed the tripwire, if any
	var/datum/weakref/maker_ref

/obj/structure/spider/tripwire_web/Initialize(mapload, mob/living/maker)
	. = ..()
	if(maker)
		maker_ref = WEAKREF(maker)
	pick_icon_state()

/** So we don't actually have the old web sprites; a lot of web sprites are DENSE and noticeable. So we take the navigation lines and place one randomly on the tile. Boom, tripwire.
 * We filter out the ones that start with a 0 because they're dead-ends
**/
/obj/structure/spider/tripwire_web/proc/pick_icon_state()
	var/static/list/valid_states
	if(!valid_states)
		valid_states = list()
		for(var/state in icon_states(icon))
			if(copytext(state, 1, 2) == "0")
				continue
			valid_states += state
	if(length(valid_states))
		icon_state = pick(valid_states)

// Basically the most reliable proc to use for passing through a space.
/obj/structure/spider/tripwire_web/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!isliving(mover))
		return .
	if(HAS_TRAIT(mover, TRAIT_WEB_SURFER))
		return .
	triggered(mover)
	return TRUE

/// When the tripwire is triggered.
/obj/structure/spider/tripwire_web/proc/triggered(mob/living/triggerer)
	var/mob/living/maker = maker_ref?.resolve()
	if(!should_notify_maker(maker, triggerer))
		qdel(src)
		return
	if(maker)
		var/area/area_loc = get_area(src)
		var/area_name = area_loc ? area_loc.name : "unknown area"
		to_chat(maker, span_warning("Your tripwire in [area_name] was triggered!"))
	qdel(src)

/// We do not notify the maker under certain circumstances.
/obj/structure/spider/tripwire_web/proc/should_notify_maker(mob/living/maker, mob/living/triggerer)
	// DO WE EXIST?
	if(!maker)
		return FALSE
	// They're not on the same z level (maps with multiple Zs are fine)
	var/turf/maker_turf = get_turf(maker)
	var/turf/web_turf = get_turf(src)
	if(!maker_turf || !web_turf || !is_valid_z_level(maker_turf, web_turf))
		return FALSE
	// It was destroyed without a triggerer
	if(!triggerer)
		return FALSE
	// The triggerer is immune to resonance
	if(triggerer.can_block_resonance())
		return FALSE
	// The triggerer is immune to magic
	if(triggerer.can_block_magic(MAGIC_RESISTANCE))
		return FALSE
	// The triggerer is immune to scrying
	if(HAS_TRAIT(triggerer, TRAIT_ANTIRESONANCE_SCRYING))
		return FALSE
	return TRUE
