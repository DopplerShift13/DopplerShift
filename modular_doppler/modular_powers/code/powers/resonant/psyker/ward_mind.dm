/datum/power/psyker_power/ward_mind
	name = "Ward Mind"
	desc = "Temporarily strengthens your mind to block out mental assaults. You become immune to various abilities that use the mental trait as well as resonance-based detection, such as a large variety of Psyker powers but also a handful of other interactions.\
	\n You gain Stress passively while active, and a moderate amount is gained whenever you block a mental ability."
	security_record_text = "Subject can ward their mind against mental assault and scrying."
	value = 5
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/power/psyker/ward_mind

/datum/action/cooldown/power/psyker/ward_mind
	name = "Ward Mind"
	desc = "Temporarily strengthens your mind to block out mental assaults. You become immune to various abilities that use the mental trait as well as resonance-based detection, such as a large variety of Psyker powers but also a handful of other interactions.\
	\n You gain Stress passively while active, and a moderate amount is gained whenever you block a mental ability."
	button_icon = 'icons/mob/actions/actions_elites.dmi'
	button_icon_state = "magic_box"
	cooldown_time = 15 SECONDS

	/// The status effect on the caster.
	var/datum/status_effect/power/ward_mind/active_effect

/datum/action/cooldown/power/psyker/ward_mind/Remove(mob/removed_from)
	. = ..()
	if(active_effect)
		qdel(active_effect)
		active_effect = null
	active = FALSE

/datum/action/cooldown/power/psyker/ward_mind/use_action(mob/living/user, atom/target)
	if(active_effect)
		qdel(active_effect)
		active_effect = null
		active = FALSE
		to_chat(user, span_notice("You let your mental guard down."))
	else
		active_effect = user.apply_status_effect(/datum/status_effect/power/ward_mind, src)
		active = TRUE
		to_chat(user, span_notice("Your mind wards against intrusion."))
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	return TRUE

/datum/status_effect/power/ward_mind
	id = "ward_mind"
	alert_type = /atom/movable/screen/alert/status_effect/ward_mind
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 1 SECONDS
	processing_speed = STATUS_EFFECT_FAST_PROCESS

	/// Stress per blocked antimagic charge.
	var/stress_per_charge = PSYKER_STRESS_MODERATE
	/// Per-second upkeep while active.
	var/stress_per_second = PSYKER_STRESS_TRIVIAL * 1.5
	/// Reference to the ward mind action.
	var/datum/action/cooldown/power/psyker/ward_mind/source_action

/atom/movable/screen/alert/status_effect/ward_mind
	name = "Ward Mind"
	desc = "You are immune to resonance-based detection and mental effects; but you passively generate stress."
	icon = 'icons/mob/actions/actions_elites.dmi'
	icon_state = "magic_box"


/datum/status_effect/power/ward_mind/on_creation(mob/living/new_owner, datum/action/cooldown/power/psyker/ward_mind/passed_action)
	. = ..()
	source_action = passed_action

/datum/status_effect/power/ward_mind/on_apply()
	if(!owner)
		return FALSE
	ADD_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, REF(src))
	RegisterSignal(owner, COMSIG_MOB_RECEIVE_MAGIC, PROC_REF(on_receive_magic), override = TRUE)
	RegisterSignal(owner, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	if(source_action)
		source_action.active = TRUE
		source_action.active_effect = src
		source_action.build_all_button_icons(UPDATE_BUTTON_STATUS)
	return TRUE

/datum/status_effect/power/ward_mind/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_RECEIVE_MAGIC)
		UnregisterSignal(owner, COMSIG_ATOM_DISPEL)
		REMOVE_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, REF(src))
	if(source_action)
		source_action.active = FALSE
		source_action.active_effect = null
		source_action.build_all_button_icons(UPDATE_BUTTON_STATUS)
	return

/// When any magical effect attempts to interact with us, attempt to block it if its mental.
/datum/status_effect/power/ward_mind/proc/on_receive_magic(mob/living/carbon/source, casted_magic_flags, charge_cost, list/antimagic_sources)
	SIGNAL_HANDLER
	if(!(casted_magic_flags & MAGIC_RESISTANCE_MIND))
		return NONE
	var/obj/item/organ/resonant/psyker/psyker_organ = owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!psyker_organ)
		return NONE
	adjust_stress_from_block(psyker_organ, charge_cost)
	if(psyker_organ.stress >= psyker_organ.stress_threshold)
		return NONE
	antimagic_sources += owner
	return COMPONENT_MAGIC_BLOCKED

/// Stresses out the psyker based on what we blocked and its charge cost.
/datum/status_effect/power/ward_mind/proc/adjust_stress_from_block(obj/item/organ/resonant/psyker/psyker_organ, charge_cost)
	if(!isnum(charge_cost) || charge_cost <= 0)
		return
	psyker_organ.modify_stress(charge_cost * stress_per_charge)

/// On dispel, end the status effect.
/datum/status_effect/power/ward_mind/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	qdel(src)
	return DISPEL_RESULT_DISPELLED

/datum/status_effect/power/ward_mind/tick(seconds_between_ticks)
	if(!source_action || QDELETED(source_action))
		qdel(src)
		return
	source_action.modify_stress(stress_per_second * seconds_between_ticks)
