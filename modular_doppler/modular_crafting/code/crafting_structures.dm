/datum/crafting_recipe/lavalamp
	name = "Lava Lamp"
	result = /obj/machinery/power/floodlight/lavalamp
	time = 3 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/light = 1,
		/obj/item/reagent_containers/cup/glass/bottle = 1,
	)
	category = CAT_STRUCTURE
	tool_behaviors = list(TOOL_SCREWDRIVER)
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/scratching_post
	name = "Scratching Post"
	result = /obj/structure/punching_bag/scratching_post
	time = 3 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 2,
		/obj/item/stack/tile/carpet = 1,
	)
	category = CAT_STRUCTURE
	tool_behaviors = list(TOOL_WIRECUTTER)
	crafting_flags = CRAFT_CHECK_DENSITY
