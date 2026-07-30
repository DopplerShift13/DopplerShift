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

	/// Active mirage instances
	var/list/active_mirages = list()
	/// Mirage behavior mode
	var/mode = MIRAGE_MODE_STATIONARY
	/// Stress cost
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
	var/mob/living/basic/resonant_mirage/new_mirage = new(spawn_turf)
	new_mirage.Copy_Parent(owner, 20 SECONDS)
	new_mirage.set_action_ref(src)
	new_mirage.apply_mode(mode)
	active_mirages += new_mirage

	// Causes it to act immediately.
	new_mirage.taunt_nearest_hostile(5)
	new_mirage.wake_ai()

	modify_stress(stress_cost)
	playsound(new_mirage, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	return TRUE

/// Changes behavior of the spawned illusion.
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
	for(var/mob/living/basic/resonant_mirage/mirage as anything in active_mirages)
		if(!QDELETED(mirage))
			qdel(mirage)
	active_mirages.Cut()

/// Removes all active mirages.
/datum/action/cooldown/power/psyker/mirage/proc/cleanup_mirages()
	for(var/mob/living/basic/resonant_mirage/mirage as anything in active_mirages.Copy())
		if(QDELETED(mirage))
			active_mirages -= mirage


/*
	Mirage mob: basic mob used for aggro, but with per-viewer masking.
*/
/mob/living/basic/resonant_mirage
	name = "illusion"
	desc = "It's a fake!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	icon_living = "static"
	icon_dead = "null"
	mob_biotypes = NONE
	faction = list(FACTION_ILLUSION)
	basic_mob_flags = DEL_ON_DEATH
	death_message = "vanishes into thin air! It was a fake!"

	health = 1
	maxHealth = 1
	environment_smash = ENVIRONMENT_SMASH_NONE

	/// Weakref to what we're copying
	var/datum/weakref/parent_mob_ref
	/// Weakref to the power action
	var/datum/weakref/action_ref
	/// the mode that was used to summon this creature
	var/last_mode = MIRAGE_MODE_STATIONARY
	/// ref for the alt apperance
	var/alt_appearance_key

/// Copies stats from the parent entity that summoned it, if any.
/mob/living/basic/resonant_mirage/proc/Copy_Parent(mob/living/original, life = 5 SECONDS)
	appearance = original.appearance
	gender = original.gender
	parent_mob_ref = WEAKREF(original)
	setDir(original.dir)
	transform = initial(transform)
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, death)), life)

/mob/living/basic/resonant_mirage/examine(mob/user)
	var/mob/living/parent_mob = parent_mob_ref?.resolve()
	if(parent_mob)
		return parent_mob.examine(user)
	return ..()

/// imposes the caster onto the mob
/mob/living/basic/resonant_mirage/proc/set_action_ref(datum/action/cooldown/power/psyker/mirage/action)
	action_ref = WEAKREF(action)
	if(!alt_appearance_key)
		alt_appearance_key = "mirage_alpha_[REF(src)]"
		var/image/appearance_image = image(loc = src)
		appearance_image.appearance = appearance
		appearance_image.dir = dir
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/mirage_alpha, alt_appearance_key, appearance_image, action, action?.owner)
		RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mirage_dir_change))
	RegisterSignal(src, COMSIG_ATOM_DISPEL, PROC_REF(on_mirage_dispel))

/// Draw a nearby hostile's aggro to sell the illusion.
/mob/living/basic/resonant_mirage/proc/taunt_nearest_hostile(range_limit = 5)
	var/datum/action/cooldown/power/psyker/mirage/action = action_ref?.resolve()
	var/mob/living/nearest_mob
	var/nearest_dist

	// Validation, cause taunting mobs is COMPLICATED
	for(var/mob/living/living_mob in range(range_limit, src))
		if(living_mob == src || QDELETED(living_mob)) // no self taunting
			continue
		if(istype(living_mob, /mob/living/simple_animal/hostile/illusion) || istype(living_mob, /mob/living/basic/resonant_mirage)) // no taunting other illusions
			continue
		if(living_mob.mind) // no sentient taunting
			continue
		if(!islist(living_mob.faction) || (!(FACTION_HOSTILE in living_mob.faction) && !(FACTION_MINING in living_mob.faction))) // has to be in the hostile mob faction or the mining faction
			continue
		if(FACTION_BOSS in living_mob.faction) // "There is no aggro reset. (...) There is some shit about an aggro reset when people don't know how to manage their aggro."
			continue
		if(action && !action.can_affect_mental(living_mob)) // can't be immune to mental shit
			continue
		if(!istype(living_mob, /mob/living/simple_animal/hostile) && !living_mob.ai_controller) // either a hostile mob or has to have an ai controler
			continue
		var/distance = get_dist(src, living_mob)
		if(isnull(nearest_dist) || distance < nearest_dist) // get the nearest mob in range
			nearest_mob = living_mob
			nearest_dist = distance

	if(nearest_mob)
		if(istype(nearest_mob, /mob/living/simple_animal/hostile)) // hostile mobs forced target
			var/mob/living/simple_animal/hostile/hostile_mob = nearest_mob
			hostile_mob.GiveTarget(src)
		else if(nearest_mob.ai_controller) // otherwise we just force the blackboard to use a different target.
			nearest_mob.ai_controller.CancelActions()
			nearest_mob.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			nearest_mob.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, src)
			nearest_mob.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, src)

/// Applies the selection AI mode. Have your illusions act as you please :D
/mob/living/basic/resonant_mirage/proc/apply_mode(new_mode)
	last_mode = new_mode

	switch(new_mode)
		if(MIRAGE_MODE_STATIONARY)
			set_ai_controller_type(null)
		if(MIRAGE_MODE_AGGRESSIVE)
			set_ai_controller_type(/datum/ai_controller/basic_controller/simple/simple_hostile)
		if(MIRAGE_MODE_FLEE)
			set_ai_controller_type(/datum/ai_controller/basic_controller/simple/simple_fearful)

/// Sets the behavior type on the AI.
/mob/living/basic/resonant_mirage/proc/set_ai_controller_type(controller_type)
	if(isnull(controller_type))
		QDEL_NULL(ai_controller)
		return
	if(istype(ai_controller, controller_type))
		ai_controller.reset_ai_status()
		ai_controller.set_blackboard_key(BB_TARGETING_STRATEGY, /datum/targeting_strategy/basic/mirage)
		return
	QDEL_NULL(ai_controller)
	ai_controller = new controller_type(src)
	ai_controller.set_blackboard_key(BB_TARGETING_STRATEGY, /datum/targeting_strategy/basic/mirage)

/// 'Waking it up'. When this was a simple animal this wasn't as big of a problem, but /basic/ mobs are just more sluggish and with mirrages being meant to divert aggro, we want them reacting asap.
/mob/living/basic/resonant_mirage/proc/wake_ai()
	if(!ai_controller)
		return
	ai_controller.set_ai_status(AI_STATUS_ON)
	ai_controller.SelectBehaviors(0.1)
	for(var/datum/ai_behavior/current_behavior as anything in ai_controller.current_behaviors)
		ai_controller.ProcessBehavior(0.1, current_behavior)

/mob/living/basic/resonant_mirage/Destroy()
	if(alt_appearance_key)
		remove_alt_appearance(alt_appearance_key)
		alt_appearance_key = null
		UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	UnregisterSignal(src, COMSIG_ATOM_DISPEL)
	action_ref = null
	return ..()

/// On dispel, poofs the mirrage.
/mob/living/basic/resonant_mirage/proc/on_mirage_dispel(datum/source, atom/dispeller)
	SIGNAL_HANDLER
	qdel(src)
	return DISPEL_RESULT_DISPELLED

/// We need to tell the alt appearance variant to turn.
/mob/living/basic/resonant_mirage/proc/on_mirage_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	var/image/appearance_image = hud_list?[alt_appearance_key]
	if(appearance_image)
		appearance_image.dir = new_dir

/// If you have disbelieved the illusion (immune to mental) you can just walk through them.
/mob/living/basic/resonant_mirage/CanAllowThrough(atom/movable/mover, border_dir)
	if(should_ignore_target(mover))
		return TRUE
	return ..()

/// Basically we check if they're our owner, are affected by mental or are an illusion of the same mob.
/mob/living/basic/resonant_mirage/proc/should_ignore_target(atom/target)
	var/datum/action/cooldown/power/psyker/mirage/action = action_ref?.resolve()
	if(!action || !ismob(target) || !isliving(target))
		return FALSE
	var/mob/living/living_target = target
	var/mob/living/owner = action.owner
	if(owner && living_target == owner) // owner
		return TRUE
	if(!action.can_affect_mental(living_target)) // magic immune
		return TRUE
	if(istype(living_target, /mob/living/basic/resonant_mirage))
		var/mob/living/basic/resonant_mirage/illusion_target = living_target
		if(illusion_target.parent_mob_ref?.resolve() == owner)
			return TRUE
	return FALSE

/// We basically do a fake attack to sell the 'illusion'. We don't want it to actually deal damage, or people will have hissyfit arguments that these are 'harmful' and should be 'illegal'
/mob/living/basic/resonant_mirage/melee_attack(atom/target, list/modifiers, ignore_cooldown = FALSE)
	if(!isliving(target))
		return FALSE
	if(should_ignore_target(target))
		return FALSE
	if(!early_melee_attack(target, modifiers, ignore_cooldown))
		return FALSE

	var/mob/living/living_target = target
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

	SEND_SIGNAL(src, COMSIG_HOSTILE_POST_ATTACKINGTARGET, target, TRUE)
	return TRUE

/// Targeting strategy: never pick targets the mirage should ignore.
/datum/targeting_strategy/basic/mirage/can_attack(mob/living/living_mob, atom/target, vision_range)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(living_mob, /mob/living/basic/resonant_mirage))
		return .
	var/mob/living/basic/resonant_mirage/mirage = living_mob
	if(mirage.should_ignore_target(target))
		return FALSE
	return TRUE


/// Alternate appearance for mirage: semi-transparent for owner and mental-immune viewers.
/datum/atom_hud/alternate_appearance/basic/mirage_alpha
	/// Reference to the power action
	var/datum/weakref/action_ref
	/// Reference to the power action owner
	var/datum/weakref/owner_ref
	/// Alpha percentage on the mob alt appearance
	var/alpha_override = 80

/datum/atom_hud/alternate_appearance/basic/mirage_alpha/New(key, image/appearance_image, datum/action/cooldown/power/psyker/mirage/action, mob/living/owner, options = AA_TARGET_SEE_APPEARANCE)
	action_ref = WEAKREF(action)
	owner_ref = WEAKREF(owner)
	if(appearance_image)
		appearance_image.alpha = alpha_override
		appearance_image.override = TRUE
	. = ..(key, appearance_image, options)

/// Who is ALLOWED to see us for who we truly are?
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
