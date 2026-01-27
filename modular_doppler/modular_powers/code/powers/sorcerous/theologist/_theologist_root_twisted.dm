/datum/power/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Twist the burdens of others into many lesser ones. The target is healed, then damaged for half that amount in random damage types. \
	Gives Piety proportional to the amount of damage twisted. \
	This is mutually exclusive with the other 'A Burden...' powers."
	action_path = /datum/action/cooldown/power/theologist/theologist_root/twisted

	value = 5
	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THEOLOGIST
	priority = POWER_PRIORITY_ROOT

/datum/action/cooldown/power/theologist/theologist_root/twisted
	name = "A Burden Twisted"
	desc = "Twist the burdens of others into many lesser ones. The target is healed, then damaged for half that amount in random damage types. \
	Gives Piety proportional to the amount of damage twisted."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "hand"
	cooldown_time = 150
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = FALSE

	//How much we can heal max with twisted per use.
	var/healing_max = 30
	//Tracks how much healing we did throughout the proccess.
	var/healing_done = 0

	//Tracks how much damage we did throughout the process.
	var/damage_done = 0


/datum/action/cooldown/power/theologist/theologist_root/twisted/use_action(mob/living/user, mob/living/target)
	owner.visible_message(span_warning("[owner] lays a hand on [target], twisting their wounds into other, smaller wounds!"), span_notice("You twist [target]'s wounds!"))
	new /obj/effect/temp_visual/heal(get_turf(target), "#cf2525")
	// I mean let's be real here if we are going to pawn off of other sound effects, chaos is basically the name of the game here.
	playsound(owner, 'sound/effects/magic/cosmic_expansion.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	// I am going to shamelessly steal the red meditation spotlight for a moment.
	target.apply_status_effect(/datum/status_effect/spotlight_light/resonant, 10)
	// Does the healing and damage
	heal_random_damage(owner, target)
	deal_random_damage(owner, target, (healing_done / 2))

	// Handles piety gain
	var/piety_gained = max(0, floor(healing_done * 0.15))
	// resets for next time
	healing_done = 0
	damage_done = 0
	adjust_piety(piety_gained)
	if(piety_gained >= 1)
		to_chat(owner, span_notice("You Burden Twisted yielded [piety_gained] piety!"))
	else
		to_chat(owner, span_notice("Your Burden Twisted yielded no piety!"))

	return TRUE

/datum/action/cooldown/power/theologist/theologist_root/twisted/set_click_ability(mob/on_who)
	. = ..()
	to_chat(owner, span_notice("You ready yourself to twist the burden of others!<br><B>Left-click</B> a creature next to you to target them!"))

// Does the random 30 healing, entirely randomly. Very chaotic, very random.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/heal_random_damage(mob/living/user, mob/living/target)
	// Tells the while loop to stop
	var/no_more_healing = FALSE
	// Cap for how much our random healing can do.
	var/rand_cap
	//Used to save how much healing was done in that switch-case
	var/heal_done

	while(!no_more_healing)
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
		// Nothing to heal or healed the max already
		if(!damage_choices.len || healing_done >= healing_max)
			no_more_healing = TRUE
			break
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
				heal_done = target.adjustToxLoss(-rand(1, rand_cap))
				healing_done += heal_done

			if("oxy")
				rand_cap = min(healing_max - healing_done, oxy_damage)
				heal_done = target.adjustOxyLoss(-rand(1, rand_cap))
				healing_done += heal_done
	no_more_healing = FALSE
	return TRUE

// Pretty similar to heal_random_damage but we're just hurting them.
/datum/action/cooldown/power/theologist/theologist_root/twisted/proc/deal_random_damage(mob/living/user, mob/living/target, damage_max)
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
				target.adjustToxLoss(dam_done)
			// The jackpot
			if("oxy")
				target.adjustOxyLoss(dam_done)
		damage_done += dam_done

	no_more_damaging = FALSE
	return TRUE
