// Pretty much adds a context tip when hovering over the equipment menu

/atom/movable/screen/human/toggle/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	register_context()

/atom/movable/screen/human/toggle/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_LMB] = "Open Equipment"
	context[SCREENTIP_CONTEXT_RMB] = "Show/Hide Mutant Parts"
	return CONTEXTUAL_SCREENTIP_SET
