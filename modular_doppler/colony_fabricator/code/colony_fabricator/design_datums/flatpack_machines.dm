// Machine categories

#define FABRICATOR_CATEGORY_FLATPACK_MACHINES "/Flatpacked Machines"
#define FABRICATOR_SUBCATEGORY_MANUFACTURING "/Manufacturing"
#define FABRICATOR_SUBCATEGORY_POWER "/Power"
#define FABRICATOR_SUBCATEGORY_MATERIALS "/Materials"
#define FABRICATOR_SUBCATEGORY_ATMOS "/Atmospherics"

// Techweb node that shouldnt show up anywhere ever specifically for the fabricator to work with

/datum/techweb_node/colony_fabricator_flatpacks
	id = TECHWEB_NODE_COLONY_FLATPACKS
	display_name = "Colony Fabricator Flatpack Designs"
	description = "Contains all of the colony fabricator's flatpack machine designs."
	design_ids = list(
		"flatpack_arc_furnace",
		"flatpack_colony_fab",
		"flatpack_fuel_generator",
		"flatpack_turbine_team_fortress_two",
		"flatpack_bootleg_teg",
		"big_battery_lmfao",
		"extra_big_battery_lmfao",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 50000000000000) // God save you
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = TRUE

// Lets the colony lathe make more colony lathes but at very hihg cost, for fun

/datum/design/flatpack_colony_fabricator
	name = "Flat-Packed Colony Fabricator"
	desc = "A deployable fabricator capable of producing other flat-packed machines and other special equipment tailored for \
		rapidly constructing functional structures given resources and power. While it cannot be upgraded, it can be repacked \
		and moved to any location you see fit."
	id = "flatpack_colony_fab"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 7.5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/flatpacked_machine
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_MANUFACTURING,
	)
	construction_time = 2 MINUTES

// Big battery lmfao

/datum/design/board/battery_pack
	name = "Battery Pack"
	desc = "A collection of large power cells wired together inside of a non-conductive box in order to stop people \
		like you from touching them and electrocuting yourself. You get the general idea that this thing should be kept \
		well away from water and fire, lest you suffer the wrath of whatever's inside the battery."
	id = "big_battery_lmfao"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/battery_pack
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_POWER,
	)

/datum/design/board/large_battery_pack
	name = "Large Battery Pack"
	desc = "A large collection of large power cells wired together inside of a non-conductive box in order to stop people \
		like you from touching them and electrocuting yourself. This one is much larger than usual, a veritable \
		mountain of batteries just waiting to catch on fire. You get the general idea that this thing should be kept \
		well away from water and fire, lest you suffer the wrath of whatever's inside the battery."
	id = "extra_big_battery_lmfao"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/large_battery_pack
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_POWER,
	)

// Arc furance

/datum/design/board/flatpack_arc_furnace
	name = "Arc Furnace"
	desc = "A deployable furnace for refining ores. While slower and less safe than conventional refining methods, \
		it multiplies the output of refined materials enough to still outperform simply recycling ore."
	id = "flatpack_arc_furnace"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/arc_furnace
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_MATERIALS,
	)

// PACMAN generator but epic!!

/datum/design/board/flatpack_solids_generator
	name = "S.O.F.I.E. Generator"
	desc = "A deployable plasma-burning generator capable of outperforming even upgraded P.A.C.M.A.N. type generators, \
		at expense of creating hot carbon dioxide exhaust."
	id = "flatpack_fuel_generator"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/colony_generator
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_POWER,
	)

// Wind turbine, produces tiny amounts of power when placed outdoors in an atmosphere, but makes significantly more if there's a storm in that area

/datum/design/board/flatpack_turbine_team_fortress_two
	name = "Miniature Wind Turbine"
	id = "flatpack_turbine_team_fortress_two"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/colony_wind_turbine
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_POWER,
	)

// Stirling generator, kinda like a TEG but on a smaller scale and producing less insane amounts of power

/datum/design/board/flatpack_bootleg_teg
	name = "Plasma Micro-Turbine"
	desc = "A compact turbine engine that consumes small amounts of plasma gas in order to produce a large \
		amount of power, in exchange for outputting a waste gas from the process out at freezing temperatures. \
		You should absolutely not stick your hand into the exposed fan blades out of the top."
	id = "flatpack_bootleg_teg"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/circuitboard/machine/plasma_mini_turbine
	category = list(
		RND_CATEGORY_INITIAL,
		FABRICATOR_CATEGORY_FLATPACK_MACHINES + FABRICATOR_SUBCATEGORY_POWER,
	)

#undef FABRICATOR_CATEGORY_FLATPACK_MACHINES
#undef FABRICATOR_SUBCATEGORY_MANUFACTURING
#undef FABRICATOR_SUBCATEGORY_POWER
#undef FABRICATOR_SUBCATEGORY_MATERIALS
#undef FABRICATOR_SUBCATEGORY_ATMOS
