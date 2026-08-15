/obj/item/spell_focus
	name = "thaumaturge's spell focus"
	desc = "An orb of raw thaumaturgic resonance, adjustable to take on any form of your choosing, one-time only. Needed to restore thaumaturgic powers."
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "ice_1"
	slot_flags = NONE
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME
	affinity = 2 // check thaumaturge_affinity.dm if you ever wonder what deserves what affinity
	/// If FALSE, suppress belt sprite entirely (prevents missing belt sprites).
	var/shows_on_belt = FALSE
	/// Short description of what this item is capable of, for radial menu uses.
	var/menu_description = "An orb of energy. Fits in pockets. Very convenient, gives affinity 2 and is not visible in your hands, but doesn't do much more than that."

/obj/item/spell_focus/Initialize(mapload)
	. = ..()

	// Only the base focus should offer "picks". Subtypes are the end result.
	if(type != /obj/item/spell_focus)
		return

	var/list/focuses = list()
	for(var/obj/item/spell_focus/focus_type as anything in typesof(/obj/item/spell_focus))
		focuses[focus_type] = initial(focus_type.menu_description)

	AddComponent(/datum/component/subtype_picker, focuses, CALLBACK(src, PROC_REF(on_spell_focus_picked)))

/obj/item/spell_focus/proc/on_spell_focus_picked(obj/item/spell_focus/new_focus, mob/living/picker)
	if(!istype(new_focus))
		return
	new_focus.on_selected(src, picker)

/obj/item/spell_focus/proc/on_selected(obj/item/spell_focus/old_focus, mob/living/picker)
	// Preserve unique renames (if the old focus was renamed by a player).
	if(old_focus.name != initial(old_focus.name))
		name = old_focus.name

/obj/item/spell_focus/tome
	name = "thaumaturge's tome"
	desc = "A tome! What secrets does it hold? Apparently long lines of jargon that only one specific person can understand; some people need to learn how to convey information."
	icon = 'icons/obj/service/library.dmi'
	icon_state = "bookcharge"
	lefthand_file = 'icons/mob/inhands/items/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/books_righthand.dmi'
	inhand_icon_state = "kojiki" // they have no inhands but affinity3 needs inhands so we borrow another blue book instead
	throw_speed = 1
	throw_range = 5
	slot_flags = NONE
	shows_on_belt = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("bashes", "whacks", "educates")
	attack_verb_simple = list("bash", "whack", "educate")
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	affinity = 3
	menu_description = "An arcane tome. Fits in your backpack, and provides affinity 3; but does not fit in the pockets and is fairly conspicuous."

/obj/item/spell_focus/wand
	name = "thaumaturge's wand"
	desc = "A pointy stick, attuned to work with thaumaturgic resonance. Capable of restoring thaumaturgic powers when resting."
	icon = 'icons/obj/weapons/guns/magic.dmi'
	icon_state = "nothingwand-drained"
	inhand_icon_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	slot_flags = NONE
	w_class = WEIGHT_CLASS_NORMAL
	affinity = 3
	menu_description = "A classical magic wand. Fits in your backpack, and provides affinity 3; but does not fit in any pockets and is clearly visible when held."

/obj/item/spell_focus/staff
	name = "thaumaturge's staff"
	desc = "A big ol' staff, attuned to work with thaumaturgic resonance. Makes for an excellent focus for thaumaturgic powers, and is capable of restoring thaumaturgic powers when resting."
	icon = 'icons/obj/weapons/staff.dmi'
	icon_state = "godstaff-blue"
	inhand_icon_state = "godstaff-blue"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 7
	slot_flags = ITEM_SLOT_BACK
	affinity = 5
	menu_description = "A staff with an orb on the end. Because it is bulky, it can only be stored in the back slot, but offers affinity 5 in return. As well as being very apt for whacking fools that can't comprehend your arcane knowledge."
