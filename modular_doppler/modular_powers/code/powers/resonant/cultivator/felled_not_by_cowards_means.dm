/*
	More protection against projectile armor types, in exchange for noguns.
*/
/datum/power/cultivator/felled_not_by_cowards_means
	name = "Felled Not By Coward's Means"
	desc = "Your alignment makes you particularly resilient against projectiles. You gain +2 to bullet, energy and laser armour granted by your alignment. \
	\nYou also negate any projectile-damage that would put you in critical health: this damage is instead dealt to your energy (without any damage modifiers). \
	\nYou cannot use firearms in alignment."
	security_record_text = "Subject is extra resistant in alignment to firearms, but cannot wield them in that state."
	security_threat = POWER_THREAT_MAJOR
	mob_trait = TRAIT_NOGUNS
	value = 2

	required_powers = list(/datum/power/cultivator_root)
	required_allow_subtypes = TRUE

	menu_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	menu_icon_state = "culti_gun_resist"

	/// Additional armor rating supplied to active alignment targets against projectile damage. One armor tier equals 10 rating.
	var/projectile_armor_bonus = 20
	/// Energy drained when an otherwise critical projectile is negated, per point of its base damage.
	var/projectile_block_energy_multiplier = 1

/datum/power/cultivator/felled_not_by_cowards_means/add(client/client_source)
	. = ..()
	if(!power_holder)
		return
	RegisterSignal(power_holder, COMSIG_CULTIVATOR_MODIFY_ALIGNMENT_ARMOR, PROC_REF(modify_alignment_armor))
	RegisterSignal(power_holder, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(block_critical_projectile))
	refresh_alignment_armor()

/datum/power/cultivator/felled_not_by_cowards_means/remove()
	if(power_holder)
		UnregisterSignal(power_holder, list(COMSIG_CULTIVATOR_MODIFY_ALIGNMENT_ARMOR, COMSIG_ATOM_PRE_BULLET_ACT))
		refresh_alignment_armor()
	. = ..()

/// Raises alignment armor targets before their difference from the user's worn armor is calculated.
/datum/power/cultivator/felled_not_by_cowards_means/proc/modify_alignment_armor(datum/source, datum/action/cooldown/power/cultivator/alignment/alignment_action, list/armor_values)
	SIGNAL_HANDLER
	armor_values[BULLET] += projectile_armor_bonus
	armor_values[ENERGY] += projectile_armor_bonus
	armor_values[LASER] += projectile_armor_bonus

/// Prevents projectiles from literally felling us: any projectile whose base damage would put us into crit is negated.
/// Base damage is intentionally used here because this signal fires before armor and other modifiers (e.g species modifiers) are applied.
/datum/power/cultivator/felled_not_by_cowards_means/proc/block_critical_projectile(mob/living/blocking_user, obj/projectile/projectile_hit, def_zone, piercing_hit)
	SIGNAL_HANDLER
	if(!isnum(projectile_hit.damage) || projectile_hit.damage <= 0)
		return NONE

	var/datum/action/cooldown/power/cultivator/alignment/active_alignment = get_active_alignment()
	if(!active_alignment)
		return NONE
	if(projectile_hit.damage_type == STAMINA)
		return NONE

	if(projectile_hit.damage < blocking_user.health)
		return NONE

	active_alignment.adjust_energy(-(projectile_hit.damage * projectile_block_energy_multiplier))
	play_critical_projectile_block_effect(blocking_user, projectile_hit, active_alignment)
	return COMPONENT_BULLET_BLOCKED

/// Returns the currently active alignment, if any.
/datum/power/cultivator/felled_not_by_cowards_means/proc/get_active_alignment()
	for(var/datum/action/cooldown/power/cultivator/alignment/alignment_action in power_holder.actions)
		if(alignment_action.active)
			return alignment_action
	return null

/// Displays feedback when the critical projectile hit is negated.
/datum/power/cultivator/felled_not_by_cowards_means/proc/play_critical_projectile_block_effect(mob/living/blocking_user, obj/projectile/projectile_hit, datum/action/cooldown/power/cultivator/alignment/active_alignment)
	blocking_user.visible_message(
		span_danger("[projectile_hit] bounces harmlessly off of [blocking_user]!"),
		span_userdanger("[projectile_hit] bounces harmlessly off of you!"),
	)
	var/mutable_appearance/phase_overlay = mutable_appearance('icons/effects/effects.dmi', "phasein")
	phase_overlay.color = active_alignment.alignment_outline_color
	phase_overlay.pixel_x = rand(-8, 8)
	phase_overlay.pixel_y = rand(-8, 8)
	blocking_user.flick_overlay_view(phase_overlay, 1 SECONDS)
	playsound(blocking_user, 'sound/effects/parry.ogg', 50, TRUE)

/// Applies a changed power selection immediately when an alignment is already active.
/datum/power/cultivator/felled_not_by_cowards_means/proc/refresh_alignment_armor()
	for(var/datum/action/cooldown/power/cultivator/alignment/alignment_action in power_holder.actions)
		if(alignment_action.active)
			alignment_action.recompute_alignment_armor(power_holder)
