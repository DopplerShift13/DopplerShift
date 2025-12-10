// Service

/datum/supply_pack/service/hydro_synthesizers
	name = "Hydroponics Plumbing Synthesizer Pack"
	desc = "Watering and feeding your plants got you down? Worry no further as this kit contains two each of water and hydroponics fertilizer synthesizers."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/machinery/plumbing/synthesizer/water_synth,
		/obj/machinery/plumbing/synthesizer/water_synth,
		/obj/machinery/plumbing/synthesizer/colony_hydroponics,
		/obj/machinery/plumbing/synthesizer/colony_hydroponics,
	)
	crate_name = "hydroponics synthesizers crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/frontier_kitchen
	name = "Frontier Kitchen Equipment"
	desc = "A range of frontier appliance classics, enough to set up a functioning kitchen no matter where you are in the galaxy."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/stock_parts/water_recycler,
		/obj/machinery/chem_dispenser/spice_machine/unanchored,
		/obj/machinery/chem_dispenser/big_drink_machine/unanchored,
		/obj/machinery/griddle/frontier_tabletop/unanchored,
		/obj/machinery/microwave/engineering/cell_included/unanchored,
		/obj/machinery/burner_plate/unanchored,
		/obj/item/flatpack/oven,
		/obj/item/reagent_containers/cup/soup_pot/lizard,
		/obj/item/cutting_board/modern,
		/obj/item/storage/box/colony_cookware,
	)
	crate_name = "frontier kitchen crate"

// Engineering

/datum/supply_pack/engineering/colony_starter
	name = "Outpost Starter Kit"
	desc = "Hunting for riches? Starting a new lfe all over? Extremely asocial? If you order now, we'll even throw in a lifetime \
		warranty for the flatpack of your fabricator. Contains most of what you should need in order to start fresh just about \
		anywhere uninhabited in the galaxy."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/flatpacked_machine,
		/obj/item/flatpacked_machine/gps_beacon,
		/obj/item/flatpack/organic_materials_printer,
		/obj/item/stack/sheet/plastic_wall_panel/fifty,
		/obj/item/stack/rods/twentyfive,
		/obj/item/stack/sheet/iron/thirty,
		/obj/item/stack/sheet/glass/twenty,
		/obj/item/flatpacked_machine/airlock_kit_manual,
		/obj/item/flatpacked_machine/airlock_kit_manual,
		/obj/item/stack/cable_coil/thirty,
		/obj/item/wallframe/apc,
		/obj/item/electronics/apc,
		/obj/item/stock_parts/power_store/battery/high,
		/obj/item/pickaxe/emergency,
		/obj/item/crowbar/red,
		/obj/item/multitool,
	)
	crate_name = "colonization kit crate"
