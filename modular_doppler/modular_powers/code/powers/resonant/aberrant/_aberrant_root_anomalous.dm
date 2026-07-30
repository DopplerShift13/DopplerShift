/*
	Anomalous root. The anomaly root is largely a ribbon style power, but can be neat at times.
*/

/datum/power/aberrant_root/anomalous
	name = "Anomalous Origin"
	desc = "Things just don't add up with you. You can interact with anomalies to close them, as if you were using an anomaly neutralizer."
	security_record_text = "Subject has unusual properties when interacting with anomalies."
	value = 1

/datum/power/aberrant_root/anomalous/add(client/client_source)
	RegisterSignal(power_holder, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))

/datum/power/aberrant_root/anomalous/remove()
	UnregisterSignal(power_holder, COMSIG_LIVING_UNARMED_ATTACK)

/// Listener for hitting anomalies.
/datum/power/aberrant_root/anomalous/proc/on_unarmed_attack(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(!proximity || !istype(target, /obj/effect/anomaly))
		return NONE

	if(HAS_TRAIT(target, TRAIT_ILLUSORY_EFFECT))
		to_chat(source, span_notice("You pass your hand through [target], but nothing seems to happen. Is it really even there?"))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	var/obj/effect/anomaly/anomaly_target = target
	to_chat(source, span_notice("You reach out and touch [anomaly_target], disrupting the anomaly!"))
	anomaly_target.anomalyNeutralize()
	return COMPONENT_CANCEL_ATTACK_CHAIN
