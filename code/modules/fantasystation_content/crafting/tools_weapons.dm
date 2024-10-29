/// Spears

/obj/item/fantasy_spear
	name = "stone spear"
	desc = "A long stick with a sharpened piece of stone attached to the end. Makes good for stabbing or throwing."
	icon = 'icons/obj/fantasystation_obj/tools.dmi'
	icon_state = "stone_spear0"
	base_icon_state = "stone_spear"
	lefthand_file = 'icons/mob/fantasystation_onmobs/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/fantasystation_onmobs/inhands/righthand.dmi'
	worn_icon = 'icons/mob/fantasystation_onmobs/worn_items/worn.dmi'
	worn_icon_state = "stone_spear"
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 18
	throw_speed = 4
	demolition_mod = 0.75
	embed_type = /datum/embed_data/spear
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	wound_bonus = -15
	bare_wound_bonus = 10
	reach = 2
	/// How much damage to do unwielded
	var/force_unwielded = 10
	/// How much damage to do wielded
	var/force_wielded = 18

/obj/item/fantasy_spear/Initialize(mapload)
	. = ..()
	force = force_unwielded
	AddComponent(/datum/component/jousting, \
		max_tile_charge = 10, \
		min_tile_charge = 5, \
		)
	AddComponent(/datum/component/two_handed, \
		force_unwielded = force_unwielded, \
		force_wielded = force_wielded, \
		icon_wielded = "[base_icon_state]1", \
	)
	update_appearance()

/obj/item/fantasy_spear/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/// Flint version of the spar

/obj/item/fantasy_spear/flint
	name = "flint spear"
	desc = "A long stick with a sharpened piece of flint attached to the end. Makes good for stabbing or throwing."
	icon_state = "flint_spear0"
	base_icon_state = "flint_spear"
	worn_icon_state = "flint_spear"
	throwforce = 20
	wound_bonus = -10
	bare_wound_bonus = 15
	force_unwielded = 10
	force_wielded = 20

/// Axes

/obj/item/fantasy_axe
	name = "stone axe"
	desc = "A sharpened chunk of stone on the end of a stick that works good enough for cutting down trees with."
	icon = 'icons/obj/fantasystation_obj/tools.dmi'
	icon_state = "stone_axe"
	lefthand_file = 'icons/mob/fantasystation_onmobs/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/fantasystation_onmobs/inhands/righthand.dmi'
	inhand_icon_state = "stone_axe"
	worn_icon = 'icons/mob/fantasystation_onmobs/worn_items/worn.dmi'
	worn_icon_state = "stone_axe"
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_AXE
	toolspeed = 1.75
	force = 15
	throwforce = 15
	throw_speed = 4
	throw_range = 7
	demolition_mod = 1.5
	embed_type = /datum/embed_data/hatchet
	attack_verb_continuous = list("chops", "tears", "lacerates", "cuts")
	attack_verb_simple = list("chop", "tear", "lacerate", "cut")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK

/obj/item/fantasy_axe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
		speed = 7 SECONDS, \
		effectiveness = 100, \
	)

/// Flint version

/obj/item/fantasy_axe/flint
	name = "flint axe"
	desc = "A sharpened chunk of flint on the end of a stick that works good enough for cutting down trees with."
	icon_state = "flint_axe"
	inhand_icon_state = "flint_axe"
	worn_icon_state = "flint_axe"
	toolspeed = 1.5
	force = 17
	throwforce = 17
	throw_range = 8

/// Knives

/obj/item/fantasy_knife
	name = "stone knife"
	desc = "A sharp piece of stone in the shape of a knife, stuck to a convieniently short piece of a wood."
	icon = 'icons/obj/fantasystation_obj/tools.dmi'
	icon_state = "stone_knife"
	lefthand_file = 'icons/mob/fantasystation_onmobs/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/fantasystation_onmobs/inhands/righthand.dmi'
	inhand_icon_state = "stone_knife"
	worn_icon = 'icons/mob/fantasystation_onmobs/worn_items/worn.dmi'
	worn_icon_state = "stone_knife"
	w_class = WEIGHT_CLASS_SMALL
	force = 10
	demolition_mod = 0.75
	throwforce = 10
	throw_speed = 3
	throw_range = 6
	wound_bonus = 0
	bare_wound_bonus = 10
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_KNIFE
	toolspeed = 1.75
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	slot_flags = ITEM_SLOT_BELT

/obj/item/fantasy_knife/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)
	AddComponent(/datum/component/butchering, \
		speed = 7 SECONDS, \
		effectiveness = 120, \
	)

/// Flint knife

/obj/item/fantasy_knife/flint
	name = "flint knife"
	desc = "A sharp piece of stone in the shape of a knife, stuck to a convieniently short piece of a wood."
	icon_state = "flint_knife"
	inhand_icon_state = "flint_knife"
	worn_icon_state = "flint_knife"
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 12
	wound_bonus = 5
	bare_wound_bonus = 15
	toolspeed = 1.5

/// Firestarter tool

/obj/item/fantasy_firestarter
	name = "firestarter"
	desc = "Two sticks and some wound together dried grass, excellent for starting fires with."
	icon = 'icons/obj/fantasystation_obj/tools.dmi'
	icon_state = "firestarter"
	lefthand_file = 'icons/mob/fantasystation_onmobs/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/fantasystation_onmobs/inhands/righthand.dmi'
	inhand_icon_state = "stick"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE

/obj/item/fantasy_firestarter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(!isturf(interacting_with) && !isobj(interacting_with))
		interacting_with.balloon_alert(user, "cannot ignite this")
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, 20 SECONDS, interacting_with))
		return ITEM_INTERACT_BLOCKING
	playsound(interacting_with, 'sound/fantasystation/tools/firestarter.ogg', 50, TRUE)
	if(isturf(interacting_with))
		var/turf/interacting_turf = interacting_with
		interacting_turf.hotspot_expose(1000, 100)
	else
		interacting_with.fire_act(1000, 100)
	qdel(src)
	return ITEM_INTERACT_SUCCESS
