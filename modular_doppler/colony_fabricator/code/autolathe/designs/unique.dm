/datum/design/colony_headlamp
	name = "Head Lamp"
	id = "colony_headlamp"
	build_type = AMENITY_LATHE
	materials = /obj/item/clothing/head/utility/headlights::custom_materials
	build_path = /obj/item/clothing/head/utility/headlights
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/kitchen_knife_lizard
	name = "Kitchen Knife"
	id = "kitchen_knife_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/knife/lizard_kitchen::custom_materials
	build_path = /obj/item/knife/lizard_kitchen
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/soup_pot_lizard
	name = "Stout Soup Pot"
	id = "soup_pot_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/reagent_containers/cup/soup_pot/lizard::custom_materials
	build_path = /obj/item/reagent_containers/cup/soup_pot/lizard
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/food_press
	name = "Food Press"
	id = "food_press"
	build_type = AMENITY_LATHE
	materials = /obj/item/kitchen/rollingpin/press::custom_materials
	build_path = /obj/item/kitchen/rollingpin/press
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/kitchen_knife_lizard
	name = "Ladle"
	id = "ladle_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/kitchen/spoon/soup_ladle/copper::custom_materials
	build_path = /obj/item/kitchen/spoon/soup_ladle/copper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/oven_tray_lizard
	name = "Oven Tray"
	id = "oven_tray_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/plate/oven_tray/copper::custom_materials
	build_path = /obj/item/plate/oven_tray/copper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plate_lizard
	name = "Plate"
	id = "plate_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/plate/copper::custom_materials
	build_path = /obj/item/plate/copper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/bowl_lizard
	name = "Bowl"
	id = "bowl_lizard"
	build_type = AMENITY_LATHE
	materials = /obj/item/reagent_containers/cup/bowl/copper::custom_materials
	build_path = /obj/item/reagent_containers/cup/bowl/copper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/cutting_board_modern
	name = "Cutting Board"
	id = "cutting_board"
	build_type = AMENITY_LATHE
	materials = /obj/item/cutting_board/modern::custom_materials
	build_path = /obj/item/cutting_board/modern
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/copper_flare
	name = "Flare"
	id = "copper_flare"
	build_type = AMENITY_LATHE
	materials = /obj/item/flashlight/flare/copper::custom_materials
	build_path = /obj/item/flashlight/flare/copper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_LIGHTING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING
