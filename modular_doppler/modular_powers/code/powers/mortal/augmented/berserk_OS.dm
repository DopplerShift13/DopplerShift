//An implant that injects you with demoneye on demand, acting like a bootleg Berserk OS

/datum/power/augmented/berserk_os
	name = "Premium Shellguard Munitions Horomone Regulator"
	desc = "The only official horomone regulator implant from Shellguard available on the market.\
	Often dubbed as the Qani-Laaca Sensory Implant's younger brother, it greatly alters the user's pain response and physical strength.\
	\n Injects you with a 'safe' dose of a combat cocktail on activation. Has an 'overcharge' function that grants you a larger dose at the cost of increased side-effects."
	security_record_text = "Subject has a Shellguard Munitions Horomone Regulator, prolonging their endurance in combat."
	security_threat = POWER_THREAT_MAJOR
	power_flags = POWER_HUMAN_ONLY
	var/disable_if_prisoner = TRUE

	value = 8 // To account for the buffs I've made to the demoneye drug, and the fact that this is a spinal implant.
	augment = /obj/item/organ/cyberimp/berserk_os
