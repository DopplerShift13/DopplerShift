/obj/item/gps/colony_beacon
	name = "\improper GPS beacon"
	desc = "A big, flashing GPS beacon. Either bolted to the floor or anchored into the ground, \
		because of people like you who will get lost otherwise."
	icon = 'modular_doppler/colony_fabricator/icons/machines.dmi'
	icon_state = "gps_beacon"
	anchored = TRUE
	density = TRUE
	gpstag = "UNL_HOME_BEACON"
	/// The item that the beacon disassembles into
	var/repacked_type = /obj/item/flatpacked_machine/gps_beacon

/obj/item/gps/colony_beacon/examine(mob/user)
	. = ..()
	. += span_notice("Disassemble with a [EXAMINE_HINT("wrench")].")

/obj/item/gps/colony_beacon/wrench_act(mob/living/user, obj/item/wrench)
	user.visible_message(span_warning("[user] disassembles [src]."),
		span_notice("You start to disassemble [src]..."), span_hear("You hear clanking and banging noises."))
	if(!wrench.use_tool(src, user, 2 SECONDS, volume=50))
		return ITEM_INTERACT_BLOCKING
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/gps/colony_beacon/atom_deconstruct(disassembled)
	. = ..()
	if(disassembled)
		new repacked_type(drop_location())

/obj/item/gps/colony_beacon/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	attack_self(user)

/obj/item/flatpacked_machine/gps_beacon
	name = "packed GPS beacon"
	desc = /obj/item/gps/colony_beacon::desc
	icon = 'modular_doppler/colony_fabricator/icons/packed_machines.dmi'
	icon_state = "beacon_folded"
	w_class = WEIGHT_CLASS_SMALL
	type_to_deploy = /obj/item/gps/colony_beacon
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
