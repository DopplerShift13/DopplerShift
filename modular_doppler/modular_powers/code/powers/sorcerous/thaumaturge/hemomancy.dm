/*
	Variant of spell preperation. Rather than needing to choose and prepare spells, you have access to all your chosen spells (with an increased root cost to compensate).
	You instead pay the spell's cost in blood, proportional to charge_cost.
	Comes with an innate ability to drain blood from various things much like sanguine absorption. So you can aura-farm blood without needing to quite literally drink it.
	Given the cultist stereotypes, your magic is also now affected by holy resistance.
*/
/datum/power/thaumaturge_root/hemomancy
	name = "Hemomancy"
	desc = "You cast spells by channeling your blood. All your spells drain your blood when wielding them, usually 4 * the power's allocation cost. \
	Blood exceeding 110% of your natural blood threshold is consumed at higher rates to boost the affinity of your spells, empowering them to higher levels of Affinity, up to a maximum of 6. This does not trigger on spells that have a chance refund charges based on affinity. \
	\nYou cannot gain Affinity from items, you do not benefit from random chance to refund charges on spells, and all your spells are now affected by holy resistance.\
	\nYou also gain the Channel Blood action. Using it allows you to transfer blood from various sources back to you (and converts the blood-type to yours), and grants Affinity 3 (4 if you're a Hemophage) while the channel is active. Requires an empty hand."
	security_record_text = "Subject is capable of wielding their blood to perform thaumaturgic magic."
	action_path = /datum/action/cooldown/power/thaumaturge/channel_blood
	species_blacklist = list(/datum/species/android, /datum/species/android/holosynth, /datum/species/golem, /datum/species/plasmaman, /datum/species/ethereal, /datum/species/jelly, /datum/species/pod, /datum/species/snail) // You can't do blood magic without blood, duh!
	value = 5
	magic_flags = POWER_MAGIC_STANDARD | POWER_MAGIC_UNHOLY

/datum/power/thaumaturge_root/hemomancy/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// Spell preperation is so complicated we basically handle it all in a component, including the UI part.
	power_holder.AddComponent(/datum/component/thaumaturge/hemomancy, power_holder)
	. = ..()

/datum/power/thaumaturge_root/hemomancy/remove()
	. = ..()
	if(!power_holder)
		return
	var/tobedel = power_holder.GetComponent(/datum/component/thaumaturge/hemomancy)
	QDEL_NULL(tobedel)

/datum/action/cooldown/power/thaumaturge/channel_blood
	name = "Channel Blood"
	desc = "Empowers your hand with the ability to absorb blood from the touched object or creature, and converting it to your own bloodtype. Whilst active, you have Affinity 3 with your Thaumaturge spells, but cannot use that hand until you cancel the ability."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "manip"
	max_charges = null
	cooldown_time = 15

	prep_cost = 0

/datum/action/cooldown/power/thaumaturge/channel_blood/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/thaumaturge/channel_blood/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/datum/action/cooldown/power/thaumaturge/channel_blood/use_action(mob/living/user, atom/target)
	// Deletes the hand if active
	if(active)
		for(var/obj/item/melee/channel_blood/blood_hand in user.held_items)
			qdel(blood_hand)
			playsound(get_turf(user), 'sound/effects/magic/enter_blood.ogg', 30, TRUE, SILENCED_SOUND_EXTRARANGE)
			to_chat(user, span_notice("You dissipate the blood around your hand back into your body."))
			user.update_held_items()
		active = FALSE
		return TRUE

	// Checks if the hand is occupied
	if(user.get_active_held_item())
		user.balloon_alert(user, "hand occupied!")
		return FALSE

	// Attempts to make a new blood hand
	var/obj/item/melee/channel_blood/new_blood_hand = new(user, src)
	if(!user.put_in_active_hand(new_blood_hand))
		qdel(new_blood_hand)
		return FALSE
	playsound(user, 'sound/effects/magic/enter_blood.ogg', 30, TRUE, SILENCED_SOUND_EXTRARANGE)
	active = TRUE
	return TRUE

/// When dispelled, the bloodied hand dissipates.
/datum/action/cooldown/power/thaumaturge/channel_blood/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE

	for(var/obj/item/melee/channel_blood/blood_hand in owner.held_items)
		qdel(blood_hand)
		to_chat(owner, span_boldwarning("Your bloodied hand dissipates against your own volition!"))
		owner.update_held_items()
		break

	active = FALSE
	StartCooldownSelf(150)
	return DISPEL_RESULT_DISPELLED

/*
	Touch-based hand that handles all the interactions.
*/
/obj/item/melee/channel_blood
	name = "Channeled Blood"
	desc = "A bloodied hand, entirely submerged in your own blood and sticking to it through supernatural means. It appears ready to burst as you channel your magic. \
	Can be used to drain blood from objects and creatures."
	icon = 'icons/obj/weapons/hand.dmi'
	lefthand_file = 'icons/mob/inhands/items/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/touchspell_righthand.dmi'
	icon_state = "scream_for_me"
	inhand_icon_state = "disintegrate"
	item_flags = ABSTRACT | DROPDEL | HAND_ITEM
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	affinity = 3 // this doesn't do anything by itself: though it alters the description to say it gives Affinity 3.
	/// How much blood we drain per touch from objects.
	var/drain_amount = 25
	/// How much blood we drain from a mob per second.
	var/mob_drain_amount = 10
	/// The action that created this hand.
	var/datum/weakref/source_action_ref

/obj/item/melee/channel_blood/Initialize(mapload, datum/action/cooldown/power/thaumaturge/channel_blood/source_action)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
	if(source_action)
		source_action_ref = WEAKREF(source_action)

// Adds a listener to the affinity check
/obj/item/melee/channel_blood/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	RegisterSignal(user, COMSIG_THAUMATURGE_AFFINITY_QUERY, PROC_REF(on_thaumaturge_affinity_query))
	// Sets the affinity higher if we're a hemophage.
	if(ishemophage(user))
		affinity = 4

// Removes the affinity check listener.
/obj/item/melee/channel_blood/dropped(mob/user, silent = FALSE)
	if(isliving(user))
		clear_channel_state(user)
	. = ..()

/obj/item/melee/channel_blood/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!isliving(old_loc) || loc == old_loc || QDELETED(src))
		return

	var/mob/living/old_holder = old_loc
	clear_channel_state(old_holder)
	qdel(src)

// Removes the affinity check listener.
/obj/item/melee/channel_blood/Destroy(force)
	if(isliving(loc))
		var/mob/living/holder = loc
		clear_channel_state(holder)
	return ..()

/// Removes the hand and if the pwower exists, sets it to non-active.
/obj/item/melee/channel_blood/proc/clear_channel_state(mob/living/holder)
	if(!holder)
		return

	UnregisterSignal(holder, COMSIG_THAUMATURGE_AFFINITY_QUERY)

	var/datum/action/cooldown/power/thaumaturge/channel_blood/source_action = source_action_ref?.resolve()
	if(!QDELETED(source_action))
		source_action.active = FALSE
		return

	for(var/datum/action/cooldown/power/action as anything in holder.actions)
		if(!istype(action, /datum/action/cooldown/power/thaumaturge/channel_blood))
			continue

		action.active = FALSE
		return

/// While this hand is held, it contributes +3 affinity to thaumaturge actions.
/obj/item/melee/channel_blood/proc/on_thaumaturge_affinity_query(mob/living/source, datum/action/cooldown/power/thaumaturge/action)
	SIGNAL_HANDLER
	if(!action)
		return
	action.affinity += 3

	// Checks if we're a hemophage and if so give a +1 bonus to affinity ontop of that.
	if(ishemophage(source))
		action.affinity += 1

// Handles blood draining and blocks default melee attack behavior.
/obj/item/melee/channel_blood/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isliving(user) || !target)
		return TRUE
	if(get_dist(user, target) > 1)
		return TRUE

	// If the target is a living mob, we start a beam effect.
	if(isliving(target))
		var/mob/living/target_mob = target
		if(start_blood_channel(target_mob, user))
			user.visible_message(span_warning("[user] starts magically draining the blood out of [target_mob]!"))
			to_chat(user, span_notice("You begin channeling blood from [target_mob]."))
		else
			to_chat(user, span_warning("You failed to channel blood from [target_mob]!"))
		return

	var/drained = drain_blood_from_target(target, user, drain_amount)
	if(drained <= 0)
		to_chat(user, span_warning("You failed to draw any blood!"))
		return

	user.blood_volume += drained
	to_chat(user, span_notice("You siphon [round(drained, 0.1)]u of blood into yourself."))
	playsound(get_turf(user), 'sound/effects/splat.ogg', 30, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/// Proc that determines what function we call for the target, depending on what we're drawing blood from.
/obj/item/melee/channel_blood/proc/drain_blood_from_target(atom/target, mob/living/user, amount)
	if(istype(target, /obj/item/reagent_containers))
		return drain_blood_from_container(target, amount)
	if(istype(target, /obj/effect/decal/cleanable/blood))
		return drain_blood_from_decal(target, amount)
	return 0

/// Starts or refreshes blood channeling on a mob.
/obj/item/melee/channel_blood/proc/start_blood_channel(mob/living/target_mob, mob/living/user)
	if(!target_mob || !user)
		return FALSE
	// Respect anti-magic protections similarly to power anti_magic_on_target handling.
	if(target_mob.can_block_resonance(1) || target_mob.can_block_magic(MAGIC_RESISTANCE | MAGIC_RESISTANCE_HOLY, charge_cost = 1))
		return FALSE
	if(target_mob.get_blood_reagent() != /datum/reagent/blood || target_mob.blood_volume <= 0)
		return FALSE

	// Removes it if its already there.
	target_mob.remove_status_effect(/datum/status_effect/power/thaumaturge_blood_channeling)
	return target_mob.apply_status_effect(/datum/status_effect/power/thaumaturge_blood_channeling, user, mob_drain_amount)

/// Acquires blood from a reagent container.
/obj/item/melee/channel_blood/proc/drain_blood_from_container(obj/item/reagent_containers/container, amount)
	if(!container?.reagents || amount <= 0)
		return 0
	var/available = container.reagents.get_reagent_amount(/datum/reagent/blood)
	if(available <= 0)
		return 0
	var/to_take = min(amount, available)
	container.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)
	return to_take

/// Acquires blood from decals.
/obj/item/melee/channel_blood/proc/drain_blood_from_decal(obj/effect/decal/cleanable/blood/blood_decal, amount)
	if(!blood_decal || amount <= 0)
		return 0
	if(blood_decal.dried || blood_decal.bloodiness <= 0)
		return 0
	if(!(blood_decal.decal_reagent == /datum/reagent/blood || blood_decal.reagents?.has_reagent(/datum/reagent/blood)))
		return 0

	var/available_units = blood_decal.bloodiness * BLOOD_TO_UNITS_MULTIPLIER
	if(available_units <= 0)
		return 0

	var/to_take = min(amount, available_units)
	if(to_take >= available_units)
		if(blood_decal.reagents)
			blood_decal.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)
		qdel(blood_decal)
	else
		var/bloodiness_to_remove = to_take / BLOOD_TO_UNITS_MULTIPLIER
		blood_decal.adjust_bloodiness(-bloodiness_to_remove)
		if(blood_decal.reagents)
			blood_decal.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)

	return to_take

/*
	Status effect used for continuous blood channeling from mob targets.
*/
/datum/status_effect/power/thaumaturge_blood_channeling
	id = "thaumaturge_blood_channeling"
	duration = -1
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/thaumaturge_blood_channeling

	/// Who receives the siphoned blood.
	var/mob/living/channel_origin
	/// Continuous beam visual.
	var/datum/beam/channel_beam
	/// Blood moved each tick.
	var/channel_amount = 10

// Passes the channel amount from the var over.
/datum/status_effect/power/thaumaturge_blood_channeling/on_creation(mob/living/new_owner, mob/living/new_channel_origin, new_channel_amount)
	channel_origin = new_channel_origin
	if(isnum(new_channel_amount))
		channel_amount = max(0, new_channel_amount)
	. = ..()

// Creates the beaaam.
/datum/status_effect/power/thaumaturge_blood_channeling/on_apply()
	. = ..()
	if(!isliving(owner) || !isliving(channel_origin))
		return FALSE
	if(get_dist(owner, channel_origin) > 1)
		return FALSE
	channel_beam = owner.Beam(channel_origin, icon_state = "blood", time = 10 MINUTES, maxdistance = 1)
	to_chat(owner, span_userdanger("You feel your blood being siphoned by [channel_origin]!"))
	return TRUE

// Deletes the beaaaam
/datum/status_effect/power/thaumaturge_blood_channeling/on_remove()
	QDEL_NULL(channel_beam)
	return ..()

// Transfers blood on tick.
/datum/status_effect/power/thaumaturge_blood_channeling/tick(seconds_between_ticks)
	var/mob/living/channel_target = owner
	if(!channel_target || !channel_origin)
		qdel(src)
		return

	// Channel requires adjacency.
	if(get_dist(channel_target, channel_origin) > 1)
		qdel(src)
		return

	// Origin must still be actively channeling with the blood hand and action toggled on.
	if(!origin_can_channel())
		qdel(src)
		return

	// Respect anti-magic and blood validity each tick.
	if(channel_target.can_block_resonance(1) || channel_target.can_block_magic(MAGIC_RESISTANCE | MAGIC_RESISTANCE_HOLY, charge_cost = 1))
		qdel(src)
		return
	if(channel_target.get_blood_reagent() != /datum/reagent/blood || channel_target.blood_volume <= 0)
		qdel(src)
		return

	var/transferred = min(channel_amount, channel_target.blood_volume)
	// if juice-box, delete.
	if(transferred <= 0)
		qdel(src)
		return

	channel_target.blood_volume = max(channel_target.blood_volume - transferred, 0)
	channel_origin.blood_volume += transferred

/// Validates if the original caster meets the prerequisites.
/datum/status_effect/power/thaumaturge_blood_channeling/proc/origin_can_channel()
	if(!isliving(channel_origin))
		return FALSE

	// If the blood hand is active
	var/has_live_blood_hand = FALSE
	for(var/obj/item/melee/channel_blood/blood_hand as anything in channel_origin.held_items)
		if(QDELETED(blood_hand) || blood_hand.loc != channel_origin)
			continue
		has_live_blood_hand = TRUE
		break
	if(!has_live_blood_hand)
		return FALSE

	// If the power is considered active.
	for(var/datum/action/action as anything in channel_origin.actions)
		if(!istype(action, /datum/action/cooldown/power/thaumaturge/channel_blood))
			continue
		var/datum/action/cooldown/power/thaumaturge/channel_blood/channel_action = action
		return !!channel_action.active
	return FALSE

/atom/movable/screen/alert/status_effect/thaumaturge_blood_channeling
	name = "Blood Channeling"
	desc = "Your blood is being drained!"
	icon = 'icons/mob/actions/actions_cult.dmi'
	icon_state = "manip"
