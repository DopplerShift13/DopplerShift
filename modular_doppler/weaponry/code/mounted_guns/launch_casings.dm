/obj/item/gun/ballistic
	/// What angle from forwards (using the turn() proc) does this gun eject casings at when mounted. 45 multiples ONLY
	var/ejection_angle_offset = null

/// Instead of dropping the casing to the ground, instead we launch it away from ourselves at high speed
/obj/item/gun/ballistic/proc/launch_casing(obj/casing, atom/movable/firer)
	var/throw_direction	= turn(firer.dir, ejection_angle_offset)
	var/turf/target_turf = get_ranged_target_turf(firer, throw_direction, 3)
	target_turf = get_offset_target_turf(target_turf, rand(-1, 1), rand(-1, 1))
	casing.throw_at(target_turf, 4, 1)
