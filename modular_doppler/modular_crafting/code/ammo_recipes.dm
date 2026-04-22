/datum/crafting_recipe/bolt_slug
	name = "Stack of Bolt Slugs"
	result = /obj/item/ammo_box/magazine/ammo_stack/bolt_slug/full
	reqs = list(
		/obj/item/stack/rods = 5,
		/obj/item/stack/sheet/mineral/uranium = 1,
	)
	tool_behaviors = list(
		TOOL_WIRECUTTER,
		TOOL_WELDER,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bolt_slug/shot
	name = "Fistfuls of Bearings"
	result = /obj/item/ammo_box/magazine/ammo_stack/bolt_shot/full
