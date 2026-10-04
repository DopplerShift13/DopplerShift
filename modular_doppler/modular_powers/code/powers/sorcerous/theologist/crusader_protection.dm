/*
	Lucky/advantage mechanics for Divine Protection if its against projectile, but forefit your right to guns.
	SOME DAY LOVE WILL FIND YOU
*/

/datum/power/theologist/crusader_protection
	name = "Warrior Crusader"
	desc = "You believe in the virtue of fighting up close and personal in fair combat. Your Divine Protection gains +1% base block chance per Piety when blocking projectiles, up to +50%.\
	\nYou can no longer wield firearms, as they conflict with this belief. Even shotguns, as close and personal as they may be!"
	security_record_text = "Subject miraculously avoids nearly all harm from firearms, but is unable to use firearms."
	security_threat = POWER_THREAT_MAJOR
	mob_trait = TRAIT_NOGUNS
	value = 1

	required_powers = list(/datum/power/theologist/divine_protection)

/datum/power/theologist/crusader_protection/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_THEOLOGIST_DIVINE_PROTECTION_MODIFIERS, PROC_REF(add_projectile_block_chance))

/datum/power/theologist/crusader_protection/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_THEOLOGIST_DIVINE_PROTECTION_MODIFIERS)

/// Adds projectile-only block chance equal to the holder's Piety, capped at 50%.
/datum/power/theologist/crusader_protection/proc/add_projectile_block_chance(mob/living/blocking_user, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, list/block_chance_modifiers)
	SIGNAL_HANDLER

	if(!isprojectile(hitby) || !blocking_user)
		return NONE

	var/datum/component/theologist_piety/piety_component = blocking_user.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return NONE

	block_chance_modifiers += clamp(piety_component.piety, 0, 50)

	return NONE
