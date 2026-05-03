/datum/power/theologist/smiting_strike
	name = "Smiting Strike"
	desc = "Channel energy into the item you are currently holding. Your next attack that hits with it against a creature deals 15 additional burn damage and sends them flying backwards 4 spaces. This deals extra damage to unholy creatures. \
	This knockback cannot stun or damage on impact. Costs 5 Piety to use. This effect ends if the item leaves your hands."
	security_record_text = "Subject can bless their own weapons to knock back foes and sear their bodies."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/theologist/smiting_strike
	value = 4

	required_powers = list(/datum/power/theologist_root/revered)

/datum/action/cooldown/power/theologist/smiting_strike
	name = "Smiting Strike"
	desc = "Channel energy into the item you are currently holding. Your next attack that hits with it against a creature deals 15 additional burn damage and sends them flying backwards 4 spaces. This deals extra damage to unholy creatures. \
	This knockback cannot stun or damage on impact. Costs 5 Piety to use. This effect ends if the item leaves your hands."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "sword_fling"
	cooldown_time = 60
	cost = 5

	/// How much damage the smite element will do
	var/smite_damage = 15
	/// How much distance the smite element will knock back
	var/smite_knockback = 4
	/// How much bonus damage does it do to unholy targets.
	var/unholy_smite_bonus = 10
	///If the upgrade to imbue multiple items is unlocked.
	var/can_imbue_multiples
	///If it singular, which one is the one currently imbued?
	var/obj/currently_imbued

/datum/action/cooldown/power/theologist/smiting_strike/use_action(mob/living/user, atom/target)
	var/obj/item/potential_smite = owner.get_active_held_item()
	if(!potential_smite)
		if(owner.get_inactive_held_item())
			to_chat(owner, span_warning("You must hold the desired item in your hands to imbue it!"))
		else
			to_chat(owner, span_warning("You aren't holding anything that can be imbued!"))
		return FALSE

	// To prevent you from smiting with something that doesn't normally want you to attack wtih it.
	if(potential_smite.force <= 0)
		to_chat(owner, span_warning("Item is too weak"))
		return FALSE
	// In order to detect our buff, we pass along a trait to the host item.
	if(HAS_TRAIT(potential_smite, TRAIT_HAS_SMITING_STRIKE))
		to_chat(owner, span_warning("The item is already imbued!"))
		return FALSE
	if(potential_smite.item_flags & ABSTRACT)
		return FALSE
	if(SEND_SIGNAL(potential_smite, COMSIG_ITEM_MARK_RETRIEVAL, src, owner) & COMPONENT_BLOCK_MARK_RETRIEVAL)
		return FALSE

	if(!can_imbue_multiples)
		imbue_singular(potential_smite)
	else
		imbue_global(potential_smite)
	return TRUE

/// Applies the element to the item and removes it from any other actively imbued item.
/datum/action/cooldown/power/theologist/smiting_strike/proc/imbue_singular(obj/to_imbue)
	if(currently_imbued)
		var/thingholdingimbued = currently_imbued.loc
		if(ismob(thingholdingimbued))
			to_chat(thingholdingimbued, span_warning("The smiting energies leave [currently_imbued]"))
		currently_imbued.RemoveElement(/datum/element/theologist_smite)
		currently_imbued = null
	currently_imbued = to_imbue
	currently_imbued.AddElement(/datum/element/theologist_smite, smite_damage, smite_knockback, FALSE, TRUE, TRUE)
	to_chat(owner, span_notice("You infuse smiting energies into [currently_imbued]"))

/// Applies the element and does not remove any existing ones.
/datum/action/cooldown/power/theologist/smiting_strike/proc/imbue_global(obj/to_imbue)
	to_imbue.AddElement(/datum/element/theologist_smite, smite_damage, smite_knockback, FALSE, TRUE, FALSE)
	to_chat(owner, span_notice("You infuse smiting energies into [to_imbue]"))

// Whilst I originally considered adding just the knockback element, we kind-of want more control over when the smite fades.
/datum/element/theologist_smite
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// extra damage the smite does
	var/smite_damage
	/// extra damage to unholy targets
	var/unholy_smite_bonus
	/// distance the atom will be thrown
	var/throw_distance
	/// whether this can throw anchored targets (tables, etc)
	var/throw_anchored
	/// whether this is a gentle throw (default false means people thrown into walls are stunned / take damage)
	var/throw_gentle
	/// whether dropping this item ends the element
	var/self_terminate_on_drop
	/// The person assigned to be the holder of the object.
	var/mob/living/holder
	/// the bless effect
	var/image/bless_overlay


// This is basically the knockback code but hybridized. Sue me.
/datum/element/theologist_smite/Attach(atom/target, smite_damage = 1, unholy_smite_bonus = 1, throw_distance = 1, throw_anchored = FALSE, throw_gentle = FALSE, self_terminate_on_drop = FALSE)
// While the balancer inside me suggests we restrict this to melee hits... I kind of want to see the fun of ranged smites.
// For the future person to balance this; really just remove projectile_hit() and the first if in this sequence if you want to axe ranged.
	. = ..()
	if(isgun(target) || isprojectilespell(target)) // turrets, etc
		RegisterSignal(target, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	else if(isitem(target))
		RegisterSignal(target, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		return ELEMENT_INCOMPATIBLE

	ADD_TRAIT(target, TRAIT_HAS_SMITING_STRIKE, src)
	src.smite_damage = smite_damage
	src.unholy_smite_bonus = unholy_smite_bonus
	src.throw_distance = throw_distance
	src.throw_anchored = throw_anchored
	src.throw_gentle = throw_gentle
	src.self_terminate_on_drop = self_terminate_on_drop

	if(isitem(target) && self_terminate_on_drop) // No point tracking this if we aren't going to self_terminate on drop
		RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))

	// Applies the sparkling bless effect
	// I'd normally do mutable_appearance but overlays are uppity with elements and this method works with rust soooo I am using it like this.
	bless_overlay = image(icon = 'icons/effects/effects.dmi', icon_state = "blessed", layer = target.layer - 0.1)
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(apply_bless_overlay))
	target.update_appearance()
	// dispel listener
	RegisterSignal(target, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))


/// Checks if the item is no longer in our hands. If so, remove this element.
/datum/element/theologist_smite/proc/on_item_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	if(self_terminate_on_drop)
		Detach(source)
	return

/// Applies the overlay effect
/datum/element/theologist_smite/proc/apply_bless_overlay(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER

	if(bless_overlay)
		overlays += bless_overlay

// Prevents signalers from loitering.
/datum/element/theologist_smite/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_DISPEL)
	UnregisterSignal(source, list(COMSIG_ITEM_AFTERATTACK, COMSIG_HOSTILE_POST_ATTACKINGTARGET, COMSIG_PROJECTILE_ON_HIT, COMSIG_ATOM_UPDATE_OVERLAYS))
	if(self_terminate_on_drop)
		UnregisterSignal(source, COMSIG_ITEM_DROPPED)
	REMOVE_TRAIT(source, TRAIT_HAS_SMITING_STRIKE, src)
	source.update_appearance()
	holder = null
	return ..()


/// triggered after an item attacks something
/datum/element/theologist_smite/proc/item_afterattack(obj/item/source, atom/target, mob/user, list/modifiers)
	SIGNAL_HANDLER

	if(!isliving(target))
		return
	if(on_hit(target, user, get_dir(source, target)))
		Detach(source)


/// triggered after a projectile hits something
/datum/element/theologist_smite/proc/projectile_hit(datum/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER

	if(!isliving(target))
		return
	if(on_hit(target, null, angle2dir(Angle)))
		Detach(fired_from)

/// The on hit effect
/datum/element/theologist_smite/proc/on_hit(mob/living/target, mob/thrower, throw_dir)
	//Knockback code
	if(!ismovable(target) || throw_dir == null)
		return FALSE
	if(target.anchored && !throw_anchored)
		return FALSE
	// Magic immune
	if(target.can_block_resonance(1))
		// deliberately eats your smite.
		return TRUE
	if(throw_distance < 0)
		throw_dir = REVERSE_DIR(throw_dir)
		throw_distance *= -1
	var/atom/throw_target = get_edge_target_turf(target, throw_dir)
	target.safe_throw_at(throw_target, throw_distance, 1, thrower, gentle = throw_gentle)
	new /obj/effect/temp_visual/electricity(get_turf(target), "#ddd166")
	playsound(target, 'sound/effects/magic/magic_block_holy.ogg', 75, TRUE)
	//If the mob is in the unholy mob typecache, they take more damage from smite.
	if(is_type_in_typecache(target, GLOB.unholy_mobs))
		target.adjustFireLoss(smite_damage + unholy_smite_bonus)
	else
		target.adjustFireLoss(smite_damage)
	to_chat(target, span_userdanger("You are knocked back by a burning, resonant energy!"))
	return TRUE

/// The on dispel effect
/datum/element/theologist_smite/proc/on_dispel(atom/source, atom/dispeller)
	SIGNAL_HANDLER
	Detach(source)
