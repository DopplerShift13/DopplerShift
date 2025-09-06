/obj/structure/shelf
	name = "shelf"
	desc = "Only a problem if someone has to help you reach the top of it."
	icon = 'modular_doppler/modular_items/icons/rack.dmi'
	icon_state = "shelf"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW //You can throw objects over this, despite its density.
	max_integrity = 35

/obj/structure/shelf/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/elevation, pixel_shift = 26)
	register_context()
	ADD_TRAIT(src, TRAIT_COMBAT_MODE_SKIP_INTERACTION, INNATE_TRAIT)

/obj/structure/shelf/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE
	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	else
		context[SCREENTIP_CONTEXT_RMB] = "Precise placement"
		context[SCREENTIP_CONTEXT_LMB] = "Center item"
		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/shelf/examine(mob/user)
	. = ..()
	. += span_notice("It's held together by a couple of <b>bolts</b>.")

// I'm unsure why TG racks do this but it seems important
/obj/structure/shelf/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return TRUE

/obj/structure/shelf/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/shelf/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return .
	if((tool.item_flags & ABSTRACT) || (user.combat_mode && !(tool.item_flags & NOBLUDGEON)))
		return NONE
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
	return ITEM_INTERACT_BLOCKING

/obj/structure/shelf/attack_paw(mob/living/user, list/modifiers)
	attack_hand(user, modifiers)

/obj/structure/shelf/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.combat_mode || user.body_position == LYING_DOWN || user.usable_legs < 2)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_danger("[user] kicks [src]."), null, null, COMBAT_MESSAGE_RANGE)
	take_damage(rand(4,8), BRUTE, MELEE, 1)

/obj/structure/shelf/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/items/dodgeball.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/items/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/tools/welder.ogg', 40, TRUE)

/obj/structure/shelf/atom_deconstruct(disassembled = TRUE)
	var/obj/item/stack/sheet/iron/newparts = new(loc)
	transfer_fingerprints_to(newparts)
