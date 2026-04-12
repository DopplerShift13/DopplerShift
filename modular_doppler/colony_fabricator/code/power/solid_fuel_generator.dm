/obj/item/circuitboard/machine/colony_generator
	name = "SOFIE-Type Portable Generator"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/port_gen/pacman/solid_fuel
	needs_anchored = FALSE
	req_components = list(
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/cable_coil = 5,
	)

/obj/machinery/power/port_gen/pacman/solid_fuel
	name = "\improper SOFIE-type portable generator"
	desc = "The second most common generator design in the galaxy, second only to the P.A.C.M.A.N. \
		The S.O.F.I.E. (Stationary Operating Fuel Ignition Engine) is similar to other generators in \
		burning sheets of plasma in order to produce power. \
		Unlike other generators however, this one isn't as portable, or as safe to operate, \
		but at least it makes a hell of a lot more power. Must be <b>bolted to the ground</b> \
		and <b>attached to a wire</b> before use. A massive warning label wants you to know that this generator \
		<b>outputs waste heat and gasses to the air around it</b>."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "fuel_generator_0"
	base_icon_state = "fuel_generator"
	circuit = /obj/item/circuitboard/machine/colony_generator
	anchored = TRUE
	max_sheets = 25
	time_per_sheet = parent_type::time_per_sheet * (5 / 3) //66.6% better
	power_gen = parent_type::power_gen * 2.5
	drag_slowdown = 1.5
	sheet_path = /obj/item/stack/sheet/mineral/plasma

/obj/machinery/power/port_gen/pacman/solid_fuel/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/machinery/power/port_gen/pacman/solid_fuel/on_construction(mob/user, from_flatpack)
	return

/obj/machinery/power/port_gen/pacman/solid_fuel/process()
	. = ..()
	if(active)
		var/turf/where_we_spawn_air = get_turf(src)
		where_we_spawn_air.atmos_spawn_air("helium=10;TEMP=480")
