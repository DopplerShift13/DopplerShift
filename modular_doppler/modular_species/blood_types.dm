/datum/blood_type/insectoid
	name = BLOOD_TYPE_INSECTOID
	color = BLOOD_COLOR_INSECTOID
	restoration_chem = /datum/reagent/iron
	compatible_types = list(
		/datum/blood_type/insectoid,
	)

/datum/blood_type/synthetic
	name = BLOOD_TYPE_SYNTHETIC
	color = BLOOD_COLOR_SYNTHETIC
	compatible_types = list(
		/datum/blood_type/synthetic,
	)

/datum/blood_type/holosynth
	name = BLOOD_TYPE_HOLOGEL
	color = BLOOD_COLOR_HOLOGEL
	restoration_chem = /datum/reagent/silicon
	compatible_types = list(
		/datum/blood_type/holosynth,
	)

/datum/blood_type/holosynth/get_emissive_alpha(atom/source, is_worn = FALSE)
	if (is_worn)
		return 102
	return 125

/datum/blood_type/holosynth/set_up_blood(obj/effect/decal/cleanable/blood/blood, new_splat = FALSE)
	. = ..()
	blood.emissive_alpha = max(blood.emissive_alpha, new_splat ? 125 : 63)
	if (new_splat)
		return
	blood.can_dry = FALSE

/datum/blood_type/sap
	name = BLOOD_TYPE_SAP
	dna_string = "Plant DNA"
	color = /datum/reagent/consumable/sap::color
	reagent_type = /datum/reagent/consumable/sap
	restoration_chem = /datum/reagent/consumable/sugar
	blood_flags = BLOOD_ADD_DNA | BLOOD_TRANSFER_VIRAL_DATA
