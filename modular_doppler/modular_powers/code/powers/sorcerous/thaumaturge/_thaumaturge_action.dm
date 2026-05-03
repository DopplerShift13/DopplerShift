/datum/action/cooldown/power/thaumaturge
	name = "abstract thaumaturge power action - ahelp this"
	background_icon_state = "bg_star"
	overlay_icon_state = "bg_default_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	// We generally don't dabble with cooldowns but a cooldown of 0.5 seconds is kinda handy to prevent you from blowing your load on all your charges by accident.
	cooldown_time = 5
	// hides the cooldown text cause we contest the ui element location.
	text_cooldown = FALSE
	/// Unlike normal spells, we have charges. More of that explained below at check_if_valid()
	var/charges = 0
	/// The cap on charges; you can't prepare more than these. If you leave this null, the spell will not interact with the charges system.
	var/max_charges = THAUMATURGE_MAX_CHARGES_BASE
	/// How many charges does it consume on use?
	var/charges_to_use = 1
	/// How much 'mana' does it cost to prepare this per charge?
	var/prep_cost = 1

	/// Overlay that shows the number of charges
	var/mutable_appearance/charge_overlay

	/// How much affinity is currently affecting the action. It is deliberate we snap-shot this on cast.
	var/affinity
	/// How much affinity is required to use the action.
	var/required_affinity

/datum/action/cooldown/power/thaumaturge/New()
	if(max_charges)
		disable() // prep your spells first
	update_charges_overlay()

/datum/action/cooldown/power/thaumaturge/try_use(mob/living/user, atom/target)
	if(!check_if_valid()) // checks for charges
		return FALSE
	if(ishuman(user)) // We're not checking for clothes on cats
		affinity = get_affinity(user)
	if(affinity < required_affinity) // Do we have the minimal required affinity
		owner.balloon_alert(user, "requires [required_affinity] affinity!")
		return FALSE
	. = ..()

// The charge deduction is handled on_action_success and thusly gains override_charges as an arg.
// If your spell does anything unusual with charges such as refunds or costing multiples, this is where you would handle that.
// You can otherwise use on_action_success as normal, just make sure to call parrent.
/datum/action/cooldown/power/thaumaturge/on_action_success(mob/living/user, atom/target, override_charges)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	adjust_charges(isnull(override_charges) ? -charges_to_use : -override_charges)
	check_if_valid()
	return

/// Adjusts the charge counts up to the cap and not below 0 unless overriden.
/datum/action/cooldown/power/thaumaturge/proc/adjust_charges(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_charges
	charges = clamp(charges + amount, 0, cap_to)

/*
	Affinity system stuff here. Dress like a mage, get bonuses.
*/
/// Gets and reutrns a mob's current highest affinity number.
/datum/action/cooldown/power/thaumaturge/proc/get_affinity(mob/living/user)
	var/highest_affinity = 0

	// Checks if you're wearing items with affinity. This has to be clothing; wearing your staff does not count.
	var/list/equipped_items = user.get_equipped_items()
	for(var/obj/item/equipped_item as anything in equipped_items)
		if(!equipped_item)
			continue
		if(!istype(equipped_item, /obj/item/clothing) || equipped_item.affinity_worn_override)
			continue

		if(equipped_item.affinity > highest_affinity)
			highest_affinity = equipped_item.affinity

	// Checks if you're holding items with affinity.
	for(var/obj/item/held_item as anything in user.held_items)
		if(!held_item)
			continue

		// Holding clothing shouldn't contribute
		if(istype(held_item, /obj/item/clothing))
			continue

		if(held_item.affinity > highest_affinity)
			highest_affinity = held_item.affinity

	return highest_affinity

/*
	Deviating massively from the original cooldown system, thaumaturge has charges they have to prepare and plan for in advance, just like the classic vanician spellcasting system.
	Mechanically, we check if charges are 0. If so we Disable(). Otherwise, we deduct a charge and go on a short cooldown.
*/

/// Checks if we have charges to use.
/datum/action/cooldown/power/thaumaturge/proc/check_if_valid()
	update_charges_overlay()
	if(charges <= 0 && max_charges) // If charges are 0 or less and it has a max_charges set.
		disable()
		return FALSE
	else
		enable()
		return TRUE

/// Handles the UI stuff.
/datum/action/cooldown/power/thaumaturge/proc/update_charges_overlay()
	var/atom/movable/ui_element = get_atom_moveable()
	if(!ui_element)
		return
	if(!max_charges)
		return

	ui_element.cut_overlay(charge_overlay)
	charge_overlay = new/mutable_appearance
	charge_overlay.maptext_width = 32
	charge_overlay.maptext_height = 16

	// Bottom-left-ish
	charge_overlay.maptext_x = 4
	charge_overlay.maptext_y = 0

	charge_overlay.maptext = MAPTEXT("<span style='text-align:left; color:#ff69b4;'>[charges]</span>")
	ui_element.add_overlay(charge_overlay)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Get the moveable atom specifically for adjusting the number.
/datum/action/cooldown/power/thaumaturge/proc/get_atom_moveable()
	for(var/datum/hud/hud_instance as anything in viewers)
		var/atom/movable/screen/movable/action_button/action_button_instance = viewers[hud_instance]
		if(istype(action_button_instance, /atom/movable/screen/movable/action_button))
			return action_button_instance




