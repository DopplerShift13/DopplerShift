/datum/martial_art/krav_maga
	COOLDOWN_DECLARE(attack_cooldown)

/datum/martial_art/krav_maga/check_streak(mob/living/attacker, mob/living/defender)
	if(attack_cooldown > world.time)
		defender.balloon_alert(attacker,"On Cooldown")
		return FALSE
	. = ..()

	if(.)
		attack_cooldown = world.time + 5 SECONDS
