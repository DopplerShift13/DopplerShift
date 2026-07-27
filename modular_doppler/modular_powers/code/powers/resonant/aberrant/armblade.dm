// Its like a weaker version of the changeling armblade.
/datum/power/aberrant/armblade
	name = "Armblade"
	desc = "Allows you to transform your arm into a deadly blade. The weapon itself has high damage, pierces armor and can destroy tables that block your way.\
	\n Requires an empty hand to use."
	security_record_text = "Subject can manifest a sharp-edged blade from their arm."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	required_powers = list(/datum/power/aberrant_root/monstrous)
	action_path = /datum/action/cooldown/power/aberrant/armblade

/datum/action/cooldown/power/aberrant/armblade
	name = "Armblade"
	desc = "Reform your arm into a deadly blade. Using the power again retracts it."
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "armblade"
	active = FALSE

	cooldown_time = 50

/datum/action/cooldown/power/aberrant/armblade/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/aberrant/armblade/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/datum/action/cooldown/power/aberrant/armblade/use_action(mob/living/user, atom/target)
	if(active)
		for(var/obj/item/melee/arm_blade/aberrant/blade in user.held_items)
			user.temporarilyRemoveItemFromInventory(blade, TRUE)
			playsound(user, 'sound/effects/blob/blobattack.ogg', 30, TRUE)
			user.visible_message(
				span_warning("With a sickening crunch, [user] reforms [user.p_their()] blade into an arm!"),
				span_notice("You assimilate the blade back into your body."))
			user.update_held_items()
		active = FALSE
		return TRUE

	if(user.get_active_held_item())
		user.balloon_alert(user, "hand occupied!")
		return FALSE

	var/obj/item/melee/arm_blade/aberrant/new_blade = new(user, FALSE)
	if(!user.put_in_active_hand(new_blade))
		qdel(new_blade)
		return FALSE

	playsound(user, 'sound/effects/blob/blobattack.ogg', 30, TRUE)
	active = TRUE
	return TRUE

/// When dispelled, arm pops back in.
/datum/action/cooldown/power/aberrant/armblade/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE

	for(var/obj/item/melee/arm_blade/aberrant/blade in owner.held_items)
		owner.temporarilyRemoveItemFromInventory(blade, TRUE)
		owner.visible_message(
				span_warning("With a sickening crunch, [owner] reforms [owner.p_their()] blade into an arm!"),
				span_boldwarning("Your arm twists back to normal against your own volition!"))
		owner.update_held_items()
		break

	active = FALSE
	StartCooldownSelf(150)
	return DISPEL_RESULT_DISPELLED

// Weaker version
/obj/item/melee/arm_blade/aberrant
	force = 20
	armour_penetration = 25

// No door forcing.
/obj/item/melee/arm_blade/aberrant/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(target, /obj/structure/table))
		var/obj/smash = target
		smash.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		target.attack_alien(user)

// Override the init as to rephrase the spawn message, preventing changeling nouns of 'our'
/obj/item/melee/arm_blade/aberrant/Initialize(mapload, silent, synthetic)
	. = ..(mapload, TRUE, synthetic) // suppress parent message
	if(ismob(loc))
		loc.visible_message(span_warning("A grotesque blade forms around [loc.name]\'s arm!"), span_notice("Your arm twists and mutates, transforming it into a deadly blade."))
	return .
