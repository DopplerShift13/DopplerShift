/*
	1.5x speed/action success chance on surgery.
	Fun fact fail_prob_index is flat amounts so we are actually giving a -50 flat which is hella busted, but also imho surgery failure chance doesn't exist outside of ghetto.
*/

/datum/power/expert/master_surgeon
	name = "Master Surgeon"
	desc = " Surgery takes composure and skill which you have aplenty. Increases your success rate and action speed with surgery by a factor of 1.5x."
	security_record_text = "Subject has an unusual skill in surgery."
	value = 4
	/// 1.5x faster => multiply time by 1/1.5
	var/surgery_speed_mult = 1 / 1.5
	/// Flat reduction to failure chance (percentage points)
	var/surgery_fail_reduction = 50

/datum/power/expert/master_surgeon/add()
	RegisterSignal(power_holder, COMSIG_LIVING_INITIATE_SURGERY_STEP, PROC_REF(apply_surgery_bonuses))

/datum/power/expert/master_surgeon/remove()
	UnregisterSignal(power_holder, COMSIG_LIVING_INITIATE_SURGERY_STEP)

/// Applies the modifiers to surgery when we perform a step.
/datum/power/expert/master_surgeon/proc/apply_surgery_bonuses(mob/living/_source, mob/living/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, datum/surgery_step/step, list/modifiers)
	SIGNAL_HANDLER
	modifiers[FAIL_PROB_INDEX] -= surgery_fail_reduction
	modifiers[SPEED_MOD_INDEX] *= surgery_speed_mult

