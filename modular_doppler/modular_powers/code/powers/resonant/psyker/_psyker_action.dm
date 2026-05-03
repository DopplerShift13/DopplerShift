/datum/action/cooldown/power/psyker
	name = "abstract psyker power action - ahelp this"
	background_icon_state = "bg_hive"
	overlay_icon_state = "bg_hive_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	// We're a psychic we don't need hands.
	need_hands_free = FALSE

	/// The organ that processes most of the Psyker Powers. Mostly all functions here communicate with this.
	var/obj/item/organ/resonant/psyker/psyker_organ

	/// If the spell (flavorwise) affects the target's mind. So this should be FALSE for things like telekinesis but TRUE for mind reading.
	var/mental = TRUE

	/// charge cost on antimagic powers. If it has a cooldown and is non-spamable then this should be 1; otherwise keep it as is. 0 means the target isn't made aware they get targeted as well.
	var/antimagic_charge_cost = 0

/datum/action/cooldown/power/psyker/New()
	. = ..()
	ValidateOrgan()

/// Actually checks if our Psyker Organ is there. We really want to check this every use.
/datum/action/cooldown/power/psyker/proc/ValidateOrgan()
	if(owner) // Prevents runtiming on start
		psyker_organ =  owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!psyker_organ)
		return FALSE
	return TRUE

/// This doesn't actually add the stress itself; it merely tells the organ to add the stress. Validation is handled on the organ side.
/datum/action/cooldown/power/psyker/proc/modify_stress(amount, override_cap)
	psyker_organ.modify_stress(amount, override_cap)

// We added checking for organs on try_use, as well as making sure that if we are wearing a tinfoil cap, we can't just wield our psychic powers.
/datum/action/cooldown/power/psyker/try_use(mob/living/user, mob/living/target)
	if(!ValidateOrgan())
		owner.balloon_alert(owner, "No paracausal gland!")
		return FALSE
	// This checks against mental on the target
	if(isliving(target) && mental && !can_affect_mental(target, antimagic_charge_cost))
		modify_stress(PSYKER_STRESS_MINOR)
		owner.balloon_alert(owner, "The target's mind is unreachable!")
		to_chat(owner, span_boldnotice("The target's mind is unreachable!"))
		return FALSE
	. = .. ()

/// Checks if the target can be affected by mental based psyker stuff, since it has its own litle list of unique immunities. Returns TRUE if the target has nothing that affects mental.
/datum/action/cooldown/power/psyker/proc/can_affect_mental(mob/living/target, charge_cost)
	if(!charge_cost)
		charge_cost = antimagic_charge_cost
	if(target.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = charge_cost))
		return FALSE
	if(target.can_block_magic(MAGIC_RESISTANCE, charge_cost = charge_cost))
		return FALSE
	if(target.can_block_resonance(charge_cost))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_DUMB)) // this is a feature
		return FALSE
	return TRUE

/// Checks if the target can be affected by specifically psyker's scrying
/datum/action/cooldown/power/psyker/proc/can_affect_scrying(mob/living/target, charge_cost = 0)
	if(!charge_cost)
		charge_cost = antimagic_charge_cost
	if(!can_affect_mental(target, charge_cost))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_ANTIRESONANCE_SCRYING))
		return FALSE
	return TRUE
