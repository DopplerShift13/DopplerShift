/datum/action/cooldown/power/theologist
	name = "abstract theologist power action - ahelp this"
	background_icon_state = "bg_clock"
	overlay_icon_state = "bg_clock_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	/// The component that handles most piety components.
	var/datum/component/theologist_piety/piety_component

	/// Reference to the theologist UI component
	var/atom/movable/screen/theologist_piety/theologist_ui

	/// Cost in Piety to use.
	var/cost

/datum/action/cooldown/power/theologist/Grant(mob/grant_to)
	. = ..()
	ValidatePietyComponent()
	return .

/// Since Theologist has both 3 roots and a persistent resource system, we use a component for handling Piety
/datum/action/cooldown/power/theologist/proc/ValidatePietyComponent()
	if(owner) // Prevents runtiming on start
		var/mob/living/carrier = owner
		piety_component = carrier.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return FALSE
	return TRUE

/// Validation handled in the piety component.
/datum/action/cooldown/power/theologist/proc/adjust_piety(amount, override_cap)
	piety_component.adjust_piety(amount, override_cap)

/// Gets the current piety of the mob.
/datum/action/cooldown/power/theologist/proc/get_piety()
	return piety_component.piety

// We check to see if our piety component is actually there, because usually things will go bad if they don't.
/datum/action/cooldown/power/theologist/try_use(mob/living/user, mob/living/target)
	if(!ValidatePietyComponent())
		owner.balloon_alert(owner, "Yell at the coders; you're missing your piety system!")
		return FALSE
	if(piety_component.piety < cost)
		user.balloon_alert(user, "needs [cost] piety!")
		return FALSE
	. = .. ()

// Make sure the cost gets deducted after using the power (we already checked if we can afford it)
/datum/action/cooldown/power/theologist/on_action_success(mob/living/user, atom/target)
	if(cost)
		adjust_piety(-cost)
	return

/// Applies tox changes whilst respecting toxinlover as a trait
/datum/action/cooldown/power/theologist/proc/adjust_tox_noinvert(mob/living/target, amount, updating_health = TRUE, required_biotype = ALL)
	if(HAS_TRAIT(target, TRAIT_TOXINLOVER))
		amount = -amount
	return target.adjustToxLoss(amount, updating_health = updating_health, forced = FALSE, required_biotype = required_biotype)
