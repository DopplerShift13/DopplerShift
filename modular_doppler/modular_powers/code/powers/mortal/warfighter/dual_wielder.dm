/*
	Allows toggling a dual-wield stance.
	When active, a melee attack with one weapon immediately follows with an off-hand strike.
	Both strikes have an independent flat miss chance.
*/

#define DUAL_WIELD_OFFHAND "dual_wield_offhand"
#define DUAL_WIELD_ATTACK_ITEM "dual_wield_attack_item"
#define DUAL_WIELD_HAS_FORCED_MISS "dual_wield_has_forced_miss"
#define DUAL_WIELD_FORCED_MISS "dual_wield_forced_miss"

/datum/power/warfighter/dual_wielder
	name = "Dual Wielder"
	desc = "You can toggle a dual-wield stance. While active, striking with a melee weapon immediately follows with an off-hand strike. Both strikes have a 30% chance to miss."
	security_record_text = "Subject knows how to efficiently fight with two melee weapons at once."
	security_threat = POWER_THREAT_MAJOR
	value = 5

	required_powers = list(/datum/power/warfighter/quick_draw)
	action_path = /datum/action/cooldown/power/warfighter/dual_wielder

/datum/action/cooldown/power/warfighter/dual_wielder
	name = "Dual Wield"
	desc = "Toggle dual-wielding. While active, melee attacks immediately follow with an off-hand strike (each strike has a 30% miss chance)."
	button_icon = 'modular_doppler/modular_powers/icons/powers/actions_icons.dmi'
	button_icon_state = "dual_wield"

	// starts on
	active = TRUE
	// Chance that we miss a swing
	var/dual_wield_miss_chance = 30
	/// Overlay for mirrored icon when active.
	var/mutable_appearance/dual_wield_overlay

/datum/action/cooldown/power/warfighter/dual_wielder/use_action(mob/living/user, atom/target)
	active = !active
	user.balloon_alert(user, active ? "dual wield on" : "dual wield off")
	button_icon_state = (active ? "dual_wield" : "dual_wield_off")
	build_all_button_icons(UPDATE_BUTTON_ICON | UPDATE_BUTTON_STATUS) // need this so the icon state updates.
	return TRUE

/datum/action/cooldown/power/warfighter/dual_wielder/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_melee_attack))

/datum/action/cooldown/power/warfighter/dual_wielder/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, COMSIG_MOB_ITEM_ATTACK)

/datum/action/cooldown/power/warfighter/dual_wielder/proc/on_melee_attack(mob/living/source, atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER

	if(source != owner)
		return
	if(!active)
		return

	var/is_offhand = LAZYACCESS(attack_modifiers, DUAL_WIELD_OFFHAND)
	var/obj/item/main_item = source.get_active_held_item()
	var/obj/item/off_item = source.get_inactive_held_item()
	// Only apply dual-wield logic if both hands are valid melee weapons (force > 0).
	if(!is_valid_melee_item(main_item) || !is_valid_melee_item(off_item))
		return
	var/obj/item/attacking_item = LAZYACCESS(attack_modifiers, DUAL_WIELD_ATTACK_ITEM) || main_item

	var/forced_miss = FALSE
	var/has_forced_miss = LAZYACCESS(attack_modifiers, DUAL_WIELD_HAS_FORCED_MISS)
	if(has_forced_miss)
		forced_miss = LAZYACCESS(attack_modifiers, DUAL_WIELD_FORCED_MISS)
	var/main_miss = has_forced_miss ? forced_miss : prob(dual_wield_miss_chance)

	var/offhand_attempted = FALSE
	var/offhand_miss = FALSE
	if(!is_offhand)
		offhand_miss = prob(dual_wield_miss_chance)
		offhand_attempted = try_offhand_attack(source, target, modifiers, offhand_miss)

	if(main_miss)
		if(offhand_attempted && offhand_miss) // if you miss both
			user.do_attack_animation(target, used_item = attacking_item)
			user.visible_message(span_warning("[user] misses with both weapons!"), span_danger("<b>You miss with both weapons!</b>"))
			playsound(owner, 'sound/items/weapons/etherealmiss.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(!is_offhand && offhand_attempted && !offhand_miss) // if you hit both
		target.visible_message(span_warning("[user] lands a hit with both weapons!"), span_userdanger("<b>You were hit by both of [user]'s weapons!</b>"))
		playsound(owner, 'sound/items/weapons/etherealhit.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/datum/action/cooldown/power/warfighter/dual_wielder/proc/is_valid_melee_item(obj/item/item)
	if(!item)
		return FALSE
	if(istype(item, /obj/item/offhand))
		return FALSE
	if(item.item_flags & NOBLUDGEON)
		return FALSE
	if(istype(item, /obj/item/gun))
		return FALSE
	if(item.force <= 0)
		return FALSE
	return TRUE

/datum/action/cooldown/power/warfighter/dual_wielder/proc/try_offhand_attack(mob/living/source, atom/target, list/modifiers, offhand_miss)
	var/obj/item/offhand = source.get_inactive_held_item()
	if(!is_valid_melee_item(offhand))
		return FALSE
	if(offhand == source.get_active_held_item())
		return FALSE
	if(!source.Adjacent(target))
		return FALSE

	INVOKE_ASYNC(offhand, TYPE_PROC_REF(/obj/item, melee_attack_chain), source, target, modifiers, list(DUAL_WIELD_OFFHAND = TRUE, DUAL_WIELD_ATTACK_ITEM = offhand, DUAL_WIELD_HAS_FORCED_MISS = TRUE, DUAL_WIELD_FORCED_MISS = offhand_miss))
	return TRUE

#undef DUAL_WIELD_OFFHAND
#undef DUAL_WIELD_ATTACK_ITEM
#undef DUAL_WIELD_HAS_FORCED_MISS
#undef DUAL_WIELD_FORCED_MISS
