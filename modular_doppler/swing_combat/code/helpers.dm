/**
 * Returns a list of turfs, from left to right (by default), that are in the direction from the base atom
 *
 * For example, a the dir of north would give you the tile to the top left, top, and top right from the base
 * And a dir of northwest would give you the tile directly left, top left, and directly top
 *
 * * base - The atom to get the turfs from
 * * general_dir - The direction to get the turfs in
 * * reversed - Whether or not to reverse the order of the turfs, from left to right to right to left instead
 */
/proc/get_turfs_and_adjacent_in_direction(atom/base, general_dir, reversed = FALSE)
	var/list/result_list = list()
	var/turf/left_turf = get_step(base, turn(general_dir, -45))
	var/turf/middle_turf = get_step(base, general_dir)
	var/turf/right_turf = get_step(base, turn(general_dir, 45))
	if(istype(left_turf))
		result_list += left_turf
	if(istype(middle_turf))
		result_list += middle_turf
	if(istype(right_turf))
		result_list += right_turf
	if(reversed)
		reverse_range(result_list)
	return result_list

/proc/get_turfs_in_straight_line_toward(atom/base, atom/target, attack_range = 2)
	var/list/result_list = list()
	var/reach_iterator = 1
	var/turf/last_turf
	while(reach_iterator <= attack_range)
		if(!last_turf)
			last_turf = get_step_towards(base, target)
		else
			last_turf = get_step_towards(last_turf, target)
		result_list += last_turf
		reach_iterator++
	return result_list

/// Gets a dir towards a target, so that 90% of attacks aren't diagonal
/proc/get_vague_dir(atom/source, atom/target)
	return angle2dir(get_angle(source, target))

/// Animate attack but specifically for swing combat, lets you choose which direction a swing arc takes rather than random
/obj/item/proc/animate_attack_swing_combat(atom/movable/attacker, atom/attacked_atom, animation_type, swing_reversed)
	var/list/image_override = list()
	var/list/animation_override = list()
	var/used_icon_angle = icon_angle
	var/list/angle_override = list()
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_ANIMATION, attacker, attacked_atom, animation_type, image_override, animation_override, angle_override)
	var/image/attack_image = null
	if (!length(image_override))
		attack_image = isnull(attack_icon) ? image(icon = src) : image(icon = attack_icon, icon_state = attack_icon_state)
	else
		attack_image = image_override[1]

	if (length(animation_override))
		animation_type = animation_override[1]
	else if (!animation_type)
		switch (get_sharpness())
			if (SHARP_EDGED)
				animation_type = ATTACK_ANIMATION_SLASH
			if (SHARP_POINTY)
				animation_type = ATTACK_ANIMATION_PIERCE
			else
				animation_type = ATTACK_ANIMATION_BLUNT

	if (length(angle_override))
		used_icon_angle = angle_override[1]

	attack_image.plane = attacked_atom.plane + 1
	attack_image.pixel_w = attacker.base_pixel_x + attacker.base_pixel_w - attacked_atom.base_pixel_x - attacked_atom.base_pixel_w
	attack_image.pixel_z = attacker.base_pixel_y + attacker.base_pixel_z - attacked_atom.base_pixel_y - attacked_atom.base_pixel_z
	// Scale the icon.
	attack_image.transform *= 0.5
	// The icon should not rotate.
	attack_image.appearance_flags = APPEARANCE_UI

	var/atom/movable/flick_visual/attack = attacked_atom.flick_overlay_view(attack_image, 1 SECONDS)
	var/matrix/copy_transform = new(attacker.transform)
	var/x_sign = 0
	var/y_sign = 0
	var/direction = get_dir(attacker, attacked_atom)
	if (direction & NORTH)
		y_sign = -1
	else if (direction & SOUTH)
		y_sign = 1

	if (direction & EAST)
		x_sign = -1
	else if (direction & WEST)
		x_sign = 1

	// Attacking self, or something on the same turf as us
	if (!direction)
		y_sign = 1
		// Not a fan of this, but its the "cleanest" way to animate this
		x_sign = 0.25 * (prob(50) ? 1 : -1)
		// For piercing attacks
		direction = SOUTH

	// And animate the attack!
	switch (animation_type)
		if (ATTACK_ANIMATION_BLUNT)
			attack.pixel_x = 14 * x_sign
			attack.pixel_y = 12 * y_sign
			animate(attack, alpha = 175, transform = copy_transform.Scale(0.75), pixel_x = 4 * x_sign, pixel_y = 3 * y_sign, time = 0.2 SECONDS)
			animate(time = 0.1 SECONDS)
			animate(alpha = 0, time = 0.1 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)

		if (ATTACK_ANIMATION_PIERCE)
			var/attack_angle = dir2angle(direction) + rand(-7, 7)
			// Deducting 90 because we're assuming that icon_angle of 0 means an east-facing sprite
			var/anim_angle = attack_angle - 90 - used_icon_angle
			var/angle_mult = 1
			if (x_sign && y_sign)
				angle_mult = 1.4
			attack.pixel_x = 22 * x_sign * angle_mult
			attack.pixel_y = 18 * y_sign * angle_mult
			attack.transform = attack.transform.Turn(anim_angle)
			copy_transform = copy_transform.Turn(anim_angle)
			animate(
				attack,
				pixel_x = (22 * x_sign - 12 * sin(attack_angle)) * angle_mult,
				pixel_y = (18 * y_sign - 8 * cos(attack_angle)) * angle_mult,
				time = 0.1 SECONDS,
				easing = CUBIC_EASING|EASE_IN,
			)
			animate(
				attack,
				alpha = 175,
				transform = copy_transform.Scale(0.75),
				pixel_x = (22 * x_sign + 26 * sin(attack_angle)) * angle_mult,
				pixel_y = (18 * y_sign + 22 * cos(attack_angle)) * angle_mult,
				time = 0.3 SECONDS,
				easing = CUBIC_EASING|EASE_OUT,
			)
			animate(
				alpha = 0,
				pixel_x = -3 * -(x_sign + sin(attack_angle)),
				pixel_y = -2 * -(y_sign + cos(attack_angle)),
				time = 0.1 SECONDS,
				easing = CIRCULAR_EASING|EASE_OUT
			)

		if (ATTACK_ANIMATION_SLASH)
			attack.pixel_x = 18 * x_sign
			attack.pixel_y = 14 * y_sign
			var/x_rot_sign = 0
			var/y_rot_sign = 0
			var/attack_dir = (swing_reversed ? -1 : 1)
			var/anim_angle = dir2angle(direction) - 90 - used_icon_angle

			if (x_sign)
				y_rot_sign = attack_dir
			if (y_sign)
				x_rot_sign = attack_dir

			// Animations are flipped, so flip us too!
			if (x_sign > 0 || y_sign < 0)
				attack_dir *= -1

			// We're swinging diagonally, use separate logic
			var/anim_dir = attack_dir
			if (x_sign && y_sign)
				if (attack_dir < 0)
					x_rot_sign = -x_sign * 1.4
					y_rot_sign = 0
				else
					x_rot_sign = 0
					y_rot_sign = -y_sign * 1.4

				// Flip us if we've been flipped *unless* we're flipped due to both axis
				if ((x_sign < 0 && y_sign > 0) || (x_sign > 0 && y_sign < 0))
					anim_dir *= -1

			attack.pixel_x += 10 * x_rot_sign
			attack.pixel_y += 8 * y_rot_sign
			attack.transform = attack.transform.Turn(anim_angle - 45 * anim_dir)
			copy_transform = copy_transform.Scale(0.75)
			animate(attack, alpha = 175, time = 0.3 SECONDS, flags = ANIMATION_PARALLEL)
			animate(time = 0.1 SECONDS)
			animate(alpha = 0, time = 0.1 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)

			animate(attack, transform = copy_transform.Turn(anim_angle + 45 * anim_dir), time = 0.3 SECONDS, flags = ANIMATION_PARALLEL)

			var/x_return = 10 * -x_rot_sign
			var/y_return = 8 * -y_rot_sign

			if (!x_rot_sign)
				x_return = 18 * x_sign
			if (!y_rot_sign)
				y_return = 14 * y_sign

			var/angle_mult = 1
			if (x_sign && y_sign)
				angle_mult = 1.4
				if (attack_dir > 0)
					x_return = 8 * x_sign
					y_return = 14 * y_sign
				else
					x_return = 18 * x_sign
					y_return = 6 * y_sign

			animate(attack, pixel_x = 4 * x_sign * angle_mult, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_IN, flags = ANIMATION_PARALLEL)
			animate(pixel_x = x_return, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_OUT)

			animate(attack, pixel_y = 3 * y_sign * angle_mult, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_IN, flags = ANIMATION_PARALLEL)
			animate(pixel_y = y_return, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_OUT)
