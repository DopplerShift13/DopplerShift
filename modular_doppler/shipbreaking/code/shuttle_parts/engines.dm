/obj/machinery/power/shuttle_engine/heater/salvage
	name = "combustion chamber"
	desc = "Large tanks, turbopumps, valves, pipes, everything you need to combine chemical fuels into just the right \
		combination to work as a rocket rather than a giant bomb."
	icon = 'modular_doppler/shipbreaking/icons/exterior.dmi'
	icon_state = "chamber"
	circuit = null
	inertia_force_weight = 2
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 8,
	)

/obj/machinery/power/shuttle_engine/heater/salvage/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_RECYCLE_LIKE_ITEM, TRAIT_GENERIC)

// Don't want people accidentally deconstructing these and losing all the resources
/obj/machinery/power/shuttle_engine/heater/salvage/crowbar_act(mob/living/user, obj/item/tool)
	return

/obj/machinery/power/shuttle_engine/propulsion/salvage
	name = "chemical propulsion engine"
	desc = "The bell of an old type of chemical combustion engine for ship propulsion. Uses a comedically toxic \
		tri-propellant mix banned from the atmospheres of most inhabited planets with a specific impulse into the thousands of \
		seconds."
	icon = 'modular_doppler/shipbreaking/icons/exterior.dmi'
	icon_state = "engine"
	circuit = null
	inertia_force_weight = 2
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 12,
		/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 5,
	)

/obj/machinery/power/shuttle_engine/propulsion/salvage/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_RECYCLE_LIKE_ITEM, TRAIT_GENERIC)

// Don't want people accidentally deconstructing these and losing all the resources
/obj/machinery/power/shuttle_engine/propulsion/salvage/crowbar_act(mob/living/user, obj/item/tool)
	return
