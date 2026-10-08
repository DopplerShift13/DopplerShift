// MORE BLOOD
/datum/power/aberrant_root/monstrous
	name = "Monstrous Body"
	desc = "If it bleeds, you can kill it. Just with you, blood doesn't really matter. You have 125% the normal blood capacity of your species, and regenerate blood that much faster as well.\
	\nThe thresholds for being low on blood are unchanged, meaning you are extra resistant to bloodloss.\
	\nIf your species lacks natural blood regen (e.g Hemophages), you also bleed out 35% slower from wounds."
	security_record_text = "Subject's body contains and regenerates more blood."
	value = 3
	menu_icon = 'icons/obj/medical/bloodpack.dmi'
	menu_icon_state = "generic_bloodpack"

	/// Target blood level while this power is active.
	var/target_blood_volume
	/// Tracks if we applied our regen multiplier so we can undo safely.
	var/regen_multiplier_applied
	/// Tracks if we applied our bleed multiplier so we can undo safely.
	var/bleed_multiplier_applied
	/// How much extra blood capacity we have.
	var/extra_blood_mult = 1.25
	/// How much faster our blood regenerates.
	var/extra_blood_regen_mult = 1.25
	/// How much we multiply the bleed rate with for mobs with TRAIT_NOHUNGER
	var/nohunger_bleed_mult = 0.65

/datum/power/aberrant_root/monstrous/add()
	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder) || HAS_TRAIT(human_holder, TRAIT_NOBLOOD))
		return

	target_blood_volume = BLOOD_VOLUME_NORMAL * extra_blood_mult

	human_holder.physiology.blood_regen_mod *= extra_blood_regen_mult
	regen_multiplier_applied = TRUE

	if(HAS_TRAIT(human_holder, TRAIT_NOHUNGER)) // yes, blood regen is arbitrated by this trait.
		human_holder.physiology.bleed_mod *= nohunger_bleed_mult
		bleed_multiplier_applied = TRUE

	RegisterSignal(human_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(handle_extra_blood_regen))

/// Adds your blood. In add_unique so it doesn't reset your blood if you acquire this power through power transfers.
/datum/power/aberrant_root/monstrous/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder) || HAS_TRAIT(human_holder, TRAIT_NOBLOOD))
		return

	human_holder.blood_volume = min(target_blood_volume, BLOOD_VOLUME_MAXIMUM)


/datum/power/aberrant_root/monstrous/remove()
	var/mob/living/carbon/human/human_holder = power_holder
	if(!istype(human_holder))
		return

	UnregisterSignal(human_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD)

	if(regen_multiplier_applied)
		human_holder.physiology.blood_regen_mod /= extra_blood_regen_mult
		regen_multiplier_applied = FALSE

	if(bleed_multiplier_applied)
		human_holder.physiology.bleed_mod /= nohunger_bleed_mult
		bleed_multiplier_applied = FALSE


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

	// Blood regen scales off of nutrtion and drains nutrition which we need to emulate that.
	if(HAS_TRAIT(human_holder, TRAIT_NOHUNGER))
		return
	var/nutrition_ratio = round(human_holder.nutrition / NUTRITION_LEVEL_WELL_FED, 0.2)
	if(human_holder.satiety > 80) // Base blood regen has this bonus too
		nutrition_ratio *= 1.25
	human_holder.adjust_nutrition(-nutrition_ratio * HUNGER_FACTOR * seconds_per_tick)

	var/blood_regen_amount = BLOOD_REGEN_FACTOR * human_holder.physiology.blood_regen_mod * nutrition_ratio * seconds_per_tick
	human_holder.blood_volume = min(human_holder.blood_volume + blood_regen_amount, target_blood_volume)
