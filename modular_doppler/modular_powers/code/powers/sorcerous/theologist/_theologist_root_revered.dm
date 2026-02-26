
/datum/power/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature over a prolonged period of time. This may be yourself. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. \
	This is mutually exclusive with the other 'A Burden...' powers."
	action_path = /datum/action/cooldown/power/theologist/theologist_root/revered

	value = 5

/datum/action/cooldown/power/theologist/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature over a prolonged period of time. This may be yourself. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "transformslime"
	cooldown_time = 50
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = TRUE

	// Current instance of the status effect
	var/datum/status_effect/power/burden_revered/active_effect

	// Keeps track if we are targeting ourselves, as to ensure we don't give ourselves piety by repeatedly healing ourselves, which isn't very pious (according to MOST religions).
	var/healing_self = FALSE

/datum/action/cooldown/power/theologist/theologist_root/revered/use_action(mob/living/user, mob/living/target)
	to_chat(owner, span_boldnotice("Placeholder"))
	if(active_effect)
		qdel(active_effect)
	active_effect = target.apply_status_effect(/datum/status_effect/power/burden_revered, src)
	active = TRUE
	if(active_effect && target == owner)
		healing_self = TRUE
	return TRUE

/datum/action/cooldown/power/theologist/theologist_root/revered/set_click_ability(mob/on_who)
	. = ..()
	to_chat(owner, span_notice("You ready yourself to relieve the burden of others!<br><B>Left-click</B> a creature next to you to target them!"))

/datum/action/cooldown/power/theologist/theologist_root/revered/proc/effect_expired(mob/living/target, amount)
	if(target.ckey) // Don't get piety from healing nobodies.
		adjust_piety(amount)
		if(amount >= 1 && !healing_self)
			to_chat(owner, span_notice("Your previous Burden Revered has expired! You gained [amount] piety!"))
			owner.playsound_local(owner, 'sound/effects/pray.ogg', 50, FALSE)
		else
			to_chat(owner, span_notice("Your previous Burden Revered has expired!"))
	else
		to_chat(owner, span_notice("Your previous Burden Revered has expired!"))

	//Always reset this after use.
	active = FALSE
	healing_self = FALSE

	return

// Status effect that Burden Revered applies
/datum/status_effect/power/burden_revered
	id = "burden_revered"
	duration = 2 MINUTES // If somehow it overestays its welcome
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/burden_revered
	// The power responsible for this, so we can make sure it properly gives piety to the caster
	var/datum/action/cooldown/power/theologist/theologist_root/revered/burden_power
	// The maximum amount we will heal
	var/healing_max = THEOLOGIST_ROOT_HEALING
	// How much we have healed already
	var/healing_done = 0
	// How much we heal per tick.
	var/base_healing_amount = 1
	// Has the thing already expired?
	var/already_expired

/datum/status_effect/power/burden_revered/on_apply()
	ADD_TRAIT(owner, TRAIT_ANALGESIA, type)
	RegisterSignal(owner, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	return TRUE

// Sets the link with the original action
/datum/status_effect/power/burden_revered/on_creation(mob/living/new_owner,	datum/action/cooldown/power/theologist/theologist_root/revered/passed_power)
	. = ..()
	burden_power = passed_power


// You might wonder why we run Destroy as well as on_remove. The issue is that on_remove can trigger on qdel, which invalidates burden_power, which prevents us from efficiently passing on the piety back to the owner.
/datum/status_effect/power/burden_revered/Destroy()
	if(!already_expired)
		expire()
	..()

/datum/status_effect/power/burden_revered/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_DISPEL)
	REMOVE_TRAIT(owner, TRAIT_ANALGESIA, type)
	return

// Dispel functionality
/datum/status_effect/power/burden_revered/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	to_chat(owner, span_userdanger("Your [burden_power.name] deactives prematurely!"))
	if(!owner == burden_power.owner)
		to_chat(burden_power.owner, span_warning("Your [burden_power.name] has been dispelled!"))
	burden_power.StartCooldownSelf(150) // Just so you don't immediately reapply it.
	expire()
	return DISPEL_RESULT_DISPELLED


// This is where the heal budgeting happens.
/datum/status_effect/power/burden_revered/tick(seconds_between_ticks)
	var/healing_amount = (base_healing_amount * seconds_between_ticks)
	new /obj/effect/temp_visual/heal(get_turf(owner), "#ddd166")

	// Expire if at full health.
	if(owner && owner.health >= owner.maxHealth)
		expire()
		return
	// Expire if we've reached the max.
	if(healing_done >= healing_max)
		expire()
		return

	// Only include damage types that actually need healing
	var/list/damage_choices = list()
	var/brute_damage = owner.getBruteLoss()
	var/burn_damage = owner.getFireLoss()
	var/tox_damage = owner.getToxLoss()
	var/oxy_damage = owner.getOxyLoss()

	if(brute_damage > 0) damage_choices += "brute"
	if(burn_damage > 0) damage_choices += "burn"
	if(tox_damage > 0) damage_choices += "tox"
	if(oxy_damage > 0) damage_choices += "oxy"

	// Nothing to heal
	if(!damage_choices.len)
		return

	var/damage_choice = pick(damage_choices)

	switch(damage_choice)
		if("brute")
			var/heal_done = min(healing_amount, brute_damage)
			owner.adjustBruteLoss(-heal_done)
			healing_done += heal_done

		if("burn")
			var/heal_done = min(healing_amount, burn_damage)
			owner.adjustFireLoss(-heal_done)
			healing_done += heal_done

		if("tox")
			var/heal_done = min(healing_amount, tox_damage)
			owner.adjustToxLoss(-heal_done)
			healing_done += heal_done

		if("oxy")
			var/heal_done = min(healing_amount, oxy_damage)
			owner.adjustOxyLoss(-heal_done)
			healing_done += heal_done

// QDEL destroys burden_power
/datum/status_effect/power/burden_revered/proc/expire()
	var/piety_gained = max(0, floor(healing_done * THEOLOGIST_PIETY_HEALING_COEFFICIENT)) // TODO: defines
	// Report back BEFORE deletion starts
	if(burden_power)
		burden_power.effect_expired(owner, piety_gained)
	already_expired = TRUE
	src.Destroy() // There might be something better, but QDEL triggers the qdel loop warning.

/atom/movable/screen/alert/status_effect/burden_revered
	name = "A Burden Revered"
	desc = "You passively heal damage, and are immune to pain for it's duration."
	icon_state = "designated_target" // Placeholder
