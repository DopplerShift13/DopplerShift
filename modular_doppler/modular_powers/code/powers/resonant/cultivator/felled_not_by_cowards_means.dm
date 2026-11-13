/*
	More protection against projectile armor types, in exchange for noguns.
*/
/datum/power/cultivator/felled_not_by_cowards_means
	name = "Felled Not By Coward's Means"
	desc = "Your alignment makes you particularly resilient against projectiles. You gain +2 to bullet, energy, and laser armor granted by your alignment. \
	\nYou also negate any projectile-damage that would put you in critical health: this damage is instead dealt to your energy (without any damage modifiers) at 1.5x the rate. \
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
	var/projectile_block_energy_multiplier = 1.5
	/// The holder's alignment action, used to check its active state and consume its Energy.
	var/datum/action/cooldown/power/cultivator/alignment/alignment_power

/datum/power/cultivator/felled_not_by_cowards_means/add(client/client_source)
	. = ..()
	if(isnull(power_holder))
		return
	RegisterSignal(power_holder, COMSIG_CULTIVATOR_MODIFY_ALIGNMENT_ARMOR, PROC_REF(modify_alignment_armor))
	RegisterSignal(power_holder, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(block_critical_projectile))
	RegisterSignals(power_holder, list(COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED), PROC_REF(on_power_list_changed))

/datum/power/cultivator/felled_not_by_cowards_means/post_add()
	. = ..()
	cache_alignment_power()
	refresh_alignment_armor()

/datum/power/cultivator/felled_not_by_cowards_means/remove()
	if(power_holder)
		UnregisterSignal(power_holder, list(COMSIG_CULTIVATOR_MODIFY_ALIGNMENT_ARMOR, COMSIG_ATOM_PRE_BULLET_ACT, COMSIG_MOB_POWER_ADDED, COMSIG_MOB_POWER_REMOVED))
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
	if(!alignment_power?.active)
		return NONE
	if(projectile_hit.damage_type == STAMINA)
		return NONE

	if(projectile_hit.damage < blocking_user.health)
		return NONE

	alignment_power.adjust_energy(-(projectile_hit.damage * projectile_block_energy_multiplier))
	play_critical_projectile_block_effect(blocking_user, projectile_hit, alignment_power)
	return COMPONENT_BULLET_BLOCKED

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

/// Updates the alignment armor on a mob.
/datum/power/cultivator/felled_not_by_cowards_means/proc/refresh_alignment_armor()
	if(alignment_power?.active)
		alignment_power.recompute_alignment_armor(power_holder)

/// Checks if something happened to root powers, and if so re-check which alignment we're registered to.
/datum/power/cultivator/felled_not_by_cowards_means/proc/on_power_list_changed(mob/living/source, datum/power/changed_power)
	SIGNAL_HANDLER
	if(!istype(changed_power, /datum/power/cultivator_root))
		return
	cache_alignment_power()
	refresh_alignment_armor()

/// Stores the cultivator root belonging to the power holder by just grabbing the first one we find.
/datum/power/cultivator/felled_not_by_cowards_means/proc/cache_alignment_power()
	alignment_power = null
	for(var/datum/action/cooldown/power/cultivator/alignment/alignment_action in power_holder.actions)
		alignment_power = alignment_action
		return
