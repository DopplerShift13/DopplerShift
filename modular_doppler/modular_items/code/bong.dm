 /*
    .===. (
    |   |  )
    |   | (
    |   | )
    |   \//
  ,'    //.
 :~~~~~//~~;      welcome 2 bong.dm enjoi ur stay
  `.  // .'
  `-------'
*/

/obj/item/bong
	name = "glass bong"
	desc = "A classic waterpipe produced out of surplus labglass in a storied style that boasts \
	centuries of history. The most primitive of such devices date back to human prehistory, but these \
	iterations really came into being in the 1960s among Terran devotees of cannabis sativa."
	icon = 'modular_doppler/modular_items/icons/paraphenalia.dmi'
	icon_state = "bong"
	lefthand_file = 'modular_doppler/modular_items/icons/paraphenalia_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_items/icons/paraphenalia_righthand.dmi'
	inhand_icon_state = "bong"

	/// did we spark the bowl yet?
	var/lit = FALSE
	/// the overlay we use when packed and lit
	var/overlay_on = "overlay_on"
	/// the overlay we use when packed but not lit
	var/overlay_off = "overlay_off"
	/// how many hits you can get off this
	var/max_hits = 4
	/// how many hits have been taken?
	var/bong_rips = 0
	/// reagent capacity
	var/chem_volume = 30
	/// are we packed?
	var/packed = FALSE
	/// how much reagent is transferred per use?
	var/reagent_transfer_per_use
	/// how far does our smoke go?
	var/smoke_radius = 2
	/// overlay for our packed state and lit state
	var/mutable_appearance/weed_overlay

/obj/item/bong/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)
	weed_overlay = mutable_appearance('modular_doppler/modular_items/icons/paraphenalia.dmi', overlay_off)

/obj/item/bong/update_overlays()
	. = ..()
	if(LAZYLEN(contents) & !lit)
		. += weed_overlay
		weed_overlay = overlay_off
	if(LAZYLEN(contents) & lit)
		. += weed_overlay
		weed_overlay = overlay_on
	else
		. -= weed_overlay

/obj/item/bong/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/food/grown))
		var/obj/item/food/grown/grown_item = used_item
		if(packed)
			balloon_alert(user, "already packed!")
			return
		if(!HAS_TRAIT(grown_item, TRAIT_DRIED))
			balloon_alert(user, "needs to be dried!")
			return
		to_chat(user, span_notice("You stuff [grown_item] into [src]."))
		bong_rips = max_hits
		packed = TRUE
		if(grown_item.reagents)
			grown_item.reagents.trans_to(src, grown_item.reagents.total_volume, transferred_by = user)
			reagent_transfer_per_use = reagents.total_volume / max_hits
		qdel(grown_item)
		to_chat(user, span_notice("You stuff [used_item] into [src]."))
		bong_rips = max_hits
		packed = TRUE
		if(used_item.reagents)
			used_item.reagents.trans_to(src, used_item.reagents.total_volume, transferred_by = user)
			reagent_transfer_per_use = reagents.total_volume / max_hits
		qdel(used_item)
	else
		var/lighting_text = used_item.ignition_effect(src, user)
		if(!lighting_text)
			return ..()
		if(bong_rips <= 0)
			balloon_alert(user, "nothing to smoke!")
			return ..()
		light(lighting_text)
		name = "lit [initial(name)]"

/obj/item/bong/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))
		extinguish()
	else if(!lit && bong_rips > 0)
		to_chat(user, span_notice("You empty [src] onto [location]."))
		new /obj/effect/decal/cleanable/ash(location)
		packed = FALSE
		bong_rips = 0
		reagents.clear_reagents()
	return

/obj/item/bong/attack(mob/hit_mob, mob/user, def_zone)
	if(!packed || !lit)
		return
	hit_mob.visible_message(span_notice("[user] starts [hit_mob == user ? "taking a hit from [src]." : "forcing [hit_mob] to take a hit from [src]!"]"), hit_mob == user ? span_notice("You start taking a hit from [src].") : span_userdanger("[user] starts forcing you to take a hit from [src]!"))
	playsound(src, 'sound/effects/chemistry/heatdam.ogg', 50, TRUE)
	if(!do_after(user, 40))
		return
	to_chat(hit_mob, span_notice("You finish taking a hit from the [src]."))
	if(reagents.total_volume)
		reagents.trans_to(hit_mob, reagent_transfer_per_use, transferred_by = user, methods = VAPOR)
		bong_rips--
	var/turf/open/pos = get_turf(src)
	if(istype(pos))
		for(var/i in 1 to smoke_radius)
			spawn_cloud(pos, smoke_radius)
	hit_mob.emote("cough")
	if(bong_rips <= 0)
		balloon_alert(hit_mob, "out of uses!")
		extinguish()
		packed = FALSE
		name = "[initial(name)]"
		reagents.clear_reagents() //just to make sure

/// handles setting the lit var, fx for lighting the bong, and interactions for certain volatile chems
/obj/item/bong/proc/light(flavor_text = null)
	if(lit)
		return

	lit = TRUE
	playsound(src.loc, 'sound/items/lighter/cig_light.ogg', 100, 1)
	set_light_on(TRUE)

	if(reagents?.has_reagent(/datum/reagent/flash_powder))	// flashpowder explodes
		if(!isliving(loc))
			loc.visible_message(span_hear("\The [src] burns up!"))
			qdel(src)
			return
		var/mob/living/user = loc
		loc.visible_message(span_hear("[user]'s [name] burns up as [p_they(user)] fall to the ground!"), span_danger("The solution violently explodes!"))
		user.flash_act(INFINITY, visual = TRUE, length = 5 SECONDS)
		user.playsound_local(get_turf(user), SFX_EXPLOSION, 50, TRUE)
		user.cause_hallucination(/datum/hallucination/death, "trick trick [name]")
		qdel(src)
		return
	if(reagents?.get_reagent_amount(/datum/reagent/toxin/plasma))	// plasma explodes
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return
	if(reagents?.get_reagent_amount(/datum/reagent/fuel))	// fuel explodes
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return

	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	if(flavor_text)
		var/turf/bong_turf = get_turf(src)
		bong_turf.visible_message(flavor_text)

	update_appearance(UPDATE_ICON)
	START_PROCESSING(SSobj, src)

/// spawns some steam clouds after we hit the bong
/obj/item/bong/proc/spawn_cloud(turf/open/location, smoke_radius)
	var/list/turfs_affected = list(location)
	var/list/turfs_to_spread = list(location)
	var/spread_stage = smoke_radius
	for(var/i in 1 to smoke_radius)
		if(!turfs_to_spread.len)
			break
		var/list/new_spread_list = list()
		for(var/turf/open/turf_to_spread as anything in turfs_to_spread)
			if(isspaceturf(turf_to_spread))
				continue
			var/obj/effect/abstract/fake_steam/fake_steam = locate() in turf_to_spread
			var/at_edge = FALSE
			if(!fake_steam)
				at_edge = TRUE
				fake_steam = new(turf_to_spread)
			fake_steam.stage_up(spread_stage)

			if(!at_edge)
				for(var/turf/open/open_turf as anything in turf_to_spread.atmos_adjacent_turfs)
					if(!(open_turf in turfs_affected))
						new_spread_list += open_turf
						turfs_affected += open_turf

		turfs_to_spread = new_spread_list
		spread_stage--

/obj/item/bong/extinguish()
	. = ..()
	if(!lit)
		return
	STOP_PROCESSING(SSobj, src)
	reagents.flags |= NO_REACT
	lit = FALSE
	playsound(src.loc, 'sound/items/lighter/cig_snuff.ogg', 100, 1)
	update_appearance(UPDATE_ICON)
	set_light_on(FALSE)
	if(ismob(loc))
		to_chat(loc, span_notice("Your [name] goes out."))

#define MAX_FAKE_STEAM_STAGES 5
#define STAGE_DOWN_TIME (10 SECONDS)
#define FAKE_STEAM_TARGET_ALPHA 204

/// Fake steam effect
/obj/effect/abstract/fake_steam
	layer = FLY_LAYER
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "water_vapor"
	blocks_emissive = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/next_stage_down = 0
	var/current_stage = 0

/obj/effect/abstract/fake_steam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/abstract/fake_steam/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/abstract/fake_steam/process()
	if(next_stage_down > world.time)
		return
	stage_down()

/// controls steam opacity
/obj/effect/abstract/fake_steam/proc/update_alpha()
	alpha = FAKE_STEAM_TARGET_ALPHA * (current_stage / MAX_FAKE_STEAM_STAGES)

/// moves us along the steam decay timeline
/obj/effect/abstract/fake_steam/proc/stage_down()
	if(!current_stage)
		qdel(src)
		return
	current_stage--
	next_stage_down = world.time + STAGE_DOWN_TIME
	update_alpha()

/// sets our max steamy-ness
/obj/effect/abstract/fake_steam/proc/stage_up(max_stage = MAX_FAKE_STEAM_STAGES)
	var/target_max_stage = min(MAX_FAKE_STEAM_STAGES, max_stage)
	current_stage = min(current_stage + 1, target_max_stage)
	next_stage_down = world.time + STAGE_DOWN_TIME
	update_alpha()

#undef FAKE_STEAM_TARGET_ALPHA
#undef MAX_FAKE_STEAM_STAGES

/obj/item/bong/z_bong
	name = "z-bong"
	desc = "Technically the z-shaped chamber can take bigger rips and more effectively cool the smoke. In reality, \
	people get this one because it looks really neat."
	icon_state = "z-bong"
	inhand_icon_state = "z-bong"

/obj/item/bong/nevada_bong
	name = "nevada bottle bong"
	desc = "A plastic bottle hastily pierced and taped to a makeshift bowl."
	icon_state = "nevada-bong"

/obj/item/bong/lemonade_bong
	name = "lemonade bottle bong"
	desc = "A plastic bottle hastily pierced and taped to a makeshift bowl."
	icon_state = "lemonade-bong"

/obj/item/bong/waterbottle_bong
	name = "waterbottle bong"
	desc = "A plastic bottle hastily pierced and taped to a makeshift bowl."
	icon_state = "waterbottle-bong"

/obj/item/cigarette/pipe/spoon
	name = "glass pipe"
	desc = ""
	icon = 'modular_doppler/modular_items/icons/paraphenalia.dmi'
	worn_icon = 'modular_doppler/modular_items/icons/paraphenalia_worn.dmi'
	icon_state = "pipeoff"
	icon_off = "pipeoff"
	icon_on = "pipeon"
