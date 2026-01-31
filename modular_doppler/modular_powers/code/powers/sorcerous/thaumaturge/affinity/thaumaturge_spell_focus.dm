/obj/item/spell_focus
	name = "thaumaturge's spell focus"
	desc = "An orb of raw thaumaturgic resonance, adjustable to take on any form of your choosing. Needed to restore thaumaturgic powers."
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "ice_1"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME
	affinity = 2 // check thaumaturge_affinity.dm if you ever wonder what deserves what affinity
	/// Short description of what this item is capable of, for radial menu uses.
	var/menu_description = "An orb of energy. Fits in pockets. Can be worn on the belt. Very convenient and not visible in your hands, but doesn't do much more than that."

/obj/item/spell_focus/wand
	name = "thaumaturge's wand"
	desc = "A pointy stick, attuned to work with thaumaturgic resonance. Capable of restoring thaumaturgic powers when resting."
	icon = 'icons/obj/weapons/guns/magic.dmi'
	icon_state = "nothingwand-drained"
	inhand_icon_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	affinity = 3
	menu_description = "A classical magic wand. Fits in your backpack and on your belt, and provides more affinity than the orb; but does not fit in any pockets and is clearly visible when held."

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
	menu_description = "A staff with an orb on the end. Because it is bulky, it can only be stored in the back slot, but offers a very high amount of Affinity in return. As well as being very apt for whacking youngsters."


