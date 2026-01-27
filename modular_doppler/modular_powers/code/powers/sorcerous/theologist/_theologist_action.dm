/datum/action/cooldown/power/theologist
	name = "abstract theologist power action - ahelp this"
	background_icon_state = "bg_clock"
	overlay_icon_state = "bg_clock_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	// The organ that processes most of the Psyker Powers. Mostly all functions here communicate with this.
	var/datum/power/theologist_piety/piety_power

	// The UI used for piety.alist
	var/atom/movable/screen/theologist_piety/theologist_ui

/datum/action/cooldown/power/theologist/New()
	. = ..()
	ValidatePietyPower()

// Since Theologist has both 3 roots and a persistent resource system, we use a hidden extra power for handling Piety.
/datum/action/cooldown/power/theologist/proc/ValidatePietyPower()
	if(owner) // Prevents runtiming on start
		var/mob/living/carrier = owner
		piety_power = carrier.get_power(/datum/power/theologist_piety)
	if(!piety_power)
		return FALSE
	return TRUE

// Validation handled in the piety power.
/datum/action/cooldown/power/theologist/proc/adjust_piety(amount, override_cap)
	piety_power.adjust_piety(amount, override_cap)

// We check to see if our piety power is actually there, because usually things will go bad if they don't.
/datum/action/cooldown/power/theologist/try_use(mob/living/user, mob/living/target)
	if(!ValidatePietyPower())
		owner.balloon_alert(owner, "Yell at the coders; you're missing your piety system!")
		return FALSE
	. = .. ()
