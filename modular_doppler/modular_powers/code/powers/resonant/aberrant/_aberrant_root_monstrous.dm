// MORE BLOOD
/datum/power/aberrant_root/monstrous
	name = "Monstrous Body"
	desc = "If it bleeds, you can kill it. Just with you, blood doesn't really matter. You have 125% the normal blood capacity of your species, and regenerate blood that much faster as well.\
	\n The thresholds for being low on blood are unchanged, meaning you are extra resistent to bloodloss."
	security_record_text = "Subject's body contains and regenerates more blood."
	value = 3

	/// Target blood level while this power is active.
	var/target_blood_volume
	/// Tracks if we applied our regen multiplier so we can undo safely.
	var/regen_multiplier_applied
	/// How much extra blood capacity we have.
	var/extra_blood_mult = 1.25
	/// How much faster our blood regenerates.
	var/extra_blood_regen_mult = 1.25

/datum/power/aberrant_root/monstrous/add()
	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder) || HAS_TRAIT(human_holder, TRAIT_NOBLOOD))
		return

	target_blood_volume = BLOOD_VOLUME_NORMAL * extra_blood_mult
	human_holder.blood_volume = min(target_blood_volume, BLOOD_VOLUME_MAXIMUM)

	human_holder.physiology.blood_regen_mod *= extra_blood_regen_mult
	regen_multiplier_applied = TRUE

	RegisterSignal(human_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(handle_extra_blood_regen))


/datum/power/aberrant_root/monstrous/remove()
	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder))
		return

	UnregisterSignal(human_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD)

	if(regen_multiplier_applied)
		human_holder.physiology.blood_regen_mod /= extra_blood_regen_mult
		regen_multiplier_applied = FALSE

	if(human_holder.blood_volume > BLOOD_VOLUME_NORMAL)
		human_holder.blood_volume = BLOOD_VOLUME_NORMAL

	target_blood_volume = 0

/// So its hardcoded that blood caps out at BLOOD_VOLUME_NORMAL so we have to handle blood regen in our own way here.
/datum/power/aberrant_root/monstrous/proc/handle_extra_blood_regen(datum/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	if(!target_blood_volume)
		return

	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder) || HAS_TRAIT(human_holder, TRAIT_NOBLOOD))
		return

	if(human_holder.blood_volume < BLOOD_VOLUME_NORMAL || human_holder.blood_volume >= target_blood_volume)
		return

	var/blood_regen_amount = BLOOD_REGEN_FACTOR * human_holder.physiology.blood_regen_mod * seconds_per_tick
	human_holder.blood_volume = min(human_holder.blood_volume + blood_regen_amount, target_blood_volume)
