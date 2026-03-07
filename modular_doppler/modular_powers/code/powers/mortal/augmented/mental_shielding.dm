/*
	Blocks mental magic and scrying. Rather than adding the antimagic component we handle it here because we need to handle charge_cost in our own way (convert it to quality).
*/
/datum/power/augmented/mental_shielding
	name = "Premium TNFL Mental Shielding Implant"
	desc = " Based on the nullifying effects that tinfoil has on certain magical phenomena, this dermal implant creates a protective coating around your brain.\
	\n Creates a barrier that blocks resonant based scrying, as well as mental abilities used on you (including magic stronger than Resonant).\
	\n Blocking mental abilities consumes quality, increasing consumption rate the lower the quality is."

	value = 6
	augment = /obj/item/organ/cyberimp/brain/mental_shielding

/obj/item/organ/cyberimp/brain/mental_shielding
	name = "TNFL Mental Shielding Implant"
	desc = "Based on the nullifying effects that tinfoil has on certain magical phenomena, this dermal implant creates a protective coating around your brain. \
		Creates a barrier that blocks resonant based scrying, as well as mental abilities used on you (including magic stronger than Resonant). \
		Blocking mental abilities consumes quality, increasing consumption rate the lower the quality is."
	icon_state = "brain_implant_connector"
	slot = ORGAN_SLOT_BRAIN_CNS
	actions_types = list(/datum/action/item_action/organ_action/premium/use)

	var/enabled = TRUE

	// the factor with which we multiply the final cost of anti-mental
	var/mental_mult = 5

/obj/item/organ/cyberimp/brain/mental_shielding/Initialize(mapload)
	. = ..()
	if(!premium)
		premium = new /datum/premium_augment(src)
		premium.refurb_parts = list(
			/obj/item/stack/sheet/iron = 3,
			/obj/item/stack/cable_coil = 2)

// Registers antimagic signals
/obj/item/organ/cyberimp/brain/mental_shielding/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	RegisterSignal(receiver, COMSIG_MOB_RECEIVE_MAGIC, PROC_REF(on_receive_magic), override = TRUE)
	if(enabled)
		ADD_TRAIT(receiver, TRAIT_ANTIRESONANCE_SCRYING, IMPLANT_TRAIT)

// Unregisters antimagic signals
/obj/item/organ/cyberimp/brain/mental_shielding/on_mob_remove(mob/living/carbon/owner, special, movement_flags)
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_RECEIVE_MAGIC)
	REMOVE_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, IMPLANT_TRAIT)

// Listener to check if it can block. Basically we just check if the quality is not 0.
// Direct hook for antimagic signals, avoids component deletion behavior.
/obj/item/organ/cyberimp/brain/mental_shielding/proc/on_receive_magic(mob/living/carbon/source, casted_magic_flags, charge_cost, list/antimagic_sources)
	SIGNAL_HANDLER
	if(!enabled || !premium?.can_function())
		return NONE
	if(!(casted_magic_flags & MAGIC_RESISTANCE_MIND))
		return NONE
	antimagic_sources += src
	var/adjusted_cost = process_quality_cost(max(1, charge_cost))
	premium.adjust_quality(-adjusted_cost)
	return COMPONENT_MAGIC_BLOCKED

/// Convert an antimagic charge cost into a quality cost.
/obj/item/organ/cyberimp/brain/mental_shielding/proc/process_quality_cost(raw_cost)
	if(raw_cost <= 0 || !premium)
		return 0
	var/efficiency = premium?.get_efficiency() || 0
	if(efficiency <= 0)
		return 0
	var/mult = (AUGMENTED_PREMIUM_EFFICIENCY_HIGH / efficiency) * mental_mult
	return max(1, round(raw_cost * mult))

/obj/item/organ/cyberimp/brain/mental_shielding/use_action()
	if(!owner)
		return FALSE
	enabled = !enabled
	if(enabled)
		ADD_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, IMPLANT_TRAIT)
		to_chat(owner, span_notice("Your [name] hums as it activates."))
	else
		REMOVE_TRAIT(owner, TRAIT_ANTIRESONANCE_SCRYING, IMPLANT_TRAIT)
		to_chat(owner, span_notice("Your [name] powers down."))
	return enabled
