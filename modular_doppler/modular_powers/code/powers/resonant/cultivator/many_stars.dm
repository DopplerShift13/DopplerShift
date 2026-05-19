/datum/power/cultivator/many_stars
	name = "The Many Stars that Dot the Endless Sky"
	desc = "An active ability. Activating it sends forth a little star, which stops when it reaches it's destination (or hits an object) passively glowing in an area as a light source for 60 seconds. \
	ou can have up to 8 of these active. \
	While in alignment, you can right click with this ability to explode all active stars that are not in motion dealing 20 burn damage to all creatures in a 3x3 area centered on it. \
	Exploding the stars consumes Energy per star. No cooldown."
	security_record_text = "Subject can shoot lights to illuminate an area, which can be detonated while in a heightened state to explode and damage those around it."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/cultivator_root/astral_touched)
	action_path = /datum/action/cooldown/power/cultivator/many_stars

// Tracks what mouse button was pressed and routes it through use_action
/// No mouse-press, either fallback or something weird happened.
#define STARS_CLICK_NONE 0
/// Left mouse click.
#define STARS_CLICK_LEFT 1
/// Right mouse click.
#define STARS_CLICK_RIGHT 2

/datum/action/cooldown/power/cultivator/many_stars
	name = "The Many Stars that Dot the Endless Sky"
	desc = "Activating the ability sends forth a little star, which stops when it reaches it's destination (or hits an object) passively glowing in an area as a light source for 5 minutes. \
	ou can have up to 8 of these active. \
	While in alignment, you can right click with this ability to explode all active stars that are not in motion dealing 20 burn damage to all creatures in a 3x3 area centered on it. \
	Exploding the stars consumes Energy per star. No cooldown."
	button_icon = 'icons/effects/eldritch.dmi'
	button_icon_state = "ring_leader_effect"

	click_to_activate = TRUE
	unset_after_click = FALSE
	anti_magic_on_target = FALSE
	click_cd_override = 3 // matches cooldown between shots

	/// Icon for the stars we throw
	var/star_icon = 'icons/effects/eldritch.dmi'
	/// Icon state for the stars we throw
	var/star_state = "ring_leader_effect"
	/// Color for the stars we throw
	var/star_color = "#c1effa"

	/// how big are the stars
	var/star_size = 0.7
	/// how long do the stars last
	var/star_duration = 300 SECONDS
	/// the light range
	var/star_light_range = 5
	/// the light's power (how strong of a light)
	var/star_light_power = 1
	/// the max amount of stars
	var/max_active_stars = 8
	/// list of stars that are currently active
	var/list/active_stars

	/// world.time for when we should be able to shoot our next shot
	var/next_star_shot_time = 0
	/// Cooldown for shots in miliseconds.
	var/star_shot_delay = 3

	/// how much damage does the star do on explosion
	var/star_explosion_damage = 25
	/// the explosion effect range
	var/star_explosion_range = 1
	/// the explosion sound
	var/star_explosion_sound = 'sound/effects/magic/wandodeath.ogg'
	/// the energy cost for exploding the stars
	var/star_explosion_cost = CULTIVATOR_ENERGY_TRIVIAL * 2
	/// the energy cost per star
	var/star_explosion_cost_per_star = CULTIVATOR_ENERGY_TRIVIAL

	/// Cached alignment action for gating effects.
	var/datum/action/cooldown/power/cultivator/alignment/astral_touched/astral_alignment
	/// Which mouse click is used in use_action
	var/stars_click_type = STARS_CLICK_NONE

/datum/action/cooldown/power/cultivator/many_stars/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK)) // EXPLOSION
		stars_click_type = STARS_CLICK_RIGHT
	else
		stars_click_type = STARS_CLICK_LEFT
	. = ..()
	if(!.)
		stars_click_type = STARS_CLICK_NONE
	return TRUE

/datum/action/cooldown/power/cultivator/many_stars/use_action(mob/living/user, atom/target)
	// Sets the click type.
	if(stars_click_type == STARS_CLICK_RIGHT) // if right click, explode
		return explode_active_stars(user)
	if(world.time < next_star_shot_time) // otherwise, we shoot stars.
		return FALSE
	next_star_shot_time = world.time + star_shot_delay
	if(fire_projectile(user, target, /obj/projectile/resonant/many_stars))
		playsound(user, 'sound/effects/magic/cosmic_energy.ogg', 60, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		return TRUE
	return FALSE

/// If we get dispelled, our stars end. Whilst this goes around the ususal philosophy of dispelling the target object, you are still linked to them with the ability to blow it up.
/datum/action/cooldown/power/cultivator/many_stars/proc/dispel(atom/target, atom/dispeller)
	var/list/stars_to_del = active_stars.Copy()
	if(stars_to_del)
		to_chat(target, span_boldwarning("Your stars suddenly vanish!"))
	for(var/obj/effect/many_stars_star/star as anything in stars_to_del)
		qdel(star)

/// Checks where to place the star
/datum/action/cooldown/power/cultivator/many_stars/proc/can_place_star(turf/target_turf)
	if(!target_turf || !isopenturf(target_turf))
		return FALSE
	if(target_turf.is_blocked_turf(exclude_mobs = TRUE)) // space needs to not be blocked
		return FALSE
	if(locate(/obj/effect/many_stars_star) in target_turf) // space can't already have a star
		return FALSE
	return TRUE

/// Adds a star to the list and removes the oldest if it exceeds the max
/datum/action/cooldown/power/cultivator/many_stars/proc/register_star(obj/effect/many_stars_star/new_star)
	if(!new_star)
		return
	LAZYINITLIST(active_stars)
	active_stars += new_star
	if(length(active_stars) > max_active_stars)
		var/obj/effect/many_stars_star/oldest_star = active_stars[1]
		if(oldest_star)
			qdel(oldest_star)

/// Removes a star from the list.
/datum/action/cooldown/power/cultivator/many_stars/proc/unregister_star(obj/effect/many_stars_star/old_star)
	if(!active_stars || !old_star)
		return
	active_stars -= old_star

/// KA-BOOOOOOOM. Blows up all stars in our active stars list.
/datum/action/cooldown/power/cultivator/many_stars/proc/explode_active_stars(mob/living/user)
	if(!is_astral_alignment_active(user))
		if(user)
			user.balloon_alert(user, "alignment required!")
		return
	if(!active_stars || !length(active_stars))
		return
	if(energy_component.energy < star_explosion_cost)
		user.balloon_alert(user, "needs more energy!")
	if(user)
		user.log_message("detonated their Many Stars.", LOG_GAME)

	var/list/stars_to_explode = active_stars.Copy()
	adjust_energy(-star_explosion_cost) // removes the base cost
	for(var/obj/effect/many_stars_star/star as anything in stars_to_explode)
		if(QDELETED(star))
			continue
		var/turf/star_turf = get_turf(star)
		if(!star_turf)
			continue
		playsound(star_turf, star_explosion_sound, 75, TRUE)
		star_turf.visible_message(span_bolddanger("The star explodes in a wave of energy!"))
		// applies damage, does cool effects, does logging.
		var/obj/effect/temp_visual/circle_wave/explosion_fx = new /obj/effect/temp_visual/circle_wave/many_stars(star_turf)
		explosion_fx.color = star_color
		for(var/turf/effect_turf in range(star_explosion_range, star_turf))
			for(var/mob/living/target in effect_turf)
				// We skip this whole thing if the mob is immune to resonance
				if(target.can_block_resonance(ANTIRESONANCE_BASE_CHARGE_COST) || target.can_block_magic(MAGIC_RESISTANCE, ANTIRESONANCE_BASE_CHARGE_COST))
					continue
				var/dam_dealt = apply_damage_with_armor(target,	star_explosion_damage, damage_type = astral_alignment?.alignment_damage_type || BURN, attack_flag = BOMB)
				target.log_message("was hit by a Many Stars detonation from [user] for [dam_dealt] damage.", LOG_VICTIM, color="blue")
				if(user)
					user.log_message("detonated Many Stars against [target] for [dam_dealt] damage.", LOG_ATTACK, color="red")
				to_chat(target, span_userdanger("You are hit by an explosive blast of energy!"))
		qdel(star)

		// Removes cost per star; if we end up at 0, explode no more stars and shut off their power.
		adjust_energy(-star_explosion_cost_per_star)
		if(energy_component.energy <= 0)
			user.balloon_alert(user, "no more energy!")
			if(astral_alignment.active)
				astral_alignment.disable_alignment(user)
			break

/// Gets & sets astral allignment. We only really reference it in the explosion.
/datum/action/cooldown/power/cultivator/many_stars/proc/is_astral_alignment_active(mob/living/user)
	if(!astral_alignment)
		for(var/datum/action/cooldown/power/cultivator/alignment/astral_touched/alignment_action in user.actions)
			astral_alignment = alignment_action
			break
	if(!astral_alignment)
		return FALSE
	return astral_alignment.active

/// Creates the lingering star on impact.
/datum/action/cooldown/power/cultivator/many_stars/proc/spawn_star(turf/impact_turf, turf/fallback_turf, obj/projectile/resonant/many_stars/source_projectile)
	var/turf/placement_turf = null
	if(can_place_star(impact_turf))
		placement_turf = impact_turf
	else if(can_place_star(fallback_turf))
		placement_turf = fallback_turf

	if(!placement_turf)
		return

	var/obj/effect/many_stars_star/new_star = new(placement_turf)
	new_star.owner_power = src
	new_star.lifespan = star_duration
	new_star.light_range = star_light_range
	new_star.light_power = star_light_power
	// Copies the effects of the soruce projectile if possible.
	if(source_projectile)
		new_star.icon = source_projectile.icon
		new_star.icon_state = source_projectile.icon_state
		new_star.color = source_projectile.color
		new_star.light_color = source_projectile.star_color ? source_projectile.star_color : source_projectile.color
		new_star.star_size = source_projectile.star_size
	else
		new_star.icon = star_icon
		new_star.icon_state = star_state
		new_star.color = star_color
		new_star.light_color = star_color
		new_star.star_size = star_size

	new_star.apply_star_scale()

	register_star(new_star)

// Applies the configured effects to the star.
/datum/action/cooldown/power/cultivator/many_stars/ready_projectile(obj/projectile/projectile_instance, atom/target, mob/living/user)
	. = ..()
	if(!projectile_instance || !istype(projectile_instance, /obj/projectile/resonant/many_stars))
		return

	// Applies the icon, state and color to the projectie.
	var/obj/projectile/resonant/many_stars/star_proj = projectile_instance
	star_proj.star_icon = star_icon
	star_proj.star_state = star_state
	star_proj.star_color = star_color

	if(star_icon)
		star_proj.icon = star_icon
	if(star_state)
		star_proj.icon_state = star_state
	if(star_color)
		star_proj.color = star_color
	if(star_size)
		star_proj.star_size = star_size
		star_proj.apply_star_scale()

	// Applies the light to hte projectile.
	star_proj.light_range = star_light_range
	star_proj.light_power = star_light_power
	star_proj.light_color = star_color ? star_color : star_proj.color
	star_proj.light_on = TRUE
	star_proj.set_light(star_light_range, star_light_power, star_color ? star_color : star_proj.color, l_on = TRUE)

	var/turf/target_turf = get_turf(target)
	star_proj.target_turf = target_turf

/obj/projectile/resonant/many_stars
	name = "star"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "ring_leader_effect"

	/// Icon of the star
	var/star_icon
	/// Icon state of the star
	var/star_state
	/// Color of the star
	var/star_color
	/// Size of the star's sprite
	var/star_size = 0.5
	/// The last turf we passed through as a star
	var/turf/last_passed_turf
	/// The turf the caster aimed us ast
	var/turf/target_turf
	/// Have we reached our destination?
	var/reached_target = FALSE

// Tracks the last space we were in
/obj/projectile/resonant/many_stars/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(old_loc)
		last_passed_turf = get_turf(old_loc)
	if(!reached_target && target_turf && get_turf(src) == target_turf) // if we're at the click target we stop
		reached_target = TRUE
		deletion_queued = PROJECTILE_RANGE_DELETE

// Runs the star spawning on hit
/obj/projectile/resonant/many_stars/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	var/turf/impact_turf = get_turf(target)
	var/datum/action/cooldown/power/cultivator/many_stars/power = creating_power
	if(power)
		power.spawn_star(impact_turf, last_passed_turf, src)

// If we cap out on range
/obj/projectile/resonant/many_stars/on_range()
	. = ..()
	var/turf/impact_turf = get_turf(src)
	var/datum/action/cooldown/power/cultivator/many_stars/power = creating_power
	if(power)
		power.spawn_star(impact_turf, last_passed_turf, src)

/// Applies the size to the projectile
/obj/projectile/resonant/many_stars/proc/apply_star_scale()
	if(!star_size)
		return
	var/matrix/scale_matrix = matrix()
	scale_matrix.Scale(star_size, star_size)
	transform = scale_matrix

// The lingering star effect
/obj/effect/many_stars_star
	name = "star"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "ring_leader_effect"
	anchored = TRUE
	density = FALSE
	max_integrity = 1
	light_range = 3
	light_power = 1
	light_color = "#66c5dd"
	/// Size of the object
	var/star_size = 0.5
	/// Lifespan of the object
	var/lifespan = 300 SECONDS
	/// Reference to the action datum that created this
	var/datum/action/cooldown/power/cultivator/many_stars/owner_power

// Adds expiration timer and size modifier.
/obj/effect/many_stars_star/Initialize(mapload)
	. = ..()
	apply_star_scale()
	if(lifespan)
		addtimer(CALLBACK(src, PROC_REF(expire)), lifespan)

/obj/effect/many_stars_star/Destroy()
	if(owner_power)
		owner_power.unregister_star(src)
	owner_power = null
	return ..()

/// On expiration, just remove.
/obj/effect/many_stars_star/proc/expire()
	qdel(src)

// Dissipate harmlessly on attack
/obj/effect/many_stars_star/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(attacking_item?.force)
		if(user)
			to_chat(user, span_notice("You smack the star, and it vanishes!"))
		qdel(src)
	return .

// Same with an unarmed touch.
/obj/effect/many_stars_star/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(user)
		to_chat(user, span_notice("You interact with the star, and it vanishes!"))
	qdel(src)
	return .

/// Applies the size modifier on the star item.
/obj/effect/many_stars_star/proc/apply_star_scale()
	if(!star_size)
		return
	var/matrix/scale_matrix = matrix()
	scale_matrix.Scale(star_size, star_size)
	transform = scale_matrix

// The aoe explosion circle from many_stars
/obj/effect/temp_visual/circle_wave/many_stars
	color = COLOR_CYAN
	duration = 0.5 SECONDS
	amount_to_scale = 1.5

#undef STARS_CLICK_NONE
#undef STARS_CLICK_LEFT
#undef STARS_CLICK_RIGHT
