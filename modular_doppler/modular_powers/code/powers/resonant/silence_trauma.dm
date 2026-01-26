/datum/brain_trauma/magic/resonance_silenced
	name = "Aresonaphasia"
	desc = "Patient is unable to wield their own Resonant powers."
	scan_desc = "resonance silenced"
	gain_text = span_notice("You feel like you're no longer in touch with your own Resonant powers.")
	lose_text = span_notice("You begin to feel your Resonant Powers returning.")

/datum/brain_trauma/magic/resonance_silenced/on_gain()
	// Dispel everything
	var/list/powers_list = owner.powers
	if(!length(powers_list))
		return

	for(var/datum/power/power_instance in powers_list)
		power_instance.dispel()

	// TODO: actually make the silence work (the spell_requirements code scares me)
	//ADD_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/magic/resonance_silenced/on_lose()
	//REMOVE_TRAIT(owner, TRAIT_RESONANCE_SILENCED, TRAUMA_TRAIT)
	..()
