/*
	Allows you to bind with a specific item and draw any of its type on demand. Keyword type; so if you like consumable items a la flashbangs & bolas, you'll love this one.
*/
/datum/power/warfighter/quick_draw
	name = "Equipment Specialist"
	desc = "Some folks have studied warfare in their own specialized way for years, putting them on an equal ground with many others. This category includes things such as swords, shields and more. \
	The power itself grants you the 'Quick Draw' ability, letting you 'acclimate' with an item of your choice. \
	Whilst acclimated, you can use the power to instantly draw that type of item to your hand, as long as it is anywhere on your person, or within melee range of you. \
	You can even use this to snag it back from your enemies."
	security_record_text = "Subject has a high amount of manual dexterity and is hard to disarm."
	security_threat = POWER_THREAT_MAJOR
	value = 3
	action_path = /datum/action/cooldown/power/warfighter/quick_draw

/datum/action/cooldown/power/warfighter/quick_draw
	name = "Quick Draw"
	desc = "Acclimate to a held item type, then draw that item from sensible storage or nearby hands automatically into your active hand."
	button_icon = 'icons/mob/actions/actions_slime.dmi' // placeholders out of the wazoo
	button_icon_state = "slimeeject"

	/// Cached overlay so we can cleanly update it.
	var/mutable_appearance/bonded_overlay
	/// Type path of the bonded item.
	var/bonded_type
	/// Display name for user feedback.
	var/bonded_name
	/// Icon file for bonded item overlay.
	var/bonded_icon
	/// Icon state for bonded item overlay.
	var/bonded_icon_state

/datum/action/cooldown/power/warfighter/quick_draw/use_action(mob/living/user, atom/target)
	var/obj/item/held_item = user.get_active_held_item()

	// Bind if we don't have a bonded type yet.
	if(!bonded_type)
		if(!held_item)
			user.balloon_alert(user, "hold an item to acclimate")
			return FALSE
		if(!can_bond_item(held_item, user))
			user.balloon_alert(user, "can't acclimate to that")
			return FALSE
		bonded_type = held_item.type
		bonded_name = held_item.name
		bonded_icon = held_item.icon
		bonded_icon_state = held_item.icon_state
		user.balloon_alert(user, "acclimated to [held_item]")
		build_all_button_icons(UPDATE_BUTTON_OVERLAY)
		return TRUE

	// Rebind if holding a different item type.
	if(held_item && !istype(held_item, bonded_type))
		if(!can_bond_item(held_item, user))
			user.balloon_alert(user, "can't acclimate to that")
			return FALSE
		bonded_type = held_item.type
		bonded_name = held_item.name
		bonded_icon = held_item.icon
		bonded_icon_state = held_item.icon_state
		user.balloon_alert(user, "reacclimated to [held_item]")
		build_all_button_icons(UPDATE_BUTTON_OVERLAY)
		return TRUE

	if(user.get_active_held_item() && user.get_inactive_held_item())
		user.balloon_alert(user, "hands full")
		return FALSE

	var/obj/item/target_item = find_drawable_item(user)
	if(!target_item)
		var/label_name = bonded_name ? bonded_name : "item"
		user.balloon_alert(user, "no [label_name]")
		return FALSE

	if(!draw_item_to_hand(user, target_item))
		user.balloon_alert(user, "can't draw it")
		return FALSE

	user.visible_message(
		span_notice("[user] draws [target_item]!"),
		span_notice("You draw [target_item]."),
	)
	return TRUE

// Adds an overlay to the power button so that the user knows what their bonded item is.
/datum/action/cooldown/power/warfighter/quick_draw/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	..()

	if(!bonded_icon || !bonded_icon_state)
		if(bonded_overlay)
			current_button.cut_overlay(bonded_overlay)
			bonded_overlay = null
		return

	if(bonded_overlay)
		current_button.cut_overlay(bonded_overlay)

	bonded_overlay = mutable_appearance(icon = bonded_icon, icon_state = bonded_icon_state)
	current_button.add_overlay(bonded_overlay)

/// Checks if an item can be bonded to.
/datum/action/cooldown/power/warfighter/quick_draw/proc/can_bond_item(obj/item/held_item, mob/living/user)
	if(!held_item || !user)
		return FALSE
	if(held_item.item_flags & ABSTRACT)
		return FALSE
	return TRUE

/// Checks if an item is eligible to be quick-drawn from the user's gear.
/datum/action/cooldown/power/warfighter/quick_draw/proc/can_quickdraw_item(obj/item/candidate_item, mob/living/user, list/equipped_items)
	if(!candidate_item || !user)
		return FALSE
	if(candidate_item.item_flags & ABSTRACT)
		return FALSE
	// Normally you can't draw equipped items unless they're in a container (anti-cheese), but it works if its either in the pockets, the belts, the suit slot or the id.
	var/allow_equipped_slot = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/slot_id = human_user.get_slot_by_item(candidate_item)
		if(slot_id == ITEM_SLOT_LPOCKET || slot_id == ITEM_SLOT_RPOCKET || slot_id == ITEM_SLOT_BELT || slot_id == ITEM_SLOT_BACK || slot_id == ITEM_SLOT_SUITSTORE || slot_id == ITEM_SLOT_ID)
			allow_equipped_slot = TRUE

	if(candidate_item in equipped_items)
		if(!allow_equipped_slot)
			return FALSE
	if(candidate_item.loc == user && !allow_equipped_slot)
		return FALSE

	// Reject implants/organs and abstract containers in the loc chain.
	var/atom/current_container = candidate_item.loc
	while(current_container && !ismob(current_container))
		if(istype(current_container, /obj/item/implant) || istype(current_container, /obj/item/organ))
			return FALSE
		if(isobj(current_container))
			var/obj/item/container_item = current_container
			if(container_item.item_flags & ABSTRACT)
				return FALSE
			if(container_item.atom_storage?.locked)
				return FALSE
		current_container = current_container.loc

	// Must be inside a storage container to count as "on your person".
	if(!allow_equipped_slot && !isobj(candidate_item.loc))
		return FALSE
	var/obj/item/candidate_container = candidate_item.loc
	if(!allow_equipped_slot && !candidate_container.atom_storage)
		return FALSE

	return TRUE

/// Finds a suitable bonded item to draw.
/datum/action/cooldown/power/warfighter/quick_draw/proc/find_drawable_item(mob/living/user)
	if(!bonded_type || !user)
		return null

	var/list/equipped_items = user.get_equipped_items(INCLUDE_POCKETS | INCLUDE_HELD | INCLUDE_ACCESSORIES)
	var/list/gear_items = user.get_all_gear(recursive = TRUE)

	for(var/obj/item/candidate_item in gear_items)
		if(!istype(candidate_item, bonded_type))
			continue
		if(!can_quickdraw_item(candidate_item, user, equipped_items))
			continue
		return candidate_item

	// Check adjacent ground items (melee range).
	for(var/obj/item/ground_item in view(1, user))
		if(!istype(ground_item, bonded_type))
			continue
		if(ground_item.item_flags & ABSTRACT)
			continue
		if(!isturf(ground_item.loc))
			continue
		return ground_item

	// Check adjacent enemies' hands only.
	for(var/mob/living/nearby_mob in view(1, user))
		if(nearby_mob == user)
			continue
		var/obj/item/active_item = nearby_mob.get_active_held_item()
		if(istype(active_item, bonded_type) && can_take_from_other(nearby_mob, active_item))
			return active_item
		var/obj/item/inactive_item = nearby_mob.get_inactive_held_item()
		if(istype(inactive_item, bonded_type) && can_take_from_other(nearby_mob, inactive_item))
			return inactive_item

	return null

/// Checks if we can take an item from another mob's hand.
/datum/action/cooldown/power/warfighter/quick_draw/proc/can_take_from_other(mob/living/other_mob, obj/item/held_item)
	if(!other_mob || !held_item)
		return FALSE
	if(held_item.item_flags & ABSTRACT)
		return FALSE
	if(!other_mob.canUnEquip(held_item, FALSE))
		return FALSE
	return TRUE

/// Moves the target item into the user's hands, if possible.
/datum/action/cooldown/power/warfighter/quick_draw/proc/draw_item_to_hand(mob/living/user, obj/item/target_item)
	if(!user || !target_item)
		return FALSE

	// taken from a mob
	if(ismob(target_item.loc))
		var/mob/living/holder_mob = target_item.loc
		if(!holder_mob.canUnEquip(target_item, FALSE))
			return FALSE
		if(!holder_mob.transferItemToLoc(target_item, user, force = FALSE))
			return FALSE
		if(!holder_mob == user) // tell the person we're stealing from that we stole from them.
			user.balloon_alert(user, "snagged")
			holder_mob.balloon_alert(holder_mob, "[target_item.name] was snagged!")
		return user.put_in_hands(target_item)

	// took it from our person
	if(isobj(target_item.loc))
		var/obj/item/storage_container = target_item.loc
		if(storage_container.atom_storage)
			if(storage_container.atom_storage.locked)
				return FALSE
			if(!storage_container.atom_storage.remove_single(user, target_item, user))
				return FALSE
			return user.put_in_hands(target_item)

	// took it from the ground
	if(isturf(target_item.loc))
		return user.put_in_hands(target_item)

	return FALSE
