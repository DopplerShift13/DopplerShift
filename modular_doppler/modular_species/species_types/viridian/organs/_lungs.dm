/obj/item/organ/lungs/pod
	name = "viridian vacuole"
	desc = "A large organelle designed to store oxygen and other important gasses."
	breath_noise = "a humid hiss"
	foodtype_flags = PODPERSON_ORGAN_FOODTYPES
	color = COLOR_LIME

/obj/item/organ/lungs/pod/Initialize(mapload)
	. = ..()
	add_gas_reaction(/datum/gas/carbon_dioxide, while_present = PROC_REF(consume_co2))

/obj/item/organ/lungs/pod/proc/consume_co2(mob/living/carbon/breather, datum/gas_mixture/breath, co2_pp, old_co2_pp)
	var/gas_breathed = breath.gases[/datum/gas/carbon_dioxide][MOLES]
	breath.gases[/datum/gas/carbon_dioxide][MOLES] -= gas_breathed
	breath_out.assert_gases(/datum/gas/oxygen)
	breath_out.gases[/datum/gas/oxygen][MOLES] += gas_breathed * 3
