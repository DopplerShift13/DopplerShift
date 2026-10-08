/datum/brain_trauma/magic/resonance_silenced
	name = "Aresonaphasia"
	desc = "Patient is unable to wield their own Resonant powers."
	scan_desc = "resonance silence"
	gain_text = span_notice("You feel like you're no longer in touch with your own Resonant powers.")
	lose_text = span_notice("You begin to feel your Resonant Powers returning.")

/datum/brain_trauma/magic/resonance_silenced/on_gain()
	owner.dispel(src)
	ADD_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/magic/resonance_silenced/on_lose()
	REMOVE_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAUMA_TRAIT)
	..()
