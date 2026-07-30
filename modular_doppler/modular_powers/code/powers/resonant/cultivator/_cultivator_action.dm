/datum/action/cooldown/power/cultivator
	name = "abstract cultivator power action - ahelp this"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_spell_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	/// The component that talks with cultivator energy. Mostly all functions here communicate with this.
	var/datum/component/cultivator_energy/energy_component

	/// The UI element displaying how much energy we have.
	var/atom/movable/screen/cultivator_energy/cultivator_ui

	/// Cost in Energy to use
	var/cost
	/// Bypasses the cost check while active. On_action_success still subtracts it as normal.
	var/bypass_cost
	/// Does this power get called by _cultivator_energy.dm when we check for aura farming? Used for potential future powers that allow you to aura farm in other ways.
	var/contributes_to_aura_farming = FALSE


/datum/action/cooldown/power/cultivator/Grant(mob/grant_to)
	. = ..()
	ValidateEnergyComponent()
	return .

/// Feng Shui / Aura farming mechanics; get stuff in the environment, increase energy based on it
/// This function should be responsible for checking all the environmental stuff, calculating it and then returning it to the energy system.
/datum/action/cooldown/power/cultivator/proc/aura_farm()
	return 0

/// Since Cultivator has multiple roots and a persistent resource system, we use a component for handling Energy
/datum/action/cooldown/power/cultivator/proc/ValidateEnergyComponent()
	if(owner) // Prevents runtiming on start
		var/mob/living/carrier = owner
		energy_component = carrier.GetComponent(/datum/component/cultivator_energy)
	if(!energy_component)
		return FALSE
	return TRUE

/// Validation handled in the energy component.
/datum/action/cooldown/power/cultivator/proc/adjust_energy(amount, override_cap)
	energy_component.adjust_energy(amount, override_cap)

///Easy access to energy
/datum/action/cooldown/power/cultivator/proc/get_energy()
	return energy_component.energy

// We check to see if our energy component is actually there, because usually things will go bad if they don't.
/datum/action/cooldown/power/cultivator/try_use(mob/living/user, mob/living/target)
	if(!ValidateEnergyComponent())
		owner.balloon_alert(owner, "Yell at the coders; you're missing your energy system!")
		return FALSE
	if(energy_component.energy < cost && !bypass_cost)
		user.balloon_alert(user, "needs [cost] energy!")
		return FALSE
	. = .. ()

// Make sure the cost gets deducted after using the power (we already checked if we can afford it)
/datum/action/cooldown/power/cultivator/on_action_success(mob/living/user, atom/target)
	if(cost)
		adjust_energy(-cost)
	return
