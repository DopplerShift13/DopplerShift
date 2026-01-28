/datum/power/theologist_root/shared
	name = "A Burden Shared"
	desc = "Channels a beam of energy between you and a target, equalizing damage over a period of time, scaling with severity. \
	The beam requires continous line of sight to function, and neither you or your target can be incapacitated. Generates Piety if you are transfering damage to yourself. \
	This is mutually exclusive with the other 'A Burden...' powers."
	action_path = /datum/action/cooldown/power/theologist/theologist_root/shared

	value = 5

/datum/action/cooldown/power/theologist/theologist_root/shared
	name = "A Burden Shared"
	desc = "Channels a beam of energy between you and a target, equalizing damage over a period of time, scaling with severity. \
	The beam requires continous line of sight to function, and neither you or your target can be incapacitated. Generates Piety if you are transfering damage to yourself."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "swap"
	cooldown_time = 150
	click_to_activate = TRUE

	// Targeting rules:
	// - Click a living target to start/retarget the beam between you and them.
	// - While active, pressing the action again (manual deactivation) should end the beam.
	target_range = 10 // 2 space beyond screen width if purely vertical/horizontal
	target_type = /mob/living
	target_self = FALSE
	unset_after_click = TRUE

	// The piety build-up. Gets exchanged at exchange_build() if its either positive or negative.
	var/piety_buildup

	/// Who we're currently linked to.
	var/mob/living/carbon/current_target

	/// Visual beam datum we keep alive while the link is active.
	var/datum/beam/current_beam

	// Visual for the glow on the target
	var/mutable_appearance/target_glow

	/// How often (in deciseconds) we validate LoS + apply the equalization tick.
	var/check_delay = 10
	var/last_check = 0

	// Current instance of the status effect
	var/datum/status_effect/power/burden_revered/active_effect


/datum/action/cooldown/power/theologist/theologist_root/shared/Destroy()
	clear_link(manual = TRUE)
	return ..()

// We override trigger to be able to cancel the ability on clicking the button
/datum/action/cooldown/power/theologist/theologist_root/shared/Trigger(mob/clicker, trigger_flags, atom/target)
	// If we're already actively beaming, pressing the button again should cancel immediately.
	if(current_target)
		clear_link(manual = TRUE)
		// Also ensure click-intercept is not left enabled.
		unset_click_ability(owner, refund_cooldown = FALSE)
		return FALSE

	. = ..()

// Currency exchange for piety.
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/exchange_buildup()
	// Have we been a good boy?
	if(piety_buildup >= 1)
		piety_buildup -= 1
		adjust_piety(1)
		to_chat(owner, span_notice("Taking on the burdens of others has gained you piety!"))
	// Have we been a bad boy?
	else if (piety_buildup <= -1)
		piety_buildup += 1
		// Have we been a VERY bad boy? Don't think you can get away with willynilly using this at 0 piety.
		if(get_piety() <= 0 && prob(25))
			lightningbolt(owner)
			if(ishuman(owner))
				var/mob/living/carbon/human/sinner = owner
				sinner.Paralyze(100)
			to_chat(owner, span_userdanger("Divine forces have punished you for your lack of piety!"), confidential = TRUE)
			clear_link()
			return
		adjust_piety(-1)
		to_chat(owner, span_warning("The transfer of your burdens onto others lost you piety!"))


/**
 * Always-called cleanup. Use manual = TRUE when the user actively cancels the power.
 */
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/clear_link(manual = FALSE)
	// gets rid of the beam
	if(current_beam)
		UnregisterSignal(current_beam, COMSIG_QDELETING)
		QDEL_NULL(current_beam)
	// gets rid of the target's glow
	if(target_glow)
		current_target.cut_overlay(target_glow)
		target_glow = null
	// unflags active and tells the caster that the link :b:roke
	if(active)
		active = FALSE
		if(!manual && owner && isliving(owner))
			owner.balloon_alert(owner, "link broken!")
	// gets rid of the warning status message
	if(active_effect)
		qdel(active_effect)

	current_target = null
	if(manual)
		unset_click_ability(owner, refund_cooldown = FALSE)

/**
 * Called when the beam is deleted by something external (range/los/cleanup, etc).
 */
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/beam_died()
	SIGNAL_HANDLER
	current_beam = null
	active = FALSE // avoid re-qdel
	clear_link()

/**
 * Starts (or re-targets) the link between the user and a clicked target.
 * Returning TRUE means: the power was used successfully and should start cooldown (and unset targeting mode).
 */
/datum/action/cooldown/power/theologist/theologist_root/shared/use_action(mob/living/carbon/user, atom/target)
	var/mob/living/new_target = target

	// If already active, cleanly drop the existing link before re-targeting.
	if(active)
		clear_link(manual = TRUE)

	current_target = new_target
	last_check = 0

	// Create a beam from user -> target. This mirrors medbeam.dm's Beam() lifecycle.
	current_beam = user.Beam(current_target, icon_state = "light_beam", time = 10 MINUTES, maxdistance = target_range, beam_type = /obj/effect/ebeam/medical, beam_color = "#ddd166")
	RegisterSignal(current_beam, COMSIG_QDELETING, PROC_REF(beam_died))

	target_glow = mutable_appearance(
		icon = 'icons/effects/effects.dmi',
		icon_state = "shield-yellow",
		layer = current_target.layer - 0.1,
		appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART
	)
	current_target.add_overlay(target_glow)

	active = TRUE
	active_effect = current_target.apply_status_effect(/datum/status_effect/power/burden_shared)

	return TRUE

/datum/action/cooldown/power/theologist/theologist_root/shared/process()
	// So we're kind-of parroting the original, but we don't want to stop proccessing so no . = ..()
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	if(!active)
		if(!owner || (next_use_time - world.time) <= 0)
			STOP_PROCESSING(SSfastprocess, src)
		return

	// If the owner vanishes or we no longer have a target, end it.
	if(active)
		// checks if we actually hve an owner or target
		if(!owner || !isliving(owner) || !current_target)
			clear_link()
			return
		// Checks if our owner or target are DEAD
		if(current_target.stat == DEAD || owner.stat == DEAD)
			to_chat(owner, span_warning("You cannot share burdens with dead people!"))
			clear_link()
			return

		// checks if our owner or target got SNAPPED
		if(QDELETED(owner) || QDELETED(current_target))
			clear_link()
			return

		// checks if our owner is INCAPACITATED or KNOCKED DOWN
		// Honestly more of a balance concern the latter, sorry paraplegic people.
		if(HAS_TRAIT(owner, TRAIT_INCAPACITATED) || HAS_TRAIT(owner, TRAIT_FLOORED))
			to_chat(owner, span_warning("You need to be standing!"))
			clear_link()
			return

		if(world.time <= last_check + check_delay)
			return
		last_check = world.time

		// LoS gate. If it fails, deleting the beam triggers beam_died() -> clear_link().
		if(!los_check(get_atom_on_turf(owner), current_target))
			QDEL_NULL(current_beam)
			return

		on_beam_tick(owner, current_target)
		exchange_buildup()


 // Maths out who needs to receive the healing and who needs to receive the damage.
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/on_beam_tick(mob/living/carbon/user, mob/living/target)
	// Non carbons get their own equalization.
	if(!iscarbon(target))
		equalize_simple(user, target)
		return

	var/list/user_damage = get_damage_snapshot(user)
	var/list/target_damage = get_damage_snapshot(target)

	for(var/damage_type in user_damage)
		var/user_amount = user_damage[damage_type]
		var/target_amount = target_damage[damage_type]
		if(target_amount > user_amount)
			equalize(target, user, damage_type)
		if(target_amount < user_amount)
			equalize(user, target, damage_type)
		else
			continue
	return

// Gets the damage of the affected creature.
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/get_damage_snapshot(mob/living/carbon/subject)
	return list(
		"brute" = subject.getBruteLoss(),
		"burn"  = subject.getFireLoss(),
		"tox"   = subject.getToxLoss(),
		"oxy"   = subject.getOxyLoss(),
	)

//Actually calls the proper health adjustments
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/equalize(mob/living/carbon/giver, mob/living/carbon/taker, damage_type as text)
// Given we have already determined who has more and who has less in on_beam_tick, we can always assume that giver has more than taker, and thus make the comparison sum using that.
	var/amount
	// To summarize; heals the target by the amount (which is capped at 5)
	switch(damage_type)
		if("brute")
			amount = clamp((giver.getBruteLoss() - taker.getBruteLoss()) / 20, 0.5, 3)
			giver.adjustBruteLoss(-amount)
			taker.adjustBruteLoss(amount)

		if("burn")
			amount = clamp((giver.getFireLoss() - taker.getFireLoss()) / 20, 0.5 , 3)
			giver.adjustFireLoss(-amount)
			taker.adjustFireLoss(amount)

		if("tox")
			amount = clamp((giver.getToxLoss() - taker.getToxLoss()) / 20, 0.5 , 3)
			giver.adjustToxLoss(-amount)
			taker.adjustToxLoss(amount)

		if("oxy")
			amount = clamp((giver.getOxyLoss() - taker.getOxyLoss()) / 20, 0.5 , 3)
			giver.adjustOxyLoss(-amount)
			taker.adjustOxyLoss(amount)

	// Piety buildup increases/deductions
	if(taker == owner)
		piety_buildup += amount * THEOLOGIAN_PIETY_HEALING_COEFFICIENT
	else if(giver == owner)
		piety_buildup -= amount * THEOLOGIAN_PIETY_HEALING_COEFFICIENT

	return

// Special version for when targeting non-carbon living creatures (usually simple_creatures)
/datum/action/cooldown/power/theologist/theologist_root/shared/proc/equalize_simple(mob/living/carbon/user, mob/living/target)
	// Since we are comparing living vs carbon, we are doing health on our target and brute on our guy.
	var/user_missingHP = user.maxHealth - user.health
	var/target_missingHP = target.maxHealth - target.health

	// Boooo, hurting the animals!
	// Way less effective on simple mobs
	// TODO: Piety loss for animal murder?

	/*
	This section is really ugly. Due for a do-over.
	*/
	if(user_missingHP > target_missingHP)
		var/bruteloss = clamp((user.getBruteLoss() - target.bruteloss) / 20, 0.2, 1.5)
		var/fireloss = clamp((user.getFireLoss() - target.fireloss) / 20, 0.2, 1.5)
		var/toxloss = clamp((user.getToxLoss() - target.toxloss) / 20, 0.2, 1.5)
		var/oxyloss = clamp((user.getOxyLoss() - target.oxyloss) / 20, 0.2, 1.5)
		user.adjustBruteLoss(-bruteloss)
		user.adjustFireLoss(-fireloss)
		user.adjustToxLoss(-toxloss)
		user.adjustOxyLoss(-oxyloss)
		target.bruteloss -= bruteloss
		target.fireloss -= fireloss
		target.toxloss -= toxloss
		target.oxyloss -= oxyloss

		return

	// Yaaay, healing the animals :)
	if(user_missingHP < target_missingHP)
		var/bruteloss = clamp((target.bruteloss - user.getBruteLoss()) / 20, 0.2, 1.5)
		var/fireloss = clamp((target.fireloss - user.getFireLoss()) / 20, 0.2, 1.5)
		var/toxloss = clamp((target.toxloss - user.getToxLoss()) / 20, 0.2, 1.5)
		var/oxyloss = clamp((target.oxyloss - user.getOxyLoss()) / 20, 0.2, 1.5)
		user.adjustBruteLoss(bruteloss)
		user.adjustFireLoss(fireloss)
		user.adjustToxLoss(toxloss)
		user.adjustOxyLoss(oxyloss)
		target.bruteloss += bruteloss
		target.fireloss += fireloss
		target.toxloss += toxloss
		target.oxyloss += oxyloss
	else
		return

// You know, if I was a smarter man I'd have made the status effect actually handle effects.
// Largely here for alerts so people know they are being damage transfered.
/datum/status_effect/power/burden_shared
	id = "burden_shared"
	duration = 5 MINUTES // If somehow it overestays its welcome
	tick_interval = -1 SECONDS // This one's just cosmetic
	alert_type = /atom/movable/screen/alert/status_effect/burden_shared

/atom/movable/screen/alert/status_effect/burden_shared
	name = "A Burden Shared"
	desc = "Damage is being equalized between you and the caster!"
	icon_state = "lightningorb" // Placeholder
