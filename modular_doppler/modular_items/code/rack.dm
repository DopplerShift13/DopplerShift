/obj/structure/rack
	icon = 'modular_doppler/modular_items/icons/rack.dmi'

/obj/structure/rack/shelf
	name = "shelf"
	desc = "A tall shelf for storing things on."
	icon_state = "shelf"

/obj/structure/rack/shelf/atom_deconstruct(disassembled = TRUE)
	var/obj/item/stack/sheet/iron = new(loc)
	transfer_fingerprints_to(newparts)

/obj/structure/rack/shelf/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(isnull(held_item))
		return .
	if(held_item.tool_behaviour != TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "Precise placement"
		context[SCREENTIP_CONTEXT_LMB] = "Center item"
		. |= CONTEXTUAL_SCREENTIP_SET
	return .

/obj/structure/rack/shelf/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return ..()
	// Left click to center item placement
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(user.transfer_item_to_turf(tool, get_turf(src), silent = FALSE))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	// Right click for precise placement
	if(LAZYACCESS(modifiers, ICON_X) && LAZYACCESS(modifiers, ICON_Y))
		var/x_offset = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X * 0.5), ICON_SIZE_X * 0.5)
		var/y_offset = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(ICON_SIZE_Y * 0.5), ICON_SIZE_Y * 0.5)
		if(user.transfer_item_to_turf(tool, get_turf(src), x_offset, y_offset, silent = FALSE))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return ..()
