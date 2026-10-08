/datum/power/theologist/do_no_harm
	name = "Do No Harm"
	desc = "Those that take the Hippocratic Oath abstain from all intentional wrong-doing and harm; and your adherence to this oath empowers you. \
	Your healing powers are increased by a percentage equal to your Piety, but you are now a pacifist and unable to do harm onto others."
	mob_trait = TRAIT_PACIFISM
	value = 3
	power_flags = POWER_HUMAN_ONLY | POWER_HEALING

	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	menu_icon = 'icons/obj/mining_zones/artefacts.dmi'
	menu_icon_state = "asclepius_active"

	/// How much of a multiplier Do No Harm gives per piety. Base healing * (1 + healing_bonus).
	var/healing_bonus = 0.01

/datum/power/theologist/do_no_harm/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS, PROC_REF(add_healing_modifier))

/datum/power/theologist/do_no_harm/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS)

/// Adds Do No Harm's percentage bonus to the additive healing modifiers while the holder remains a pacifist.
/datum/power/theologist/do_no_harm/proc/add_healing_modifier(mob/living/source, atom/healing_target, list/additive_healing_modifiers, list/multiplicative_healing_modifiers)
	SIGNAL_HANDLER

	if(!istype(source))
		return NONE
	// Just make sure Pacifism is still there.
	if(!HAS_TRAIT(source, TRAIT_PACIFISM))
		return NONE

	// Get the Piety component
	var/datum/component/theologist_piety/piety_component = source.GetComponent(/datum/component/theologist_piety)
	if(!piety_component || piety_component.piety <= 0)
		return NONE

	additive_healing_modifiers += (piety_component.piety * healing_bonus)
	return NONE
