/obj/item/circuitboard/machine/big_drink_machine
	name = "Drink Dispenser"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/big_drink_machine
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell = 1)
	def_components = list(/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell)
	needs_anchored = FALSE

/obj/machinery/chem_dispenser/big_drink_machine
	name = "drink dispenser"
	desc = "The most overbuilt coffee machine in the entire world, made to fit the varying palates of the many species \
		in the 4CA, within the limits of whatever technology you can stuff into a metal box."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "dispenser"
	base_icon_state = "dispenser"
	anchored = FALSE
	circuit = /obj/item/circuitboard/machine/big_drink_machine
	show_ph = FALSE
	base_reagent_purity = 0.5
	dispensable_reagents = list(
		/datum/reagent/water,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/corn_syrup,
		/datum/reagent/consumable/honey,
		/datum/reagent/consumable/astrotame,
		/datum/reagent/consumable/caramel,
		/datum/reagent/consumable/korta_milk,
		/datum/reagent/consumable/korta_nectar,
		/datum/reagent/consumable/milk,
		/datum/reagent/consumable/soymilk,
		/datum/reagent/consumable/cream,
		/datum/reagent/consumable/lemonade,
		/datum/reagent/consumable/coco,
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/tea,
		/datum/reagent/consumable/ice,
		/datum/reagent/consumable/mushroom_tea,
		/datum/reagent/consumable/vanilla,
	)

/obj/machinery/chem_dispenser/big_drink_machine/display_beaker()
	var/mutable_appearance/overlayed_beaker = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	overlayed_beaker.pixel_w = 0
	overlayed_beaker.pixel_z = 0
	return overlayed_beaker

/obj/machinery/chem_dispenser/big_drink_machine/unanchored
	anchored = FALSE
