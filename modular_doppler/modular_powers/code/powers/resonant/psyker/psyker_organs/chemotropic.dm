/*
	You do not passively regenerate stress, but you gain drastically increased stress loss (including in combat) from substances.
*/
/datum/power/psyker_root/chemotropic
	name = "Chemotropic Gland"
	desc = "An unnatural organ that grows inside the chest-cavity of Psykers. Required as a catalyst to wield Psyker powers.\
	\nThis gland particularly only functions through external chemical stimuli: particularly substances such as nicotine, ethanol and hard-drugs. You barely recover stress passively, but recover vast amounts from having any of the aforementioned\
	substances inside your bloodstream, with hard-drugs yielding more reecovery than nicotine and ethanol.\
	\nHaving matching negative quirks with the substance (such as the Smoker quirk with Nicotine) increases the stress recovery."
	security_record_text = "Subject wields psionic abilities and recovers from it through substance consumption."
	organ_type = /obj/item/organ/resonant/psyker/chemotropic

/obj/item/organ/resonant/psyker/chemotropic
	name = "chemotropic gland"
	desc = "An intrusive organ that should not even be able to function in most bodies. It responds to chemical stimuli in the bloodstream, accelerating psychic recovery in exchange for unhealthy dependency."
	icon = 'modular_doppler/modular_powers/icons/items/organs.dmi'
	icon_state = "chemotropic"
	recovery_per_second = PSYKER_STRESS_RECOVERY * 0.25
	matching_root_type = /datum/power/psyker_root/chemotropic
	stress_backlash_cooldown = 180 SECONDS // double duration between backlash events since you can be stuck on a tier from the lack of accessible recovery.

	/// Base amount to recover from chemicals, before all multipliers
	var/base_recovery_amount = PSYKER_STRESS_CHEMOTROPIC_POWER
	/// Multiplier for nicotine recovery. Keep in mind that smoking drip-feeds it.
	var/nicotine_multiplier = 0.5
	/// Multiplier for ethanol
	var/ethanol_multiplier = 0.5
	/// Multiplier for hard drugs
	var/hard_drugs_multiplier = 1

	/// Multiplier on how much quirks increase the appropriate stress gain.
	var/quirk_multiplier = 1.25

/// Returns the stress recovery multiplier granted by active chemical stimuli.
/obj/item/organ/resonant/psyker/chemotropic/proc/get_chemical_recovery_multiplier()
	if(!owner?.reagents?.reagent_list)
		return 0

	var/recovery_multiplier = 0
	for(var/datum/reagent/reagent as anything in owner.reagents.reagent_list)
		// Nicotine is relatively common and less hamrful so its less the power.
		if(istype(reagent, /datum/reagent/drug/nicotine))
			var/nicotine_recovery = nicotine_multiplier
			if(owner.has_quirk(/datum/quirk/item_quirk/addict/smoker))
				nicotine_recovery *= quirk_multiplier
			recovery_multiplier = max(recovery_multiplier, nicotine_recovery)
			continue
		// Alcoholism is still common but more directly hamrful so its a bit less power
		if(istype(reagent, /datum/reagent/consumable/ethanol))
			var/ethanol_recovery = ethanol_multiplier
			if(owner.has_quirk(/datum/quirk/item_quirk/addict/alcoholic))
				ethanol_recovery *= quirk_multiplier
			recovery_multiplier = max(recovery_multiplier, ethanol_recovery)
			continue
		// Doing drugs gets you full power. Go do drugs, kids.
		if(istype(reagent, /datum/reagent/drug))
			var/hard_drug_recovery = hard_drugs_multiplier
			if(owner.has_quirk(/datum/quirk/item_quirk/addict/junkie))
				hard_drug_recovery *= quirk_multiplier
			recovery_multiplier = max(recovery_multiplier, hard_drug_recovery)
			break

	return recovery_multiplier

/// Returns stress recovery per second based on substances in the host's bloodstream.
/obj/item/organ/resonant/psyker/chemotropic/get_stress_recovery_per_second()
	var/recovery_multiplier = get_chemical_recovery_multiplier()
	if(!recovery_multiplier)
		return recovery_per_second

	var/recovery_amount = base_recovery_amount * recovery_multiplier
	// Wrong root? Recover only a third as much.
	if(!has_matching_root())
		recovery_amount *= PSYKER_MISMATCHED_ORGAN_EFFICIENCY

	return recovery_amount + recovery_per_second
