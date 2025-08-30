/obj/item/storage/belt/crusader	//Belt + sheath combination - still only holds one sword at a time though
	icon = 'modular_doppler/modular_cosmetics/icons/obj/belt/crusaderbelt.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/belt/crusaderbelt.dmi'
	name = "sword belt"
	desc = "Technically called a baldric, this can hold an assortment of equipment for whatever situation an adventurer may encounter; as well as having an attached sheath."
	icon_state = "crusader_belt"
	worn_icon_state = "crusader_belt"
	inhand_icon_state = "utility"
	w_class = WEIGHT_CLASS_BULKY // Can't fit a sheath in your bag.
	interaction_flags_click = NEED_DEXTERITY
	storage_type = /datum/storage/belt/crusader

/obj/item/storage/belt/crusader/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/storage/belt/crusader/PopulateContents()
	. = ..()
	new /obj/item/storage/belt/storage_pouch(src)

/// Gets our sword item, if any.
/obj/item/storage/belt/crusader/proc/get_sword_item()
	if(length(contents) < 2)
		return null
	return contents[2]

// Makes ctrl-click also open the inventory,
// so that you can open it with full hands without dropping the sword.
/obj/item/storage/belt/crusader/item_ctrl_click(mob/user)
	. = ..()
	atom_storage.show_contents(user)
	return CLICK_ACTION_SUCCESS

// This is basically the same as the normal sheath,
// but because there's always an item locked in the first slot it uses the second slot for swords.
/obj/item/storage/belt/crusader/click_alt(mob/user)
	var/obj/item/drawn_item = get_sword_item()
	if(isnull(drawn_item))
		to_chat(user, span_warning("[src] is empty!"))
		return CLICK_ACTION_BLOCKING

	add_fingerprint(user)
	playsound(src, 'sound/items/unsheath.ogg', 50, TRUE, -5)
	if(!user.put_in_hands(drawn_item))
		to_chat(user, span_notice("You fumble for [drawn_item] and it falls on the floor."))
		update_appearance()
		return CLICK_ACTION_SUCCESS

	user.visible_message(span_notice("[user] takes [drawn_item] out of [src]."), span_notice("You take [drawn_item] out of [src]."))
	update_appearance()
	return CLICK_ACTION_SUCCESS

// Checks for a sword/rod in the sheath slot, changes the sprite accordingly.
/obj/item/storage/belt/crusader/update_icon(updates)
	. = ..()
	if(get_sword_item())
		icon_state = "crusader_belt_sheathed"
		worn_icon_state = "crusader_belt_sheathed"
	else
		icon_state = "crusader_belt"
		worn_icon_state = "crusader_belt"

/obj/item/storage/belt/crusader/examine(mob/user)
	. = ..()
	.+= span_notice("[EXAMINE_HINT("Ctrl-Click")] it to easily open its inventory.")
	// If there's no sword/rod in the sheath slot, we don't display the alt-click instruction.
	if(get_sword_item())
		. += span_notice("[EXAMINE_HINT("Alt-Click")] it to quickly draw the blade.")
		return


/datum/storage/belt/crusader
	max_slots = 2
	max_specific_storage = WEIGHT_CLASS_BULKY //This makes sure swords and the pouches can fit in here - the whitelist keeps the bad stuff out.
	allow_big_nesting = TRUE // Lets the pouch work
	do_rustle = FALSE
	click_alt_open = FALSE

/datum/storage/belt/crusader/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
		set_holdable(
		can_hold_list = list(
			/obj/item/storage/belt/storage_pouch,
			/obj/item/forging/reagent_weapon/sword,
			/obj/item/forging/reagent_weapon/katana,
			/obj/item/forging/reagent_weapon/bokken,
			/obj/item/forging/reagent_weapon/dagger,
			/obj/item/melee/sabre,
			/obj/item/melee/parsnip_sabre,
			/obj/item/claymore,
			/obj/item/melee/cleric_mace,
			/obj/item/knife,
			/obj/item/melee/baton,
			/obj/item/nullrod,	//holds any subset of nullrod in the sheath-storage - - -
		),
		cant_hold_list = list(	// - - - except the second list's items (no fedora in the sheath)
			/obj/item/nullrod/armblade,
			/obj/item/nullrod/carp,
			/obj/item/nullrod/chainsaw,
			/obj/item/nullrod/bostaff,
			/obj/item/nullrod/hammer,
			/obj/item/nullrod/pitchfork,
			/obj/item/nullrod/pride_hammer,
			/obj/item/nullrod/spear,
			/obj/item/nullrod/staff,
			/obj/item/nullrod/fedora,
			/obj/item/nullrod/godhand,
			/obj/item/nullrod/staff,
			/obj/item/nullrod/whip,
		),
	)

//Overrides normal dumping code to instead dump from the pouch item inside
/datum/storage/belt/crusader/dump_content_at(atom/dest_object, mob/dumping_mob)
	var/atom/used_belt = parent
	if(!used_belt)
		return
	var/obj/item/storage/belt/storage_pouch/pouch = locate() in real_location
	if(!pouch)
		pouch.balloon_alert(dumping_mob, "no pouch!")
		return //oopsie!! If we don't have a pouch! You're fucked!
	if(locked)
		pouch.balloon_alert(dumping_mob, "locked!")
		return
	pouch.atom_storage.dump_content_at(dest_object, dumping_mob)


/// Separate mini-storage inside the belt, leaving room for only one sword.
/// Inspired by a (very poorly implemented) belt on Desert Rose.
/obj/item/storage/belt/storage_pouch
	icon = 'modular_doppler/modular_cosmetics/icons/obj/belt/crusaderbelt.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/belt/crusaderbelt.dmi'
	name = "storage pouch"
	desc = span_notice("Click on this to open your belt's inventory!")
	icon_state = "storage_pouch_icon"
	worn_icon_state = "storage_pouch_icon"
	w_class = WEIGHT_CLASS_BULKY // Still cant put it in your bags, it's technically a belt.
	anchored = TRUE // Don't want people taking it out with their hands.
	storage_type = /datum/storage/belt/storage_pouch

// Opens the bag on click - considering it's already anchored, this makes it function similarly to how ghosts can open all nested inventories.
/obj/item/storage/belt/storage_pouch/attack_hand(mob/user, list/modifiers)
	. = ..()
	atom_storage.show_contents(user)


/datum/storage/belt/storage_pouch
	max_slots = 6
	max_specific_storage = WEIGHT_CLASS_SMALL //Rather than have a huge whitelist, the belt can simply hold anything a pocket can hold - Can easily be changed if it somehow becomes an issue.


/datum/crafting_recipe/crusader_belt
	name = "Sword Belt and Sheath"
	result = /obj/item/storage/belt/crusader
	reqs = list(
		/obj/item/storage/belt/utility = 1,
		/obj/item/stack/sheet/leather = 3,
		/obj/item/stack/sheet/cloth = 2,
		/obj/item/stack/sheet/mineral/gold = 1,
	)
	tool_behaviors = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_WELDER) // To cut the leather and fasten/weld the sheath detailing.
	time = 3 SECONDS
	category = CAT_CLOTHING
