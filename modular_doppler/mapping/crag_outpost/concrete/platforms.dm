/obj/structure/platform/crag_sand
	name = "earthen embankment"
	desc = "Piled and packed sand that serves as cover from projectiles, a place to stand on, or barrier against dust kicked up by shuttle landings."
	icon = 'icons/_smooth_doppler/objects/sand_embankment.dmi'
	frame_icon = null
	icon_state = "sand_embankment-0"
	base_icon_state = "sand_embankment"
	sheet_type = /obj/item/stack/ore/crag_sand
	smoothing_groups = SMOOTH_GROUP_DIRT_EMBANKMENT
	canSmoothWith = SMOOTH_GROUP_DIRT_EMBANKMENT
	footstep = FOOTSTEP_SAND
	max_integrity = 120
	/// The chance that this will act as cover
	var/embankment_cover_chance = 60

/obj/structure/platform/crag_sand/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE
	if(held_item.tool_behaviour == TOOL_MINING)
		context[SCREENTIP_CONTEXT_RMB] = "Destroy"
		. = CONTEXTUAL_SCREENTIP_SET
	return . || NONE

/obj/structure/platform/crag_sand/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(tool.tool_behaviour != TOOL_MINING)
		return NONE
	to_chat(user, span_notice("You start destroying [src]..."))
	if(tool.use_tool(src, user, 3 SECONDS, volume = 50))
		deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/platform/crag_sand/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	return FALSE

/obj/structure/platform/crag_sand/wrench_act_secondary(mob/living/user, obj/item/tool)
	return FALSE

/obj/structure/platform/crag_sand/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if((mover.pass_flags & PASSGRILLE) || isprojectile(mover))
		return prob(embankment_cover_chance)

/obj/structure/platform/crag_sand/concrete
	name = "eclogiticrete embankment"
	desc = "An eclogiticrete embankment that serves as cover from projectiles, a place to stand on, or barrier against dust kicked up by shuttle landings."
	icon = 'icons/_smooth_doppler/objects/concrete_embankment.dmi'
	frame_icon = null
	icon_state = "concrete_embankment-0"
	base_icon_state = "concrete_embankment"
	sheet_type = /obj/item/stack/sheet/crag_concrete
	smoothing_groups = SMOOTH_GROUP_CONCRETE_EMBANKMENT
	canSmoothWith = SMOOTH_GROUP_CONCRETE_EMBANKMENT
	footstep = FOOTSTEP_FLOOR
	max_integrity = 200
