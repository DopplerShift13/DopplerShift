/obj/structure/tizirian_radiator
	name = "portable heat radiator"
	desc = "A small, self-powering machine that works not too much unlike a large heat lamp. \
		Standing anywhere near it is bound to warm you up. Thanks in part to being designed by \
		and for Tizirians, humans standing near it for too long may experience discomfort and \
		potential burns."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "lizard_heater"
	density = FALSE
	anchored = TRUE
	light_on = TRUE
	light_color = LIGHT_COLOR_FLARE
	light_range = 5
	light_power = 1.25
	/// Soundloop because this thing is potentially dangerous and potentially hard to notice
	var/datum/looping_sound/arc_furnace_running/soundloop
	/// The item that the heater disassembles into
	var/repacked_type = /obj/item/flatpacked_machine/gps_beacon

/obj/structure/tizirian_radiator/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
	AddComponent(/datum/component/powerful_heat_radiator)

/obj/structure/tizirian_radiator/examine(mob/user)
	. = ..()
	. += span_notice("Disassemble with a [EXAMINE_HINT("wrench")].")

/obj/structure/tizirian_radiator/Destroy(force)
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/tizirian_radiator/wrench_act(mob/living/user, obj/item/wrench)
	user.visible_message(span_warning("[user] disassembles [src]."),
		span_notice("You start to disassemble [src]..."), span_hear("You hear clanking and banging noises."))
	if(!wrench.use_tool(src, user, 2 SECONDS, volume=50))
		return ITEM_INTERACT_BLOCKING
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/tizirian_radiator/atom_deconstruct(disassembled)
	. = ..()
	if(disassembled)
		new repacked_type(drop_location())

// Disassembled item
/obj/item/flatpacked_machine/lizard_heater
	name = "packed heat radiator"
	desc = /obj/structure/tizirian_radiator::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "lizard_heater"
	w_class = WEIGHT_CLASS_SMALL
	type_to_deploy = /obj/structure/tizirian_radiator
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
	)
