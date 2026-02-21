/datum/action/cooldown/power/cultivator
	name = "abstract cultivator power action - ahelp this"
	background_icon_state = "bg_star"
	overlay_icon_state = "ab_goldborder"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	// The organ that processes most of the Psyker Powers. Mostly all functions here communicate with this.
	var/datum/component/cultivator_dantian/dantian_component

	// The UI used for dantian.alist
	var/atom/movable/screen/cultivator_dantian/cultivator_ui

	// Cost in Dantian to use
	var/cost

/datum/action/cooldown/power/cultivator/New()
	. = ..()
	ValidateDantianComponent()

// Since Cultivator has multiple roots and a persistent resource system, we use a component for handling Dantian
/datum/action/cooldown/power/cultivator/proc/ValidateDantianComponent()
	if(owner) // Prevents runtiming on start
		var/mob/living/carrier = owner
		dantian_component = carrier.GetComponent(/datum/component/cultivator_dantian)
	if(!dantian_component)
		return FALSE
	return TRUE

// Validation handled in the dantian component.
/datum/action/cooldown/power/cultivator/proc/adjust_dantian(amount, override_cap)
	dantian_component.adjust_dantian(amount, override_cap)

//Easy access to dantian
/datum/action/cooldown/power/cultivator/proc/get_dantian()
	return dantian_component.dantian

// We check to see if our dantian component is actually there, because usually things will go bad if they don't.
/datum/action/cooldown/power/cultivator/try_use(mob/living/user, mob/living/target)
	if(!ValidateDantianComponent())
		owner.balloon_alert(owner, "Yell at the coders; you're missing your dantian system!")
		return FALSE
	if(dantian_component.dantian < cost)
		user.balloon_alert(user, "needs [cost] dantian!")
		return FALSE
	. = .. ()

// Make sure the cost gets deducted after using the power (we already checked if we can afford it)
/datum/action/cooldown/power/cultivator/on_action_success(mob/living/user, atom/target)
	if(cost)
		adjust_dantian(-cost)
	return

