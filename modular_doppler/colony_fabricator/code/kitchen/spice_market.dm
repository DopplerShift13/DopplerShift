/obj/item/circuitboard/machine/spice_machine
	name = "Automatic Spice Cabinet"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/spice_machine
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell = 1,
	)
	def_components = list(/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell)
	needs_anchored = FALSE

/obj/machinery/chem_dispenser/spice_machine
	name = "automatic spice cabinet"
	desc = "A large glass box filled with most of the spices and sauces you could really imagine to exist. \
		A moving arm collects from inside the shelves and drops straight into whatever container you stick in \
		the side."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "spicer"
	base_icon_state = "spicer"
	working_state = "spicer_working"
	nopower_state = "spicer_nopower"
	anchored = TRUE
	circuit = /obj/item/circuitboard/machine/spice_machine
	show_ph = FALSE
	base_reagent_purity = 0.5
	dispensable_reagents = list(
		// Frying
		/datum/reagent/consumable/nutriment/fat,
		/datum/reagent/consumable/nutriment/fat/oil,
		/datum/reagent/consumable/nutriment/fat/oil/olive,
		/datum/reagent/consumable/nutriment/fat/oil/corn,
		// I'm gonna sauce ye
		/datum/reagent/consumable/soysauce,
		/datum/reagent/consumable/ketchup,
		/datum/reagent/consumable/capsaicin,
		/datum/reagent/consumable/mayonnaise,
		/datum/reagent/consumable/bbqsauce,
		/datum/reagent/consumable/vinegar,
		/datum/reagent/consumable/worcestershire,
		// Seasonings
		/datum/reagent/consumable/salt,
		/datum/reagent/consumable/blackpepper,
		/datum/reagent/consumable/red_bay,
		/datum/reagent/consumable/curry_powder,
		// Flour (and rice)
		/datum/reagent/consumable/flour,
		/datum/reagent/consumable/rice_flour,
		/datum/reagent/consumable/korta_flour,
		/datum/reagent/consumable/cornmeal,
		/datum/reagent/consumable/corn_starch,
		/datum/reagent/consumable/rice,
		// Other Stuff
		/datum/reagent/consumable/enzyme,
		/datum/reagent/consumable/eggyolk,
		/datum/reagent/consumable/eggwhite,
		/datum/reagent/consumable/char,
		/datum/reagent/consumable/peanut_butter,
		/datum/reagent/consumable/cherryjelly,
		/datum/reagent/consumable/yoghurt,
		/datum/reagent/consumable/dashi_concentrate,
		/datum/reagent/consumable/grounding_solution,
		/datum/reagent/medicine/salglu_solution, // You cook with this just believe me here
	)

/obj/machinery/chem_dispenser/spice_machine/display_beaker()
	var/mutable_appearance/overlayed_beaker = beaker_overlay || mutable_appearance(icon, "spice_beaker")
	overlayed_beaker.pixel_w = 0
	overlayed_beaker.pixel_z = 0
	return overlayed_beaker

/obj/machinery/chem_dispenser/spice_machine/unanchored
	anchored = FALSE
