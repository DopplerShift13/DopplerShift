/datum/export/material/aluminum
	cost = 35
	material_id = /datum/material/aluminum
	message = "cm3 of aluminum"

/datum/export/material/nanocarbon
	cost = 55
	material_id = /datum/material/nanocarbon
	message = "cm3 of nanocarbon"

/datum/export/salvage_generic
	cost = 75
	unit_name = "general salvage"
	export_types = list(
		/obj/structure/engine_covers/thruster_nozzle,
		/obj/structure/engine_covers/heater_cover,
		/obj/structure/shuttle_decoration/rcs,
		/obj/structure/shuttle_decoration/ladder,
		/obj/structure/shuttle_decoration/ladder_black,
		/obj/structure/shuttle_decoration/eva_catwalks,
		/obj/structure/shuttle_decoration/radiator,
		/obj/structure/shuttle_decoration/extinguisher,
		/obj/structure/shuttle_decoration/bullbar,
		/obj/structure/shuttle_decoration/headlight,
		/obj/structure/shuttle_decoration/landing_engine,
		/obj/structure/shuttle_decoration/aux_engine,
		/obj/structure/shuttle_decoration/junction_box,
	)

/datum/export/shipping_containers
	cost = 300
	unit_name = "salvaged shipping containers"
	export_types = list(
		/obj/structure/closet/shipping_container,
	)

/datum/export/salvage_scanners
	cost = 200
	unit_name = "salvaged sensor equipment"
	export_types = list(
		/obj/machinery/exoscanner/shuttle_part/radar_panel,
		/obj/machinery/exoscanner/shuttle_part/sensors_blister,
		/obj/machinery/exoscanner/shuttle_part/open_sensors_blister,
		/obj/machinery/exoscanner/shuttle_part/radio_dish,
	)

/datum/export/salvage_shipmind
	cost = 600
	unit_name = "recovered shipmind"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/battery/shipmind,
	)

/datum/export/salvage_reactor
	cost = 1000
	unit_name = "salvaged bloom reactor"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/reactor,
	)

/datum/export/salvage_reactor
	cost = 1500
	unit_name = "salvaged large bloom reactor"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/reactor/super,
	)

/datum/export/salvage_engines
	cost = 300
	unit_name = "salvaged engines"
	export_types = list(
		/obj/machinery/power/shuttle_engine/propulsion/salvage,
		/obj/machinery/power/shuttle_engine/heater/salvage,
		/obj/structure/engine_covers/ion_plate,
	)

/datum/export/salvage_hazard
	cost = 200
	unit_name = "hazardous salvage"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/battery,
		/obj/structure/shuttle_decoration/liquid_tank/coolant,
	)

/datum/export/salvage_munitions
	cost = 250
	unit_name = "salvaged munitions"
	export_types = list(
		/obj/structure/shuttle_decoration/munition/missile,
		/obj/structure/shuttle_decoration/munition/missile/orbital,
		/obj/structure/shuttle_decoration/munition/missile/extraorbital,
		/obj/structure/shuttle_decoration/munition/ciws,
		/obj/structure/shuttle_decoration/munition/autocannon,
		/obj/structure/shuttle_decoration/munition/chaff_flares,
	)

/datum/export/salvage_fuel
	cost = 200
	unit_name = "salvaged fuel tanks"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/explosive,
		/obj/structure/shuttle_decoration/liquid_tank/explosive/hydrazine,
		/obj/structure/shuttle_decoration/liquid_tank/explosive/lithium,
	)

/datum/export/salvage_fuel_big
	cost = 400
	unit_name = "salvaged large tanks"
	export_types = list(
		/obj/structure/shuttle_decoration/liquid_tank/explosive/industrial,
		/obj/structure/shuttle_decoration/liquid_tank/explosive/hydrazine/industrial,
		/obj/structure/shuttle_decoration/liquid_tank/explosive/lithium/industrial,
	)

/datum/export/salvage_crates
	cost = 150
	unit_name = "salvaged shipping crates"
	export_types = list(
		/obj/structure/closet/crate/shuttle,
		/obj/structure/closet/crate/shuttle/small,
		/obj/structure/closet/crate/shuttle_hard,
	)

/datum/export/salvage_airlocks
	cost = 100
	unit_name = "salvaged airlocks"
	export_types = list(
		/obj/structure/hull_plating/airlock,
		/obj/structure/hull_plating/airlock/interior,
		/obj/structure/hull_plating/airlock/access_panel,
	)
