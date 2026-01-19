//adding teshari silicon stuff to the mechfabricator

#define RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL "/Raptoral"
#define RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL "/Advanced Raptoral Limbs"

/datum/design/teshari_cyber_chest
	name = "Raptoral Cybernetic Torso"
	id = "teshari_cyber_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/robot/android/teshari
	materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT * 18)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_head
	name = "Raptoral Cybernetic Head"
	id = "teshari_cyber_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/robot/android/teshari
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_l_arm
	name = "Raptoral Cybernetic Left Forelimb"
	id = "teshari_cyber_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot/android/teshari
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 4)
	construction_time = 18 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_r_arm
	name = "Raptoral Cybernetic Right Forelimb"
	id = "teshari_cyber_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot/android/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4)
	construction_time = 18 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_l_leg
	name = "Raptoral Cybernetic Left Hindlimb"
	id = "teshari_cyber_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/android/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4)
	construction_time = 18 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_r_leg
	name = "Raptoral Cybernetic Right Hindlimb"
	id = "teshari_cyber_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/android/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4)
	construction_time = 18 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

#undef RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL
#undef RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL
