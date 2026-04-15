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

	weed_overlay = mutable_appearance('modular_doppler/modular_food_drinks_and_chems/icons/paraphenalia.dmi', overlay_off)	// since the bongs will share a bowl location we just need one overlay icon
	START_PROCESSING(SSobj, src)

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

