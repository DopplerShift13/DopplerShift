/*
	Shoots a blast of wind for various neat purposes; mostly just to push your co-workers around and the occasional fire.
	Perfectly encapsulates the design philosophy of thaumaturge spells being big on util and not specifically good at one thing.
*/

// Maximum amount of items we can push with this spell.
#define THAUMATURGE_GALE_BLAST_PUSH_LIMIT 20

/datum/power/thaumaturge/gale_blast
	name = "Gale Blast"
	desc = "Shoots forth a blast of wind. The blast keeps traveling until it hits a solid structure, extinguishing any fires and dragging along any items with it. If it hits a solid entity, it knocks it back 3 spaces and extinguishes it if it was on fire. \
	\nRequires Affinity 3. For every 2 excess affinity, your push force increases (letting you push heavier objects), and you gain +1 push distance."
	security_record_text = "Subject can create and shoot out strong, violent gusts of wind."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	action_path = /datum/action/cooldown/power/thaumaturge/gale_blast
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/gale_blast
	name = "Gale Blast"
	desc = "Shoots forth a blast of wind. The blast keeps traveling until it hits a solid structure, extinguishing any fires and dragging along any items with it. If it hits a solid entity, it knocks it back 3 spaces and extinguishes it if it was on fire."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "smoke"

	required_affinity = 3
	prep_cost = 3
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

/datum/action/cooldown/power/thaumaturge/gale_blast/use_action(mob/living/user, atom/target)
	if(fire_projectile(user, target, /obj/projectile/resonant/gale_blast))
		user.visible_message(span_warning("[user] shoots a [/obj/projectile/resonant/gale_blast::name]!"))
		playsound(user, 'sound/effects/podwoosh.ogg', 60, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		return TRUE
	return FALSE


// The projectile itself
/obj/projectile/resonant/gale_blast
	name = "gale blast"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"

	/// How far we knockback on impact.
	var/knockback_range = 3
	/// How much force the traveling wind applies to loose objects it tries to drag along.
	var/wind_drag_force = MOVE_FORCE_STRONG
	/// How much force the impact burst applies when throwing a struck target backward.
	var/knockback_force = MOVE_FORCE_STRONG
	/// Affinity captured when the projectile was fired. This keeps the projectile behavior consistent no matter what happens to the caster.
	var/stored_affinity
	/// Hidden or special movables that should never be dragged by wind effects.
	var/static/list/wind_drag_blacklist = typecacheof(list(
		/atom/movable/mirage_holder, // movable object that creates the illusion. surprised it is an atom/movable.
	))
	/// Ordered weakest to strongest for affinity-based force scaling.
	var/static/list/force_tiers = list(
		MOVE_FORCE_EXTREMELY_WEAK,
		MOVE_FORCE_VERY_WEAK,
		MOVE_FORCE_WEAK,
		MOVE_FORCE_NORMAL,
		MOVE_FORCE_STRONG,
		MOVE_FORCE_VERY_STRONG,
		MOVE_FORCE_EXTREMELY_STRONG,
		MOVE_FORCE_OVERPOWERING,
	)

/// Gets the proper push-force for your gale blast
/obj/projectile/resonant/gale_blast/proc/get_scaled_force(base_force)
	var/tier_increase = get_affinity_force_tier_increase()
	var/base_tier_index = force_tiers.Find(base_force)

	if(!base_tier_index)
		return base_force

	var/scaled_tier_index = min(base_tier_index + tier_increase, force_tiers.len)
	return force_tiers[scaled_tier_index]

/// Saves off any power state that should not change after the projectile is fired.
/obj/projectile/resonant/gale_blast/snapshot_power_state(datum/action/cooldown/power/power)
	var/datum/action/cooldown/power/thaumaturge/thaumaturge_power = power
	if(isnull(thaumaturge_power?.affinity)) // we default to 3 in case something else fires this
		stored_affinity = 3
		return
	stored_affinity = thaumaturge_power.affinity

/// Does +1 knockback and +1 force tier with every 2 excess affinity.
/obj/projectile/resonant/gale_blast/proc/get_affinity_force_tier_increase()
	var/excess_affinity = max(0, stored_affinity - 3)
	return FLOOR(excess_affinity / 2, 1)

// Code for dragging along objects.
/obj/projectile/resonant/gale_blast/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()

	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return
	var/turf/old_turf = get_turf(old_loc)

	// Handless moving objects along with it.
	drag_along_movables(old_turf, current_turf)
	// Extinguishes hotspots. Doesn't mess with atmos.
	extinguish_hotspots_on_turf(current_turf)

/// Drags along anything that's not nailed down on the floor.
/// Testing note: This drags along ghosts. This is too funny to fix.
/obj/projectile/resonant/gale_blast/proc/drag_along_movables(turf/from_turf, turf/to_turf)
	if(!from_turf || !to_turf)
		return

	var/travel_dir = get_dir(from_turf, to_turf)
	if(!travel_dir)
		return

	var/pushed_atoms = 0

	// Checks if we're allowed to drag it and if the space can be passed through.
	for(var/atom/movable/movable_instance as anything in from_turf)
		// We cap the amount of items that can be moved similar to push brooms to prevent you from casting LAGIMUS MAXIMUS.
		if(pushed_atoms >= THAUMATURGE_GALE_BLAST_PUSH_LIMIT)
			break

		if(!can_wind_drag(movable_instance, from_turf))
			continue

		if(!movable_instance.CanPass(movable_instance, to_turf, travel_dir))
			continue

		// Drags along the object.
		movable_instance.Move(to_turf)
		// Also extinguishes it.
		movable_instance.extinguish()
		pushed_atoms++

/// Checks if we can drag along the target.
/obj/projectile/resonant/gale_blast/proc/can_wind_drag(atom/movable/movable_instance, turf/current_turf)
	if(!movable_instance)
		return FALSE

	var/effective_wind_drag_force = get_scaled_force(wind_drag_force)

	// Skips anything in the blacklist.
	if(is_type_in_typecache(movable_instance, wind_drag_blacklist))
		return FALSE

	// Anchored objects do not move
	if(movable_instance.anchored)
		return FALSE

	// Respect the existing move force system so immovable or heavy objects are not wind-dragged for free.
	if((movable_instance.move_resist == INFINITY) || (effective_wind_drag_force < (movable_instance.move_resist * MOVE_FORCE_PUSH_RATIO)))
		return FALSE

	// Do not drag living mobs; knockback is handled separately
	if(isliving(movable_instance))
		return FALSE

	// Only drag things actually sitting on the turf
	if(movable_instance.loc != current_turf)
		return FALSE

	return TRUE

/// Extinguishes fire in the target space.
/obj/projectile/resonant/gale_blast/proc/extinguish_hotspots_on_turf(turf/current_turf)
	if(!current_turf)
		return

	for(var/obj/effect/hotspot/hotspot_instance as anything in current_turf)
		if(hotspot_instance.type != /obj/effect/hotspot) // only delete fires!
			continue
		qdel(hotspot_instance)

/*
	On hit effects below
*/

// Helpers functions do most of the work here.
/obj/projectile/resonant/gale_blast/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	extinguish_hit_target(target)
	apply_knockback(target)


/// Handles the knockback on hit
/obj/projectile/resonant/gale_blast/proc/apply_knockback(atom/hit_atom)
	var/atom/movable/movable_target = hit_atom
	if(!istype(movable_target))
		return

	if(movable_target.anchored)
		return

	var/turf/target_turf = get_turf(movable_target)
	if(!target_turf)
		return

	// Knockback direction = projectile travel direction at impact
	var/knockback_dir = dir
	if(!knockback_dir)
		return

	// Calculates knockback dist
	var/knockback_dist = knockback_range
	var/tier_increase = get_affinity_force_tier_increase()
	var/effective_knockback_force = get_scaled_force(knockback_force)

	knockback_dist += tier_increase

	var/turf/destination_turf = target_turf
	for(var/step_count in 1 to knockback_dist)
		var/turf/next_turf = get_step(destination_turf, knockback_dir)
		if(!next_turf)
			break
		destination_turf = next_turf

	movable_target.safe_throw_at(destination_turf, knockback_dist, 2, firer, force = effective_knockback_force)
	playsound(movable_target, 'sound/effects/bamf.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

// Extinguishes the target we just hit.
/obj/projectile/resonant/gale_blast/proc/extinguish_hit_target(atom/hit_atom)
	if(!hit_atom)
		return

	if(isliving(hit_atom))
		var/mob/living/living_target = hit_atom
		living_target.extinguish_mob()
		return

	// Items / other atoms that can burn
	hit_atom.extinguish()
