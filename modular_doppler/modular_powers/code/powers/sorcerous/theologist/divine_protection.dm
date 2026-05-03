/*
	Grants a passive block chance equal to half your piety and diminishes it on hit (with minor gating)
*/

/datum/power/theologist/divine_protection
	name = "Divine Protection"
	desc = "You gain a block chance (separate from all other block chance) equal to half your piety; reduce Piety by 5 when this triggers."
	security_record_text = "Subject tends to unpredictably and miraculously avoid harm."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	required_powers = list(/datum/power/theologist_root/)
	required_allow_subtypes = TRUE
	/// World time (in deciseconds) when piety drain last triggered
	var/last_piety_drain = 0
	/// World time (in deciseconds) when block effect last triggered
	var/last_block_effect = 0
	/// The ratio of piety to block.
	var/piety_ratio = 0.5

/datum/power/theologist/divine_protection/add()
	RegisterSignal(power_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))

/datum/power/theologist/divine_protection/remove()
	UnregisterSignal(power_holder, COMSIG_LIVING_CHECK_BLOCK)

/// When calling the block signaler, we do a custom check for people's block.
/datum/power/theologist/divine_protection/proc/check_block(mob/living/blocking_user, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER

	if(!blocking_user)
		return NONE

	var/datum/component/theologist_piety/piety_component = blocking_user.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return NONE

	var/block_chance = clamp(round(piety_component.piety * piety_ratio), 0, 100)
	if(block_chance <= 0 || !prob(block_chance))
		return NONE

	block_effect(blocking_user, attack_text, hitby, attack_type)
	// We only allow piety loss once per 0.4 seconds so you don't get your piety nuked by a shotgun.
	if(world.time >= last_piety_drain + 4)
		piety_component.adjust_piety(-THEOLOGIST_PIETY_MINOR)
		last_piety_drain = world.time
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
