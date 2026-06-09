/datum/crafting_recipe/waterbottle_bong
	result = /obj/item/bong/waterbottle_bong
	reqs = list(
		/obj/item/reagent_containers/cup/glass/waterbottle = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 3 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_MISC

/datum/crafting_recipe/nevada_bong
	result = /obj/item/bong/nevada_bong
	reqs = list(
		/obj/item/reagent_containers/cup/glass/waterbottle/nevada_tea = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 3 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_MISC

/datum/crafting_recipe/lemonade_bong
	result = /obj/item/bong/lemonade_bong
	reqs = list(
		/obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/lemonade = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 3 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_MISC

//crafting recipe for the red marsian seals
/datum/crafting_recipe/redmars_dark_seal
	result = /obj/item/sticker/mars/red/redmars_dark_seal
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/toy/crayon = 1
	)
	time = 3 SECONDS
	tool_behaviors = list(TOOL_WELDER,
		TOOL_SCREWDRIVER,
		TOOL_WIRECUTTER)
	category = CAT_MISC

/datum/crafting_recipe/redmars_light_seal
	result = /obj/item/sticker/mars/red/redmars_light_seal
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/toy/crayon = 1
	)
	time = 3 SECONDS
	tool_behaviors = list(TOOL_WELDER,
		TOOL_SCREWDRIVER,
		TOOL_WIRECUTTER)
	category = CAT_MISC
