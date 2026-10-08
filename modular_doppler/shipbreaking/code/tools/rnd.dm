/datum/design/demo_remote
	name = "Demolition Vac-Charge Clacker"
	id = "demo_remote"
	build_type = PROTOLATHE | AWAY_LATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4.75,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.8,
		/datum/material/nanocarbon = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/demo_charge_detonator
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/demo_charge
	name = "Low-Pyrotechnic Shaped Demolition Vac-Charge"
	id = "demo_charge"
	build_type = PROTOLATHE | AWAY_LATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/aluminum = HALF_SHEET_MATERIAL_AMOUNT / 2,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/grenade/c4/demo_charge
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/tethergun
	name = "Matter-Energy Tetherspike"
	id = "tethergun"
	build_type = PROTOLATHE | AWAY_LATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 9,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/tethergun
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/borg_upgrade_engineering_tetherspike
	name = "Engineering Tetherspike"
	id = "borg_upgrade_engineering_tetherspike"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/tethergun
	materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 9,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/techweb_node/plasma_mining/New()
	design_ids |= list(
		"demo_remote",
		"demo_charge",
		"tethergun",
		"borg_upgrade_engineering_tetherspike",
	)
	return ..()
