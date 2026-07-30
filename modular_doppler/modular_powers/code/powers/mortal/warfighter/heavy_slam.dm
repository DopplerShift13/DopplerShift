/*
	Hits everything in a 2x3 melee aoe in the targeted direction. Damages creatures, and objects, if in combat mode.
*/

/datum/power/warfighter/heavy_slam
	name = "Heavy Slam"
	desc = "You perform a massive, arcing strike that hits a large area. You strike the 2x3 area adjacent to you in the target direction, hitting everyone in the area (and everything, if in combat mode). \
	A creature can only be hit once by this power, but large creatures take double damage. Requires you to actively be wielding a two-handed weapon."
	security_record_text = "Subject can swing two-handed weapons in an enormous area."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	action_path = /datum/action/cooldown/power/warfighter/heavy_slam
	required_powers = list(/datum/power/warfighter/quick_draw)

/datum/action/cooldown/power/warfighter/heavy_slam
	name = "Heavy Slam"
	desc = "You strike the 2x3 area adjacent to you in the target direction, hitting everyone in the area (and everything, if in combat mode). \
	A creature can only be hit once by this power, but large creatures take double damage. Requires you to actively be wielding a two-handed weapon."
	button_icon = 'icons/obj/weapons/hammer.dmi'
	button_icon_state = "hammeron"
	cooldown_time = 120
	click_to_activate = TRUE
	target_self = FALSE

/datum/action/cooldown/power/warfighter/heavy_slam/use_action(mob/living/user, atom/target)
	var/obj/item/active_item = user.get_active_held_item()
	if(!active_item)
		user.balloon_alert(user, "requires a two-handed weapon!")
		return FALSE

	var/datum/component/two_handed/twohanded = active_item.GetComponent(/datum/component/two_handed)
	if(!twohanded || !HAS_TRAIT(active_item, TRAIT_WIELDED))
		user.balloon_alert(user, "requires a two-handed weapon!")
		return FALSE

	// gets what way we should swing.
	var/dir_to_use = get_cardinal_dir(user, target)
	if(!dir_to_use)
		return FALSE
	// we turn towards where we swinging.
	user.dir = dir_to_use

	//gets the area that we are going to be slamming
	var/turf/origin = get_turf(user)
	if(!origin)
		return FALSE

	var/list/strike_turfs = list()
	var/dir_left = turn(dir_to_use, 90)
	var/dir_right = turn(dir_to_use, -90)

	var/turf/row1 = get_step(origin, dir_to_use)
	var/turf/row2 = null

	add_slam_row(strike_turfs, row1, dir_left, dir_right)
	if(row1 && !is_blocked_turf(row1)) // check if we are allowed to smash through the first row.
		row2 = get_step(row1, dir_to_use)
		add_slam_row(strike_turfs, row2, dir_left, dir_right)

	// applies the slam vfx
	for(var/turf/strike_turf in strike_turfs)
		new /obj/effect/temp_visual/dir_setting/warfighter_heavy_slam(strike_turf, dir_to_use)

	var/turf/impact_turf = row1 ? row1 : origin
	playsound(impact_turf, 'sound/effects/meteorimpact.ogg', 80, TRUE)

	var/list/shaken_mobs = list()
	for(var/turf/strike_turf in strike_turfs)
		for(var/mob/living/shake_mob in view(2, strike_turf))
			if(shake_mob in shaken_mobs)
				continue
			shaken_mobs += shake_mob
			shake_camera(shake_mob, 2, 1)

	RegisterSignal(active_item, COMSIG_ITEM_ATTACK_ANIMATION, PROC_REF(suppress_attack_animation))

	// handles hitting mobs
	var/list/hit_mobs = list()
	for(var/turf/strike_turf in strike_turfs)
		for(var/mob/living/hit_mob in strike_turf)
			if(hit_mob == user)
				continue
			if(hit_mob in hit_mobs)
				continue
			hit_mobs += hit_mob

			var/list/attack_modifiers = list()
			if(is_multi_tile_object(hit_mob) || hit_mob.mob_size >= MOB_SIZE_LARGE)
				attack_modifiers[FORCE_MULTIPLIER] = 2

			active_item.melee_attack_chain(user, hit_mob, null, attack_modifiers)

	// handles hitting objects
	if(user.combat_mode)
		var/list/hit_objs = list()
		for(var/turf/strike_turf in strike_turfs)
			for(var/obj/target_obj in strike_turf)
				if(target_obj == active_item)
					continue
				if(!(isstructure(target_obj) || ismachinery(target_obj)))
					continue
				if(target_obj in hit_objs)
					continue
				hit_objs += target_obj
				target_obj.attackby(active_item, user, null, null)

	UnregisterSignal(active_item, COMSIG_ITEM_ATTACK_ANIMATION)

	// short cd on hit
	melee_cooldown_time = active_item.attack_speed
	return TRUE

/// Handles the aoe row by row. Basically gets the left and right turfs of the direction.
/datum/action/cooldown/power/warfighter/heavy_slam/proc/add_slam_row(list/strike_turfs, turf/row_turf, dir_left, dir_right)
	if(!row_turf)
		return
	if(!(row_turf in strike_turfs))
		strike_turfs += row_turf

	var/turf/left_turf = get_step(row_turf, dir_left)
	if(left_turf && !(left_turf in strike_turfs))
		strike_turfs += left_turf

	var/turf/right_turf = get_step(row_turf, dir_right)
	if(right_turf && !(right_turf in strike_turfs))
		strike_turfs += right_turf

/// We check if we can smash through the first row.
/datum/action/cooldown/power/warfighter/heavy_slam/proc/is_blocked_turf(turf/row_turf)
	if(!row_turf)
		return TRUE
	if(row_turf.density)
		return TRUE
	for(var/obj/blocked_obj in row_turf)
		if(blocked_obj.density)
			return TRUE
	return FALSE

/// Okay look it sounds menacing but this basically just gets the direction that we're swinging towards based on where we click.
/datum/action/cooldown/power/warfighter/heavy_slam/proc/get_cardinal_dir(mob/living/user, atom/target)
	if(!user)
		return 0
	var/dir_to_use = target ? get_dir(user, target) : user.dir
	if(!dir_to_use)
		return 0
	if((dir_to_use & (NORTH | SOUTH)) && (dir_to_use & (EAST | WEST)))
		var/dx = target ? (target.x - user.x) : 0
		var/dy = target ? (target.y - user.y) : 0
		if(abs(dx) >= abs(dy))
			dir_to_use = (dx >= 0) ? EAST : WEST
		else
			dir_to_use = (dy >= 0) ? NORTH : SOUTH
	return dir_to_use

/// This is a pretty cringe way of doing it but uhh I am out of ideas on how to do this better.
/// Prevents everyone in the area from being visible struck by the weapon.
/datum/action/cooldown/power/warfighter/heavy_slam/proc/suppress_attack_animation(obj/item/source, atom/movable/attacker, atom/attacked_atom, animation_type, list/image_override, list/animation_override, list/angle_override)
	SIGNAL_HANDLER
	image_override += image(icon = 'icons/effects/effects.dmi', icon_state = "nothing")

// Effect of the slam
/obj/effect/temp_visual/dir_setting/warfighter_heavy_slam
	icon = 'icons/effects/effects.dmi'
	icon_state = "smash"
	duration = 3
