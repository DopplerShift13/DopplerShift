/// Handles all of the riding code for mounted turrets, ridable element but changed a lot
/datum/element/ridable_turret
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2
	/// The specific riding component subtype we're loading our instructions from, don't leave this as default please!
	var/riding_component_type = /datum/component/riding/vehicle/mounted_turret

/datum/element/ridable_turret/Attach(atom/movable/target, component_type = /datum/component/riding, force_rider_standup = TRUE)
	. = ..()
	if(!ismovable(target))
		return COMPONENT_INCOMPATIBLE
	target.can_buckle = TRUE
	riding_component_type = component_type
	if(force_rider_standup)
		target.buckle_lying = 0
	RegisterSignal(target, COMSIG_MOVABLE_PREBUCKLE, PROC_REF(check_mounting))

/datum/element/ridable_turret/Detach(atom/movable/target)
	target.buckle_lying = target::buckle_lying
	target.can_buckle = target::can_buckle
	UnregisterSignal(target, list(COMSIG_MOVABLE_PREBUCKLE))
	return ..()

/// Someone is buckling to this movable, which is literally the only thing we care about
/datum/element/ridable_turret/proc/check_mounting(atom/movable/target_movable, mob/living/potential_rider, force = FALSE, ride_check_flags = NONE)
	SIGNAL_HANDLER

	var/arms_needed = 1 // fucj you ??
	if(arms_needed && !equip_buckle_inhands(potential_rider, arms_needed, target_movable))
		potential_rider.visible_message(span_warning("[potential_rider] can't get a grip on [target_movable] because [potential_rider.p_their()] hands are full!"),
			span_warning("You can't get a grip on [target_movable] because your hands are full!"))
		return COMPONENT_BLOCK_BUCKLE
	if((ride_check_flags & RIDER_NEEDS_LEGS) && HAS_TRAIT(potential_rider, TRAIT_FLOORED))
		potential_rider.visible_message(span_warning("[potential_rider] can't get [potential_rider.p_their()] footing on [target_movable]!"),
			span_warning("You can't get your footing on [target_movable]!"))
		return COMPONENT_BLOCK_BUCKLE
	var/mob/living/target_living = target_movable
	// need to see if !equip_buckle_inhands() checks are enough to skip any needed incapac/restrain checks
	// CARRIER_NEEDS_ARM shouldn't apply if the ridden isn't even a living mob
	if((ride_check_flags & CARRIER_NEEDS_ARM) && !equip_buckle_inhands(target_living, 1, target_living, potential_rider)) // hardcode 1 hand for now
		target_living.visible_message(span_warning("[target_living] can't get a grip on [potential_rider] because [target_living.p_their()] hands are full!"),
			span_warning("You can't get a grip on [potential_rider] because your hands are full!"))
		return COMPONENT_BLOCK_BUCKLE
	target_living.AddComponent(riding_component_type, potential_rider, force, ride_check_flags)

/// Try putting the appropriate number of [riding offhand items][/obj/item/riding_offhand] into the target's hands, return FALSE if we can't
/datum/element/ridable_turret/proc/equip_buckle_inhands(mob/living/carbon/human/user, amount_required = 1, atom/movable/target_movable, riding_target_override = null)
	var/atom/movable/AM = target_movable
	var/amount_equipped = 0
	for(var/amount_needed = amount_required, amount_needed > 0, amount_needed--)
		var/obj/item/doppler_turret_offhand/inhand = new /obj/item/doppler_turret_offhand(user)
		if(!riding_target_override)
			inhand.rider = user
		else
			inhand.rider = riding_target_override
		inhand.turret = AM
		for(var/obj/item/I in user.held_items) // delete any hand items like slappers that could still totally be used to grab on
			if((I.item_flags & HAND_ITEM))
				qdel(I)
		// this would be put_in_hands() if it didn't have the chance to sleep, since this proc gets called from a signal handler that relies on what this returns
		var/inserted_successfully = FALSE
		if(user.put_in_active_hand(inhand))
			inserted_successfully = TRUE
		else
			var/hand = user.get_empty_held_index_for_side(LEFT_HANDS) || user.get_empty_held_index_for_side(RIGHT_HANDS)
			if(hand && user.put_in_hand(inhand, hand))
				inserted_successfully = TRUE
		if(inserted_successfully)
			amount_equipped++
		else
			qdel(inhand)
			return FALSE
	if(amount_equipped >= amount_required)
		return TRUE
	else
		unequip_buckle_inhands(user, target_movable)
		return FALSE

/// Remove all of the relevant [riding offhand items][/obj/item/riding_offhand] from the target
/datum/element/ridable_turret/proc/unequip_buckle_inhands(mob/living/carbon/user, atom/movable/target_movable)
	var/atom/movable/the_turret = target_movable
	for(var/obj/item/doppler_turret_offhand/offhand in user.contents)
		if(offhand.turret != the_turret)
			CRASH("RIDING OFFHAND ON WRONG MOB")
		else
			qdel(offhand)
	return TRUE
