/* Piety generation for when its a quiet day.
*/
/datum/power/theologist/pious_prayer
	name = "Pious Prayer"
	desc = "Focus yourself into prayer. If you are in the Chapel, this grants you Piety unless you have 10 or more Piety. Performing prayers elsewhere only has a small chance to grant Piety. Being religious increases the efficiency of this skill.\
	\nIn addition, all healing powers are increased by 20% while you or your target are stood inside the Chapel."
	security_record_text = "Subject fuels their powers with visits to the Chapel."
	value = 2
	power_flags = POWER_HUMAN_ONLY | POWER_HEALING

	action_path = /datum/action/cooldown/power/theologist/pious_prayer
	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	/// How much of a healing multiplier pious prayer gives. Base healing * (1 + healing_bonus).
	var/healing_bonus = 0.2

/datum/power/theologist/pious_prayer/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS, PROC_REF(add_healing_modifier))

/datum/power/theologist/pious_prayer/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS)

/// Adds Pious Prayer's healing bonus if either the healer or their target is inside the Chapel when healing is snapshotted.
/datum/power/theologist/pious_prayer/proc/add_healing_modifier(mob/living/source, atom/healing_target, list/additive_healing_modifiers, list/multiplicative_healing_modifiers)
	SIGNAL_HANDLER

	if(!istype(source))
		return NONE

	if(!is_inside_chapel(source) && !is_inside_chapel(healing_target))
		return NONE

	additive_healing_modifiers += healing_bonus
	return NONE

/// Returns whether the given atom is currently inside the Chapel.
/datum/power/theologist/pious_prayer/proc/is_inside_chapel(atom/subject)
	return istype(get_area(subject), /area/station/service/chapel)

/datum/action/cooldown/power/theologist/pious_prayer
	name = "Pious Prayer"
	desc = "Perform a small prayer. If you are in the Chapel, this grants you Piety unless you have 10 or more Piety. Performing prayers elsewhere only has a small chance to grant Piety. Being religious increases the efficiency of this skill."
	button_icon = 'icons/obj/antags/cult/structures.dmi'
	button_icon_state = "tomealtar"
	cooldown_time = 5

	/// The maximum amount of piety you can get from praying
	var/prayer_cap = 10

/datum/action/cooldown/power/theologist/pious_prayer/New()
	// Increase prayer cap based on various factors.
	// Are you the Chaplain?
	if(is_chaplain_job(usr.mind?.assigned_role))
		prayer_cap = 15
		return

/datum/action/cooldown/power/theologist/pious_prayer/use_action(mob/living/user, atom/target)
	///Tells the do_while loop to keep_going
	var/keep_going = TRUE
	/// One time message for the prayer cap so we don't clog the chat.
	var/cap_warning_given
	/// The area we're praying in.
	var/area/area = get_area(user)

	user.visible_message(span_warning("[user] begins to pray!"), span_notice("You begin to pray!"))
	active = TRUE
	user.apply_status_effect(/datum/status_effect/spotlight_light/divine)
	do
		if(do_after(owner, 50, target = user))
			if(get_piety() >= prayer_cap && !cap_warning_given)
				// We don't actually stop people from praying cause this can be used for ROLEPLAAAAY
				to_chat(user, span_warning("You cannot gain any more piety from prayer!"))
				cap_warning_given = TRUE
			else if(istype(area, /area/station/service/chapel) || prob(check_how_religious(user))) // If you're in the chapel or if fate aligns.
				if(cap_warning_given)
					continue
				adjust_piety(1)
				to_chat(user, span_notice("You feel more pious after your prayer."))
		else
			keep_going = FALSE
	while (keep_going)
	to_chat(user, span_notice("You stop praying."))
	// cleanup
	keep_going = FALSE
	active = FALSE
	user.remove_status_effect(/datum/status_effect/spotlight_light/divine)

/// As the name implies, we take various factors that suggest a target's devotion, as well as a few misc. factors
/datum/action/cooldown/power/theologist/pious_prayer/proc/check_how_religious(mob/living/user)
	// Combined total chance.
	var/total_chance = 10

	// Are you the chaplain?
	if(is_chaplain_job(user.mind?.assigned_role))
		total_chance += 20
	// Do you have the spiritual personality trait?
	if(HAS_TRAIT(user, TRAIT_SPIRITUAL))
		total_chance += 15
	// Do you carry the bible on your person?
	if(has_bible(user))
		total_chance += 10
	// Are you standing on a blessed tile? (Blessed with holy water).
	if(locate(/obj/effect/blessing) in user.loc)
		total_chance += 15

	return total_chance

/// Most people don't but it'd be cool if they did.
/datum/action/cooldown/power/theologist/pious_prayer/proc/has_bible(mob/living/user)
	if(!user)
		return FALSE
	return !!locate(/obj/item/book/bible) in user.get_all_contents()
