/*
	+5 to punch. Gateway to most of the martial arts stuff, just not a hard-root due to Mortal's design philosophy.
*/
/datum/power/warfighter/martial_artist
	name = "Martial Artist"
	desc = "Trained in specialized combat maneuvers, you know where to best strike your opponents. Your punches deal extra damage."
	value = 2

/datum/power/warfighter/martial_artist/add()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/power_guy = power_holder
	power_guy.unarmed_damage_bonus += 5

/datum/power/warfighter/martial_artist/remove()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/power_guy = power_holder
	power_guy.unarmed_damage_bonus -= 5

