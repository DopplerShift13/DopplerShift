/datum/crafting_recipe/surplus_esword
	result = /obj/item/melee/energy/sword/surplus
	reqs = list(
		/obj/item/wallframe/light_switch = 1,
		/obj/item/assembly/igniter = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 1,
		/obj/item/light/tube = 2,
		/obj/item/stock_parts/power_store/cell = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)
	time = 10 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/repaired_escarabajo
	result = /obj/item/shield/escarabajo
	reqs = list(
		/obj/item/escarabajo_broken = 1,
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stack/sheet/rglass = 2,
	)
	time = 30 SECONDS
	tool_behaviors = list(TOOL_WELDER)
	category = CAT_WEAPON_MELEE
