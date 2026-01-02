
/datum/design/cybernetic_stomach/power_cord
	name = "Plug-based Charging Apparatus"
	desc = "A cybernetic stomach replacement, allowing for the use of electricity instead of food."
	id = "cybernetic_stomach_power_cord"
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5
	)
	build_path = /obj/item/organ/stomach/charging/power_cord
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach/windup_key
	name = "Wind-up Key Charging Apparatus"
	desc = "A cybernetic stomach replacement, replacing the need for food with a little key that needs to be wound up."
	id = "cybernetic_stomach_windup_key"
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5
	)
	build_path = /obj/item/organ/stomach/charging/windup_key
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
