/obj/item/melee
	/// The attack speed nextmove if doing a swing type attack
	var/swing_attack_speed
	/// The attack speed nextmove if doing a swing attack secondary
	var/secondary_swing_attack_speed
	/// If the weapon can hit multiple living targets in swing attacks
	var/swing_multihits = FALSE

/obj/item/melee/Initialize(mapload)
	. = ..()
	if(!swing_attack_speed)
		swing_attack_speed = attack_speed
	if(!secondary_swing_attack_speed)
		if(secondary_attack_speed)
			secondary_swing_attack_speed = secondary_attack_speed
		else
			secondary_swing_attack_speed = swing_attack_speed

/// To be overwritten by subtypes, determines the animation for each attack
/obj/item/melee/proc/get_attack_anim_type(secondary)
	return ATTACK_ANIMATION_SLASH

/// Checks if a swing attack is valid before running the giant proc below, also handles attack cooldowns
/obj/item/melee/proc/start_swing_attack(atom/target, mob/living/attacker, backwards, secondary)
	if(!attacker.combat_mode)
		return ITEM_INTERACT_SUCCESS
	if(attacker.next_move > world.time)
		return ITEM_INTERACT_SUCCESS
	var/attack_dir = get_vague_dir(attacker, target)
	var/attack_type = get_attack_anim_type(secondary)
	run_swing_attack(attack_dir, attacker, backwards, swing_multihits, secondary, attack_type, target)
	attacker.changeNext_move(secondary ? secondary_swing_attack_speed : swing_attack_speed)
	return ITEM_INTERACT_SUCCESS

/// Handles how the weapon gets it's target turfs when swinging primary
/obj/item/melee/proc/get_targets(mob/living/attacker, direction, backwards, atom/target)
	return // Overwrite with whatever the tile getting proc should be

/// Handles how the weapon gets it's target turfs when swinging secondary
/obj/item/melee/proc/get_targets_secondary(mob/living/attacker, direction, backwards, atom/target)
	return get_targets(attacker, direction, backwards, target)

/// Handles swing attack targeting, includes handling for hitting walls and whatnot
/obj/item/melee/proc/run_swing_attack(direction, mob/living/attacker, backwards, multihit, secondary, attack_type, atom/target)
	var/list/target_turfs = list()
	if(secondary)
		target_turfs = get_targets_secondary(attacker, direction, backwards, target)
	else
		target_turfs = get_targets(attacker, direction, backwards, target)
	var/turf_index = 1
	var/halfway_point
	var/turf_list_length = length(target_turfs)
	if(turf_list_length <= 1)
		halfway_point = 1 // Futureproofing for one tile swings
	else if(turf_list_length == 2)
		halfway_point = 2
	else
		halfway_point = round(turf_list_length / 2)
	for(var/turf/target_turf in target_turfs)
		// The animation is only played if we don't hit anything by half way through the swing
		if(turf_index == halfway_point)
			animate_attack_swing_combat(attacker, get_step(attacker, direction), attack_type, backwards)
			attacker.do_attack_animation(target_turf, no_effect = TRUE)
			playsound(attacker, 'sound/items/weapons/fwoosh.ogg', 50, TRUE)
		turf_index++
		if(target_turf.is_blocked_turf(exclude_mobs = TRUE))
			if(target_turf.density)
				animate_attack_swing_combat(attacker, target_turf, ATTACK_ANIMATION_PIERCE)
				attacker.Shake(1, 1, 0.5 SECONDS)
				do_sparks(2, FALSE, target_turf)
				playsound(attacker, 'sound/items/weapons/parry.ogg', 50, TRUE)
				return
			// This part stops grilles getting hit under windows and stuff
			var/list/real_order_turf_contents = target_turf.contents
			reverse_range(real_order_turf_contents)
			for(var/atom/movable/potentially_blocking_thing as anything in real_order_turf_contents)
				if(ismob(potentially_blocking_thing))
					continue
				if(!potentially_blocking_thing.density)
					continue
				melee_attack_chain(attacker, potentially_blocking_thing)
				return // If we hit something solid that's not a mob then we stop
		for(var/mob/living/new_victim in target_turf.contents)
			if((new_victim.body_position == LYING_DOWN) && (HAS_TRAIT(new_victim, TRAIT_INCAPACITATED)))
				continue // Swings miss you if you're incapacitated and floored
			melee_attack_chain(attacker, new_victim)
			if(!multihit)
				return

// For testing
/obj/item/melee/tizirian_sword/get_attack_anim_type(secondary)
	return ATTACK_ANIMATION_SLASH

/obj/item/melee/tizirian_sword/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return start_swing_attack(interacting_with, user)

/obj/item/melee/tizirian_sword/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return start_swing_attack(interacting_with, user, TRUE, TRUE)

/obj/item/melee/tizirian_sword/get_targets(mob/living/attacker, direction, backwards)
	return get_turfs_and_adjacent_in_direction(attacker, direction, backwards)

// image(icon = 'icons/effects/effects.dmi', icon_state = "slash")

// Acts like a spear
/obj/item/melee/tizirian_sword/acts_like_spear
	name = "spear swing combat tester"

/obj/item/melee/tizirian_sword/acts_like_spear/get_attack_anim_type(secondary)
	return ATTACK_ANIMATION_PIERCE

/obj/item/melee/tizirian_sword/acts_like_spear/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return start_swing_attack(interacting_with, user)

/obj/item/melee/tizirian_sword/acts_like_spear/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return start_swing_attack(interacting_with, user)

/obj/item/melee/tizirian_sword/acts_like_spear/get_targets(mob/living/attacker, direction, backwards, target)
	return get_turfs_in_straight_line_toward(attacker, target, 2)

// image(icon = 'icons/effects/effects.dmi', icon_state = "shove")
