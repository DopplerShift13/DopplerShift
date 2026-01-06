/datum/techweb_node/construction_lathe_everything
	id = TECHWEB_NODE_COLONY_EVERYTHING
	display_name = "Construction Autofab Designs"
	description = "All of the designs specific to the Construction Autofab."
	research_costs = list(
		TECHWEB_POINT_TYPE_GENERIC = 512, // You can't actually research this anyways
	)
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = TRUE
	design_ids = list(
		"colony_water_synth",
		"colony_hydro_synth",
		"gps_transmitter",
		"super_radiator",
		"wall_heater",
		"colony_manual_door",
		"colony_tiles",
		"colony_catwalk",
		"colony_panels",
		"manual_solar_panel",
		"manual_panel_advanced",
		"solar_cell_charger",
		"wall_cell_charger",
		"co2_cracker",
		"microlathe",
		"drinks_maker",
		"tabletop_griddle",
		"spice_market",
		"burner_plate",
		"arc_furnace",
		"battery_pack",
		"large_battery_pack",
		"colony_rtg",
		"sofie",
		"stirling_generator",
		"wind_turbine_colony",
		"colony_crowbar",
		"colony_screwdriver",
		"colony_wirecutters",
		"colony_wrench",
		"colony_biogenerator",
	)

/datum/design/board/organic_synthesizer
	name = "Organic Materials Printer Board"
	desc = /obj/machinery/biogenerator/organic_printer::desc
	id = "colony_biogenerator"
	build_path = /obj/item/circuitboard/machine/organic_printer
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/wind_turbine_colony
	name = "Wind Turbine Machine Board"
	desc = /obj/machinery/power/colony_wind_turbine::desc
	id = "wind_turbine_colony"
	build_path = /obj/item/circuitboard/machine/colony_wind_turbine
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/stirling_generator
	name = "Plasma Micro Turbine Machine Board"
	desc = /obj/machinery/power/stirling_generator::desc
	id = "stirling_generator"
	build_path = /obj/item/circuitboard/machine/plasma_mini_turbine
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/sofie
	name = "SOFIE-Type Generator Machine Board"
	desc = /obj/machinery/power/port_gen/pacman/solid_fuel::desc
	id = "sofie"
	build_path = /obj/item/circuitboard/machine/colony_generator
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/colony_rtg
	name = "RTG Machine Board"
	desc = /obj/machinery/power/rtg/portable::desc
	id = "colony_rtg"
	build_path = /obj/item/circuitboard/machine/colony_rtg
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/battery_pack_large
	name = "Large Battery Pack Machine Board"
	desc = /obj/machinery/power/smes/battery_pack/large::desc
	id = "large_battery_pack"
	build_path = /obj/item/circuitboard/machine/large_battery_pack
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/battery_pack
	name = "Battery Pack Machine Board"
	desc = /obj/machinery/power/smes/battery_pack::desc
	id = "battery_pack"
	build_path = /obj/item/circuitboard/machine/battery_pack
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/board/arc_furnace
	name = "Arc Furnace Machine Board"
	desc = /obj/machinery/arc_furnace::desc
	id = "arc_furnace"
	build_path = /obj/item/circuitboard/machine/arc_furnace
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)

/datum/design/board/burner_plate
	name = "Burner Plate Machine Board"
	desc = /obj/machinery/burner_plate::desc
	id = "burner_plate"
	build_path = /obj/item/circuitboard/machine/burner_plate
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/spice_market
	name = "Automatic Spice Cabinet Machine Board"
	desc = /obj/machinery/chem_dispenser/spice_machine::desc
	id = "spice_market"
	build_path = /obj/item/circuitboard/machine/spice_machine
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/tabletop_griddle
	name = "Drink Dispenser Machine Board"
	desc = /obj/machinery/griddle/frontier_tabletop::desc
	id = "tabletop_griddle"
	build_path = /obj/item/circuitboard/machine/table_griddle
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/drinks_maker
	name = "Drink Dispenser Machine Board"
	desc = /obj/machinery/chem_dispenser/big_drink_machine::desc
	id = "drinks_maker"
	build_path = /obj/item/circuitboard/machine/big_drink_machine
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/microlathe
	name = "Microlathe Machine Board"
	desc = /obj/machinery/autolathe/colony_amenities::desc
	id = "microlathe"
	build_path = /obj/item/circuitboard/machine/amenity_autolathe
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)

/datum/design/board/co2_cracker
	name = "CO2 Cracker Machine Board"
	desc = /obj/machinery/electrolyzer/co2_cracker::desc
	id = "co2_cracker"
	build_path = /obj/item/circuitboard/machine/co2_cracker
	build_type = COLONY_FABRICATOR
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)

/datum/design/colony_water_synth
	name = "Water Synthesizer Kit"
	id = "colony_water_synth"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/water_synth::custom_materials
	build_path = /obj/item/flatpacked_machine/water_synth
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/colony_hydro_synth
	name = "Hydroponics Synthesizer Kit"
	id = "colony_hydro_synth"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/hydro_synth::custom_materials
	build_path = /obj/item/flatpacked_machine/hydro_synth
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/gps_transmitter
	name = "GPS Beacon"
	id = "gps_transmitter"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/gps_beacon::custom_materials
	build_path = /obj/item/flatpacked_machine/gps_beacon
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/super_radiator
	name = "Heat Radiator"
	id = "super_radiator"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/lizard_heater::custom_materials
	build_path = /obj/item/flatpacked_machine/lizard_heater
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/wall_heater
	name = "Wall Heater"
	id = "wall_heater"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/wallframe/wall_heater::custom_materials
	build_path = /obj/item/wallframe/wall_heater
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/colony_manual_door
	name = "Manaul Airlock"
	id = "colony_manual_door"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/airlock_kit_manual::custom_materials
	build_path = /obj/item/flatpacked_machine/airlock_kit_manual
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION,
	)

/datum/design/colony_tiles
	name = "Plastic Floor Tile"
	id = "colony_tiles"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT / 4,
	)
	build_path = /obj/item/stack/tile/iron/colony
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION,
	)

/datum/design/colony_catwalk
	name = "Catwalk Tile"
	id = "colony_catwalk"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT / 4,
	)
	build_path = /obj/item/stack/tile/catwalk_tile/colony_lathe
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION,
	)

/datum/design/colony_panels
	name = "Plastic Panel"
	id = "colony_panels"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/stack/sheet/plastic_wall_panel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION,
	)

/datum/design/manual_solar_panel
	name = "Manual Solar Panel"
	id = "manual_solar_panel"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/manual_solar::custom_materials
	build_path = /obj/item/flatpacked_machine/manual_solar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/manual_panel_advanced
	name = "Advanced Manual Solar Panel"
	id = "manual_panel_advanced"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/manual_solar/adv::custom_materials
	build_path = /obj/item/flatpacked_machine/manual_solar/adv
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/solar_cell_charger
	name = "Solar Cell Charger"
	id = "solar_cell_charger"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/flatpacked_machine/solar_charger::custom_materials
	build_path = /obj/item/flatpacked_machine/solar_charger
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

/datum/design/wall_cell_charger
	name = "Mounted Cell Charger"
	id = "wall_cell_charger"
	build_type = COLONY_FABRICATOR
	materials = /obj/item/wallframe/cell_charger_multi::custom_materials
	build_path = /obj/item/wallframe/cell_charger_multi
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MACHINERY,
	)

// red crowbar has been exlcluded from the lmao chain due to prior involvements with law enforcement

/datum/design/colony_crowbar
	name = "Experimental Crowbar"
	id = "colony_crowbar"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/crowbar/red/caravan
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// red screwdriver lmao

/datum/design/colony_screwdriver
	name = "Experimental Screwdriver"
	id = "colony_screwdriver"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/screwdriver/caravan
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// red wrench lmao

/datum/design/colony_wrench
	name = "Experimental Wrench"
	id = "colony_wrench"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/wrench/caravan
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// red wirecutters lmao

/datum/design/colony_wirecutters
	name = "Experimental Wirecutters"
	id = "colony_wirecutters"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/wirecutters/caravan
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)
