/* Larp as a doctor and get bonus healing for it. Sure, it's all technically for show, but roleplay's the name of the game here.
 * - Gain 15% multiplied by the surgery location's efficiency multiplier if the target is laying down on a supported table or bed.
 * - Gain 15% if the target is on painkillers (trait_analgesia. Burden Revered synergy bby)
 * - Gain 20% if the target is sleeping or sedated.
 * All of these bonuses are additive with one-another but multiplicative with other modifiers. It is that juicy "more" keyword that ARPG players would kill for.

*/
/datum/power/theologist/doctors_craft
	name = "Doctor's Craft"
	desc = "Even if your healing magic works as is, you manage to mix your craft with modern technology to get the most out of it.\
	\nYour healing powers now heal more if the target is laying down on a table or bed (scaling with that location's surgery efficiency, 15% on an operating table), if the target is under the effect of painkillers (15%) and if they are sleeping or sedated (20%).\
	\nAll of these bonuses are additive with eachother, but the final number is multiplicative with other modifiers."
	value = 4
	power_flags = POWER_HUMAN_ONLY | POWER_HEALING

	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	menu_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	menu_icon_state = "gold_scalpel"

	/// Healing bonus granted by an operating table, used as the baseline for other surgery locations.
	var/operating_table_healing_bonus = 0.15
	/// Healing bonus granted when the target cannot feel pain.
	var/analgesia_healing_bonus = 0.15
	/// Healing bonus granted when the target is sleeping or unconscious.
	var/sedation_healing_bonus = 0.2

/datum/power/theologist/doctors_craft/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS, PROC_REF(add_healing_modifier))

/datum/power/theologist/doctors_craft/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS)

/// Adds bonuses for treating a properly positioned, pain-free, and/or sedated patient when healing is snapshotted.
/datum/power/theologist/doctors_craft/proc/add_healing_modifier(mob/living/source, atom/healing_target, list/additive_healing_modifiers, list/multiplicative_healing_modifiers)
	SIGNAL_HANDLER

	if(!istype(source) || !isliving(healing_target))
		return NONE

	var/mob/living/living_target = healing_target
	var/total_healing_bonus = 0

	// If the target is laying down at a sufficient surgery spot.
	if(living_target.body_position == LYING_DOWN)
		var/location_modifier = get_location_modifier(living_target)
		if(location_modifier > 0.5) // An unsupported turf returns the surgery baseline of 0.5.
			total_healing_bonus += operating_table_healing_bonus * location_modifier

	// If the target is under the effects of painkillers.
	if(HAS_TRAIT(living_target, TRAIT_ANALGESIA))
		total_healing_bonus += analgesia_healing_bonus

	// If the target is unconscious or asleep.
	if(living_target.IsSleeping() || living_target.IsUnconscious())
		total_healing_bonus += sedation_healing_bonus

	// Maths out the total bonus and sends it.
	if(total_healing_bonus)
		multiplicative_healing_modifiers += total_healing_bonus
	return NONE
