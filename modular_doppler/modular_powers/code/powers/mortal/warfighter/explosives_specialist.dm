/datum/power/warfighter/explosives_specialist
	name = "Explosives Specialist"
	desc = "Bombs and grenades are your forte. You can see the countdown on grenades (and bombs, but practically all bombs already come with a display for DRAMATIC FLAIR)."
	security_record_text = "Subject is specialized in explosives, and can estimate the detonation time on grenades and explosives."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	required_powers = list(/datum/power/warfighter/quick_draw)
	mob_trait = TRAIT_POWER_EXPLOSIVES_SPECIALIST

// See modular_doppler\modular_powers\code\powers\mortal\warfighter\components\grenade_components.dm for how we add the timers
