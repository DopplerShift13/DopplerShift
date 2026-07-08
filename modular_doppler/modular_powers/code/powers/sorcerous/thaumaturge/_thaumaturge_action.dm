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
	var/prep_cost = 0
	/// If TRUE, this power has a chance to refund its resource use on successful cast.
	var/power_refunds = FALSE
	/// Base chance (percent) for refunding on cast success.
	var/power_refund_chance = 0
	/// Additional refund chance per affinity.
	var/power_refund_affinity_bonus = 0
	/// Snapshotted per-cast result of refund logic.
	var/last_power_refunded = FALSE
	/// If TRUE, this action uses the default charges system.
	var/charge_mechanics = TRUE
	/// Thaumaturge component tied to this action's owner. Used for mechanics settings.
	var/datum/component/thaumaturge/thaumaturge_component

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

/datum/action/cooldown/power/thaumaturge/Grant(mob/grant_to)
	. = ..()
	ValidateThaumaturgeComponent()
	check_if_valid(grant_to)
	return .

/// Checks if we have our referenced thaumaturge component for mechanics/display behavior.
/datum/action/cooldown/power/thaumaturge/proc/ValidateThaumaturgeComponent()
	if(owner && !thaumaturge_component)
		thaumaturge_component = owner.GetComponent(/datum/component/thaumaturge)
	if(!thaumaturge_component)
		return FALSE
	return TRUE

/datum/action/cooldown/power/thaumaturge/try_use(mob/living/user, atom/target)
	ValidateThaumaturgeComponent()
	if(!check_if_valid(user))
		return FALSE
	if(ishuman(user)) // We're not checking for clothes on cats
		affinity = get_affinity(user)
	if(affinity < required_affinity) // Do we have the minimal required affinity
		owner.balloon_alert(user, "requires [required_affinity] affinity!")
		return FALSE
	// Ensures extra anti-magic flags get properly added retroactively to powers.
	magic_resistance_types = thaumaturge_component.additional_magic_resistance_flags
	. = ..()

// The charge deduction is handled on_action_success and thusly gains override_charges as an arg.
// If your spell does anything unusual with charges such as refunds or costing multiples, this is where you would handle that.
// You can otherwise use on_action_success as normal, just make sure to call parent.
/datum/action/cooldown/power/thaumaturge/on_action_success(mob/living/user, atom/target, override_charges)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	ValidateThaumaturgeComponent()
	last_power_refunded = handle_power_refund()
	if(last_power_refunded)
		override_charges = 0
		to_chat(owner, span_notice("Your [name] spell did not consume a charge!"))

	charge_mechanics = isnull(thaumaturge_component?.charge_mechanics) ? charge_mechanics : thaumaturge_component.charge_mechanics
	if(charge_mechanics)
		adjust_charges(isnull(override_charges) ? -charges_to_use : -override_charges)
	check_if_valid(user)
	return

/// Handles refund chance for powers that support it.
/datum/action/cooldown/power/thaumaturge/proc/handle_power_refund()
	if(!power_refunds)
		return FALSE
	// Hemomancy-style roots do not use charge mechanics, so they should never roll refunds.
	if(!isnull(thaumaturge_component?.charge_mechanics) && !thaumaturge_component.charge_mechanics)
		return FALSE
	var/refund_chance = clamp(power_refund_chance + (power_refund_affinity_bonus * max(affinity, 0)), 0, THAUMATURGE_REFUND_MAX)
	if(prob(refund_chance))
		return TRUE
	return FALSE

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
	ValidateThaumaturgeComponent()
	var/highest_affinity = 0

	// If the root power benefits from dressing like a wizard.
	if(thaumaturge_component?.affinity_benefits_from_items)
		// Checks if you're wearing items with affinity. This has to be clothing; wearing your staff does not count.
		var/list/equipped_items = user.get_equipped_items()
		for(var/obj/item/equipped_item as anything in equipped_items)
			if(!equipped_item)
				continue
			if(!istype(equipped_item, /obj/item/clothing) && !equipped_item.affinity_worn_override)
				continue

			if(equipped_item.affinity > highest_affinity)
				highest_affinity = equipped_item.affinity

		// Checks if you're holding items with affinity.
		for(var/obj/item/held_item as anything in user.held_items)
			if(!held_item)
				continue

			// Holding clothing or worn-override items shouldn't contribute.
			if(istype(held_item, /obj/item/clothing) || held_item.affinity_worn_override)
				continue

			if(held_item.affinity > highest_affinity)
				highest_affinity = held_item.affinity

	// Seed affinity and let external listeners influence affinity.
	// Generally speaking you should only add and subtract to this number.
	affinity = highest_affinity
	SEND_SIGNAL(user, COMSIG_THAUMATURGE_AFFINITY_QUERY, src)
	return max(0, affinity)

/*
	Deviating massively from the original cooldown system, thaumaturge has charges they have to prepare and plan for in advance, just like the classic vanician spellcasting system.
	Mechanically, we check if charges are 0. If so we Disable(). Otherwise, we deduct a charge and go on a short cooldown.
*/

/// Checks if we have charges to use.
/datum/action/cooldown/power/thaumaturge/proc/check_if_valid(mob/living/user = owner)
	ValidateThaumaturgeComponent()
	update_charges_overlay()
	if(!thaumaturge_component?.charge_mechanics)
		enable()
		return TRUE

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
	ValidateThaumaturgeComponent()
	var/used_mode = thaumaturge_component?.resource_display_mode || THAUMATURGE_RESOURCE_DISPLAY_CHARGES

	// Usually we only show a resource number for charge-based actions.
	// Hemomancy-style roots can still request prep_cost display even with null max_charges.
	if(!max_charges && used_mode != THAUMATURGE_RESOURCE_DISPLAY_PREP_COST)
		return

	ui_element.cut_overlay(charge_overlay)
	charge_overlay = new/mutable_appearance
	charge_overlay.maptext_width = 32
	charge_overlay.maptext_height = 16

	// Bottom-left-ish
	charge_overlay.maptext_x = 4
	charge_overlay.maptext_y = 0

	var/used_color = thaumaturge_component?.charges_color || "#ff69b4"
	var/display_value = get_resource_display_value()
	// Don't render "0" for prep-cost displays; zero-cost powers should look costless.
	if(used_mode == THAUMATURGE_RESOURCE_DISPLAY_PREP_COST && display_value <= 0)
		build_all_button_icons(UPDATE_BUTTON_STATUS)
		return
	charge_overlay.maptext = MAPTEXT("<span style='text-align:left; color:[used_color];'>[display_value]</span>")
	ui_element.add_overlay(charge_overlay)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Gets the numeric value shown in the resource overlay.
/datum/action/cooldown/power/thaumaturge/proc/get_resource_display_value()
	ValidateThaumaturgeComponent()
	var/used_mode = thaumaturge_component?.resource_display_mode || THAUMATURGE_RESOURCE_DISPLAY_CHARGES
	var/used_mult = thaumaturge_component?.resource_display_multiplier || 1
	// Prep cost a la hemomancy
	if(used_mode == THAUMATURGE_RESOURCE_DISPLAY_PREP_COST)
		return prep_cost * max(used_mult, 1)
	// Charges a la spell preperation.
	return charges * max(used_mult, 1)

/// Get the moveable atom specifically for adjusting the number.
/datum/action/cooldown/power/thaumaturge/proc/get_atom_moveable()
	for(var/datum/hud/hud_instance as anything in viewers)
		var/atom/movable/screen/movable/action_button/action_button_instance = viewers[hud_instance]
		if(istype(action_button_instance, /atom/movable/screen/movable/action_button))
			return action_button_instance

