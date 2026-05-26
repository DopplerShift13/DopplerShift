/*
	Variant of spell preperation. Rather than needing to choose and prepare spells, you have access to all your chosen spells (with an increased root cost to compensate).
	You instead pay the spell's cost in blood, proportional to charge_cost.
	Comes with an innate ability to drain blood from various things much like sanguine absorption. So you can aura-farm blood without needing to quite literally drink it.
*/
/datum/power/thaumaturge_root/hemomancy
	name = "Hemomancy"
	desc = "You cast spells by channeling your blood. All your spells drain your blood when wielding them, usually 3 * the power's cost. \
	Blood exceeding 110% of your natural blood threshold is consumed at higher rates to boost the affinity of your spells, empowering them to higher levels of Affinity, up to a maximum of 6. You cannot gain Affinity from items.\
	\n You also gain the Channel Blood action. Using it allows you to transfer blood from various sources back to you (and converts the blood-type to yours), and grants Affinity 3 (4 if you're a Hemophage) while the channel is active. Requires an empty hand."
	security_record_text = "Subject is capable of wielding their blood to perform thaumaturgic magic."
	action_path = /datum/action/cooldown/power/thaumaturge/channel_blood
	charges_color = "#c72222"
	resource_display_mode = THAUMATURGE_RESOURCE_DISPLAY_PREP_COST
	charge_mechanics = FALSE
	species_blacklist = list(/datum/species/android, /datum/species/android/holosynth, /datum/species/golem, /datum/species/plasmaman, /datum/species/ethereal, /datum/species/jelly, /datum/species/pod, /datum/species/snail) // You can't do blood magic without blood, duh!
	value = 5

/datum/power/thaumaturge_root/hemomancy/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// Spell preperation is so complicated we basically handle it all in a component, including the UI part.
	power_holder.AddComponent(/datum/component/thaumaturge_hemomancy, power_holder)
	. = ..()

/datum/power/thaumaturge_root/hemomancy/remove()
	. = ..()
	if(!power_holder)
		return
	var/tobedel = power_holder.GetComponent(/datum/component/thaumaturge_hemomancy)
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
	var/obj/item/melee/channel_blood/new_blood_hand = new(user)
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
	item_flags = ABSTRACT | HAND_ITEM | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	affinity = 3 // this doesn't do anything by itself: though it alters the description to say it gives Affinity 3.
	/// How much blood we drain per touch.
	var/drain_amount = 25
	/// Multiplier on the drain against mobs.
	var/drain_mob_mult = 0.4

// Adds a listener to the affinity check
/obj/item/melee/channel_blood/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	RegisterSignal(user, COMSIG_THAUMATURGE_AFFINITY_QUERY, PROC_REF(on_thaumaturge_affinity_query))
	// Sets the affinity higher if we're a hemophage.
	if(ishemophage(user))
		affinity = 4

// Removes the affinity check listener.
/obj/item/melee/channel_blood/dropped(mob/user, silent = FALSE)
	. = ..()
	if(!isliving(user))
		return
	UnregisterSignal(user, COMSIG_THAUMATURGE_AFFINITY_QUERY)

// Removes the affinity check listener.
/obj/item/melee/channel_blood/Destroy(force)
	if(isliving(loc))
		var/mob/living/holder = loc
		UnregisterSignal(holder, COMSIG_THAUMATURGE_AFFINITY_QUERY)
	return ..()

/// While this hand is held, it contributes +3 affinity to thaumaturge actions.
/obj/item/melee/channel_blood/proc/on_thaumaturge_affinity_query(mob/living/source, datum/action/cooldown/power/thaumaturge/action)
	SIGNAL_HANDLER
	if(!action)
		return
	action.affinity += 3

	// Checks if we're a hemophage and if so give a +1 bonus to affinity ontop of that.
	if(ishemophage(source))
		action.affinity += 1

// Handles blood draining from objects
/obj/item/melee/channel_blood/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !isliving(user) || !target)
		return

	var/drained = drain_blood_from_target(target, user, drain_amount)
	if(drained <= 0)
		to_chat(user, span_warning("You failed to draw any blood!"))
		return

	user.blood_volume += drained
	to_chat(user, span_notice("You siphon [round(drained, 0.1)]u of blood into yourself."))
	playsound(get_turf(user), 'sound/effects/splat.ogg', 30, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/// Proc that determines what function we call for the target, depending on what we're drawing blood from.
/obj/item/melee/channel_blood/proc/drain_blood_from_target(atom/target, mob/living/user, amount)
	if(istype(target, /obj/item/reagent_containers))
		return drain_blood_from_container(target, amount)
	if(istype(target, /obj/effect/decal/cleanable/blood))
		return drain_blood_from_decal(target, amount)
	if(isliving(target))
		return drain_blood_from_mob(target, user, amount)
	return 0

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

/// Acquires blood from mobs.
/obj/item/melee/channel_blood/proc/drain_blood_from_mob(mob/living/target_mob, mob/living/user, amount)
	if(!target_mob || amount <= 0)
		return 0
	// Respect anti-magic protections similarly to power anti_magic_on_target handling.
	if(target_mob.can_block_resonance(1) || target_mob.can_block_magic(MAGIC_RESISTANCE | MAGIC_RESISTANCE_HOLY, charge_cost = 1))
		return 0
	if(target_mob.get_blood_reagent() != /datum/reagent/blood || target_mob.blood_volume <= 0)
		return 0
	amount *= drain_mob_mult // you drain less from mobs.
	var/to_take = min(amount, target_mob.blood_volume)
	if(to_take <= 0)
		return 0
	target_mob.blood_volume = max(target_mob.blood_volume - to_take, 0)
	to_chat(target_mob, span_userdanger("You feel your blood being siphoned by [user]!"))
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
