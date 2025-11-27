// Charge level defines
#define POWER_CORD_CHARGE_MAX 5 MEGA JOULES
#define POWER_CORD_CHARGE_RATE (STANDARD_CELL_RATE * 1.5)
#define POWER_CORD_CHARGE_DELAY 0.55 SECONDS
#define POWER_CORD_APC_MINIMUM_PERCENT 5

/**
 * ORGAN
 */

/obj/item/organ/stomach/charging/power_cord
	name = "plug-based charging apparatus"
	desc = "" // TODO
	actions_types = list(/datum/action/item_action/organ_action/power_cord)

	// Weakref to our power cord item.
	var/datum/weakref/power_cord_ref

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
	user.changeNext_move(CLICK_CD_MELEE)

	var/datum/species/android/energy_holder = user.dna.species
	if(energy_holder.core_energy >= POWER_CORD_CHARGE_MAX)
		user.balloon_alert(user, "fully charged!")
		return

	user.visible_message(span_notice("[user] inserts a power connector into [target]."), span_notice("You begin to draw power from [target]."))
	do_power_draw(target, user)

	if(QDELETED(target))
		return

	if(HAS_TRAIT(user, TRAIT_CHARGING))
		REMOVE_TRAIT(user, TRAIT_CHARGING, ORGAN_TRAIT)
	user.visible_message(span_notice("[user] unplugs from [target]."), span_notice("You unplug from [target]."))

/**
 * Runs a loop to charge an android from a cell or APC.
 * Displays chat messages to the user and nearby observers.
 *
 * Stops when:
 * - The user's is full.
 * - The cell has less than the minimum charge.
 * - The user moves, or anything else that can happen to interrupt a do_after.
 *
 * Arguments:
 * * target - The power cell or APC to drain.
 * * user - The human mob draining the power cell.
 */
/obj/item/hand_item/power_cord/proc/do_power_draw(obj/target, mob/living/carbon/human/user)
	// Draw power from an APC if one was given.
	var/obj/machinery/power/apc/target_apc
	if(istype(target, /obj/machinery/power/apc))
		target_apc = target

	var/obj/item/stock_parts/power_store/target_cell = target_apc ? target_apc.cell : target
	var/minimum_cell_charge = target_apc ? POWER_CORD_APC_MINIMUM_PERCENT : 0

	if(!target_cell || target_cell.percent() < minimum_cell_charge)
		user.balloon_alert(user, "target charge low!")
		return
	var/energy_needed
	while(TRUE)
		ADD_TRAIT(user, TRAIT_CHARGING, ORGAN_TRAIT)
		// Check if the charge level of the cell is below the minimum.
		// Prevents from overloading the cell.
		if(target_cell.percent() < minimum_cell_charge)
			user.balloon_alert(user, "target charge low!")
			break

		// Attempt to drain charge from the cell.
		if(!do_after(user, POWER_CORD_CHARGE_DELAY, target)) // slurp slurp slurp slurp
			break

		// Check if the user is nearly fully charged.
		// Ensures minimum draw is always lower than this margin.
		var/datum/species/android/energy_holder = user.dna.species
		energy_needed = POWER_CORD_CHARGE_MAX - energy_holder.core_energy

		// Calculate how much to draw from the cell this cycle.
		var/current_draw = min(energy_needed, POWER_CORD_CHARGE_RATE * POWER_CORD_CHARGE_DELAY)

		var/energy_delivered = target_cell.use(current_draw, force = TRUE)
		target_cell.update_appearance()
		if(!energy_delivered)
			// The cell could be sabotaged, which causes it to explode and qdelete.
			if(QDELETED(target_cell))
				return
			user.balloon_alert(user, "target empty!")
			break

		energy_holder.core_energy += energy_delivered

		playsound(user, 'modular_doppler/modular_sounds/sound/mobs/humanoids/android/drain.wav', 25, FALSE)
		if(prob(8))
			do_sparks(3, FALSE, target_cell.loc)
		if(energy_holder.core_energy >= POWER_CORD_CHARGE_MAX)
			user.balloon_alert(user, "fully charged")
			break

#undef POWER_CORD_CHARGE_MAX
#undef POWER_CORD_CHARGE_RATE
#undef POWER_CORD_APC_MINIMUM_PERCENT
