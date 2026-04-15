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
	icon = 'modular_doppler/modular_food_drinks_and_chems/icons/paraphenalia.dmi'
	icon_state = "bong"
	lefthand_file =
	righthand_file =
	inhand_icon_state =

	/// did we spark the bowl yet?
	var/lit = FALSE
	/// the overlay we use when packed and lit
	var/overlay_on = "overlay_on"
	/// the overlay we use when packed but not lit
	var/overlay_off = "overlay_off"

	var/smoke_radius = 1
	var/mutable_appearance/weed_overlay

/obj/item/bong/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/toiletbong)

	weed_overlay = mutable_appearance('modular_doppler/modular_food_drinks_and_chems/icons/paraphenalia.dmi', overlay_off)

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

/obj/item/bong/attack_self(mob/user)
	. = ..()
	if(!LAZYLEN(contents))
		user.balloon_alert(user, "it's empty!")
		return
	if(!lit)
		user.balloon_alert(user, "it's not lit!")
		return
	user.visible_message(span_boldnotice("[user] takes a rip on the [src]."))
	if(!do_after(user, 2 SECONDS, target = src))
		return
		playsound(src, '', 50)
		var/datum/effect_system/fluid_spread/smoke/chem/smoke_machine/puff = new
		puff.set_up(smoke_radius, holder = src, location = user, carry = item.reagents, efficiency = 20)
		puff.start()
		qdel(item)
	update_appearance(UPDATE_ICON)

/obj/item/bong/proc/light(flavor_text = null)
	if(lit)
		return

	lit = TRUE
	playsound(src.loc, 'sound/items/lighter/cig_light.ogg', 100, 1)
	make_cig_smoke()
	set_light_on(TRUE)
	if(!(flags_1 & INITIALIZED_1))
		update_appearance(UPDATE_ICON)
		return

	if(reagents?.has_reagent(/datum/reagent/flash_powder))
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

	if(reagents?.get_reagent_amount(/datum/reagent/toxin/plasma)) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return
	if(reagents?.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return
	// allowing reagents to react after being lit
	update_appearance(UPDATE_ICON)
	if(flavor_text)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
	START_PROCESSING(SSobj, src)

	if(iscarbon(loc))
		var/mob/living/carbon/smoker = loc
		if(src == smoker.wear_mask)
			make_mob_smoke(smoker)

/obj/item/cigarette/proc/make_cig_smoke()
	cig_smoke = new(src, /particles/smoke/cig)
	cig_smoke.particles?.scale *= 1.5
	return cig_smoke
