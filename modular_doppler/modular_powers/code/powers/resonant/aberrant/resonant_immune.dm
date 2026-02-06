/*
	You're immune to resonant antics! But also you're permanently silenced.
*/
/datum/power/aberrant/anomaly/counter_resonance
	name = "Counter-Resonance Anomaly"
	desc = "You have a counteractive effect on resonance-based phenomena. You are immune to resonance-based effects (but not the highly advanced magics wielded by some antagonistic forces), and you cannot use any resonance-based powers."
	value = 9

	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_ABERRANT

/datum/power/aberrant/anomaly/counter_resonance/add()
	ADD_TRAIT(power_holder, TRAIT_ANTIRESONANCE, src)
	ADD_TRAIT(power_holder, TRAIT_RESONANCE_SILENCED, src)

/datum/power/aberrant/anomaly/counter_resonance/remove()
	REMOVE_TRAIT(power_holder, TRAIT_ANTIRESONANCE, src)
	REMOVE_TRAIT(power_holder, TRAIT_RESONANCE_SILENCED, src)
