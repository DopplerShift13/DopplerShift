
/// Rate at which a power cord can charge its stomach cell.
#define POWER_CORD_CHARGE_RATE (CHARGING_STOMACH_DISCHARGE_RATE * 33)
/// Delay between power cord charging attempts.
#define POWER_CORD_CHARGE_DELAY 0.5 SECONDS
/// Minimum charge percent an APC must have for a power cord to be able to drain it.
#define POWER_CORD_APC_MINIMUM_PERCENT 5

/**
 * ORGAN
 */

/obj/item/organ/stomach/charging/power_cord
	name = "plug-based charging apparatus"
	desc = "An electronic device designed to replace the need for food with \
	the need to plug into the wall every once in a while."
	actions_types = list(/datum/action/item_action/organ_action/power_cord)

	// Weakref to our power cord item.
	var/datum/weakref/power_cord_ref
	/// Last time we drained power, to block spam-draining.
	var/last_drain_time = 0

/obj/item/organ/stomach/charging/power_cord/Destroy()
	var/obj/item/hand_item/power_cord/our_cord = power_cord_ref?.resolve()
	if(our_cord)
		qdel(our_cord)
	power_cord_ref = null
	return ..()

/obj/item/organ/stomach/charging/power_cord/on_mob_remove(mob/living/carbon/stomach_owner)
	. = ..()
	var/obj/item/hand_item/power_cord/our_cord = power_cord_ref?.resolve()
	if(our_cord)
		playsound(src, 'sound/vehicles/mecha/mechmove03.ogg', 20, TRUE)
		qdel(our_cord)

/obj/item/organ/stomach/charging/power_cord/ui_action_click()
	var/obj/item/hand_item/power_cord/our_cord = power_cord_ref?.resolve()
	if(our_cord)
		qdel(our_cord)
		playsound(owner, 'sound/vehicles/mecha/mechmove03.ogg', 20, TRUE)
		return
	if(owner.get_active_held_item())
		owner.balloon_alert(owner, "hand occupied!")
		return
	our_cord = new
	power_cord_ref = WEAKREF(our_cord)
	owner.put_in_active_hand(our_cord)
	playsound(owner, 'sound/vehicles/mecha/mechmove03.ogg', 20, TRUE)

/// Check whether we can currently drain power.
/obj/item/organ/stomach/charging/power_cord/proc/can_currently_drain()
	if(world.time < (last_drain_time + POWER_CORD_CHARGE_DELAY))
		return FALSE
	return TRUE

/// Update our last drain time to the current time.
/obj/item/organ/stomach/charging/power_cord/proc/update_last_drain_time()
	last_drain_time = world.time

/**
 * ACTION
 */

/datum/action/item_action/organ_action/power_cord
	name = "Toggle Power Cord"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	button_icon_state = "toolkit_generic"
	button_icon = 'icons/obj/medical/organs/organs.dmi'
	background_icon_state = "bg_default"

/**
 * HAND ITEM
 */

/obj/item/hand_item/power_cord
	name = "power cord"
	desc = "An internal power cord. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire"
	/// What can be drained
	var/static/list/cord_whitelist = typecacheof(list(
		/obj/item/stock_parts/power_store,
		/obj/machinery/power/apc,
	))

// Attempt to charge from an object by using them on the power cord.
/obj/item/hand_item/power_cord/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_power_draw(tool, user))
		return NONE
	try_power_draw(tool, user)
	return ITEM_INTERACT_SUCCESS

// Attempt to charge from an object by using the power cord on them.
/obj/item/hand_item/power_cord/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_power_draw(interacting_with, user))
		return NONE
	try_power_draw(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/// Returns TRUE or FALSE depending on if the target object can be used as a power source.
/obj/item/hand_item/power_cord/proc/can_power_draw(obj/target, mob/user)
	return ishuman(user) && is_type_in_typecache(target, cord_whitelist)

/// Attempts to start using an object as a power source.
/obj/item/hand_item/power_cord/proc/try_power_draw(obj/target, mob/living/carbon/human/user)
	var/obj/item/organ/stomach/charging/power_cord/charging_stomach = user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!istype(charging_stomach))
		return

	if(charging_stomach.internal_cell.used_charge() <= 0)
		balloon_alert(user, "fully charged!")
		return
	if(!charging_stomach.can_currently_drain())
		balloon_alert(user, "too soon!")
		return

	user.visible_message(span_notice("[user] inserts a power connector into [target]."), span_notice("You begin to draw power from [target]."))
	do_power_draw(target, user, charging_stomach)

	if(QDELETED(user) || QDELETED(target))
		return

	user.visible_message(span_notice("[user] unplugs from [target]."), span_notice("You unplug from [target]."))

/**
 * Runs a loop to charge a power cord stomach from an object with a cell.
 *
 * Arguments:
 * * target - The object whose cell to drain.
 * * user - The human mob draining the power cell.
 * * charging_stomach - the stomach to charge
 */
/obj/item/hand_item/power_cord/proc/do_power_draw(obj/target, mob/living/carbon/human/user, obj/item/organ/stomach/charging/charging_stomach)
	var/obj/item/stock_parts/power_store/target_cell = target?.get_cell(src, user)
	if(!istype(target_cell))
		target.balloon_alert(user, "no cell!")
		return

	// The minimum percent charge our target needs to let us drain it.
	var/target_minimum_charge = 0
	if(istype(target, /obj/machinery/power/apc))
		target_minimum_charge = target_cell.max_charge() * POWER_CORD_APC_MINIMUM_PERCENT / 100
	if(target_cell.charge() < target_minimum_charge)
		target.balloon_alert(user, "charge too low!")
		return

	var/obj/item/stock_parts/power_store/stomach_cell = charging_stomach.internal_cell
	while(do_after(user, POWER_CORD_CHARGE_DELAY, target = target))
		if(isnull(charging_stomach) || (charging_stomach != user.get_organ_slot(ORGAN_SLOT_STOMACH)))
			balloon_alert(user, "stomach removed!?")
			return
		if(isnull(target_cell) || (target_cell != target.get_cell(src, user)))
			target.balloon_alert(user, "cell removed!")
			return
		if(target_cell.charge() < target_minimum_charge)
			target.balloon_alert(user, "charge too low!")
			return

		var/our_available_charge = target_cell.charge() - target_minimum_charge
		var/stomach_used_charge = stomach_cell.used_charge()
		var/potential_charge = min(our_available_charge, stomach_used_charge)
		var/to_drain = min(POWER_CORD_CHARGE_RATE, potential_charge)
		var/energy_drained = target_cell.use(to_drain, force = TRUE)
		if(energy_drained)
			charging_stomach.adjust_charge(energy_drained)
			playsound(user, 'modular_doppler/modular_sounds/sound/mobs/humanoids/android/drain.wav', 25, FALSE)
			if(prob(8))
				do_sparks(3, FALSE, get_turf(target_cell))

		if(QDELETED(target_cell) || QDELETED(target))
			return // The cell could be sabotaged, which causes it to explode and qdelete.
		if(stomach_cell.used_charge() <= 0)
			balloon_alert(user, "fully charged!")
			return
		if(target_cell.charge() <= 0)
			target.balloon_alert(user, "empty!")
			return
		if(target_cell.charge() < target_minimum_charge)
			target.balloon_alert(user, "charge too low!")
			return

#undef POWER_CORD_CHARGE_RATE
#undef POWER_CORD_CHARGE_DELAY
#undef POWER_CORD_APC_MINIMUM_PERCENT