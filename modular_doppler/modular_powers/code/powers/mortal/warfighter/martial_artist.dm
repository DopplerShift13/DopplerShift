/*
	+5 to punch. Gateway to most of the martial arts stuff, just not a hard-root due to Mortal's design philosophy.
*/
/datum/power/warfighter/martial_artist
	name = "Martial Artist"
	desc = "Trained in specialized combat maneuvers, you know where to best strike your opponents. Your punches deal extra damage."
	security_record_text = "Subject is trained in hand-to-hand combat and throws stronger punches."
	security_threat = POWER_THREAT_MAJOR
	value = 2

	power_flags = POWER_HUMAN_ONLY
	/// how much EEEEXTRA DEEEAAMEEEEG we do with our punches.
	var/bonus_damage = 5

/datum/power/warfighter/martial_artist/add()
	RegisterSignal(power_holder, COMSIG_HUMAN_UNARMED_HIT, PROC_REF(on_unarmed_hit))

/datum/power/warfighter/martial_artist/remove()
	UnregisterSignal(power_holder, COMSIG_HUMAN_UNARMED_HIT)

/// Sends a signal to the new signaler for unarmed punches.
/datum/power/warfighter/martial_artist/proc/on_unarmed_hit(mob/living/user, mob/living/target, obj/item/bodypart/affecting, damage, armor_block, limb_sharpness)
	SIGNAL_HANDLER
	if(!target || bonus_damage <= 0)
		return
	target.apply_damage(bonus_damage, BRUTE, affecting, armor_block, sharpness = limb_sharpness)
