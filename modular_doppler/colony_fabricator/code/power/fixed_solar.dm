/obj/machinery/power/solar/fixed
	name = "manual solar panel"
	desc = "A solar panel without the automatic control machinery, must be rotated manually in whichever direction you want. \
		A little more powerful than solar panels that can turn themselves, however."
	icon = 'modular_doppler/colony_fabricator/icons/power/solar.dmi'
	icon_state = "sp_base"
	material_type = /datum/material/alloy/titaniumglass
	power_tier = 2
	/// What this panel disassembles into
	var/repacked_type = /obj/item/flatpacked_machine/manual_solar

/obj/machinery/power/solar/fixed/advanced
	name = "advanced manual solar panel"
	desc = "A solar panel without the automatic control machinery, must be rotated manually in whichever direction you want. \
		A lot more powerful than solar panels that can turn themselves, however."
	material_type = /datum/material/alloy/plastitaniumglass
	power_tier = 4
	repacked_type = /obj/item/flatpacked_machine/manual_solar/adv

/obj/machinery/power/solar/fixed/Initialize(mapload, obj/item/solar_assembly/S)
	. = ..()
	panel.icon_state = "solar_panel_[material_type.name]"
	panel_edge.icon_state = "solar_panel_[material_type.name]_edge"

/obj/machinery/power/solar/fixed/set_control(obj/machinery/power/solar_control/SC)
	return // You can't link these to anything

/obj/machinery/power/solar/fixed/examine(mob/user)
	. = ..()
	. += span_notice("You can rotate it in increments of 45 degrees with a [EXAMINE_HINT("wrench")] and [EXAMINE_HINT("Left or Right-Click")].")

/obj/machinery/power/solar/fixed/wrench_act(mob/living/user, obj/item/tool)
	return manual_rotation(user, tool, 45)

/obj/machinery/power/solar/fixed/wrench_act_secondary(mob/living/user, obj/item/tool)
	return manual_rotation(user, tool, -45)

/// Rotates the solar panel by the angle given to it once the tool is used on it
/obj/machinery/power/solar/fixed/proc/manual_rotation(mob/living/user, obj/item/tool, target_change)
	if(machine_stat & BROKEN)
		return ITEM_INTERACT_BLOCKING
	user.balloon_alert(user, "turning...")
	tool.play_tool_sound(src)
	if(!tool.use_tool(src, user, 2 SECONDS))
		return ITEM_INTERACT_BLOCKING
	playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	queue_turn(azimuth_target + target_change)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/solar/fixed/Make(obj/item/solar_assembly/assembly)
	if(assembly) // We don't want it to spawn stray solar assemblies when taken apart
		qdel(assembly)

/obj/machinery/power/solar/fixed/on_deconstruction(disassembled)
	if((machine_stat & BROKEN) || !disassembled)
		playsound(src, SFX_SHATTER, 70, TRUE)
		new material_type.shard_type(get_turf(src))
	else
		new repacked_type(get_turf(src))

/obj/item/flatpacked_machine/manual_solar
	name = "manual solar panel kit"
	desc = /obj/machinery/power/solar/fixed::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "solar_basic"
	type_to_deploy = /obj/machinery/power/solar/fixed
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	w_class = WEIGHT_CLASS_BULKY

/obj/item/flatpacked_machine/manual_solar/adv
	name = "advanced manual solar panel kit"
	desc = /obj/machinery/power/solar/fixed/advanced::desc
	icon_state = "solar_adv"
	type_to_deploy = /obj/machinery/power/solar/fixed/advanced
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT,
	)
	w_class = WEIGHT_CLASS_BULKY
