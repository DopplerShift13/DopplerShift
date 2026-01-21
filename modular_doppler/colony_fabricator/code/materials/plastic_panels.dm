GLOBAL_LIST_INIT(plastic_wall_panel_recipes, list(
	new/datum/stack_recipe("plastic wall", /turf/closed/wall/prefab_plastic, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("airtight flaps", /obj/structure/plasticflaps/colony, 5, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	))

/obj/item/stack/sheet/plastic_wall_panel
	name = "LDSPPE plastic panels"
	singular_name = "LDSPPE plastic panel"
	desc = "A strong plastic with a chemical chain that would make even bio-chemists dizzy. \
		Widely known among the frontier for it's common use as wall and floor panels, better known \
		in the online block game community for it's terrifying production chain." // gregtech reference, in MY ss13?
	icon = 'modular_doppler/colony_fabricator/icons/construction/tiles_item.dmi'
	icon_state = "sheet-plastic"
	inhand_icon_state = "sheet-plastic"
	mats_per_unit = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	has_unique_girder = TRUE
	material_type = /datum/material/plastic
	merge_type = /obj/item/stack/sheet/plastic_wall_panel
	walltype = /turf/closed/wall/prefab_plastic

/obj/item/stack/sheet/plastic_wall_panel/examine(mob/user)
	. = ..()
	. += span_notice("You can build a prefabricated wall by right clicking on an empty floor.")

/obj/item/stack/sheet/plastic_wall_panel/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isopenturf(interacting_with))
		return NONE
	var/turf/open/build_on = interacting_with
	if(isgroundlessturf(build_on))
		user.balloon_alert(user, "can't place it here!")
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(get_amount() < 1)
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, 3 SECONDS, build_on))
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(!use(1))
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	build_on.place_on_top(walltype, flags = CHANGETURF_INHERIT_AIR)
	return ITEM_INTERACT_SUCCESS

/obj/item/stack/sheet/plastic_wall_panel/get_main_recipes()
	. = ..()
	. += GLOB.plastic_wall_panel_recipes

/obj/item/stack/sheet/plastic_wall_panel/ten
	amount = 10

/obj/item/stack/sheet/plastic_wall_panel/fifty
	amount = 50
