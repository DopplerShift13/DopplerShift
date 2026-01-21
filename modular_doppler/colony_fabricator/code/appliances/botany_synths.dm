// Machine that makes water and nothing else

/obj/machinery/plumbing/synthesizer/water_synth
	name = "water synthesizer"
	desc = "An infinitely useful device for those finding themselves in a frontier without a stable source of water. \
		Using a simplified version of the chemistry dispenser's synthesizer process, it can create water out of nothing \
		but good old electricity."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "water_synth"
	anchored = FALSE
	/// Reagents that this can dispense, overrides the default list on init
	var/static/list/synthesizable_reagents = list(
		/datum/reagent/water,
	)

/obj/machinery/plumbing/synthesizer/water_synth/Initialize(mapload, bolt = FALSE, layer)
	. = ..()
	dispensable_reagents = synthesizable_reagents

// Deployable item for cargo for the water synth

/obj/item/flatpacked_machine/water_synth
	name = "water synthesizer parts kit"
	desc = /obj/machinery/plumbing/synthesizer/water_synth::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "water_synth_parts"
	w_class = WEIGHT_CLASS_NORMAL
	type_to_deploy = /obj/machinery/plumbing/synthesizer/water_synth
	deploy_time = 2 SECONDS
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)

// Machine that makes botany nutrients for hydroponics farming

/obj/machinery/plumbing/synthesizer/colony_hydroponics
	name = "hydroponics synthesizer"
	desc = "An infinitely useful device for those finding themselves in a frontier without a stable source of nutrients for crops. \
		Using a simplified version of the chemistry dispenser's synthesizer process, it can create hydroponics nutrients out of nothing \
		but good old electricity."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "hydro_synth"
	anchored = FALSE
	/// Reagents that this can dispense, overrides the default list on init
	var/static/list/synthesizable_reagents = list(
		/datum/reagent/plantnutriment/eznutriment,
		/datum/reagent/plantnutriment/left4zednutriment,
		/datum/reagent/plantnutriment/robustharvestnutriment,
		/datum/reagent/plantnutriment/endurogrow,
		/datum/reagent/plantnutriment/liquidearthquake,
		/datum/reagent/toxin/plantbgone/weedkiller,
		/datum/reagent/toxin/pestkiller,
		/datum/reagent/ash,
	)

/obj/machinery/plumbing/synthesizer/colony_hydroponics/Initialize(mapload, bolt = FALSE, layer)
	. = ..()
	dispensable_reagents = synthesizable_reagents

// Deployable item for cargo for the hydro synth

/obj/item/flatpacked_machine/hydro_synth
	name = "hydroponics chemical synthesizer parts kit"
	desc = /obj/machinery/plumbing/synthesizer/colony_hydroponics::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "hydro_synth_parts"
	w_class = WEIGHT_CLASS_NORMAL
	type_to_deploy = /obj/machinery/plumbing/synthesizer/colony_hydroponics
	deploy_time = 2 SECONDS
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
