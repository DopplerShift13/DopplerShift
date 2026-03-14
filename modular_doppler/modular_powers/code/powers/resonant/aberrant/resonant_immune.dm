/*
	You're immune to resonant antics! But also you're permanently silenced.
*/
/datum/power/aberrant/counter_resonance
	name = "Counter-Resonance Anomaly"
	desc = "You have a counteractive effect on resonance-based phenomena. You are immune to resonance-based effects (but not the highly advanced magics wielded by some antagonistic forces), and you cannot use any resonance-based powers.\
	\n (Silencing only affects active powers; passive powers, such as Radiosyntehsis, are unaffected.)"
	security_record_text = "Subject is immune to resonance-based phenomena and is unable to wield them."
	security_threat = POWER_THREAT_MAJOR
	value = 9

	required_powers = list(/datum/power/aberrant_root/anomalous)

/datum/power/aberrant/counter_resonance/add()
	ADD_TRAIT(power_holder, TRAIT_ANTIRESONANCE, src)
	ADD_TRAIT(power_holder, TRAIT_RESONANCE_SILENCED, src)

/datum/power/aberrant/counter_resonance/remove()
	REMOVE_TRAIT(power_holder, TRAIT_ANTIRESONANCE, src)
	REMOVE_TRAIT(power_holder, TRAIT_RESONANCE_SILENCED, src)
