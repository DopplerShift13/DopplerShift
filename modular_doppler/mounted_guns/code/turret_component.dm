/// Riding component for turrets
/datum/component/riding/vehicle/mounted_turret
	keytype = null
	ride_check_flags = RIDER_NEEDS_ARM | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/mounted_turret/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, -12),
		TEXT_SOUTH = list(0, 12),
		TEXT_EAST =  list(-12, 0),
		TEXT_WEST =  list(12, 0),
	)

/datum/component/riding/vehicle/mounted_turret/vehicle_turned(datum/source, _old_dir, new_dir)
	. = ..()
	update_parent_layer_and_offsets(new_dir, TRUE)

/datum/component/riding/vehicle/mounted_turret/handle_ride(mob/user, direction)
	var/atom/movable/movable_parent = parent
	if(!isturf(movable_parent.loc))
		return
	movable_parent.setDir(direction)
	COOLDOWN_START(src, vehicle_move_cooldown, vehicle_move_delay)
	if(QDELETED(src))
		return
	update_parent_layer_and_offsets(movable_parent.dir)
	return TRUE

/datum/component/riding/vehicle/mounted_turret/unequip_buckle_inhands(mob/living/carbon/user)
	var/atom/movable/parent_movable = parent
	for(var/obj/item/doppler_turret_offhand/offhand_item in user.contents)
		if(offhand_item.turret != parent_movable)
			CRASH("RIDING OFFHAND ON WRONG MOB")
		if(offhand_item.selfdeleting)
			continue
		else
			qdel(offhand_item)
	return TRUE
