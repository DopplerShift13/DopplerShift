/*
 Custom action system for supporting the powers system. Use this anytime you add actions to a power.
 Almost all archetypes have their own subtype to handle their own resources and mechanics.
 This one is largely responsible for the actions framework itself.

 Largely modeled after changeling_power.dm
*/
/datum/action/cooldown/power
	name = "abstract power action - ahelp this"
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"
	active_overlay_icon_state = "bg_spell_border_active_red"
	ranged_mousepointer = 'icons/effects/mouse_pointers/weapon_pointer.dmi'
	background_icon = 'modular_doppler/modular_powers/icons/powers/backgrounds.dmi'
	overlay_icon = 'modular_doppler/modular_powers/icons/powers/backgrounds.dmi'

	/// Maximum state of consciousness before the ability is blocked.
	/// For example, `UNCONSCIOUS` prevents it from being used when in hard crit or dead,
	/// while `DEAD` allows the ability to be used on any stat values.
	var/req_stat = CONSCIOUS
	/// If your power has an active state of any type, use this.
	var/active
	/// Does this ability stop working if you are incapacitated?
	var/disabled_by_incapacitate = TRUE
	/// What power is the origin?
	var/datum/power/origin_power
	/// Can only humans use this power?
	var/human_only = TRUE
	/// Can we target ourselves?
	var/target_self = TRUE
	/// Do we need our hands free?
	var/need_hands_free = TRUE
	/// Do we need to be on a turf (not inside something) to use this power?
	var/needs_to_stand_on_turf = TRUE
	/// Bypasses the normal specified cooldown when set to TRUE. Useful if you don't want powers to always go on cooldown.
	var/no_cooldown_on_use

	/// If set, we must wait this long before use_action executes. Cast time basically.
	var/use_time = 0
	/// Flags passed to do_after during use_time (e.g. IGNORE_HELD_ITEM, IGNORE_USER_LOC_CHANGE).
	var/use_time_flags = NONE
	/// Optional overlay to show on the user during use_time.
	var/use_time_overlay_type

	/// Maximum targeting range (in tiles) for click_to_activate powers. Set to 0 or null for no range limit.
	var/target_range
	/// If set, clicked target MUST be of this type (or subtype).
	var/target_type
	/// If aim assist is used for click targeting. Disable to disable.
	var/aim_assist = TRUE
	/// Do we check for anti magic on the target when we target them? Basically if your action targets but doesn't do anything directly magical to them immediately (like projectiles), this should be false.
	var/anti_magic_on_target = TRUE
	/// Extra antimagic types checked on target when the action is used.
	var/magic_resistance_types = NONE

/datum/action/cooldown/power/New(datum/new_origin_power)
	if(istype(new_origin_power, /datum/power))
		origin_power = new_origin_power
	else
		origin_power = null
	sync_magic_resistance_types_from_power()
	return ..()

/// Whether the action is treated as magical for silence and baseline antimagic checks.
/datum/action/cooldown/power/proc/is_magical()
	return !!magic_resistance_types

/// Maps the host power's magic flags into our action's antimagic bitflag.
/datum/action/cooldown/power/proc/sync_magic_resistance_types_from_power()
	// If there is no power directly tied to it e.g meditate
	if(!origin_power)
		magic_resistance_types = NONE
		return magic_resistance_types

	var/power_magic_flags = origin_power?.magic_flags || NONE
	magic_resistance_types = NONE

	if(power_magic_flags & POWER_MAGIC_STANDARD)
		magic_resistance_types |= MAGIC_RESISTANCE
	if(power_magic_flags & POWER_MAGIC_MENTAL)
		magic_resistance_types |= MAGIC_RESISTANCE_MIND
	if(power_magic_flags & POWER_MAGIC_UNHOLY)
		magic_resistance_types |= MAGIC_RESISTANCE_HOLY

	return magic_resistance_types

/// Attempts to actively use the action by pathing through validation, antimagic, do_use_time and finally use_action
/datum/action/cooldown/power/proc/try_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_use(user, target))
		return FALSE
	// Checking for anti-resonance/anti-magic below which really is a pain.
	if(anti_magic_on_target && ismob(target) && target != user) // If the spell checks antimagic, and if the target is a mob, and if the target is not us.
		var/mob/mob_target = target
		if(is_magical() && mob_target.can_block_resonance(1)) // Resonance checks are handled by the owning power's flags.
			// I would like to deduct resources on spell fail, but I have no good way of implementing it during the validation layer when most costs happen in the on_action_success layer. TODO for the future chap who wants this.
			return FALSE
		// Checks against magic resistances beyond the standard above.
		if(is_magical() && magic_resistance_types && mob_target.can_block_magic(magic_resistance_types, charge_cost = 0))
			return FALSE
	if(!do_use_time(user, target))
		return FALSE
	// on_use_action signaler, emitted from the user so listeners can hook once on the mob.
	SEND_SIGNAL(user, COMSIG_POWER_ACTION_USED, src, target)
	if(use_action(user, target))
		// on_action_success signaler, emitted from the user so listeners can hook once on the mob.
		SEND_SIGNAL(user, COMSIG_POWER_ACTION_SUCCESS, src, target)
		on_action_success(user, target)
		return TRUE
	return FALSE

/// Validates the action can be used at all.
/// All validation should exist in here. If your action or path has custom validation, override the proc and add it to can_use()
/datum/action/cooldown/power/proc/can_use(mob/living/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_be_used_by(user)) // Runs can_be_used_by below
		return FALSE
	if(disabled_by_incapacitate && HAS_TRAIT(user, TRAIT_INCAPACITATED))
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	if(is_magical() && HAS_TRAIT(user, TRAIT_RESONANCE_SILENCED))
		owner.balloon_alert(user, "silenced!")
		return FALSE
	if(need_hands_free && HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		owner.balloon_alert(user, "restrained!")
		return FALSE
	if(needs_to_stand_on_turf && !isturf(user.loc))
		owner.balloon_alert(user, "occupied!")
		return FALSE
	if(req_stat < user.stat) // Whilst this seems similiar to trait_incapacitated, it is also used to check if you're dead in the event that disable_by_incapacitate is false. No corpses using powers!
		owner.balloon_alert(user, "incapacitated!")
		return FALSE
	return TRUE

/// Checks if we exist (wow) and are human.
/datum/action/cooldown/power/proc/can_be_used_by(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(QDELETED(user))
		return FALSE
	if(!ishuman(user) && human_only)
		owner.balloon_alert(user, "not a human!")
		return FALSE
	return TRUE

/// This is where ALL THE MAGIC HAPPENS. An action should ALWAYS route through here for its primary mechanics, even if you use multiple different inputs.
/// Make sure you return TRUE or FALSE to tell the power that it has succesfully (or unsuccesfully) been used and trigger on_action_success.
/datum/action/cooldown/power/proc/use_action(mob/living/user, atom/target)
	return TRUE

/// Handles optional channel time before the action goes off, defined by use_time.
/// If use_time_overlay_type is defined, it also puts an overlay on the mob.
/datum/action/cooldown/power/proc/do_use_time(mob/living/user, atom/target)
	if(use_time <= 0)
		return TRUE
	var/atom/use_target = target ? target : user
	var/mutable_appearance/use_overlay
	if(use_time_overlay_type)
		var/atom/overlay_obj = new use_time_overlay_type(null)
		use_overlay = new /mutable_appearance(overlay_obj)
		qdel(overlay_obj)
		user.add_overlay(use_overlay)
	if(click_to_activate && unset_after_click) // unsets the mouse on use time.
		unset_click_ability(user)
	var/success = do_after(user, use_time, target = use_target, timed_action_flags = use_time_flags)
	if(use_overlay && !QDELETED(user))
		user.cut_overlay(use_overlay)
	return success

/// Anything that should happen as a result of use_action returning TRUE.
/// Cost systems for archetypes to name an example.
/datum/action/cooldown/power/proc/on_action_success(mob/living/user, atom/target)
	return

/// Applies damage to a living target, automatically applying an armor check.
/// Returns the amount of damage dealt (as per apply_damage).
/datum/action/cooldown/power/proc/apply_damage_with_armor(mob/living/target, damage, damage_type = BRUTE, attack_flag = MELEE, def_zone = null, armour_penetration = 0,	weak_against_armour = FALSE, silent = TRUE)
	if(!target)
		return 0

	var/armor_block = target.run_armor_check(
		def_zone = def_zone,
		attack_flag = attack_flag,
		armour_penetration = armour_penetration,
		weak_against_armour = weak_against_armour,
		silent = silent,
	)
	return target.apply_damage(damage, damage_type, def_zone, armor_block)

/**
 * Actions run through the following pipeline:
 * Trigger() -> PreActivate(owner) -> Activate(owner) -> try_use(user, target)
 * Click-activated powers DO NOT route through this; they use InterceptClickOn below.
 */
/datum/action/cooldown/power/Activate(atom/target)
	var/mob/living/user = owner
	if(!user)
		return FALSE

	// Non-targeted powers just use immediately.
	if(!try_use(user, target = null))
		return FALSE

	// Support for bypassing cooldowns on use.
	if(!no_cooldown_on_use)
		StartCooldown()

	return TRUE

/** Intercepts client owner clicks to activate the ability.
 * Called by the base click intercept system on left click.
 * Whilst /datum/action/cooldown does have click support, it doesn't support range-detecting and target filtering, so we are overriding that with our own.
 * Returning only tells the game if we consume the normal click behavior (if true) or not (if false)
 */
/datum/action/cooldown/power/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!IsAvailable(feedback = TRUE))
		return FALSE
	if(!target)
		return FALSE
	if(aim_assist)
		var/atom/aim_assist_target = aim_assist(clicker, target, target_type)
		if(aim_assist_target)
			target = aim_assist_target

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
		// fixes the overlay from cast time getting stuck.
		if(clicker?.click_intercept == src && unset_after_click)
			unset_click_ability(clicker, refund_cooldown = TRUE)
		return FALSE
	StartCooldown()

	// Successful click.
	if(unset_after_click)
		unset_click_ability(clicker, refund_cooldown = FALSE)

	clicker.next_click = world.time + click_cd_override
	return TRUE

/// Optional aim assist for click targeting. Override for custom behavior.
/datum/action/cooldown/power/proc/aim_assist(mob/living/clicker, atom/target, target_type_path)
	if(!isturf(target) && !istype(target_type, /turf)) // only auto aims if you click turfs; or if the auto-aim type is a turf.
		return

	// If we have a specific type we're targeting, we're targeting that instead.
	if(target_type_path)
		return locate(target_type_path) in target

	// Otherwise, find any human, or if that fails, any living target
	return locate(/mob/living/carbon/human) in target || locate(/mob/living) in target

// We override the click abilities to fix an issue with the active_overlay_icon_state not appearing when it should.
/datum/action/cooldown/power/set_click_ability(mob/on_who)
	. = ..()
	if(.)
		build_all_button_icons(UPDATE_BUTTON_STATUS | UPDATE_BUTTON_OVERLAY)
	return .

/datum/action/cooldown/power/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(.)
		for(var/datum/action/A as anything in on_who.actions)
			for(var/datum/hud/H as anything in A.viewers)
				var/atom/movable/screen/movable/action_button/B = A.viewers[H]
				if(B)
					B.cut_overlay(B.button_overlay)
					B.button_overlay = null
					B.active_overlay_icon_state = null
		on_who.update_mob_action_buttons(UPDATE_BUTTON_OVERLAY, TRUE)
	return .

/*
Projectile action code down below
*/

/// Fires the configured or given projectile at the clicked target.
/// This assumes you are shooting just one projectile. Override if you need multi-shot, spread, special spawn logic, etc.
/// Requires click_to_activate = TRUE to do mouse based targeting.
/datum/action/cooldown/power/proc/fire_projectile(mob/living/user, atom/target,	obj/projectile/projectile)
	SHOULD_CALL_PARENT(TRUE)

	var/projectile_path = projectile
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

/// Sets up a projectile for firing.
/// Mirrors cooldown/spell/pointed/projectile
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
		resonant_proj.snapshot_power_state(src)
		resonant_proj.antimagic_flags = magic_resistance_types

	// If you want “on hit” logic for your power, hook it here.
	RegisterSignal(projectile_instance, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_power_projectile_hit))

/// Signal handler for projectile hits; relays into an overridable proc.
/datum/action/cooldown/power/proc/on_power_projectile_hit(datum/source, mob/firer, atom/target, angle, hit_limb)
	SIGNAL_HANDLER

	on_projectile_hit(source, firer, target, angle, hit_limb)

// Override in specific powers if you want “on hit” effects that connect back to the spell, e.g some-sort of ongoing effect.
/// Anything that should otherwise happen normally on projectile hit should preferably be handled in /obj/projectile/.../on_hit
/datum/action/cooldown/power/proc/on_projectile_hit(datum/source, mob/firer, atom/target, angle, hit_limb)
	return
