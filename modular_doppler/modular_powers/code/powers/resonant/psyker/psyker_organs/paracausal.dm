/*
	The vanilla option. Has passive-regen and the associated power grants it meditation.
*/
/datum/power/psyker_root/paracausal
	name = "Paracausal Gland"
	desc = "An unnatural organ that grows inside the chest-cavity of Psykers. Required as a catalyst to wield Psyker powers.\
	\nYou passively recover stress, which can be boosted by using the Meditate power while holding still."
	security_record_text = "Subject wields psionic abilities."
	organ_type = /obj/item/organ/resonant/psyker/paracausal

/obj/item/organ/resonant/psyker/paracausal
	name = "paracausal gland"
	desc = "An intrusive organ that should not even be able to function in most bodies. Commonly found in the bodies of Psykers. Though many would try to implement these into themselves to try and awaken psychic powers, \
	its presence in those without such powers is often life-threatening."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "demon_heart-on"
	recovery_per_second = PSYKER_STRESS_RECOVERY
	matching_root_type = /datum/power/psyker_root/paracausal

	/// Meditation action owned by this organ.
	var/datum/action/cooldown/power/resonant_meditate/meditate_action

/// Cleans up the organ-owned meditation action.
/obj/item/organ/resonant/psyker/paracausal/Destroy()
	QDEL_NULL(meditate_action)
	return ..()

/// Grants or removes the meditation action when this organ is inserted.
/obj/item/organ/resonant/psyker/paracausal/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	update_meditate_action(organ_owner)

/// Removes the meditation action when this organ leaves a host.
/obj/item/organ/resonant/psyker/paracausal/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	remove_meditate_action(organ_owner)
	return ..()

/// Keeps the organ-owned meditation action in sync with the current host.
/obj/item/organ/resonant/psyker/paracausal/on_life(seconds_per_tick, times_fired)
	. = ..()
	update_meditate_action(owner)

/// Ensures the current host only has meditation while they possess a compatible psyker root.
/obj/item/organ/resonant/psyker/paracausal/proc/update_meditate_action(mob/living/carbon/organ_owner)
	if(!organ_owner)
		return

	if(!meditate_action)
		meditate_action = new(src)

	if(has_compatible_root())
		if(meditate_action.owner != organ_owner)
			meditate_action.Grant(organ_owner)
		return

	remove_meditate_action(organ_owner)

/// Removes this organ's meditation action from the given host.
/obj/item/organ/resonant/psyker/paracausal/proc/remove_meditate_action(mob/living/carbon/organ_owner)
	if(!meditate_action || !organ_owner)
		return

	meditate_action.Remove(organ_owner)
