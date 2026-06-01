//Modules

/datum/design/module/mod_melee_harness
	name = "Sword Magnetic Harness"
	id = "mod_melee_harness"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/magnetic_harness/melee
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/mod_sheath
	name = "Sheath Module"
	id = "mod_sheath"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/sheath
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
