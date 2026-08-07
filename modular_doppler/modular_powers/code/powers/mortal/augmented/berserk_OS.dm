//An implant that injects you with demoneye on demand, acting like a bootleg Berserk OS

/datum/power/augmented/berserk_os
	name = "Shellguard Munitions Horomone Regulator"
	desc = "Considered the Qani-Laaca Sensory Implant's younger brother, this spinal implant grants you an edge in combat.\
	\n Injects you with a 'safe' dose of a combat cocktail on activation. Has an 'overcharge' function that grants you a larger dose at the cost of increased side-effects."
	security_record_text = "Subject has a Shellguard Munitions Horomone Regulator, prolonging their endurance in combat."
	security_threat = POWER_THREAT_MAJOR

	value = 8 // To account for the buffs I've made to the demoneye drug, and the fact that this is a spinal implant.
	augment = /obj/item/organ/cyberimp/berserk_os
