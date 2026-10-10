/* Makes your Burden Twisted heal more efficiently based on stored Piety, by dividing the damage dealt by (1 + (piety*0.02))
*/
/datum/power/theologist/twisted_pious_touch
	name = "Pious Touch"
	desc = "Your Burden Twisted now converts damage more efficiently relative to the stored Piety you possess. The amount is the base damage, divided by (1 + (Piety * 0.02)).\
	\nAs a point of measurement: at 50 Piety, this halves the amount of the damage you would normally inflict."
	security_record_text = "Subject's healing powers become more powerful with repeated use."
	value = 2
	required_powers = list(/datum/power/theologist_root/twisted)

	/// How much each point of Piety adds to Burden Twisted's conversion divider.
	var/piety_to_conversion_modifier = 0.02

/datum/power/theologist/twisted_pious_touch/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_THEOLOGIST_TWISTED_CONVERSION_MODIFIERS, PROC_REF(add_twisted_conversion_modifier))

/datum/power/theologist/twisted_pious_touch/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_THEOLOGIST_TWISTED_CONVERSION_MODIFIERS)

/// Adds the holder's current Piety contribution to Burden Twisted's conversion divider.
/datum/power/theologist/twisted_pious_touch/proc/add_twisted_conversion_modifier(mob/living/source, list/twisted_conversion_modifiers)
	SIGNAL_HANDLER

	if(!istype(source))
		return NONE

	var/datum/component/theologist_piety/piety_component = source.GetComponent(/datum/component/theologist_piety)
	if(!piety_component || piety_component.piety <= 0)
		return NONE

	twisted_conversion_modifiers += piety_component.piety * piety_to_conversion_modifier
	return NONE
