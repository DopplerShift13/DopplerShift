
/datum/power/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature's burn and brute damage over a prolonged period of time. This may be yourself. \
	\nGrants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. Does not work on synthetic bodyparts."
	security_record_text = "Subject can magically mend their own wounds and the wounds of others slowly over a long duration."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/theologist/theologist_root/revered

	value = 5

/datum/action/cooldown/power/theologist/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the targeted creature's burn and brute damage over a prolonged period of time. This may be yourself. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. Does not work on synthetic bodyparts."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "burden_revered" // I need something better
	cooldown_time = 50
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = TRUE

	// Current instance of the status effect
	var/datum/status_effect/power/burden_revered/active_effect

	// Keeps track if we are targeting ourselves, as to ensure we don't give ourselves piety by repeatedly healing ourselves, which isn't very pious (according to MOST religions).
	var/healing_self = FALSE
	// The maximum amount we will heal.
	var/healing_max = THEOLOGIST_ROOT_HEALING
	// The amount we heal per tick
	var/healing_amount = 1

/datum/action/cooldown/power/theologist/theologist_root/revered/use_action(mob/living/user, mob/living/target)
	if(active_effect)
		qdel(active_effect)
	active_effect = target.apply_status_effect(/datum/status_effect/power/burden_revered, src)
	active = TRUE
	if(active_effect && target == owner)
		healing_self = TRUE
	playsound(target, 'sound/effects/magic/staff_healing.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	to_chat(target, span_notice("[user] lays [user.p_their()] hand on you, and your wounds start to heal!"))
	to_chat(user, span_notice("You lay your hand on [target]'s shoulder, revering their burdens."))
	return TRUE

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
	if(burden_power) // inherit the healing from the power, for potential future upgrades / varedits.
		healing_max = burden_power.healing_max
		base_healing_amount = burden_power.healing_amount


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
	burden_power.StartCooldownSelf()
	expire()
	return DISPEL_RESULT_DISPELLED


// This is where the heal budgeting happens.
/datum/status_effect/power/burden_revered/tick(seconds_between_ticks)
	var/healing_amount = (base_healing_amount * seconds_between_ticks)
	new /obj/effect/temp_visual/heal(get_turf(owner), "#ddd166")

	// Expire if we've reached the max.
	if(healing_done >= healing_max)
		expire()
		return

	// Limb-based healing: only organic bodyparts.
	if(!istype(owner, /mob/living/carbon))
		expire()
		return

	var/mob/living/carbon/mob = owner
	var/healed_any = FALSE
	// gets random bodypart, heals it, bam.
	for(var/obj/item/bodypart/bodypart in mob.get_damaged_bodyparts(1, 1, BODYTYPE_ORGANIC))
		bodypart.heal_damage(healing_amount, healing_amount, required_bodytype = BODYTYPE_ORGANIC)
		mob.update_damage_overlays()
		healing_done += healing_amount
		healed_any = TRUE
		break

	// Expire if there's nothing left to heal.
	if(!healed_any)
		expire()
		return

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
	icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	icon_state = "burden_revered"
