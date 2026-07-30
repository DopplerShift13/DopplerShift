/datum/crafting_recipe/thermal_glasses
	name = "Thermal Glasses"
	result = /obj/item/clothing/glasses/thermal
	reqs = list(
		/obj/item/epic_loot/thermal_camera = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/clothing/glasses/meson = 1,
		)
	tool_behaviors = list(
		TOOL_WIRECUTTER,
		TOOL_SCREWDRIVER,
	)
	time = 10 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/high_explosive
	name = "High-Explosive Grenade"
	result = /obj/item/grenade/syndieminibomb/concussion
	reqs = list(
		/obj/item/epic_loot/plasma_explosive = 1,
		/obj/item/epic_loot/grenade_fuze = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/suppressor
	name = "Suppressor"
	result = /obj/item/suppressor
	reqs = list(
		/obj/item/epic_loot/water_filter = 1,
		/obj/item/epic_loot/cold_weld = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WELDER,
	)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/teleporter
	name = "Experimental Teleporter"
	result = /obj/item/syndicate_teleporter
	reqs = list(
		/obj/item/epic_loot/military_circuit = 1,
		/obj/item/epic_loot/processor = 1,
		/obj/item/hand_tele = 1,
		/obj/item/epic_loot/current_converter = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_MULTITOOL,
	)
	time = 15 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/exosuit_emp_shield
	name = "Exosuit EMP Shielding"
	result = /obj/item/mecha_parts/mecha_equipment/armor/antiemp_armor_booster/clandestine
	reqs = list(
		/obj/item/epic_loot/current_converter = 1,
		/obj/item/epic_loot/military_circuit = 1,
		/obj/item/epic_loot/cold_weld = 1,
		/obj/item/stack/sheet/plasteel = 20,
		/obj/item/stack/cable_coil = 15,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WELDER,
	)
	time = 15 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/eyesnatcher
	name = "Eyesnatcher"
	result = /obj/item/eyesnatcher
	reqs = list(
		/obj/item/epic_loot/vein_finder	= 1,
		/obj/item/epic_loot/eye_scope = 1,
		/obj/item/hemostat = 1,
	)
	tool_behaviors = list(
		TOOL_WRENCH,
	)
	time = 10 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/ai_detector
	name = "AI Detector Multitool"
	result = /obj/item/multitool/ai_detect
	reqs = list(
		/obj/item/epic_loot/military_circuit = 1,
		/obj/item/epic_loot/processor = 1,
		/obj/item/epic_loot/phased_array = 1,
		/obj/item/epic_loot/signal_amp = 1,
		/obj/item/epic_loot/corpo_folder = 1,
		/obj/item/multitool = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WIRECUTTER,
	)
	time = 20 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/mirage_grenade
	name = "Mirage Grenade"
	result = /obj/item/grenade/mirage
	reqs = list(
		/obj/item/grenade/chem_grenade = 1,
		/obj/item/epic_loot/graphics = 1,
		/obj/item/sequence_scanner = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/exotic_fuelpellet
	name = "Exotic Fuel Pellet"
	result = /obj/item/fuel_pellet/exotic
	reqs = list(
		/obj/item/fuel_pellet = 1,
		/obj/item/epic_loot/fuel_conditioner = 1,
		/obj/item/stack/sheet/bluespace_crystal = 1,
	)
	tool_behaviors = list(
		TOOL_WRENCH,
	)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/atrocinator
	name = "Atrocinator Module"
	result = /obj/item/mod/module/atrocinator
	reqs = list(
		/obj/item/epic_loot/shuttle_gyro = 1,
		/obj/item/mod/module/magboot = 1,
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WIRECUTTER,
	)
	time = 10 SECONDS
	category = CAT_MISC
