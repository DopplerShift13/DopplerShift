/*
	Kicks an item horizontally/vertically/diagonally in a straight line. Dense objects stun and damage on impact, otherwise acts as a throw.
	Inspired by the pent-up frustrations of several Cargo members on Doppler.
	Scales with Athletics. Hit the bar so you can hit them with their MAIL.
*/

/datum/power/expert/punt
	name = "Punt"
	desc = "Using your foot or some other part of your body, you send an object barreling down a long distance away from you. If someone is hit by the object and it is solid, they are knocked down and take damage. \
	Distance (and damage) scale with your Athletics skill. Double distance on crates and non-bulky objects! Requires Heavy Lifter."
	security_record_text = "Subject has expertise in punting objects across large distances."
	value = 3
	required_powers = list(/datum/power/expert/heavy_lifter)
	action_path = /datum/action/cooldown/power/expert/punt

/datum/action/cooldown/power/expert/punt
	name = "Punt"
	desc = "You send an object barreling down a long distance away from you. If someone is hit by the object and it is solid, they are knocked down and take damage. \
	Distance (and damage) scale with your Athletics skill. Double distance on crates and non-bulky objects!"
	button_icon = 'icons/mob/actions/actions_elites.dmi' // another placeholder
	button_icon_state = "herald_teleshot"

	target_type = /obj/
	target_range = 1
	click_to_activate = TRUE
	cooldown_time = 10

	/// The base distance we punt. Keep in mind this is without the athletics bonus (they'll at least be journeyman so +2)
	var/base_range = 1
	/// how much damage punt impact does if its a solid object.
	var/base_damage = 5

/datum/action/cooldown/power/expert/punt/use_action(mob/living/user, obj/target)
	if(!target || target.anchored || !isturf(target.loc))
		user.balloon_alert(user, "can't move that!")
		return FALSE

	// Half your athletics skill rounded is added to the distance
	var/athletics = round((user.mind?.get_skill_level(/datum/skill/athletics) || 0) / 2)

	var/range = base_range + athletics

	// items that are normal or smaller, or if its a crate (cargo rejoice), get punted twice as far.
	if(istype(target, /obj/structure/closet/crate))
		range *= 2
	if(isitem(target))
		var/obj/item/target_item = target
		if(target_item.w_class <= WEIGHT_CLASS_NORMAL)
			range *= 2
	// If we're legendary we get a bit more throw distance; enough to be able to offscreen people.
	if(user.mind?.get_skill_level(/datum/skill/athletics) >= SKILL_LEVEL_LEGENDARY)
		range += 2

	var/dir = get_dir(user, target)
	user.setDir(dir)
	var/turf/target_turf = get_ranged_target_turf(target, dir, range)

	RegisterSignal(target, COMSIG_MOVABLE_IMPACT, PROC_REF(punt_impact))
	playsound(user, 'sound/effects/meteorimpact.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	target.throw_at(target_turf, range = range, speed = target.density ? 3 : 4, thrower = user, spin = isitem(target))
	return TRUE

/// Listener that handles on impact effect such as damage, knock down and other feedback.
/datum/action/cooldown/power/expert/punt/proc/punt_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)

	// Base damage + athletics skill level * 2 (journeyman = 4*2=8)
	var/damage = base_damage + round((owner.mind?.get_skill_level(/datum/skill/athletics) || 0) * 2)
	// Dense objects are treated as damaging projectiles.
	if(source.density)
		if(isliving(hit_atom)) // if you manage to line up the shot you deserve this
			var/mob/living/living_atom = hit_atom
			var/mob/thrower = thrownthing?.get_thrower() || owner

			living_atom.apply_damage(damage, BRUTE)
			living_atom.Knockdown(2 SECONDS)
			playsound(living_atom, 'sound/items/lead_pipe_hit.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE) // I am not sorry for this choice in sound effect

			// logging
			living_atom.log_message("was punted by an object from [thrower] for [damage] damage.", LOG_VICTIM)
			thrower.log_message("punted an object at [living_atom] for [damage] damage.", LOG_ATTACK)

			if(!thrower || get_dist(thrower, hit_atom) >= 12) //if you hit someone offscreen, which can't be done without legendary or backpedaling.
				thrower.playsound_local(thrower, 'sound/items/weapons/homerun.ogg', 75)
				to_chat(thrower, span_boldnotice("You can't see it, but you've got a hunch you just hit a fantastic shot."))
		else if(hit_atom.uses_integrity) // sorry about the window ma'am
			hit_atom.take_damage(damage, BRUTE, MELEE)
