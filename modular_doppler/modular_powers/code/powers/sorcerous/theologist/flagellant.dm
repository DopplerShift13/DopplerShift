/// Grants Piety based on getting smacked.
/datum/power/theologist/flagellant
	name = "Flagellant Piety"
	desc = "You suffer so others may live. You gain Piety from being hurt by creatures. The damage taken must be directly caused by a creature; some indirect methods of damaging you such as throwing explosives or using area-of-effect magics may not grant piety.\
	\nThe Piety gained is based on the pre-mitigation damage (block, armor etc): if the source is yourself, it is instead based on the total damage you took."
	security_record_text = "Subject fuels their powers by being hurt by others."
	value = 4
	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	/// Reference to the holder's piety component.
	var/datum/component/theologist_piety/piety_component
	/// Total damage needed to gain 1 piety.
	var/damage_per_piety = 15
	/// Cap on how much piety can be reached. I originally designed this as a balancing factor but being smacked by someone else is kinda balanced already.
	var/piety_cap = 100

/datum/power/theologist/flagellant/post_add(client/client_source)
	..()
	get_piety_component()
	RegisterSignal(power_holder, COMSIG_LIVING_SUCCESSFUL_BLOCK, PROC_REF(on_successful_block))
	RegisterSignal(power_holder, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_apply_damage))

/datum/power/theologist/flagellant/remove()
	UnregisterSignal(power_holder, list(COMSIG_LIVING_SUCCESSFUL_BLOCK, COMSIG_MOB_APPLY_DAMAGE))

/// Attempts to acquire the piety component.
/datum/power/theologist/flagellant/proc/get_piety_component()
	piety_component = power_holder.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return FALSE
	return TRUE

/// Main damage hook. Estimates base damage from blocked% and grants piety.
/datum/power/theologist/flagellant/proc/on_apply_damage(datum/source, damage, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, ...)
	SIGNAL_HANDLER
	if(!piety_component && !get_piety_component()) // fix piety component if it isnt there
		return
	if(piety_component.piety >= piety_cap) // if piety exceeds 20
		return
	if(!isnum(damage) || damage <= 0 || damage_per_piety <= 0) // don't run on 0 damage and prevents divide-by-zero scenarios.
		return
	if(!is_valid_attack_source(attacking_item)) // is the damage sourced from a mob?
		return

	var/mob/living/attack_source = get_attack_source_mob(attacking_item)
	// Anti-cheese: if you are your own damage source, use post-mitigation damage. Otherwise, use pre-mitigation damage.
	var/base_damage = (attack_source == power_holder) ? damage : estimate_unmitigated_from_blocked(damage, blocked)
	if(base_damage <= 0) // what? how? better to protect against dividing by 0
		return

	piety_component.adjust_piety(base_damage / damage_per_piety)

/// Checks if we are able to succesfuly determine a mob source.
/datum/power/theologist/flagellant/proc/is_valid_attack_source(atom/hit_by)
	return !isnull(get_attack_source_mob(hit_by))

/// Resolves a mob source from mob/projectile/item damage sources.
/datum/power/theologist/flagellant/proc/get_attack_source_mob(atom/hit_by)
	if(ismob(hit_by))
		return hit_by
	if(istype(hit_by, /obj/projectile))
		var/obj/projectile/projectile = hit_by
		if(ismob(projectile.firer))
			return projectile.firer
		return null
	if(istype(hit_by, /obj/item))
		var/obj/item/item = hit_by
		if(ismob(item.loc))
			return item.loc
	return null

/// Maths out the unmitigated damage based on the blocked damage.
/datum/power/theologist/flagellant/proc/estimate_unmitigated_from_blocked(damage, blocked)
	if(!isnum(blocked))
		return damage
	var/block_multiplier = (100 - blocked) / 100
	if(block_multiplier <= 0)
		return damage
	return damage / block_multiplier

/// Successful block hook, emitted from /mob/living/proc/check_block().
/// We maths out the damage on a succesful block as well since this is one of the few ways to do full mitigation.
/datum/power/theologist/flagellant/proc/on_successful_block(datum/source, atom/hit_by, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER
	if(!piety_component && !get_piety_component()) // fix piety component if it isnt there
		return
	if(piety_component.piety >= piety_cap) // if piety exceeds cap
		return
	if(!isnum(damage) || damage <= 0 || damage_per_piety <= 0) // don't run on 0 damage and prevents divide-by-zero scenarios.
		return
	if(!is_valid_attack_source(hit_by)) // is the damage sourced from a mob?
		return
	if(get_attack_source_mob(hit_by) == power_holder) // self-sourced full block uses post-mitigation (0), so no gain.
		return

	piety_component.adjust_piety(damage / damage_per_piety)
