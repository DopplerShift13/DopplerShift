/obj/structure/fermenting_barrel_fantasy
	name = "wooden barrel"
	desc = "A large wooden barrel. You can ferment fruits and such inside it, or just use it to hold reagents."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barrel"
	base_icon_state = "barrel"
	resistance_flags = FLAMMABLE
	obj_flags = UNIQUE_RENAME
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2 * ONE_ATMOSPHERE
	max_integrity = 300
	/// Is the barrel currently opened?
	var/open = FALSE
	/// Can the barrel be opened?
	var/can_open = TRUE
	/// The amount of reagents that can be created from the contained products, used for validation
	var/potential_volume = 0
	/// Whether the fermentation is ongoing
	var/fermenting = FALSE
	/// The volume of the barrel sounds
	var/sound_volume = 25
	/// The sound of fermentation
	var/datum/looping_sound/boiling/soundloop
	/// Sound played when the lid is opened.
	var/lid_open_sound = 'sound/items/handling/cardboard_box/cardboardbox_pickup.ogg'
	/// Sound played when the lid is closed.
	var/lid_close_sound = 'sound/effects/footstep/woodclaw2.ogg'
	/// How much volume should the vessel have inside it
	var/barrel_volume = 200

/obj/structure/fermenting_barrel_fantasy/Initialize(mapload)
	. = ..()
	create_reagents(barrel_volume, DRAINABLE)
	soundloop = new(src, fermenting)
	soundloop.volume = sound_volume
	register_context()

	RegisterSignals(src, list(
		SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED),
		SIGNAL_ADDTRAIT(TRAIT_HAS_LABEL),
		SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED),
		SIGNAL_REMOVETRAIT(TRAIT_HAS_LABEL),
	), PROC_REF(update_overlay_on_sig))

/obj/structure/fermenting_barrel_fantasy/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/fermenting_barrel_fantasy/examine(mob/user)
	. = ..()
	if(open)
		var/fruit_count = contents.len
		if(fruit_count)
			. += span_notice("It contains [fruit_count] fruit\s ready to be fermented.")
			. += span_notice("[EXAMINE_HINT("Right-click")] to take them out of [src].")
		. += span_notice("It is currently open, letting you fill it with fruits or reagents.")
	else
		. += span_notice("It is currently closed, letting it ferment fruits or draw reagents from its tap.")

/obj/structure/fermenting_barrel_fantasy/attackby(obj/item/object, mob/user, params)
	if(open)
		if(istype(object, /obj/item/food/fantasy_grown) && insert_fruit(user, object))
			balloon_alert(user, "added fruit")
			return
		if(istype(object, /obj/item/storage/bag/plants))
			var/obj/item/storage/bag/plants/bag = object
			var/inserted_fruits = 0
			for(var/obj/item/food/fantasy_grown/fruit in bag.contents)
				if(!insert_fruit(user, fruit, bag))
					break
				inserted_fruits++
			if(inserted_fruits)
				balloon_alert(user, "added [inserted_fruits] fruit\s")
	else if(object.is_refillable())
		return //so we can refill them via their afterattack.
	return ..()

/obj/structure/fermenting_barrel_fantasy/attack_hand(mob/user, list/modifiers)
	if(!can_open)
		return
	if(open)
		open = FALSE
		reagents.flags |= DRAINABLE
		reagents.flags &= ~(REFILLABLE | TRANSPARENT)
		playsound(src, lid_close_sound, sound_volume)
		start_fermentation()
	else
		open = TRUE
		reagents.flags &= ~(DRAINABLE)
		reagents.flags |= REFILLABLE | TRANSPARENT
		playsound(src, lid_open_sound, sound_volume)
		stop_fermentation()
	update_appearance(UPDATE_ICON)

/obj/structure/fermenting_barrel_fantasy/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	if(!open)
		return .

	if(!length(contents))
		balloon_alert(user, "empty!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	dump_contents()
	balloon_alert(user, "emptied [src]")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/fermenting_barrel_fantasy/wrench_act(mob/living/user, obj/item/tool)
	if(default_unfasten_wrench(user, tool) == SUCCESSFUL_UNFASTEN)
		return ITEM_INTERACT_SUCCESS

/obj/structure/fermenting_barrel_fantasy/update_icon_state()
	icon_state = open ? "barrel_open" : "barrel"
	return ..()

/obj/structure/fermenting_barrel_fantasy/proc/update_overlay_on_sig()
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON)

/obj/structure/fermenting_barrel_fantasy/update_overlays()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_WAS_RENAMED) || HAS_TRAIT(src, TRAIT_HAS_LABEL))
		. += mutable_appearance(icon, "[base_icon_state]_overlay_label")

/obj/structure/fermenting_barrel_fantasy/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = open ? "Close" : "Open"

		if(open && length(contents))
			context[SCREENTIP_CONTEXT_RMB] = "Empty"

		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"

	else if(open && (istype(held_item, /obj/item/food/fantasy_grown) || istype(held_item, /obj/item/storage/bag/plants)))
		context[SCREENTIP_CONTEXT_LMB] = "Add to barrel"

	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/fermenting_barrel_fantasy/dump_contents()
	var/atom/drop_point = drop_location()
	for(var/obj/item/food/fantasy_grown/fruit as anything in contents)
		fruit.forceMove(drop_point)

/// Adds the fruit to the barrel to queue the fermentation
/obj/structure/fermenting_barrel_fantasy/proc/insert_fruit(mob/user, obj/item/food/fantasy_grown/fruit, obj/item/storage/bag/plants/bag = null)
	if(reagents.total_volume + potential_volume > reagents.maximum_volume)
		balloon_alert(user, "it's full!")
		return FALSE
	if(!fruit.can_distill)
		balloon_alert(user, "can't ferment this!")
		return FALSE
	if(bag && !bag.atom_storage.attempt_remove(fruit, src))
		balloon_alert(user, "can't take from bag!")
		return FALSE
	else if (!user.transferItemToLoc(fruit, src))
		balloon_alert(user, "can't take fruit!")
		return FALSE
	potential_volume += fruit.reagents.total_volume
	return TRUE

/// Starts the fermentation process
/obj/structure/fermenting_barrel_fantasy/proc/start_fermentation()
	if(fermenting)
		return
	if(open)
		return
	if(reagents.total_volume >= reagents.maximum_volume)
		return
	if(!(locate(/obj/item/food) in contents))
		return
	fermenting = TRUE
	soundloop.start()
	START_PROCESSING(SSobj, src)

/// Ferments the next found fruit into wine
/obj/structure/fermenting_barrel_fantasy/proc/process_fermentation()
	if(!fermenting)
		return
	if(open)
		return stop_fermentation()
	if(reagents.total_volume >= reagents.maximum_volume)
		return stop_fermentation()
	var/obj/item/food/fantasy_grown/fruit = locate(/obj/item/food/fantasy_grown) in contents
	if(!fruit)
		return stop_fermentation()
	fruit.ferment()
	potential_volume -= fruit.reagents.total_volume
	fruit.reagents.trans_to(reagents, fruit.reagents.total_volume)
	qdel(fruit)

/// Stops the fermentation process
/obj/structure/fermenting_barrel_fantasy/proc/stop_fermentation()
	fermenting = FALSE
	soundloop.stop()
	STOP_PROCESSING(SSobj, src)

/obj/structure/fermenting_barrel_fantasy/process(seconds_per_tick)
	process_fermentation()
