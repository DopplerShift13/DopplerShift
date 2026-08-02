GLOBAL_LIST_INIT(crag_concrete_recipes, list(
	new/datum/stack_recipe("concrete tiles", /obj/item/stack/tile/crag_concrete, 1, 4, 60, 0 SECONDS, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("concrete ramp", /obj/structure/stairs/ramp/concrete, 4, 1, 1, 6 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY|CRAFT_ONE_PER_TURF|CRAFT_CHECK_DENSITY, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("concrete embankment", /obj/structure/platform/crag_sand/concrete, 2, 1, 1, 4 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY|CRAFT_ONE_PER_TURF|CRAFT_CHECK_DENSITY, category = CAT_STRUCTURE), \
	))

/obj/item/stack/sheet/crag_concrete
	name = "eclogiticrete bags"
	singular_name = "eclogiticrete bag"
	desc = "A paper bag of ready-to-use eclogiticrete mix (concrete using Crag's unique material makeup) for all of your construction needs. WARNING: Do not eat."
	icon = 'modular_doppler/mapping/crag_outpost/icons/items.dmi'
	icon_state = "concrete"
	inhand_icon_state = "sheet-plastitanium"
	merge_type = /obj/item/stack/sheet/crag_concrete
	walltype = /turf/closed/wall/crag_concrete

/obj/item/stack/sheet/crag_concrete/get_main_recipes()
	. = ..()
	. += GLOB.crag_concrete_recipes

/obj/item/stack/sheet/crag_concrete/ten
	amount = 10

/obj/item/stack/sheet/crag_concrete/fifty
	amount = 50

// Sand

GLOBAL_LIST_INIT(crag_sand_recipes, list(
	new/datum/stack_recipe("earthen ramp", /obj/structure/stairs/ramp, 4, 1, 1, 6 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY|CRAFT_ONE_PER_TURF|CRAFT_CHECK_DENSITY, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("earthen embankment", /obj/structure/platform/crag_sand, 2, 1, 1, 4 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY|CRAFT_ONE_PER_TURF|CRAFT_CHECK_DENSITY, category = CAT_STRUCTURE), \
	))

/obj/item/stack/ore/crag_sand
	name = "eclogitic sand pile"
	singular_name = "eclogitic sand pile"
	icon = 'modular_doppler/mapping/crag_outpost/icons/items.dmi'
	icon_state = "eclogitic_sand"
	points = 1
	mats_per_unit = list(/datum/material/sand = SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/sand
	refined_type = /obj/item/stack/sheet/glass
	w_class = WEIGHT_CLASS_TINY
	mine_experience = 0
	merge_type = /obj/item/stack/ore/crag_sand
	usable_for_construction = FALSE

/obj/item/stack/ore/crag_sand/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddComponent(/datum/component/storm_hating)

/obj/item/stack/ore/crag_sand/on_orm_collection()
	new /obj/item/stack/sheet/crag_concrete(get_turf(src), amount)
	var/obj/item/stack/sheet/glass = new refined_type(null, amount)
	qdel(src)
	return glass

/obj/item/stack/ore/crag_sand/get_main_recipes()
	. = ..()
	. += GLOB.crag_sand_recipes
