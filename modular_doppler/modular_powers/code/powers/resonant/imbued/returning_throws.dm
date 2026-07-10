/*
	Thrown items return to you and are caught cleanly. This uses a component that whilst similar to boomerang, makes it behave much more generously.
*/
/datum/power/imbued/returning_throws
	name = "Returning Throws"
	desc = "Anything you throw forth with intent seems to come flying back to you! Whilst active, throwing objects will cause them to fly back towards you after traveling their maximum distance or hitting a target, so long as there is a direct path.\
	\nYou will always succesfully catch the object, regardless if you have your throw intent set or not. Returning Throws an be toggled on or off."
	security_record_text = "Subject displays a tendency for thrown handheld objects to return to their hands through seemingly impossible trajectories."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	magic_flags = POWER_MAGIC_STANDARD
	action_path = /datum/action/cooldown/power/imbued/returning_throws

	required_powers = list(/datum/power/imbued_root/enchanted)

/// Action button for enabling or disabling Returning Throws.
/datum/action/cooldown/power/imbued/returning_throws
	name = "Returning Throws"
	desc = "Toggles Returning Throws on or off. Whilst active, throwing objects will cause them to fly back towards you after traveling their maximum distance or hitting a target, so long as there is a direct path.\
	\nYou will always succesfully catch the object, regardless if you have your throw intent set or not."
	button_icon = 'icons/obj/weapons/spear.dmi'
	button_icon_state = "dragoonpole1"
	cooldown_time = 0
	active_overlay_icon_state = "bg_spell_border_active_blue" // changing the color to indicate its active is cooler

	/// Every item this action has marked so it can clean them up on removal.
	var/list/managed_item_refs = list()
	/// How many return hops attuned items should attempt before giving up.
	var/return_hop_attempts = 3

/// Registers the held-item signaler and tracks any held item
/datum/action/cooldown/power/imbued/returning_throws/Grant(mob/granted_to)
	. = ..()
	active = TRUE
	RegisterSignal(granted_to, COMSIG_MOB_UPDATE_HELD_ITEMS, PROC_REF(on_held_items_updated))
	if(active)
		refresh_held_items(granted_to)
	build_all_button_icons(UPDATE_BUTTON_OVERLAY)

/// Unregisters signals and untracks held items.
/datum/action/cooldown/power/imbued/returning_throws/Remove(mob/removed_from)
	UnregisterSignal(removed_from, COMSIG_MOB_UPDATE_HELD_ITEMS)
	remove_all_managed_items(removed_from)
	. = ..()

/// Toggles between on/off and tracks/untracks held items consequently.
/datum/action/cooldown/power/imbued/returning_throws/use_action(mob/living/user, atom/target)
	active = !active
	if(active)
		refresh_held_items(user)
	else
		remove_all_managed_items(user)
	owner.balloon_alert(owner, active ? "returning throws on" : "returning throws off")
	build_all_button_icons(UPDATE_BUTTON_OVERLAY)
	return TRUE

/// Override to enable the active_overlay_icon_state to be visible when active (which is normally hoarded by targeted action's default behavior)
/datum/action/cooldown/power/imbued/returning_throws/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return active

/// Refreshes item tracking whenever our held items are changed
/datum/action/cooldown/power/imbued/returning_throws/proc/on_held_items_updated(mob/living/power_owner)
	SIGNAL_HANDLER
	refresh_held_items(power_owner)

/// Iterates the owner's current hand items and ensures each one is tracked
/datum/action/cooldown/power/imbued/returning_throws/proc/refresh_held_items(mob/living/power_owner)
	if(!active)
		return

	if(!istype(power_owner))
		return

	clear_invalid_managed_refs()

	for(var/obj/item/held_item as anything in power_owner.held_items)
		if(!istype(held_item))
			continue
		attune_item(power_owner, held_item)

/// Adds or refreshes the returning-throw component on a specific held item.
/datum/action/cooldown/power/imbued/returning_throws/proc/attune_item(mob/living/power_owner, obj/item/held_item)
	if(QDELETED(held_item))
		return

	var/datum/component/returning_throw_attunement/attunement = held_item.GetComponent(/datum/component/returning_throw_attunement)
	if(attunement)
		if(attunement.belongs_to(power_owner))
			attunement.max_return_hops = return_hop_attempts
			track_managed_item(held_item)
		return

	held_item.AddComponent(/datum/component/returning_throw_attunement, power_owner, return_hop_attempts, TRUE)
	track_managed_item(held_item)

/// Stores a weak reference so the action can later clean up only items it touched.
/datum/action/cooldown/power/imbued/returning_throws/proc/track_managed_item(obj/item/managed_item)
	if(QDELETED(managed_item))
		return

	var/datum/weakref/item_ref = WEAKREF(managed_item)
	if(item_ref in managed_item_refs)
		return
	managed_item_refs += item_ref

/// Removes dead weak references from the managed item list.
/datum/action/cooldown/power/imbued/returning_throws/proc/clear_invalid_managed_refs()
	for(var/datum/weakref/item_ref as anything in managed_item_refs.Copy())
		if(!item_ref?.resolve())
			managed_item_refs -= item_ref

/// Deletes every component that still belongs to the provided owner, or the action owner if omitted.
/datum/action/cooldown/power/imbued/returning_throws/proc/remove_all_managed_items(mob/living/power_owner = owner)
	for(var/datum/weakref/item_ref as anything in managed_item_refs.Copy())
		var/obj/item/managed_item = item_ref?.resolve()
		if(QDELETED(managed_item))
			continue

		var/datum/component/returning_throw_attunement/attunement = managed_item.GetComponent(/datum/component/returning_throw_attunement)
		if(attunement?.belongs_to(power_owner))
			qdel(attunement)

	managed_item_refs.Cut()

/*
	Item-side component for Returning Throws.
	While the owner has an item in hand, it becomes a forced-catch returning throw. Whilst this is similar to boomerang, it is more magical in that it tries to hop and curve back.
	The attunement stays on the item until another mob claims it.
*/
/datum/component/returning_throw_attunement
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	/// Filter id used for the temporary returning-throw outline.
	var/static/throw_outline_filter_id = "returning_throw_outline"

	/// The mob who originally enchanted this item.
	var/datum/weakref/owner_ref
	/// Whether this component should delete itself when it loses its assigned owner or changes hands.
	var/self_terminate = FALSE
	/// Maximum number of return hops this attunement will attempt for a throw.
	var/max_return_hops = 3
	/// Whether the current throw is one of our guided return hops.
	var/is_returning = FALSE
	/// How many guided return hops remain before we leave the item where it landed.
	var/remaining_return_hops = 0
	/// Whether this attunement currently owns the temporary throw visuals.
	var/created_throw_effect = FALSE

/// Validates the parent item, records which mob owns this component, and stores its allowed return-hop count.
/datum/component/returning_throw_attunement/Initialize(mob/living/owner, max_return_hops, self_terminate = FALSE)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(istype(owner))
		owner_ref = WEAKREF(owner)
	else if(self_terminate)
		return COMPONENT_INCOMPATIBLE

	src.self_terminate = self_terminate
	src.max_return_hops = max(0, max_return_hops)

/// Hooks the item signals needed for ownership, catch interception, and throw visuals.
/datum/component/returning_throw_attunement/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_item_picked_up))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(parent, COMSIG_MOVABLE_POST_THROW, PROC_REF(on_post_throw))
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_IMPACT, PROC_REF(on_pre_impact))
	RegisterSignal(parent, COMSIG_MOVABLE_THROW_LANDED, PROC_REF(on_throw_landed))

/// Unhooks every signal installed by this attunement.
/datum/component/returning_throw_attunement/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_PICKUP, COMSIG_ITEM_EQUIPPED, COMSIG_MOVABLE_POST_THROW, COMSIG_MOVABLE_PRE_IMPACT, COMSIG_MOVABLE_THROW_LANDED))

/// Removes temporary visuals and clears throw state before deletion.
/datum/component/returning_throw_attunement/Destroy(force)
	clear_throw_effect()
	is_returning = FALSE
	remaining_return_hops = 0
	owner_ref = null
	return ..()

/// Returns TRUE when this attunement belongs to the queried mob.
/datum/component/returning_throw_attunement/proc/belongs_to(mob/living/possible_owner)
	return owner_ref?.resolve() == possible_owner

/// Adds the temporary outline for the duration of the throw if one is not already present.
/datum/component/returning_throw_attunement/proc/ensure_throw_effect()
	var/obj/item/parent_item = parent
	if(QDELETED(parent_item))
		return

	if(created_throw_effect)
		return

	parent_item.add_filter(throw_outline_filter_id, 2, outline_filter(2, POWER_COLOR_IMBUED))
	created_throw_effect = TRUE

/// Removes the temporary throw visuals, but only if this attunement created them.
/datum/component/returning_throw_attunement/proc/clear_throw_effect()
	if(!created_throw_effect)
		return

	var/obj/item/parent_item = parent
	if(QDELETED(parent_item))
		created_throw_effect = FALSE
		return

	parent_item.remove_filter(throw_outline_filter_id)
	created_throw_effect = FALSE

/// Returns TRUE when the owner is close enough to a landed item that we should snap it back into hand.
/datum/component/returning_throw_attunement/proc/is_within_close_catch_range(mob/living/owner, obj/item/parent_item)
	if(owner.z != parent_item.z)
		return FALSE

	return get_dist(owner, parent_item) <= 1

/// Starts another return hop aimed at the owner's current position instead of the stale original target turf.
/datum/component/returning_throw_attunement/proc/launch_return_hop(mob/living/owner, obj/item/parent_item, return_speed)
	if(QDELETED(owner) || QDELETED(parent_item))
		return FALSE

	if(parent_item.throwing)
		return FALSE

	var/final_return_speed = max(1, return_speed || parent_item.throw_speed)
	var/return_range = max(1, get_dist(parent_item, owner) + parent_item.throw_range + 1)
	is_returning = TRUE
	parent_item.throw_at(owner, return_range, final_return_speed, owner, TRUE)
	return TRUE

/// Continues the return path after a landing by catching nearby items, re-aiming distant ones, or stopping after several failed hops.
/datum/component/returning_throw_attunement/proc/continue_return_to_owner(mob/living/owner, obj/item/parent_item, return_speed)
	if(QDELETED(owner) || QDELETED(parent_item))
		qdel(src)
		return

	// We caught it :D
	if(parent_item.loc == owner)
		clear_throw_effect()
		is_returning = FALSE
		remaining_return_hops = 0
		return

	// If it lands adjacent to the owner, we attempt to force it into their hands.
	if(is_within_close_catch_range(owner, parent_item) && force_catch_in_hand(owner, parent_item))
		clear_throw_effect()
		is_returning = FALSE
		remaining_return_hops = 0
		owner.throw_mode_off(THROW_MODE_TOGGLE)
		owner.visible_message(
			span_notice("[owner] catches [parent_item] as it whips back around."),
			span_notice("You catch [parent_item] as it whips back into your hand."),
		)
		return

	// We ran out of hops D:
	if(remaining_return_hops <= 0)
		clear_throw_effect()
		is_returning = FALSE
		return

	remaining_return_hops--
	// Launches ourselves again
	if(!launch_return_hop(owner, parent_item, return_speed))
		clear_throw_effect()
		is_returning = FALSE

/// Defers the next return decision until after the current throw datum has fully cleaned itself up.
/datum/component/returning_throw_attunement/proc/queue_return_resolution(mob/living/owner, obj/item/parent_item, return_speed)
	addtimer(CALLBACK(src, PROC_REF(continue_return_to_owner), owner, parent_item, return_speed), 0.1 SECONDS)

/// Places the returning item directly into a hand without going through stack merge logic.
/datum/component/returning_throw_attunement/proc/force_catch_in_hand(mob/living/owner, obj/item/parent_item)
	var/empty_active_hand_index = owner.can_put_in_hand(parent_item, owner.active_hand_index) ? owner.active_hand_index : null
	if(!isnull(empty_active_hand_index))
		return owner.put_in_hand(parent_item, empty_active_hand_index, forced = TRUE, ignore_anim = TRUE)

	var/inactive_hand_index = owner.get_inactive_hand_index()
	var/empty_inactive_hand_index = owner.can_put_in_hand(parent_item, inactive_hand_index) ? inactive_hand_index : null
	if(!isnull(empty_inactive_hand_index))
		return owner.put_in_hand(parent_item, empty_inactive_hand_index, forced = TRUE, ignore_anim = TRUE)

	return owner.put_in_hand(parent_item, owner.active_hand_index, forced = TRUE, ignore_anim = TRUE)

/// Removes the component if the item is picked up by anyone other than its owner.
/datum/component/returning_throw_attunement/proc/on_item_picked_up(obj/item/source, mob/taker)
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		if(self_terminate)
			qdel(src)
		return

	clear_throw_effect()
	is_returning = FALSE
	remaining_return_hops = 0
	if(self_terminate && taker != owner)
		qdel(src)

/// Removes the component if the item is equipped by anyone other than its owner.
/datum/component/returning_throw_attunement/proc/on_item_equipped(obj/item/source, mob/equipper, slot)
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		if(self_terminate)
			qdel(src)
		return

	clear_throw_effect()
	is_returning = FALSE
	remaining_return_hops = 0
	if(self_terminate && equipper != owner)
		qdel(src)

/// Starts a fresh return sequence and applies the temporary outline when the attuned owner throws the item.
/datum/component/returning_throw_attunement/proc/on_post_throw(datum/source, datum/thrownthing/throwingdatum, spin)
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	var/mob/living/thrower = throwingdatum?.get_thrower()
	// If there is no owner, we either self-terminate or we usurpt it with the htrower
	if(!istype(owner))
		if(self_terminate)
			qdel(src)
			return
		if(!istype(thrower))
			return
		owner = thrower
		owner_ref = WEAKREF(thrower)

	if(!istype(thrower))
		return
	// If we are not self-terminating and someone stole the item and threw it, they are now the onwer.
	if(!self_terminate && thrower != owner)
		owner = thrower
		owner_ref = WEAKREF(thrower)

	// If thrower/owner are not the same (cause they at this poitn should be the same), something again went wrong and we need to top.
	if(thrower != owner)
		return

	// Sets the remaining return hops to the configured max (inherited from the action or the component)
	if(!is_returning)
		remaining_return_hops = max_return_hops
	ensure_throw_effect()

/// Intercepts the return impact on the owner and force-places the item back into their hands.
/datum/component/returning_throw_attunement/proc/on_pre_impact(datum/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	var/obj/item/parent_item = parent
	if(QDELETED(parent_item))
		qdel(src)
		return COMPONENT_MOVABLE_IMPACT_NEVERMIND

	if(!istype(owner))
		if(self_terminate)
			qdel(src)
		return COMPONENT_MOVABLE_IMPACT_NEVERMIND

	if(hit_atom != owner)
		return

	if(throwingdatum?.get_thrower() != owner)
		return

	if(force_catch_in_hand(owner, parent_item))
		clear_throw_effect()
		is_returning = FALSE
		remaining_return_hops = 0
		owner.throw_mode_off(THROW_MODE_TOGGLE)
		owner.visible_message(
			span_notice("[owner] catches [parent_item] as it whips back around."),
			span_notice("You catch [parent_item] as it whips back into your hand."),
		)
		return COMPONENT_MOVABLE_IMPACT_NEVERMIND

/// Continues guiding the item back toward its owner after each landing until it is caught or runs out of return hops.
/datum/component/returning_throw_attunement/proc/on_throw_landed(datum/source, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	var/obj/item/parent_item = parent
	if(QDELETED(parent_item))
		qdel(src)
		return

	// Is it grabbed by someone who is not our owner and is the component set to self termiante?
	if(!istype(owner))
		if(self_terminate)
			qdel(src)
		return

	// Is it not in our owner's hands yet?
	if(throwingdatum?.get_thrower() != owner)
		clear_throw_effect()
		is_returning = FALSE
		remaining_return_hops = 0
		return

	// Tries repeated hop behavior. This is what largely handles the return hopping behavior
	queue_return_resolution(owner, parent_item, throwingdatum?.speed || parent_item.throw_speed)
