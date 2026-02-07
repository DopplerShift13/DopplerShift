/*
 Custom action system for supporting the powers system. Use this anytime you add actions to a power.
 Almost all archetypes have their own subtype to handle their own resources and mechanics.
 This one is largely responsible for the actions framework itself.

 Largely modeled after changeling_power.dm
*/
/datum/action/cooldown/power
	name = "abstract power action - ahelp this"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'
	active_overlay_icon_state = "bg_spell_border_active_red"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

	/// Maximum state of consciousness before the ability is blocked.
	/// For example, `UNCONSCIOUS` prevents it from being used when in hard crit or dead,
	/// while `DEAD` allows the ability to be used on any stat values.
	var/req_stat = CONSCIOUS
	/// If your power has an active state of any type, use this.
	var/active
	/// Is this a resonant ability (read: magical)? Determines if this ability stop working if you are silenced and if we check against target magic immunites.
	var/resonant = TRUE
	/// Does this ability stop working if you are incapacitated?
	var/disabled_by_incapacitate = TRUE
	/// What power is the origin?
	var/origin_power
	/// Can only humans use this power?
	var/human_only = TRUE
	/// Can we target ourselves?
	var/target_self = TRUE
	// Do we need our hands free?
	var/need_hands_free = TRUE

	/// Maximum targeting range (in tiles) for click_to_activate powers. Set to 0 or null for no range limit.
	var/target_range
	/// If set, clicked target MUST be of this type (or subtype).
	var/target_type

	/// Imitates the effects of action/cooldown/spell/pointed/projectile if set to a projectile by shooting the listed projectile towards the target space. Useful for actions that just shoot stuff without too much nuance.
	/// If used with click_to_activate, it will shoot towards the targeted space. Otherwise, it shoots directly forwards.
	var/obj/projectile/projectile_type

// When you press the button
// Attempts to actively use the action
/datum/action/cooldown/power/proc/try_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_use(user, target))
		return FALSE
	// Checking for anti-resonance/anti-magic below which really is a pain.
	if(!projectile_type && resonant && ismob(target) && target != user) // If it is not a projectile spell, and if the spell is resonance based, and if the target is a mob, and if the target is not us.
		var/mob/mob_target = target
		if(mob_target.can_block_resonance(1)) // Runs the special can_block_resonance function which also handles the anti-magic part.
			// I would like to deduct resources on spell fail, but that is going to be so utterly complex. TODO for the future chap who wants this.
			return FALSE
	if(use_action(user, target))
		on_action_success()
		return TRUE
	return FALSE

// Validates the action can be used.
/datum/action/cooldown/power/proc/can_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_be_used_by(user)) // Runs can_be_used_by below
		return FALSE
	if(disabled_by_incapacitate && HAS_TRAIT(user, TRAIT_INCAPACITATED))
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	if(resonant && HAS_TRAIT(user, TRAIT_RESONANCE_SILENCED))
		owner.balloon_alert(user, "silenced!")
		return FALSE
	if(need_hands_free && HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		owner.balloon_alert(user, "restrained!")
		return FALSE
	if(req_stat < user.stat) // Whilst this seems similiar to trait_incapacitated, it is also used to check if you're dead in the event that disable_by_incapacitate is false. No corpses using powers!
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	return TRUE

// Checks if we exist (wow) and are human.
/datum/action/cooldown/power/proc/can_be_used_by(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(QDELETED(user))
		return FALSE
	if(!ishuman(user) && human_only)
		return FALSE
	return TRUE

// Now we do THINGS!
// Make sure you return TRUE or FALSE to tell the power that it has succesfully (or unsuccesfully) been used and trigger on_action_success.
/datum/action/cooldown/power/proc/use_action(mob/living/user, atom/target)
	// Most spells won't use this so they are free to override this, but projectile spells use this step to actually fire ze misiles.
	if(projectile_type)
		return fire_projectile(user, target)

	return TRUE

// Anything that should happen as a result of use_action returning TRUE.
// Cost systems for archetypes to name an example.
/datum/action/cooldown/power/proc/on_action_success(mob/living/user, atom/target)
	return
/*
Handles all the logic involved in using a targeted, click-based action.
- First press: enables click intercept (targeting mode)
- Second press (while already active): disables click intercept
- While active: a left click calls InterceptClickOn() and passes the clicked atom as target
*/

/**
 * Non-click_to_activate actions run through the cooldown framework:
 * Trigger() -> PreActivate(owner) -> Activate(owner)
 */
/datum/action/cooldown/power/Activate(atom/target)
	var/mob/living/user = owner
	if(!user)
		return FALSE

	// Non-targeted powers just use immediately.
	if(!try_use(user, target = null))
		return FALSE

	StartCooldown()
	return TRUE

// Intercepts client owner clicks to activate the ability.
// Called by the base click intercept system on left click.
// Whilst /datum/action/cooldown does have click support, it doesn't support range-detecting and target filtering, so we are overriding that with our own.
/datum/action/cooldown/power/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!IsAvailable(feedback = TRUE))
		return FALSE
	if(!target)
		return FALSE

	// Checks if we are allowed to actually target that type.
	if(target_type && !istype(target, target_type))
		return FALSE

	// Check if we are allowed to target ourselves.
	if(!target_self && target == clicker)
		owner.balloon_alert(clicker, "Can't target self!")
		return FALSE

	// Range gate (only applies if target_range is non-zero).
	if(target_range)
		var/turf/clicker_turf = get_turf(clicker)
		var/turf/target_turf = get_turf(target)
		if(clicker_turf && target_turf && get_dist(clicker_turf, target_turf) > target_range)
			owner.balloon_alert(clicker, "Out of range!")
			return FALSE

	// If the power can't be used, refuse the click and keep intercept state as-is.
	if(!try_use(clicker, target))
		return FALSE

	StartCooldown()

	// Successful click.
	if(unset_after_click)
		unset_click_ability(clicker, refund_cooldown = FALSE)

	clicker.next_click = world.time + click_cd_override
	return TRUE

/*
Projectile action code down below
*/

// Fires the configured or given projectile at the clicked target.
// This assumes you are shooting just one projectile. Override if you need multi-shot, spread, special spawn logic, etc.
/datum/action/cooldown/power/proc/fire_projectile(mob/living/user, atom/target,	obj/projectile/projectile_override)
	SHOULD_CALL_PARENT(TRUE)

	// We allow for projectile_override in the event that you want to call fire_projectile outside of its standard use.
	var/projectile_path = projectile_override ? projectile_override : projectile_type
	if(!projectile_path || !user || !target)
		return FALSE

	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE

	// If no clicked target was provided (non-click cast), shoot forward.
	if(!target)
		var/turf/aim_turf = user_turf
		var/aim_range = target_range ? target_range : 7

		for(var/step_count in 1 to aim_range)
			var/turf/next_turf = get_step(aim_turf, user.dir)
			if(!next_turf)
				break
			aim_turf = next_turf

		target = aim_turf

	// Still validate after we possibly auto-filled target
	if(!target)
		return FALSE

	var/obj/projectile/projectile_instance = new projectile_path(user_turf)
	ready_projectile(projectile_instance, target, user)

	projectile_instance.fire()
	return TRUE

// Sets up a projectile for firing.
// Mirrors cooldown/spell/pointed/projectile
/datum/action/cooldown/power/proc/ready_projectile(obj/projectile/projectile_instance, atom/target, mob/living/user)
	SHOULD_CALL_PARENT(TRUE)

	if(!projectile_instance)
		return

	projectile_instance.firer = user
	projectile_instance.fired_from = src
	projectile_instance.aim_projectile(target, user)

	// Saves an instance of the creating power for reference. Usually you want this to check for affinity scaling on Thaumaturge.
	// This only works on resonant projectiles. If you have a non-resonant projectile that needs this for some reason, override the proc.
	if(istype(projectile_instance, /obj/projectile/resonant))
		var/obj/projectile/resonant/resonant_proj = projectile_instance
		resonant_proj.creating_power = src

	// If you want “on hit” logic for your power, hook it here.
	RegisterSignal(projectile_instance, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_power_projectile_hit))

// Signal handler for projectile hits; relays into an overridable proc.
/datum/action/cooldown/power/proc/on_power_projectile_hit(datum/source, mob/firer, atom/target, angle, hit_limb)
	SIGNAL_HANDLER

	on_projectile_hit(source, firer, target, angle, hit_limb)

// Override in specific powers if you want “on hit” effects that connect back to the spell, e.g some-sort of ongoing effect.
// Anything that should otherwise happen normally on projectile hit should preferably be handled in /obj/projectile/.../on_hit
/datum/action/cooldown/power/proc/on_projectile_hit(datum/source, mob/firer, atom/target, angle, hit_limb)
	return
