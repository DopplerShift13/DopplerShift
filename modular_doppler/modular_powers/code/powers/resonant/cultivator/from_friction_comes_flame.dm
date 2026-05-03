/*
	Punches cause heat build-up; sets on fire at a certain heat target (warm-bloods beware!)
*/
/datum/power/cultivator/from_friction_comes_flame
	name = "From Friction Comes Flame"
	desc = "Your punches while in alignment cause the target to heat up. Once they reach 80C, your strikes also combust the target."
	security_record_text = "Subject heats up and ignites targets with their punches while in their heightened state."
	security_threat = POWER_THREAT_MAJOR
	value = 3
	required_powers = list(/datum/power/cultivator_root/flame_soul)

	/// how much we BRING THE HEAT on our punches
	var/bonus_heat = 20
	/// the flame stacks we apply per punch
	var/bonus_flame_stacks = 0.15
	/// the threshold on setting targets on fire in KELVIN (basically celcius but +273)
	var/temperature_threshold = 353
	/// reference to flame soul alignment
	var/datum/action/cooldown/power/cultivator/alignment/flame_soul/flame_soul_alignment

/datum/power/cultivator/from_friction_comes_flame/add()
	RegisterSignal(power_holder, COMSIG_HUMAN_UNARMED_HIT, PROC_REF(on_unarmed_hit))

/datum/power/cultivator/from_friction_comes_flame/remove()
	UnregisterSignal(power_holder, COMSIG_HUMAN_UNARMED_HIT)

/// Sends a signal to the new signaler for unarmed punches.
/// Will probably be used a lot more with cultivator.
/datum/power/cultivator/from_friction_comes_flame/proc/on_unarmed_hit(mob/living/user, mob/living/target, obj/item/bodypart/affecting, damage, armor_block, limb_sharpness)
	SIGNAL_HANDLER
	if(!target || !is_flame_soul_alignment_active(user))
		return
	target.adjust_bodytemperature(bonus_heat, 0, 1000)
	if(target.bodytemperature >= temperature_threshold)
		target.adjust_fire_stacks(bonus_flame_stacks)
		target.ignite_mob()

/// Checks if our alignment is active.
/datum/power/cultivator/from_friction_comes_flame/proc/is_flame_soul_alignment_active(mob/living/user)
	if(!flame_soul_alignment)
		for(var/datum/action/cooldown/power/cultivator/alignment/flame_soul/alignment_action in user.actions)
			flame_soul_alignment = alignment_action
			break
		if(!flame_soul_alignment)
			return FALSE
	return flame_soul_alignment.active
