/*
	Grants a passive block chance equal to half your piety and diminishes it on hit (with minor gating)
*/

/datum/power/theologist/divine_protection
	name = "Divine Protection"
	desc = "You gain a block chance (separate from all other block chance) equal to half your piety; lose Piety based on damage blocked.\
	\nDivine Protection can never have a higher block chance than 66%, and is unaffected by armour penetration."
	security_record_text = "Subject tends to unpredictably and miraculously avoid harm."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "shield-yellow"

	required_powers = list(/datum/power/theologist_root/)
	required_allow_subtypes = TRUE
	/// Piety spent for each point of damage blocked.
	var/piety_per_damage = THEOLOGIST_PIETY_HEALING_COEFFICIENT * 1.5
	/// World time (in deciseconds) when block effect last triggered
	var/last_block_effect = 0
	/// The ratio of piety to block.
	var/piety_ratio = 0.5
	/// The highest final block chance Divine Protection can grant.
	var/max_block_chance = 66

/datum/power/theologist/divine_protection/add()
	RegisterSignal(power_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))

/datum/power/theologist/divine_protection/remove()
	UnregisterSignal(power_holder, COMSIG_LIVING_CHECK_BLOCK)

/// When calling the block signaler, we do a custom check for people's block.
/datum/power/theologist/divine_protection/proc/check_block(mob/living/blocking_user, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER

	if(!blocking_user)
		return NONE

	// can't block if you're not awake, as funny as it would be
	if(blocking_user.stat != CONSCIOUS || HAS_TRAIT(blocking_user, TRAIT_INCAPACITATED))
		return NONE

	// can't benefit if you're silenced.
	if(HAS_TRAIT(blocking_user, TRAIT_RESONANCE_SILENCED))
		return NONE

	var/datum/component/theologist_piety/piety_component = blocking_user.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return NONE

	// Collect additive block chance modifiers before applying Divine Protection's global cap.
	var/block_chance = clamp(round(piety_component.piety * piety_ratio), 0, 100)
	var/list/block_chance_modifiers = list()
	SEND_SIGNAL(power_holder, COMSIG_THEOLOGIST_DIVINE_PROTECTION_MODIFIERS, hitby, damage, attack_text, attack_type, armour_penetration, damage_type, block_chance_modifiers)
	for(var/block_chance_modifier in block_chance_modifiers)
		block_chance += block_chance_modifier
	block_chance = clamp(block_chance, 0, max_block_chance)

	if(!prob(block_chance))
		return NONE

	// only a nat20 will save you now
	if(istype(hitby, /obj/projectile/magic/death) && rand(95))
		to_chat(blocking_user, span_userdanger("Your conviction fails to defend against death!"))
		return NONE

	block_effect(blocking_user, attack_text, hitby, attack_type)
	if(isnum(damage) && damage > 0)
		piety_component.adjust_piety(-(damage * piety_per_damage))
	return SUCCESSFUL_BLOCK

/// Special effects + feedback for the block.
/datum/power/theologist/divine_protection/proc/block_effect(mob/living/blocking_user, attack_text, atom/movable/hitby, attack_type)
	if(!blocking_user)
		return
	blocking_user.visible_message(
		span_danger("[attack_text] bounces harmlessly off of [blocking_user]!"),
		span_userdanger("[attack_text] is blocked by your Divine Protection!"),
	)
	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if(attacker && (attack_type == MELEE_ATTACK || attack_type == UNARMED_ATTACK || attack_type == LEAP_ATTACK || attack_type == OVERWHELMING_ATTACK))
		if(istype(hitby, /obj/item))
			attacker.do_attack_animation(blocking_user, used_item = hitby)
		else
			attacker.do_attack_animation(blocking_user)
	// don't trigger the fx more than 1 second to prevent taking ear damage from being shotgunned.
	if(world.time < last_block_effect + 10)
		return
	last_block_effect = world.time

	var/mutable_appearance/holy_glow = mutable_appearance('icons/mob/effects/genetics.dmi', "servitude", -MUTATIONS_LAYER)
	blocking_user.add_overlay(holy_glow)
	addtimer(CALLBACK(blocking_user, TYPE_PROC_REF(/atom, cut_overlay), holy_glow), 1 SECONDS)
	playsound(blocking_user, 'sound/effects/magic/magic_block_holy.ogg', 50, TRUE)

/// Removes the glow effect afterwards
/datum/power/theologist/divine_protection/proc/remove_holy_glow(mob/living/blocking_user, image/holy_glow_image)
	if(!blocking_user || !holy_glow_image)
		return
	blocking_user.vis_contents -= holy_glow_image
