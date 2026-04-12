/datum/crafting_recipe/bolt_slug
	name = "Bolt Slug"
	result = /obj/item/ammo_casing/bolt_slug
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
