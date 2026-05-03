// Will it blend?
// Emulates the effects of a grinder on the target in your hand. Can be used offensively too through aggressive grabs.

/datum/power/thaumaturge/blend_for_me
	name = "Blend For Me"
	desc = "Grinds the item in your hand as if it were inserted in a grinder, then conjures a glass to hold it (if you're grinding). Right-hand for grinding, left-hand for juicing. Can be used on people using an aggressive grab to inflict brute damage and bleeding. \
	\nRequires Affinity 1. Affinity gives a chance to not consume charges."
	security_record_text = "Subject can magically blend drinks, objects and people with their bare hands."
	value = 2

	action_path = /datum/action/cooldown/power/thaumaturge/blend_for_me
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/blend_for_me
	name = "Blend For Me"
	desc = "The younger cousin of a remarkably wicked spell; grinds the item in your hand as if it were inserted in a grinder, then conjures a glass to hold it (if you're grinding). Right-hand for grinding, left-hand for juicing. Can be used on people using an aggressive grab to inflict brute damage and bleeding."
	button_icon = 'icons/obj/machines/kitchen.dmi'
	button_icon_state = "juicer"

	cooldown_time = 50 // we don't want people spamming the blender noise. that's it. that's the whole reason why we force a 5 second cooldown.
	required_affinity = 1
	prep_cost = 2

	/// The grab damage per tick.
	var/grab_blend_brute = 12.5
	/// How many cycles can we blend a person.
	var/grab_blend_duration = 4

/datum/action/cooldown/power/thaumaturge/blend_for_me/use_action(mob/living/user, atom/target)
	// Check first if we are pulling a person. If so we go for the grab_blend
	if(person_blend_conditions(user, target))
		return will_a_person_blend(user, owner.pulling)

	// Are we grinding or juicing?
	var/grinding
	// What item is in our active hand?
	var/obj/item/active_held_item = user.get_active_held_item()
	if(!active_held_item)
		return FALSE

	// Is the item too big?
	if(active_held_item.w_class >= WEIGHT_CLASS_BULKY)
		user.balloon_alert(user, "Too large to blend!")
		return FALSE

	// Which hand is active?
	var/held_index = user.get_held_index_of_item(active_held_item)
	if(!held_index)
		return FALSE
	var/active_is_right_hand = IS_RIGHT_INDEX(held_index)
	if(active_is_right_hand) // If its in the right hand we grind, otherwise we blend.
		grinding = TRUE

	return will_it_blend(user, active_held_item, grinding)

/// Attempts to blend the item.
/datum/action/cooldown/power/thaumaturge/blend_for_me/proc/will_it_blend(mob/living/user, obj/item/input_item, grinding)
	// Start cooldown immediately (anti-spam)
	StartCooldown()

	// FX
	user.Shake(pixelshiftx = 1, pixelshifty = 0, duration = 40)
	playsound(user, grinding ? 'sound/machines/blender.ogg' : 'sound/machines/juicer.ogg', 50, TRUE)

	// Channel
	if(!do_after(user, 4 SECONDS, target = user))
		return FALSE

	// Temporary buffer to house the results so we can neatly transfer it to the same hand.
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE

	var/obj/effect/abstract/thaum_blend_buffer/buffer = new(user_turf, 30)

	// We reject multiple stacks of items for now. Despite multiple attempts, it seems to just NOT WORK?!
	// If you can figure out how, please do :)
	if(istype(input_item, /obj/item/stack))
		var/obj/item/stack/stack_item = input_item
		if(stack_item.amount > 1)
			user.balloon_alert(user, "Split the stack first!")
			return FALSE

	var/success
	// The blending process
	if(grinding)
		success = input_item.grind(buffer.reagents, user)
	else
		success = input_item.juice(buffer.reagents, user)

	if(!success) // If it somehow fails to grind/juice
		user.balloon_alert(user, "[input_item] resists being processed!")
		qdel(buffer)
		return FALSE

	if(buffer.reagents.total_volume <= 0) // If somehow we grind something but ntohing comes out.
		user.balloon_alert(user, "Nothing useful comes out.")
		qdel(buffer)
		return FALSE

	// Conjure bottle AFTER grind so hands are likely freed
	var/obj/item/reagent_containers/cup/glass/bottle/small/result_bottle = new(user_turf)
	user.put_in_hands(result_bottle)

	// Transfer contents
	buffer.reagents.trans_to(result_bottle, buffer.reagents.total_volume, transferred_by = user)
	qdel(buffer)

	return TRUE

// To potentially refund it, we run a small check.
/datum/action/cooldown/power/thaumaturge/blend_for_me/on_action_success(mob/living/user, atom/target, override_charges)
	var/chance_to_refund = clamp(THAUMATURGE_REFUND_MULT_AFFINITY * affinity + THAUMATURGE_REFUND_MULT_BASE, 0, THAUMATURGE_REFUND_MAX)
	if(prob(chance_to_refund))
		override_charges = 0
		to_chat(owner, span_notice("Your [name] spell did not consume a charge!"))
	else if(chance_to_refund >= 51) // At this point it's more common that it does not consume a charge, so we invert them and tell them when it does consume a charge!
		to_chat(owner, span_warning("Your [name] spell consumed a charge!"))
	return ..(user, target, override_charges)


// We create a temporary buffer for holding the reagents, given that our 'blender' in this case isn't a conventional object.
/obj/effect/abstract/thaum_blend_buffer
	name = "resonant blender"
	desc = "You think you're so fancy seeing invisible coder objects huh? Reaaal magician right here."
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE

	/// The reagent_buffer that holds all the reagents temporarily.
	var/datum/reagents/reagent_buffer

	/// Size of the buffer
	var/buffer_volume = 50

/obj/effect/abstract/thaum_blend_buffer/Initialize(mapload, new_buffer_volume)
	. = ..()
	if(isnum(new_buffer_volume) && new_buffer_volume > 0)
		buffer_volume = new_buffer_volume
	reagents = new /datum/reagents(buffer_volume, src)
	reagents.flags = TRANSPARENT | DRAINABLE

/// Check to see if we're allowed to blend people.
/datum/action/cooldown/power/thaumaturge/blend_for_me/proc/person_blend_conditions(/mob/living/user, atom/target)
	return owner.pulling && owner.grab_state <= GRAB_AGGRESSIVE && isliving(owner.pulling)

/// Attemps to blend A PERSON.
/// Keep in mind that if you try to blend an undersized person in your hand, it will use will_it_blend instead.
/datum/action/cooldown/power/thaumaturge/blend_for_me/proc/will_a_person_blend(mob/living/user, mob/living/target)
	// How many times has our do_while hurt the person?
	var/blend_attacks = 0
	owner.visible_message(span_danger("[owner] begins to magically grind [target]'s body to bits!"), span_notice("You begin to grind [target] into a pulp."))
	playsound(user, 'sound/machines/blender.ogg' , 50, TRUE)
	do
		target.Shake(pixelshiftx = 1, pixelshifty = 0, duration = 10)
		if(do_after(owner, 10, target = target) && person_blend_conditions(user, target))
			target.adjustBruteLoss(grab_blend_brute)
			// Carbon mobs can receive wounds.
			if(iscarbon(target))
				var/mob/living/carbon/thatpoorguy = target
				// 50% chance to receive a severe wound
				if(prob(50))
					thatpoorguy.cause_wound_of_type_and_severity(WOUND_SLASH, null, WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_SEVERE)
				else
					thatpoorguy.cause_wound_of_type_and_severity(WOUND_SLASH, null, WOUND_SEVERITY_MODERATE, WOUND_SEVERITY_MODERATE)
			// Scream for the first time cause this is HORRIFYING.
			if(blend_attacks == 0)
				target.emote("scream")
			playsound(user, SFX_DESECRATION, 75, TRUE, SILENCED_SOUND_EXTRARANGE)
			blend_attacks++
		else
			break
	while (blend_attacks < grab_blend_duration)
	return TRUE
