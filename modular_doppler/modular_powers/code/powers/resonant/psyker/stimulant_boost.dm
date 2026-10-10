/*
	Caffeine, energy drink, what in essence modern society runs on.
	Not included with base chemotropic because these drinks usually don't have strong downsides and are really easy to acquire, so it warrants a cost.
*/

/datum/power/psyker_power/stimulant_boost
	name = "Stimulant Boost"
	desc = "You now also recover from stress while under the effects of stimulants, such as coffee, copious amounts of energy drinks or any other caffeinated substance. This is increased if you have the All Nighter quirk.\
	\nThis does not stack with any other forms of stress recovery you may be experiencing from the Chemotropic gland."
	security_record_text = "Subject can enhance their psychic abilities through stimulant consumption."

	value = 2
	required_powers = list(/datum/power/psyker_root/chemotropic)
	required_allow_subtypes = FALSE
	magic_flags = NONE // the only magic in chugging energy drinks is having your kidneys survive it.

	menu_icon = 'icons/obj/drinks/soda.dmi'
	menu_icon_state = "space_mountain_wind"

	/// Stress recovered per second while stimulated.
	var/stimulant_recovery_per_second = PSYKER_STRESS_TRIVIAL * 2.5
	/// Stress recovered per second while stimulated with the All-Nighter quirk.
	var/all_nighter_recovery_per_second = PSYKER_STRESS_TRIVIAL * 3

/datum/power/psyker_power/stimulant_boost/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_PSYKER_CHEMOTROPIC_RECOVERY_CANDIDATES, PROC_REF(add_stimulant_recovery_candidate))

/datum/power/psyker_power/stimulant_boost/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_PSYKER_CHEMOTROPIC_RECOVERY_CANDIDATES)

/// Adds stimulant recovery as an alternative to the organ's normal recovery.
/// Using the signaler basically tosses it to its final collection call and compares it against existing canidates.
/// Chemotropic always takes the highest, so if you already are doing drugs, this doesn't do anything.
/datum/power/psyker_power/stimulant_boost/proc/add_stimulant_recovery_candidate(mob/living/source, obj/item/organ/resonant/psyker/chemotropic/chemotropic_organ, list/recovery_candidates)
	SIGNAL_HANDLER

	// Originally this was going to be designed to be caffeine but nooo, we don't have that as chem, noooo we have to use this silly trait.
	if(isnull(chemotropic_organ) || !HAS_TRAIT(source, TRAIT_STIMULATED))
		return NONE

	var/recovery_per_second = stimulant_recovery_per_second
	if(source.has_quirk(/datum/quirk/all_nighter)) // Having all nighter (aka the caffeine addict quirk) increases the rate.
		recovery_per_second = all_nighter_recovery_per_second

	recovery_candidates += recovery_per_second
	return NONE
