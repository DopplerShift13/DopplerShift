/datum/quirk/item_quirk/allergy_quirk
	name = "Chemical Allergy"
	desc = "You've got an allergy to a specific chemical."
	icon = FA_ICON_BRIEFCASE_MEDICAL
	value = 0
	gain_text = span_danger("You feel your immune system shift.")
	lose_text = span_notice("You feel your immune system phase back into perfect shape.")
	medical_record_text = "Patient has an allergy to a specific chemical."
	hardcore_value = 3
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/reagent_containers/hypospray/medipen) // epinephrine medipen stops allergic reactions
	no_process_traits = list(TRAIT_STASIS)
	var/allergy
	var/allergy_chem_name
	var/superlethal = FALSE

/datum/quirk/item_quirk/allergy_quirk/add(client/client_source)
	var/requested_allergy = client_source?.prefs.read_preference(/datum/preference/choiced/allergy_quirk)
	allergy = GLOB.possible_chemical_allergies[requested_allergy]
	superlethal = client_source?.prefs.read_preference(/datum/preference/toggle/allergy_super_lethal)
	var/datum/reagent/namehelper = allergy
	allergy_chem_name = initial(namehelper.name)
	name = "[allergy_chem_name] Allergy"
	medical_record_text = "Patient has an allergy to [allergy_chem_name]"
	RegisterSignal(quirk_holder, COMSIG_MOB_REAGENT_TICK, PROC_REF(block_metab))

/datum/quirk/item_quirk/allergy_quirk/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/clothing/accessory/dogtag/allergy/dogtag = new(get_turf(human_holder), allergy_chem_name)

	give_item_to_holder(dogtag, list(LOCATION_BACKPACK, LOCATION_HANDS), flavour_text = "Make sure medical staff can see this...", notify_player = TRUE)

/datum/quirk/item_quirk/allergy_quirk/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_REAGENT_TICK)

/datum/quirk/item_quirk/allergy_quirk/post_add()
	quirk_holder.add_mob_memory(/datum/memory/key/quirk_allergy, allergy_chem_name)
	to_chat(quirk_holder, span_boldnotice("You are allergic to [allergy_chem_name], make sure not to consume any of these!"))

/datum/quirk/item_quirk/allergy_quirk/proc/block_metab(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	if(!(source.reagents.has_reagent(allergy)))
		return NONE
	// Having epinephrine stops metabolization of an allergen, but doesn't remove it from the system (unless for some godforsaken reason you decided you want to be allergic to it.)
	if(source.reagents.has_reagent(/datum/reagent/medicine/epinephrine) && !(allergy == /datum/reagent/medicine/epinephrine))
		return COMSIG_MOB_STOP_REAGENT_METABOLISM
	// Give the person a bit of histamines and that's it.
	source.reagents.add_reagent(/datum/reagent/toxin/histamine, 1 * seconds_per_tick)
	// Unless this person REALLY wanted to die.
	if(superlethal)
		source.apply_damage(3 * seconds_per_tick, TOX)
		source.reagents.add_reagent(/datum/reagent/toxin/histamine, 2 * seconds_per_tick)
		if(SPT_PROB(10, seconds_per_tick))
			source.vomit(VOMIT_CATEGORY_DEFAULT)
			source.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN, ORGAN_SLOT_APPENDIX, ORGAN_SLOT_LUNGS, ORGAN_SLOT_HEART, ORGAN_SLOT_LIVER, ORGAN_SLOT_STOMACH), 10)
	return NONE

