/datum/power/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Channel chaotic energies into another creature next to you. The target is healed over time in random amounts up to the maximum, then damaged for half that amount in random damage types. \
	\nGives Piety proportional to the net-positive amount of damage healed. Works on synthetic bodyparts."
	security_record_text = "Subject can rapidly transmute the wounds of a target into smaller, insubstantial wounds."
	action_path = /datum/action/cooldown/power/theologist/theologist_root/twisted

	value = 5

/datum/action/cooldown/power/theologist/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Channel chaotic energies into another creature next to you. The target is healed over time in random amounts up to the maximum, then damaged for half that amount in random damage types. \
	Gives Piety proportional to the net-positive amount of damage healed. Works on synthetic bodyparts"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "hand"
	cooldown_time = 150
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = FALSE
	unset_after_click = TRUE

	/// How much we can heal max with twisted per use.
	var/healing_max = THEOLOGIST_ROOT_HEALING
	/// Tracks how much healing we did throughout the proccess.
	var/healing_done = 0

	/// Tracks how much damage we did throughout the process.
	var/damage_done = 0

	/// The beam effect when channeling
	var/datum/beam/current_beam

	/// The current target of the effect
	var/mob/living/current_target

	/// Tells the do_while loop to keep_going
	var/keep_going

/datum/action/cooldown/power/theologist/theologist_root/twisted/use_action(mob/living/user, mob/living/target)
	// We define the target just for the on_dispel listener
	current_target = target
	// Because we have a do_while, it won't get to the usual unset_click_ability() until after the efffect resolves, so we have to run it here.
	unset_click_ability(owner, FALSE)
	keep_going = TRUE
	owner.visible_message(span_warning("[owner.get_visible_name()] lays a hand on [target.get_visible_name()], twisting their injuries into other, smaller injuries!"), span_notice("You twist [target.get_visible_name()]'s injuries!"))
	// Listeners for dispelling.
	RegisterSignal(user, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	RegisterSignal(target, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

	active = TRUE
	// I am going to shamelessly steal the red meditation spotlight for a moment.
	target.apply_status_effect(/datum/status_effect/spotlight_light/twisted, 1200)
	current_beam = owner.Beam(target, icon_state = "light_beam", time = 120 SECONDS, maxdistance = target_range, beam_type = /obj/effect/ebeam/medical, beam_color = "#cf2525")

	// Does the healing and damage
	do
		if(do_after(owner, 25, target = target))
			if(target_range)
				var/turf/owner_turf = get_turf(owner)
				var/turf/target_turf = get_turf(target)
				if(owner_turf && target_turf && get_dist(owner_turf, target_turf) > target_range)
					owner.balloon_alert(owner, "Out of range!")
					break // we use break here instead cuase we don't want to heal them anymore.
			if(target.health >= target.maxHealth)
				to_chat(owner, span_notice("Your target's health is full!"))
				keep_going = FALSE
			if(target.health < target.maxHealth)
				new /obj/effect/temp_visual/heal(get_turf(target), "#cf2525")
				playsound(owner, 'sound/effects/magic/cosmic_expansion.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
				var/healtodmgcap = heal_random_damage(target)
				deal_random_damage(target, (healtodmgcap / 2))
			if(healing_done >= healing_max)
				to_chat(owner, span_notice("You have channeled the full effect of [name]!"))
				keep_going = FALSE
		else
			keep_going = FALSE
	while (keep_going)

	// cleanup
	active = FALSE
	target.remove_status_effect(/datum/status_effect/spotlight_light/twisted)
	QDEL_NULL(current_beam)

	// unregister signal
	UnregisterSignal(current_target, COMSIG_ATOM_DISPEL)
	UnregisterSignal(owner, COMSIG_ATOM_DISPEL)

	// Handles piety gain
	var/piety_gained = max(0, floor(healing_done * THEOLOGIST_PIETY_HEALING_COEFFICIENT))
	// resets for next time
	healing_done = 0
	damage_done = 0
	if(target.ckey)
		adjust_piety(piety_gained)
		if(piety_gained >= 1)
			to_chat(owner, span_notice("You Burden Twisted yielded [piety_gained] piety!"))
		else
			to_chat(owner, span_notice("Your Burden Twisted yielded no piety!"))
	else
		to_chat(owner, span_notice("Your Burden Twisted yielded no piety!"))

	return TRUE

/datum/action/cooldown/power/theologist/theologist_root/twisted/set_click_ability(mob/on_who)
	. = ..()
	to_chat(owner, span_notice("You ready yourself to twist the burden of others!<br><B>Left-click</B> a creature next to you to target them!"))

/// Does the given amount of healing, entirely randomly. Very chaotic, very random.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/heal_random_damage(mob/living/target)
	// Cap for how much our random healing can do.
	var/rand_cap
	//Used to save how much healing was done in that switch-case.
	var/heal_done = 0

	// Gets all damage types on target
	var/list/damage_choices = list()
	var/brute_damage = target.getBruteLoss()
	var/burn_damage = target.getFireLoss()
	var/tox_damage = target.getToxLoss()
	var/oxy_damage = target.getOxyLoss()
	// Checks if there's any injuries to heal b4 rolling the damage-type.
	if(brute_damage > 0) damage_choices += "brute"
	if(burn_damage > 0) damage_choices += "burn"
	if(tox_damage > 0) damage_choices += "tox"
	if(oxy_damage > 0) damage_choices += "oxy"
	// Hey we already healed you to the max!
	if(healing_done >= healing_max)
		return 0
	// Nothing to heal
	if(!damage_choices.len)
		return
	var/damage_choice = pick(damage_choices)
	switch(damage_choice)
		if("brute")
			rand_cap = min(healing_max - healing_done, brute_damage)
			heal_done = target.adjustBruteLoss(-rand(1, rand_cap))
			healing_done += heal_done
		if("burn")
			rand_cap = min(healing_max - healing_done, burn_damage)
			heal_done = target.adjustFireLoss(-rand(1, rand_cap))
			healing_done += heal_done
		if("tox")
			rand_cap = min(healing_max - healing_done, tox_damage)
			heal_done = adjust_tox_noinvert(target, (-rand(1, rand_cap)))
			healing_done += heal_done
		if("oxy")
			rand_cap = min(healing_max - healing_done, oxy_damage)
			heal_done = target.adjustOxyLoss(-rand(1, rand_cap))
			healing_done += heal_done
	return heal_done

/// Pretty similar to heal_random_damage but we're just hurting them.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/deal_random_damage(mob/living/target, damage_max)
	// Tells the while loop to stop
	var/no_more_damaging = FALSE
	// Cap for how much our random damage we can do.
	var/rand_cap
	//Used to save how much damage was done in that switch-case
	var/dam_done

	while(!no_more_damaging)
		// Dealt max amount of damage already.
		if(damage_done >= damage_max)
			no_more_damaging = TRUE
			break
		var/list/damage_choices = list("brute", "burn", "tox", "oxy")
		rand_cap = min(damage_max - damage_done)
		dam_done = rand(1, rand_cap)
		var/damage_choice = pick(damage_choices)
		switch(damage_choice)
			if("brute")
				target.adjustBruteLoss(dam_done)
			if("burn")
				target.adjustFireLoss(dam_done)
			if("tox")
				adjust_tox_noinvert(target, dam_done)
			// The jackpot
			if("oxy")
				target.adjustOxyLoss(dam_done)
		damage_done += dam_done
		// Keep the net healing at the standard for roots by subtracting damage from total healing done.
		healing_done = max(0, healing_done - dam_done)

	no_more_damaging = FALSE
	return TRUE

/// Dispel effect
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	keep_going = FALSE
	owner.visible_message(span_warning("The resonant link between [owner.get_visible_name()] and [current_target.get_visible_name()] is broken!!"), span_notice("Your [name] is dispelled!"))
	StartCooldownSelf()
	return DISPEL_RESULT_DISPELLED

// Legacy subtype for other powers still referencing this path.
/datum/status_effect/spotlight_light/twisted
	id = "twisted_spotlight"
	spotlight_color = "#cf2525"
