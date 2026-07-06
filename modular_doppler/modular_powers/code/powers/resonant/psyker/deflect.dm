/datum/power/psyker_power/deflect
	name = "Deflect"
	desc = "Deflects projectiles that strike you, flinging them away from you and preventing harm. These projectiles are then flung towards your current cursor position. Has an incredibly high upkeep, every projectile deflected \
	causes stress equal to the projectile's damage + 10 , and ends prematurely if you suffer a catastrophic stress event.\
	\nCauses stamina damage equal to half the stress generated!"
	security_record_text = "Subject can deflect projectiles away from themselves and towards new targets."
	security_threat = POWER_THREAT_MAJOR
	value = 8
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/deflect

/datum/action/cooldown/power/psyker/deflect
	name = "Deflect"
	desc = "Deflects projectiles that strike you, flinging them away from you and preventing harm. These projectiles are then flung towards your current cursor position. Has an incredibly high upkeep, every projectile deflected \
	causes stress equal to the projectile's damage + 10, and ends prematurely if you suffer a catastrophic stress event.\
	\nCauses stamina damage equal to half the stress generated!"
	button_icon = 'icons/mob/actions/actions_elites.dmi'
	button_icon_state = "singular_shot"
	cooldown_time = 4 SECONDS

	/// Forced cooldown when the effect is dispelled.
	var/dispel_cooldown_time = 15 SECONDS
	/// Per-second upkeep while active.
	var/stress_per_second = 10
	/// Flat stress added on top of projectile damage when we successfully try to deflect it.
	var/projectile_stress_bonus = 10
	/// The status effect on the caster.
	var/datum/status_effect/power/deflect/active_effect

/datum/action/cooldown/power/psyker/deflect/Remove(mob/removed_from)
	. = ..()
	if(active_effect)
		qdel(active_effect)
		active_effect = null
	active = FALSE

/datum/action/cooldown/power/psyker/deflect/use_action(mob/living/user, atom/target)
	if(active_effect)
		qdel(active_effect)
		active_effect = null
		active = FALSE
		to_chat(user, span_notice("You no longer deflect projectiles."))
	else
		active_effect = user.apply_status_effect(/datum/status_effect/power/deflect, src)
		if(!active_effect)
			return FALSE
		active = TRUE
		to_chat(user, span_notice("You brace yourself to deflect projectiles."))
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	return TRUE

/datum/action/cooldown/power/psyker/deflect/proc/force_dispel_cooldown()
	StartCooldownSelf(dispel_cooldown_time)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/status_effect/power/deflect
	id = "deflect"
	alert_type = /atom/movable/screen/alert/status_effect/deflect
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 1 SECONDS
	processing_speed = STATUS_EFFECT_FAST_PROCESS

	/// Per-second upkeep while active.
	var/stress_per_second
	/// Flat stress added on top of projectile damage when we successfully try to deflect it.
	var/projectile_stress_bonus
	/// Reference to the deflect action.
	var/datum/action/cooldown/power/psyker/deflect/source_action
	/// Tracks whether removal was caused by a dispel so we can force cooldown exactly once.
	var/was_dispelled = FALSE
	/// Persistent overlay showing the owner is in a deflective stance.
	var/mutable_appearance/caster_effect
	/// Fullscreen cursor tracker used to keep a live aiming point while the stance is active.
	var/atom/movable/screen/fullscreen/cursor_catcher/cursor_tracker

/atom/movable/screen/alert/status_effect/deflect
	name = "Deflect"
	desc = "Incoming projectiles are being twisted away from you, at a considerable stress cost."
	icon = 'icons/mob/actions/actions_elites.dmi'
	icon_state = "singular_shot"

/// Passes vars over from the action to the status effect
/datum/status_effect/power/deflect/on_creation(mob/living/new_owner, datum/action/cooldown/power/psyker/deflect/passed_action)
	. = ..()
	source_action = passed_action
	if(source_action)
		stress_per_second = source_action.stress_per_second
		projectile_stress_bonus = source_action.projectile_stress_bonus

/// Applies cursor tracking and the overlay bubble.
/datum/status_effect/power/deflect/on_apply()
	if(!owner)
		return FALSE
	playsound(owner, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	RegisterSignal(owner, COMSIG_PROJECTILE_PREHIT, PROC_REF(on_projectile_prehit))
	RegisterSignal(owner, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	cursor_tracker = owner.overlay_fullscreen("psyker_deflect_cursor", /atom/movable/screen/fullscreen/cursor_catcher, 0)
	cursor_tracker?.assign_to_mob(owner)
	if(source_action)
		source_action.active = TRUE
		source_action.active_effect = src
		source_action.build_all_button_icons(UPDATE_BUTTON_STATUS)

	caster_effect = mutable_appearance(
			icon = 'icons/effects/effects.dmi',
			icon_state = "psychic",
			layer = owner.layer + 0.1,
			appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
		)
	owner.add_overlay(caster_effect)
	return TRUE

/// Removes everything left-over by the status effect
/datum/status_effect/power/deflect/on_remove()
	if(owner)
		playsound(owner, 'sound/effects/magic/cosmic_energy.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		UnregisterSignal(owner, COMSIG_PROJECTILE_PREHIT)
		UnregisterSignal(owner, COMSIG_ATOM_DISPEL)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)
		owner.clear_fullscreen("psyker_deflect_cursor")
		cursor_tracker = null
		if(caster_effect)
			owner.cut_overlay(caster_effect)
		caster_effect = null
	if(source_action)
		if(was_dispelled)
			source_action.force_dispel_cooldown()
		source_action.active = FALSE
		source_action.active_effect = null
		source_action.build_all_button_icons(UPDATE_BUTTON_STATUS)
	return

/// Prevents incoming projectiles from hitting, plays effects and delegates to redirect_projectile()
/datum/status_effect/power/deflect/proc/on_projectile_prehit(mob/living/source, obj/projectile/hitting_projectile)
	SIGNAL_HANDLER
	if(source != owner)
		return NONE
	if(!source_action?.ValidateOrgan())
		qdel(src)
		return NONE
	if(source.stat != CONSCIOUS || HAS_TRAIT(source, TRAIT_INCAPACITATED))
		return NONE
	if(!isturf(source.loc))
		return NONE
	if(!hitting_projectile)
		return NONE

	var/obj/item/organ/resonant/psyker/psyker_organ = source_action.psyker_organ
	if(!psyker_organ)
		return NONE

	// Need a nat20 to succesfuly deflect this.
	if(istype(hitting_projectile, /obj/projectile/magic/death) && rand(95))
		to_chat(source, span_userdanger("Your psychic strength cannot ward against death!"))
		return NONE

	// Stress cost + stamina cost
	var/stress_cost = max(hitting_projectile.damage, 0) + projectile_stress_bonus
	// magic projectiles that deal 0 damage will coutn as dealing 100
	if(istype(hitting_projectile, /obj/projectile/magic) && hitting_projectile.damage <= 0)
		stress_cost = 100 + projectile_stress_bonus
	var/catastrophic_threshold = psyker_organ.stress_threshold * 2
	source_action.modify_stress(stress_cost)
	source.adjustStaminaLoss(max(stress_cost, 0) * 0.5)

	// If you try to deflect while overcapped, it just won't work.
	if(psyker_organ.stress >= catastrophic_threshold)
		to_chat(source, span_userdanger("You are too stressed to deflect the projectile!"))
		was_dispelled = TRUE
		qdel(src)
		return NONE

	// You do not get to redirect the projectile but you do prevent it from hitting you
	if(istype(hitting_projectile, /obj/projectile/magic) || istype(hitting_projectile, /obj/projectile/beam/instakill))
		to_chat(source, span_userdanger("Your psychic strength is not strong enough to steer this magic!"))
		was_dispelled = TRUE
		qdel(src)
		return PROJECTILE_INTERRUPT_HIT_PHASE

	// this trait is what determines if projectiles hit us or not
	if(HAS_TRAIT(source, TRAIT_UNHITTABLE_BY_PROJECTILES))
		return NONE
	ADD_TRAIT(source, TRAIT_UNHITTABLE_BY_PROJECTILES, REF(src))

	// deflection starts here
	redirect_projectile(source, hitting_projectile)

	// removes the trait that makes us unhittable by projectiles
	REMOVE_TRAIT(source, TRAIT_UNHITTABLE_BY_PROJECTILES, REF(src))

	// special effects only
	var/image/flash_overlay = new('icons/effects/effects.dmi', source, "void", dir = pick(GLOB.cardinals))
	source.flick_overlay_view(flash_overlay, 10)
	source.visible_message(
		span_danger("[source] twists [hitting_projectile] away with a burst of psychic force!"),
		span_userdanger("You deflect [hitting_projectile]!"),
	)
	playsound(source, 'sound/effects/magic/VoidDeflect02.ogg', 50, TRUE)
	hitting_projectile.process_movement(max(FLOOR(hitting_projectile.speed, 1), 1), tile_limit = TRUE)
	return PROJECTILE_INTERRUPT_HIT_PHASE

/// Attempts to deflect the projectile to the mouse cursor.
/datum/status_effect/power/deflect/proc/redirect_projectile(mob/living/source, obj/projectile/hitting_projectile)
	// Gets and sets the cursor as well as starting location turfs
	var/turf/source_turf = get_turf(source)
	cursor_tracker?.calculate_params()
	var/turf/cursor_turf = cursor_tracker?.given_turf
	var/cursor_pixel_x = isnum(cursor_tracker?.given_x) ? cursor_tracker.given_x : ICON_SIZE_X / 2
	var/cursor_pixel_y = isnum(cursor_tracker?.given_y) ? cursor_tracker.given_y : ICON_SIZE_Y / 2

	// Makes the projectiles ours as the owner rather than the original shooter.
	hitting_projectile.firer = source
	hitting_projectile.fired_from = source
	hitting_projectile.starting = source_turf
	hitting_projectile.original = cursor_turf || source_turf

	//Assigns the new directions for the projectile.
	if(cursor_turf)
		var/delta_x = ((cursor_turf.x - source_turf.x) * ICON_SIZE_X) + (cursor_pixel_x - (ICON_SIZE_X / 2))
		var/delta_y = ((cursor_turf.y - source_turf.y) * ICON_SIZE_Y) + (cursor_pixel_y - (ICON_SIZE_Y / 2))
		hitting_projectile.p_x = cursor_pixel_x
		hitting_projectile.p_y = cursor_pixel_y
		hitting_projectile.xo = cursor_turf.x - source_turf.x
		hitting_projectile.yo = cursor_turf.y - source_turf.y
		hitting_projectile.set_angle(ATAN2(delta_y, delta_x))
		return

/// On dispel, end the status effect and force the action onto cooldown.
/datum/status_effect/power/deflect/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	was_dispelled = TRUE
	qdel(src)
	to_chat(owner, span_userdanger("Your deflection barrier was dispelled!"))
	return DISPEL_RESULT_DISPELLED

/datum/status_effect/power/deflect/proc/on_death(mob/living/source)
	SIGNAL_HANDLER
	qdel(src)

/// Stress upkeep
/datum/status_effect/power/deflect/tick(seconds_between_ticks)
	if(!source_action || QDELETED(source_action))
		qdel(src)
		return
	source_action.modify_stress(stress_per_second * seconds_between_ticks)
	owner.adjustStaminaLoss((stress_per_second * seconds_between_ticks) * 0.5)
