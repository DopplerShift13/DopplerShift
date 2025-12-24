/obj/item/circuitboard/machine/colony_lathe
	name = "Construction Autofab"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/rnd/production/colony_lathe
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 2,
	)

/obj/machinery/rnd/production/colony_lathe
	name = "construction autofab"
	desc = "These bad boys are seen just about anywhere someone would want or need to build fast, damn the consequences. \
		That tends to be colonies, especially on dangerous worlds, where the influences of this one machine can be seen \
		in every bit of architecture."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "colony_lathe"
	base_icon_state = "colony_lathe"
	circuit = /obj/item/circuitboard/machine/colony_lathe
	production_animation = "colony_lathe_progress"
	light_color = LIGHT_COLOR_BRIGHT_YELLOW
	light_power = 5
	allowed_buildtypes = COLONY_FABRICATOR

/obj/machinery/rnd/production/colony_lathe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)
	// We don't get new designs but can't print stuff if something's not researched, so we use the web that has everything researched
	stored_research = locate(/datum/techweb/admin) in SSresearch.techwebs

/obj/machinery/rnd/production/colony_lathe/finalize_build()
	. = ..()
	flick("colony_lathe_finish_print", src)

/obj/machinery/rnd/production/colony_lathe/flick_animation(datum/material/mat_ref)
	flick_overlay_view(material_insertion_animation(mat_ref), 1 SECONDS)

// We take from all nodes even unresearched ones
/obj/machinery/rnd/production/colony_lathe/update_designs()
	var/previous_design_count = cached_designs.len
	cached_designs.Cut()
	for(var/design_id in SSresearch.techweb_designs)
		var/datum/design/design = SSresearch.techweb_designs[design_id]
		if((isnull(allowed_department_flags) || (design.departmental_flags & allowed_department_flags)) && (design.build_type & allowed_buildtypes))
			cached_designs |= design
	var/design_delta = cached_designs.len - previous_design_count
	if(design_delta > 0)
		say("Received [design_delta] new design[design_delta == 1 ? "" : "s"].")
		playsound(src, 'sound/machines/beep/twobeep_high.ogg', 50, TRUE)
	update_static_data_for_all_viewers()

// Item for carrying the lathe around and building it

/obj/item/flatpacked_machine
	name = "flat-packed construction autofab"
	/// For all flatpacked machines, set the desc to the type_to_deploy followed by ::desc to reuse the type_to_deploy's description
	desc = /obj/machinery/rnd/production/colony_lathe::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "colony_lathe_packed"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	/// What structure is created by this item.
	var/obj/type_to_deploy = /obj/machinery/rnd/production/colony_lathe
	/// How long it takes to create the structure in question.
	var/deploy_time = 4 SECONDS

/obj/item/flatpacked_machine/Initialize(mapload)
	. = ..()
	give_deployable_component()
	give_manufacturer_examine()

/// Adds the deployable component, so that it can be overridden in case that's wanted
/obj/item/flatpacked_machine/proc/give_deployable_component()
	AddComponent(/datum/component/deployable, deploy_time, type_to_deploy)

/// Adds the manufacturer examine element to the flatpack machine, but can be overridden in the future
/obj/item/flatpacked_machine/proc/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/item/borg/apparatus/sheet_manipulator/Initialize(mapload)
	. = ..()
	storable += /obj/item/flatpacked_machine

/obj/item/borg/apparatus/circuit/Initialize(mapload)
	. = ..()
	storable += /obj/item/flatpacked_machine
