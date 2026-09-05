
/datum/power/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature's brute and burn damage over a prolonged period of time. This may be yourself. \
	\nGrants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. Does not work on synthetic bodyparts.\
	\nModifiers to healing amount increase the maximum healing of this power as well as the healing rate."
	security_record_text = "Subject can magically mend their own wounds and the wounds of others slowly over a long duration."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/theologist/theologist_root/revered

	value = 5

/datum/action/cooldown/power/theologist/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature's brute and burn damage over a prolonged period of time. This may be yourself. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. Does not work on synthetic bodyparts."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "burden_revered"
	cooldown_time = 50
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = TRUE

	/// Current instance of the status effect
	var/datum/status_effect/power/burden_revered/active_effect

	/// Keeps track if we are targeting ourselves, as to ensure we don't give ourselves piety by repeatedly healing ourselves, which isn't very pious (according to MOST religions).
	var/healing_self = FALSE
	/// The maximum amount we will heal.
	var/healing_max = THEOLOGIST_ROOT_HEALING
	/// The amount we heal per second
	var/healing_amount = 1

/datum/action/cooldown/power/theologist/theologist_root/revered/use_action(mob/living/user, mob/living/target)
	if(active_effect)
		qdel(active_effect)
	active_effect = target.apply_status_effect(/datum/status_effect/power/burden_revered, src)
	if(!active_effect)
		return FALSE
	// Snapshot after applying the status so Doctor's Craft can detect Burden Revered's analgesia.
	snapshot_healing_multiplier(target)
	active_effect.refresh_healing_values()
	active = TRUE
	if(target == owner)
		healing_self = TRUE
	playsound(target, 'sound/effects/magic/staff_healing.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	to_chat(target, span_notice("[user] lays [user.p_their()] hand on you, and your wounds start to heal!"))
	to_chat(user, span_notice("You lay your hand on [target]'s shoulder, revering their burdens."))
	return TRUE

/// Callback communication from the status effect on expiration that handles piety gain and feedbackk.
/datum/action/cooldown/power/theologist/theologist_root/revered/proc/effect_expired(mob/living/target, amount)
	if(target.ckey) // Don't get piety from healing nobodies.
		if(amount >= 1 && !healing_self)
			adjust_piety(amount)
			to_chat(owner, span_notice("Your previous Burden Revered has expired! You gained [amount] piety!"))
		else
			to_chat(owner, span_notice("Your previous Burden Revered has expired!"))
	else
		to_chat(owner, span_notice("Your previous Burden Revered has expired!"))
	owner.playsound_local(owner, 'sound/effects/magic/charge.ogg', 50, FALSE)

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
	/// The power responsible for this, so we can make sure it properly gives piety to the caster
	var/datum/action/cooldown/power/theologist/theologist_root/revered/burden_power
	/// The maximum amount we will heal
	var/healing_max = THEOLOGIST_ROOT_HEALING
	/// How much we have healed already
	var/healing_done = 0
	/// How much we heal per tick.
	var/base_healing_amount = 1
	/// Has the thing already expired?
	var/already_expired

/datum/status_effect/power/burden_revered/on_apply()
	ADD_TRAIT(owner, TRAIT_ANALGESIA, type)
	RegisterSignal(owner, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	return TRUE

// Sets the link with the original action
/datum/status_effect/power/burden_revered/on_creation(mob/living/new_owner,	datum/action/cooldown/power/theologist/theologist_root/revered/passed_power)
	. = ..()
	burden_power = passed_power

/// Refreshes the status effect's healing budget after the power snapshots its modifiers.
/datum/status_effect/power/burden_revered/proc/refresh_healing_values()
	if(!burden_power)
		return
	healing_max = burden_power.healing_max * burden_power.healing_multiplier
	base_healing_amount = burden_power.healing_amount * burden_power.healing_multiplier


// You might wonder why we run Destroy as well as on_remove. The issue is that on_remove can trigger on qdel, which invalidates burden_power, which prevents us from efficiently passing on the piety back to the owner.
/datum/status_effect/power/burden_revered/Destroy()
	if(!already_expired)
		expire()
	..()

/datum/status_effect/power/burden_revered/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_DISPEL)
	REMOVE_TRAIT(owner, TRAIT_ANALGESIA, type)
	return

/// Dispel functionality
/datum/status_effect/power/burden_revered/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	to_chat(owner, span_userdanger("Your [burden_power.name] deactives prematurely!"))
	if(!owner == burden_power.owner)
		to_chat(burden_power.owner, span_warning("Your [burden_power.name] has been dispelled!"))
	burden_power.StartCooldownSelf()
	expire()
	return DISPEL_RESULT_DISPELLED


// This is where the heal budgeting happens.
/datum/status_effect/power/burden_revered/tick(seconds_between_ticks)
	new /obj/effect/temp_visual/heal(get_turf(owner), "#ddd166")

	// Expire if we've reached the max.
	if(healing_done >= healing_max)
		expire()
		return

	var/healing_amount = min(base_healing_amount * seconds_between_ticks, healing_max - healing_done)
	// Use the proc to delegate the healing.
	var/actual_healing = heal_damage(healing_amount)
	if(actual_healing <= 0) // we healed nothing? must be nothing left to heal.
		expire()
		return
	healing_done += actual_healing // tick up the healing.

/// Tries to heal the damage between brute and burn
/datum/status_effect/power/burden_revered/proc/heal_damage(healing_amount)
	if(!owner || healing_amount <= 0)
		return 0

	// Gets and sets how much brute and burn damage there is to heal.
	var/brute_damage = owner.getBruteLoss()
	var/burn_damage = owner.getFireLoss()

	// Basically heal the full-amount unless there's both damage-types, in which case we split the heal.
	var/healing_per_type = brute_damage > 0 && burn_damage > 0 ? healing_amount * 0.5 : healing_amount
	var/brute_to_heal = min(healing_per_type, brute_damage)
	var/burn_to_heal = min(healing_per_type, burn_damage)

	if(brute_to_heal <= 0 && burn_to_heal <= 0)
		return 0

	// do the actual healing.
	return owner.heal_overall_damage(brute = brute_to_heal, burn = burn_to_heal, required_bodytype = BODYTYPE_ORGANIC)

/// QDEL destroys burden_power so we can handle this b4 destroy. Passes piety back.
/datum/status_effect/power/burden_revered/proc/expire()
	var/piety_gained = max(0, floor(healing_done * THEOLOGIST_PIETY_HEALING_COEFFICIENT))
	// Report back BEFORE deletion starts
	if(burden_power)
		burden_power.effect_expired(owner, piety_gained)
	already_expired = TRUE
	src.Destroy() // There might be something better, but QDEL triggers the qdel loop warning.

/atom/movable/screen/alert/status_effect/burden_revered
	name = "A Burden Revered"
	desc = "You passively heal damage, and are immune to pain for it's duration."
	icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	icon_state = "burden_revered"
