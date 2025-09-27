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
		/datum/blood_type/synthetic,
	)
