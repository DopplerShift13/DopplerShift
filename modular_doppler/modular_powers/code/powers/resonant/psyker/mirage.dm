// Mirage mode constants
#define MIRAGE_MODE_STATIONARY 1
#define MIRAGE_MODE_AGGRESSIVE 2
#define MIRAGE_MODE_FLEE 3

/*
	Create duplicates of yourself with varying AI behaviors.
*/
/datum/power/psyker_power/mirage
	name = "Mirage"
	desc = "Creates an illusory copy of yourself for 20 seconds; it has one health and draws aggression from creatures, but doesn't deal damage and can be walked through.\
	\n Right click with the power selected to change its behavior between stationary, aggressive and flee. Creatures immune to mental and resonant effects disbelieve the illusion, making them see-through and pass-through. \
	\n Creating the illusion creates a moderate amount of stress."
	security_record_text = "Subject can create illusory duplicates of themselves."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/mirage

/datum/action/cooldown/power/psyker/mirage
	name = "Mirage"
	desc = "Creates an illusory copy of yourself for 20 seconds; it has one health and draws aggression from creatures, but doesn't deal damage and can be walked through.\
	\n Right click with the power selected to change its behavior between stationary, aggressive and flee. Creatures immune to mental and resonant effects disbelieve the illusion, making them see-through and pass-through."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "chrono_phase"
	click_to_activate = TRUE
	unset_after_click = FALSE

	// Active mirage instances
	var/list/active_mirages = list()
	// Mirage behavior mode
	var/mode = MIRAGE_MODE_STATIONARY
	// Stress cost
	var/stress_cost = PSYKER_STRESS_MODERATE * 1.5

// WE get the right click behavior to cycle behavior.
/datum/action/cooldown/power/psyker/mirage/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(clicker != owner)
		return FALSE

	var/list/mods = params2list(params)
	if(LAZYACCESS(mods, RIGHT_CLICK))
		cycle_mode()
		return TRUE

	return ..()

/datum/action/cooldown/power/psyker/mirage/use_action(mob/living/user, atom/target)
	. = ..()
	if(!owner)
		return FALSE

	cleanup_mirages()

	var/turf/spawn_turf = get_turf(target) || get_turf(owner)
	if(!spawn_turf)
		return FALSE

	// Creates a new instance of the mirrage
	var/mob/living/simple_animal/hostile/illusion/mirage/resonant/new_mirage = new(spawn_turf)
	new_mirage.Copy_Parent(owner, 20 SECONDS, 1, 0)
	new_mirage.set_action_ref(src)
	new_mirage.apply_mode(mode)
	new_mirage.match_owner_speed(owner)
	active_mirages += new_mirage

	// Causes it to act immediately.
	new_mirage.FindTarget()

	modify_stress(stress_cost)
	playsound(new_mirage, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	return TRUE

// Changes behavior of the sapawned illusion.
/datum/action/cooldown/power/psyker/mirage/proc/cycle_mode()
	if(mode == MIRAGE_MODE_STATIONARY)
		mode = MIRAGE_MODE_AGGRESSIVE
		owner?.balloon_alert(owner, "set to Aggressive")
	else if(mode == MIRAGE_MODE_AGGRESSIVE)
		mode = MIRAGE_MODE_FLEE
		owner?.balloon_alert(owner, "set to Flee")
	else
		mode = MIRAGE_MODE_STATIONARY
		owner?.balloon_alert(owner, "set to Stationary")

/datum/action/cooldown/power/psyker/mirage/Remove(mob/removed_from)
	. = ..()
	for(var/mob/living/simple_animal/hostile/illusion/mirage/resonant/mirage as anything in active_mirages)
		if(!QDELETED(mirage))
			qdel(mirage)
	active_mirages.Cut()

/datum/action/cooldown/power/psyker/mirage/proc/cleanup_mirages()
	for(var/mob/living/simple_animal/hostile/illusion/mirage/resonant/mirage as anything in active_mirages.Copy())
		if(QDELETED(mirage))
			active_mirages -= mirage


/*
	Mirage mob: simple animal used for aggro, but with per-viewer masking.
*/
/mob/living/simple_animal/hostile/illusion/mirage/resonant
	var/datum/weakref/action_ref
	var/last_mode = MIRAGE_MODE_STATIONARY
	var/alt_appearance_key
	density = TRUE
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"

/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/set_action_ref(datum/action/cooldown/power/psyker/mirage/action)
	action_ref = WEAKREF(action)
	if(!alt_appearance_key)
		alt_appearance_key = "mirage_alpha_[REF(src)]"
		var/image/appearance_image = image(loc = src)
		appearance_image.appearance = appearance
		appearance_image.dir = dir
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/mirage_alpha, alt_appearance_key, appearance_image, action, action?.owner)
		RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mirage_dir_change))
	RegisterSignal(src, COMSIG_ATOM_DISPEL, PROC_REF(on_mirage_dispel))

/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/match_owner_speed(mob/living/owner)
	if(!owner)
		return
	if(!isnum(owner.cached_multiplicative_slowdown))
		return
	var/desired = max(0.1, owner.cached_multiplicative_slowdown)
	move_to_delay = desired
	set_varspeed(desired)

// Applies the selection AI mode. Have your illusions act as you please :D
/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/apply_mode(new_mode)
	last_mode = new_mode

	switch(new_mode)
		if(MIRAGE_MODE_STATIONARY)
			stop_automated_movement = TRUE
			toggle_ai(AI_IDLE)
		if(MIRAGE_MODE_AGGRESSIVE)
			stop_automated_movement = FALSE
			retreat_distance = 0
			minimum_distance = 0
			toggle_ai(AI_ON)
		if(MIRAGE_MODE_FLEE)
			stop_automated_movement = FALSE
			retreat_distance = 10
			minimum_distance = 10
			toggle_ai(AI_ON)

/mob/living/simple_animal/hostile/illusion/mirage/resonant/Destroy()
	if(alt_appearance_key)
		remove_alt_appearance(alt_appearance_key)
		alt_appearance_key = null
		UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	UnregisterSignal(src, COMSIG_ATOM_DISPEL)
	action_ref = null
	return ..()

/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/on_mirage_dispel(datum/source, atom/dispeller)
	SIGNAL_HANDLER
	qdel(src)
	return DISPEL_RESULT_DISPELLED

// We need to tell the alt appearance variant to turn.
/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/on_mirage_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	var/image/appearance_image = hud_list?[alt_appearance_key]
	if(appearance_image)
		appearance_image.dir = new_dir

// If you have disbelieved the illusion (immune to mental) you can just walk through them.
/mob/living/simple_animal/hostile/illusion/mirage/resonant/CanAllowThrough(atom/movable/mover, border_dir)
	if(should_ignore_target(mover))
		return TRUE
	return ..()

// We don't aggro our owner,
/mob/living/simple_animal/hostile/illusion/mirage/resonant/CanAttack(atom/the_target)
	if(should_ignore_target(the_target))
		return FALSE
	return ..()

// Basically we check if they're our owner, are affected by mental or are an illusion of the same mob.
/mob/living/simple_animal/hostile/illusion/mirage/resonant/proc/should_ignore_target(atom/target)
	var/datum/action/cooldown/power/psyker/mirage/action = action_ref?.resolve()
	if(!action || !ismob(target) || !isliving(target))
		return FALSE
	var/mob/living/living_target = target
	var/mob/living/owner = action.owner
	if(owner && living_target == owner) // owner
		return TRUE
	if(!action.can_affect_mental(living_target)) // magic immune
		return TRUE
	if(istype(living_target, /mob/living/simple_animal/hostile/illusion)) // ilusion of the same mob
		var/mob/living/simple_animal/hostile/illusion/illusion_target = living_target
		if(illusion_target.parent_mob_ref?.resolve() == owner)
			return TRUE
	return FALSE

// We basically do a fake attack to sell the 'illusion'. We don't want it to actually deal damage, or people will have hissyfit arguments that these are 'harmful' and should be 'illegal'
/mob/living/simple_animal/hostile/illusion/mirage/resonant/AttackingTarget(atom/attacked_target)
	if(!isliving(attacked_target))
		return FALSE

	var/mob/living/living_target = attacked_target
	do_attack_animation(living_target, ATTACK_EFFECT_PUNCH)

	var/verb_continuous = attack_verb_continuous || "attacks"
	var/verb_simple = attack_verb_simple || "attack"

	visible_message(
		span_danger("[src] [verb_continuous] [living_target]!"),
		span_userdanger("[src] [verb_continuous] you!"),
		null,
		COMBAT_MESSAGE_RANGE,
		src
	)
	to_chat(src, span_danger("You [verb_simple] [living_target]!"))

	if(attacked_sound)
		playsound(loc, attacked_sound, 25, TRUE, -1)

	return TRUE


// Alternate appearance for mirage: semi-transparent for owner and mental-immune viewers.
/datum/atom_hud/alternate_appearance/basic/mirage_alpha
	var/datum/weakref/action_ref
	var/datum/weakref/owner_ref
	var/alpha_override = 80

/datum/atom_hud/alternate_appearance/basic/mirage_alpha/New(key, image/appearance_image, datum/action/cooldown/power/psyker/mirage/action, mob/living/owner, options = AA_TARGET_SEE_APPEARANCE)
	action_ref = WEAKREF(action)
	owner_ref = WEAKREF(owner)
	if(appearance_image)
		appearance_image.alpha = alpha_override
		appearance_image.override = TRUE
	. = ..(key, appearance_image, options)

// Who is ALLOWED to see us for who we truly are?
/datum/atom_hud/alternate_appearance/basic/mirage_alpha/mobShouldSee(mob/viewer)
	var/datum/action/cooldown/power/psyker/mirage/action = action_ref?.resolve()
	if(!action || !ismob(viewer) || !isliving(viewer))
		return FALSE
	var/mob/living/owner = owner_ref?.resolve()
	if(owner && viewer == owner)
		return TRUE
	return !action.can_affect_mental(viewer)

#undef MIRAGE_MODE_STATIONARY
#undef MIRAGE_MODE_AGGRESSIVE
#undef MIRAGE_MODE_FLEE
