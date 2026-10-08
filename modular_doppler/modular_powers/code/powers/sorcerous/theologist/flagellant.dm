/// Grants Piety based on getting smacked.
/datum/power/theologist/flagellant
	name = "Flagellant Piety"
	desc = "You suffer so others may live. You gain Piety from being hurt by creatures. The damage taken must be caused by a creature and must be blockable; \
	so indirect methods of damaging you such as throwing explosives or using area-of-effect magics will not grant piety.\
	\nThe Piety gained is based on the pre-mitigation damage (block, armor etc). Damage that comes from self-flagellation is based on the actual damage taken."
	security_record_text = "Subject fuels their powers by being hurt by others."
	value = 4
	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE
	menu_icon = 'icons/obj/weapons/whip.dmi'
	menu_icon_state = "whip"

	/// Reference to the holder's piety component.
	var/datum/component/theologist_piety/piety_component
	/// How much piety you gain per point of damage.
	var/piety_per_damage = THEOLOGIST_PIETY_HEALING_COEFFICIENT

/datum/power/theologist/flagellant/post_add(client/client_source)
	..()
	get_piety_component()
	RegisterSignal(power_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))
	RegisterSignal(power_holder, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_apply_damage))
	RegisterSignal(power_holder, COMSIG_HUMAN_GOT_PUNCHED, PROC_REF(on_got_punched))

/datum/power/theologist/flagellant/remove()
	UnregisterSignal(power_holder, list(COMSIG_LIVING_CHECK_BLOCK, COMSIG_MOB_APPLY_DAMAGE,	COMSIG_HUMAN_GOT_PUNCHED))

/// Attempts to acquire the piety component.
/// TODO: I should roll this into base theologist mechanics and not just Theologist actions, but I'll do that in P2 Theologist mechanics since this is just a hotfix for 1 power.
/datum/power/theologist/flagellant/proc/get_piety_component()
	piety_component = power_holder.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return FALSE
	return TRUE

/// Awards piety for attacks based on the base damage dealt.
/// This is the only signaler that lets us get both non-item and item damage and the source in one signaler.
/// Does not work with self-harm.
/datum/power/theologist/flagellant/proc/on_check_block(datum/source, atom/hit_by, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER
	var/mob/living/attack_source = get_attack_source_mob(hit_by)
	if(!attack_source)
		return
	if(attack_source == power_holder) // normally we don't path through here but if you somehow hit yourself with a ricocheted projectile, you shouldn't get piety twice. only shame.
		return
	award_piety(damage)

/// Awards Piety if we are self-flagellating with items.
/// Self-harm does not path through block so we have to do this seperately.
/datum/power/theologist/flagellant/proc/on_apply_damage(datum/source, damage, damage_type, bodypart, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	if(!isitem(attacking_item))
		return
	if(get_attack_source_mob(attacking_item) != power_holder)
		return
	award_piety(damage)

/// Awards Piety if we are self-flagellating with unarmed attacks.
/// Self-harm does not path through block so we have to do this seperately.
/datum/power/theologist/flagellant/proc/on_got_punched(datum/source, mob/living/carbon/human/attacker, damage, attack_type, obj/item/bodypart/affecting, final_armor_block, kicking, limb_sharpness)
	SIGNAL_HANDLER
	if(attacker != power_holder)
		return

	/// We need to calc the would-be damage mitigation to know how much we would actually be taking from hurting ourselves..
	var/mob/living/carbon/human/human_holder = power_holder
	var/total_block = final_armor_block + human_holder.physiology?.damage_resistance + human_holder.dna?.species?.damage_modifier
	var/damage_amount = damage * ((100 - total_block) / 100)
	damage_amount *= human_holder.get_incoming_damage_modifier(damage_amount, attack_type, affecting, limb_sharpness, get_dir(attacker, human_holder))

	award_piety(damage_amount)

/// Awards piety, but double-checks the piety component is there first since piety component sits in the action layer.
/// Read the todo on get_piety_component
/datum/power/theologist/flagellant/proc/award_piety(damage)
	if(!piety_component && !get_piety_component()) // fix piety component if it isnt there
		return
	piety_component.adjust_piety(damage * piety_per_damage)

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
